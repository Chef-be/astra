const http = require('http');
const crypto = require('crypto');
const mysql = require('mysql2/promise');
const { WebSocketServer } = require('ws');

const port = parseInt(process.env.PORT || '8080', 10);
const dbPrefix = process.env.DB_PREFIX || 'astra_';
const secret = process.env.ASTRA_SHARED_SECRET || '';

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'astra-db',
  port: parseInt(process.env.DB_PORT || '3306', 10),
  user: process.env.DB_USER || 'astra',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'astra',
  charset: 'utf8mb4',
  waitForConnections: true,
  connectionLimit: 10
});

function base64UrlDecode(value) {
  const normalized = value.replace(/-/g, '+').replace(/_/g, '/');
  const padding = '='.repeat((4 - normalized.length % 4) % 4);
  return Buffer.from(normalized + padding, 'base64').toString('utf8');
}

function verifyToken(token) {
  if (!token || token.indexOf('.') === -1) {
    return null;
  }

  const parts = token.split('.');
  if (parts.length !== 2) {
    return null;
  }

  const payloadPart = parts[0];
  const signaturePart = parts[1];
  const expectedSignature = crypto.createHmac('sha256', secret).update(payloadPart).digest('base64url');

  if (expectedSignature !== signaturePart) {
    return null;
  }

  let payload;
  try {
    payload = JSON.parse(base64UrlDecode(payloadPart));
  } catch (error) {
    return null;
  }

  if (!payload || !payload.userId || payload.expiresAt < Math.floor(Date.now() / 1000)) {
    return null;
  }

  return payload;
}

async function fetchChatSettings(universe) {
  const [rows] = await pool.query(
    `SELECT chat_history_limit, chat_botname
     FROM ${dbPrefix}config
     WHERE uni = ?
     LIMIT 1`,
    [universe]
  );

  const row = rows[0] || {};
  return {
    historyLimit: Math.min(300, Math.max(20, parseInt(row.chat_history_limit || '120', 10))),
    botName: row.chat_botname || 'Orchestrateur bots'
  };
}

async function fetchChannelDefinitions() {
  const [rows] = await pool.query(
    `SELECT channel_key, label, description, is_active, requires_admin, settings_json
     FROM ${dbPrefix}live_chat_channels`
  );

  const channels = {};
  rows.forEach((row) => {
    let settings = {};
    try {
      settings = row.settings_json ? JSON.parse(row.settings_json) : {};
    } catch (error) {
      settings = {};
    }

    channels[row.channel_key] = {
      key: row.channel_key,
      label: row.label,
      description: row.description,
      isActive: parseInt(row.is_active, 10) === 1,
      requiresAdmin: parseInt(row.requires_admin, 10) === 1,
      minAuthLevel: typeof settings.minAuthLevel !== 'undefined'
        ? parseInt(settings.minAuthLevel, 10)
        : (parseInt(row.requires_admin, 10) === 1 ? 3 : 0),
      isSystem: Boolean(settings.isSystem)
    };
  });

  return channels;
}

async function safeChannel(channel, session) {
  const requested = String(channel || '').trim();
  if (!requested) {
    return null;
  }

  if (requested === 'alliance') {
    if (session.allianceId > 0) {
      return 'alliance:' + session.allianceId;
    }

    return null;
  }

  const definitions = await fetchChannelDefinitions();
  const channelDefinition = definitions[requested];

  if (!channelDefinition || !channelDefinition.isActive) {
    return null;
  }

  if ((session.authlevel || 0) < channelDefinition.minAuthLevel) {
    return null;
  }

  return requested;
}

function publicChannel(channelKey) {
  if (String(channelKey).startsWith('alliance:')) {
    return 'alliance';
  }

  return channelKey;
}

async function fetchChatHistory(channelKey, universe) {
  const settings = await fetchChatSettings(universe);
  const [rows] = await pool.query(
    `SELECT id, user_id, username, message_text, created_at
     FROM ${dbPrefix}live_chat_messages
     WHERE channel_key = ? AND universe = ? AND is_deleted = 0
     ORDER BY id DESC
     LIMIT ?`,
    [channelKey, universe, settings.historyLimit]
  );

  return rows.reverse();
}

async function getActiveMute(userId) {
  const [rows] = await pool.query(
    `SELECT id, reason, expires_at
     FROM ${dbPrefix}live_chat_mutes
     WHERE user_id = ? AND expires_at > UNIX_TIMESTAMP()
     ORDER BY id DESC
     LIMIT 1`,
    [userId]
  );

  return rows[0] || null;
}

async function insertStoredChatMessage({ userId, username, allianceId, channelKey, content, universe }) {
  const [result] = await pool.query(
    `INSERT INTO ${dbPrefix}live_chat_messages
      (user_id, username, alliance_id, channel_key, message_text, universe, created_at, is_deleted)
     VALUES (?, ?, ?, ?, ?, ?, UNIX_TIMESTAMP(), 0)`,
    [userId, username, allianceId || 0, channelKey, content, universe]
  );

  const [rows] = await pool.query(
    `SELECT id, user_id, username, message_text, created_at
     FROM ${dbPrefix}live_chat_messages
     WHERE id = ? LIMIT 1`,
    [result.insertId]
  );

  const item = rows[0] || null;
  if (item && item.id) {
    rememberChatCursor(universe, item.id);
  }

  return item;
}

function tokenizeBotCommand(input) {
  const tokens = [];
  const regex = /"([^"]+)"|'([^']+)'|(\S+)/gu;
  let match;

  while ((match = regex.exec(String(input || ''))) !== null) {
    tokens.push(match[1] || match[2] || match[3] || '');
  }

  return tokens;
}

function normalizeBotTargetType(token) {
  const normalized = String(token || '').trim().toLowerCase();
  const map = {
    bots: 'all',
    bot: 'bot',
    chef: 'chef',
    'alliance-bots': 'alliance',
    alliance: 'alliance',
    escouade: 'escouade',
    'system-bots': 'systeme',
    systeme: 'systeme',
    'galaxy-bots': 'galaxie',
    galaxie: 'galaxie',
    'profil-bots': 'profil',
    profil: 'profil',
    campagne: 'campagne'
  };

  return map[normalized] || normalized;
}

function extractBotPayload(tokens) {
  const payload = { arguments: tokens.slice() };

  tokens.forEach((token, index) => {
    const normalized = String(token || '').trim().toLowerCase();

    if (/^\d+:\d+(?::\d+)?$/.test(token)) {
      payload.coordinates = token;
      payload.target_coordinates = token;
      if ((token.match(/:/g) || []).length === 1) {
        payload.zone_reference = token;
      }
    }

    if (/^\d+[mh]$/.test(token)) {
      payload.duration = token;
    }

    if ((normalized === 'vers' || normalized === 'cible') && tokens[index + 1]) {
      payload.target_player = tokens[index + 1];
      payload.target_username = String(tokens[index + 1]).replace(/^@/, '');
    }

    if (normalized === 'mention' && tokens[index + 1]) {
      payload.target_username = String(tokens[index + 1]).replace(/^@/, '');
    }

    if (normalized === 'message' && tokens[index + 1]) {
      payload.message = tokens.slice(index + 1).join(' ');
    }

    if (normalized === 'intervalle' && tokens[index + 1]) {
      payload.interval = tokens[index + 1];
    }

    if ((normalized === 'canal' || normalized === 'channel') && tokens[index + 1]) {
      payload.channel_key = String(tokens[index + 1]).trim().toLowerCase();
    }

    if (normalized === 'mode' && tokens[index + 1]) {
      payload.mode = tokens[index + 1];
    }

    if (normalized === 'doctrine' && tokens[index + 1]) {
      payload.doctrine = tokens[index + 1];
    }
  });

  if (!payload.verb && tokens[0]) {
    payload.verb = String(tokens[0]).trim().toLowerCase();
  }

  return payload;
}

function parseBotCommand(content) {
  const command = String(content || '').trim();
  if (!command.startsWith('/')) {
    return null;
  }

  const tokens = tokenizeBotCommand(command.slice(1));
  if (!tokens.length) {
    return null;
  }

  const family = String(tokens.shift() || '').trim().toLowerCase();
  if (family === 'bots') {
    return {
      commandFamily: 'bots',
      commandName: tokens[0] ? String(tokens[0]).trim().toLowerCase() : 'statut',
      targetType: 'all',
      targetReference: 'all',
      payload: extractBotPayload(tokens.slice(1))
    };
  }

  if (['bot', 'chef', 'alliance-bots', 'escouade', 'system-bots', 'galaxy-bots', 'profil-bots'].includes(family)) {
    return {
      commandFamily: 'bots',
      commandName: tokens[1] ? String(tokens[1]).trim().toLowerCase() : 'statut',
      targetType: normalizeBotTargetType(family),
      targetReference: tokens[0] || '',
      payload: extractBotPayload(tokens.slice(2))
    };
  }

  if (['message-prive', 'message-chat'].includes(family)) {
    return {
      commandFamily: 'communication',
      commandName: family,
      targetType: normalizeBotTargetType(tokens[0] || 'bot'),
      targetReference: tokens[1] || '',
      payload: extractBotPayload(tokens.slice(2))
    };
  }

  if (['campagne', 'harcelement', 'rotation-attaque', 'vague', 'siege'].includes(family)) {
    return {
      commandFamily: 'campagnes',
      commandName: family,
      targetType: normalizeBotTargetType(tokens[0] || 'alliance'),
      targetReference: tokens[1] || '',
      payload: extractBotPayload(tokens.slice(2))
    };
  }

  return {
    commandFamily: 'bots',
    commandName: family,
    targetType: 'all',
    targetReference: 'all',
    payload: extractBotPayload(tokens)
  };
}

function isBotCommand(content) {
  return parseBotCommand(content) !== null;
}

async function resolvePrimaryBotId(session, parsed) {
  if (!parsed || !parsed.targetReference) {
    return null;
  }

  if (!['bot', 'chef'].includes(parsed.targetType)) {
    return null;
  }

  let sql = `SELECT u.id
    FROM ${dbPrefix}users u`;
  const params = [session.universe, parsed.targetReference];

  if (parsed.targetType === 'chef') {
    sql += ` INNER JOIN ${dbPrefix}bot_state bs ON bs.bot_user_id = u.id`;
  }

  sql += ` WHERE u.universe = ? AND u.is_bot = 1 AND u.username = ?`;
  if (parsed.targetType === 'chef') {
    sql += ` AND bs.hierarchy_status = 'chef'`;
  }
  sql += ' LIMIT 1';

  const [rows] = await pool.query(sql, params);
  return rows[0] ? rows[0].id : null;
}

async function queueBotInstruction(session, content) {
  const cleanContent = String(content || '').trim();
  const parsed = parseBotCommand(cleanContent);
  const targetSelector = parsed ? `${parsed.targetType}:${parsed.targetReference}` : 'all:all';
  const targetBotUserId = await resolvePrimaryBotId(session, parsed);
  const priority = ['raid', 'recon', 'reconnaissance', 'campagne', 'siege', 'harcelement', 'rotation-attaque', 'vague'].includes(parsed && parsed.commandName ? parsed.commandName : '')
    ? 85
    : 60;

  const [result] = await pool.query(
    `INSERT INTO ${dbPrefix}bot_commands
      (universe, issued_by_user_id, target_bot_user_id, target_selector, command_text, command_family, command_name, target_type, target_reference, scope_mode, priority, payload_json, parsed_command_json, status, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'direct', ?, ?, ?, 'parsed', UNIX_TIMESTAMP())`,
    [
      session.universe,
      session.userId,
      targetBotUserId,
      targetSelector,
      cleanContent,
      parsed ? parsed.commandFamily : 'bots',
      parsed ? parsed.commandName : 'statut',
      parsed ? parsed.targetType : 'all',
      parsed ? parsed.targetReference : 'all',
      priority,
      JSON.stringify(parsed ? parsed.payload : {}),
      JSON.stringify(parsed || {})
    ]
  );

  await pool.query(
    `INSERT INTO ${dbPrefix}bot_activity
      (bot_user_id, universe, activity_type, activity_summary, activity_payload, created_at)
     VALUES (?, ?, 'instruction', ?, ?, UNIX_TIMESTAMP())`,
    [
      targetBotUserId || 0,
      session.universe,
      `Instruction structurée de ${session.username} vers ${targetSelector} : ${cleanContent}`,
      JSON.stringify({
        source: 'chat',
        commandId: result.insertId,
        issued_by: session.username,
        target: targetSelector,
        command: cleanContent,
        next_action_type: 'instruction',
        next_action_summary: cleanContent,
        next_action_at: Math.floor(Date.now() / 1000) + 180
      })
    ]
  );

  return {
    commandId: result.insertId,
    targetSelector,
    commandText: cleanContent
  };
}

async function createBotAckMessage(session, instruction) {
  const settings = await fetchChatSettings(session.universe);
  return insertStoredChatMessage({
    userId: 0,
    username: settings.botName,
    allianceId: 0,
    channelKey: 'bots',
    content: `Consigne enregistrée pour ${instruction.targetSelector} : ${instruction.commandText}`,
    universe: session.universe
  });
}

async function fetchNotifications(userId, afterId = 0, limit = 20) {
  const [rows] = await pool.query(
    `SELECT id, notification_type, title, body, link_url, is_read, created_at
     FROM ${dbPrefix}notifications
     WHERE user_id = ? AND id > ? AND is_read = 0
     ORDER BY id DESC
     LIMIT ?`,
    [userId, afterId, limit]
  );

  return rows;
}

async function getUnreadCount(userId) {
  const [rows] = await pool.query(
    `SELECT COUNT(*) AS total
     FROM ${dbPrefix}notifications
     WHERE user_id = ? AND is_read = 0`,
    [userId]
  );

  return rows[0] ? rows[0].total : 0;
}

const server = http.createServer(async (req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'not_found' }));
});

const wss = new WebSocketServer({ noServer: true });
const chatPollCursor = {};

function send(ws, payload) {
  if (ws.readyState === 1) {
    ws.send(JSON.stringify(payload));
  }
}

function rememberChatCursor(universe, messageId) {
  if (!messageId) {
    return;
  }

  const key = String(universe);
  const current = parseInt(chatPollCursor[key] || '0', 10) || 0;
  if (messageId > current) {
    chatPollCursor[key] = messageId;
  }
}

async function ensureChatCursor(universe) {
  const key = String(universe);
  if (typeof chatPollCursor[key] !== 'undefined') {
    return chatPollCursor[key];
  }

  const [rows] = await pool.query(
    `SELECT MAX(id) AS max_id
     FROM ${dbPrefix}live_chat_messages
     WHERE universe = ?`,
    [universe]
  );

  chatPollCursor[key] = rows[0] && rows[0].max_id ? rows[0].max_id : 0;
  return chatPollCursor[key];
}

async function fetchChatMessagesAfterId(universe, afterId) {
  const [rows] = await pool.query(
    `SELECT id, user_id, username, alliance_id, channel_key, message_text, created_at
     FROM ${dbPrefix}live_chat_messages
     WHERE universe = ? AND id > ? AND is_deleted = 0
     ORDER BY id ASC
     LIMIT 100`,
    [universe, afterId]
  );

  return rows;
}

function getPresenceSnapshot(universe) {
  const users = [];
  const seen = new Set();

  wss.clients.forEach((client) => {
    if (client.readyState !== 1 || !client.session) {
      return;
    }

    if (parseInt(client.session.universe, 10) !== parseInt(universe, 10)) {
      return;
    }

    if (seen.has(client.session.userId)) {
      return;
    }

    seen.add(client.session.userId);
    users.push({
      id: client.session.userId,
      username: client.session.username,
      authlevel: client.session.authlevel || 0,
      allianceId: client.session.allianceId || 0
    });
  });

  users.sort((left, right) => String(left.username || '').localeCompare(String(right.username || ''), 'fr', {
    sensitivity: 'base'
  }));

  return users;
}

function broadcastPresence(universe) {
  const payload = {
    type: 'presence:snapshot',
    items: getPresenceSnapshot(universe)
  };

  wss.clients.forEach((client) => {
    if (client.readyState !== 1 || !client.session) {
      return;
    }

    if (parseInt(client.session.universe, 10) !== parseInt(universe, 10)) {
      return;
    }

    send(client, payload);
  });
}

async function syncSocketChannels(ws) {
  const definitions = await fetchChannelDefinitions();
  ws.channels = new Set();

  Object.values(definitions).forEach((channel) => {
    if (!channel.isActive) {
      return;
    }

    if ((ws.session.authlevel || 0) < channel.minAuthLevel) {
      return;
    }

    ws.channels.add(channel.key);
  });

  if (ws.session.allianceId > 0 && definitions.alliance && definitions.alliance.isActive) {
    ws.channels.add('alliance:' + ws.session.allianceId);
  }
}

async function sendNotificationSnapshot(ws) {
  const rows = await fetchNotifications(ws.session.userId, 0, 20);
  const unreadCount = await getUnreadCount(ws.session.userId);
  ws.lastNotificationId = rows.length ? Math.max(...rows.map((row) => row.id)) : ws.lastNotificationId;
  send(ws, {
    type: 'notifications:snapshot',
    items: rows,
    unreadCount
  });
}

async function pollNotifications(ws) {
  const rows = await fetchNotifications(ws.session.userId, ws.lastNotificationId || 0, 20);

  if (rows.length) {
    ws.lastNotificationId = Math.max(...rows.map((row) => row.id), ws.lastNotificationId || 0);
    send(ws, {
      type: 'notifications:new',
      items: rows,
      unreadCount: await getUnreadCount(ws.session.userId)
    });
  } else {
    send(ws, {
      type: 'notifications:count',
      unreadCount: await getUnreadCount(ws.session.userId)
    });
  }
}

function broadcastToChannel(channelKey, universe, payload) {
  wss.clients.forEach((client) => {
    if (client.readyState !== 1 || !client.channels || !client.channels.has(channelKey)) {
      return;
    }

    if (!client.session || parseInt(client.session.universe, 10) !== parseInt(universe, 10)) {
      return;
    }

    send(client, payload);
  });
}

async function pollStoredChatMessages() {
  const universes = new Set();

  wss.clients.forEach((client) => {
    if (client.readyState !== 1 || !client.session) {
      return;
    }

    universes.add(parseInt(client.session.universe, 10));
  });

  for (const universe of universes) {
    const cursor = await ensureChatCursor(universe);
    const rows = await fetchChatMessagesAfterId(universe, cursor);

    rows.forEach((row) => {
      rememberChatCursor(universe, row.id);
      broadcastToChannel(row.channel_key, universe, {
        type: 'chat:message',
        channel: publicChannel(row.channel_key),
        item: row
      });
    });
  }
}

wss.on('connection', async (ws, request, session) => {
  ws.session = session;
  ws.channels = new Set();
  await syncSocketChannels(ws);
  await ensureChatCursor(session.universe);

  ws.lastNotificationId = 0;
  await sendNotificationSnapshot(ws);
  send(ws, {
    type: 'presence:snapshot',
    items: getPresenceSnapshot(session.universe)
  });
  broadcastPresence(session.universe);

  ws.notificationTimer = setInterval(() => {
    pollNotifications(ws).catch(() => {});
  }, 5000);

  ws.on('message', async (buffer) => {
    let data;
    try {
      data = JSON.parse(buffer.toString('utf8'));
    } catch (error) {
      console.error('Invalid realtime payload:', error.message);
      return;
    }

    if (!data || !data.action) {
      return;
    }

    try {
      if (data.action === 'notifications:sync') {
        await sendNotificationSnapshot(ws);
        return;
      }

      if (data.action === 'chat:history') {
        const channelKey = await safeChannel(data.channel, session);
        if (!channelKey) {
          send(ws, { type: 'chat:error', message: 'Canal non autorisé.' });
          return;
        }

        const items = await fetchChatHistory(channelKey, session.universe);
        send(ws, {
          type: 'chat:history',
          channel: publicChannel(channelKey),
          items
        });
        return;
      }

      if (data.action === 'chat:send') {
        const channelKey = await safeChannel(data.channel, session);
        const content = String(data.content || '').trim().slice(0, 500);

        if (!channelKey) {
          send(ws, { type: 'chat:error', message: 'Canal non autorisé.' });
          return;
        }

        if (!content) {
          send(ws, { type: 'chat:error', message: 'Le message est vide.' });
          return;
        }

        const mute = await getActiveMute(session.userId);
        if (mute) {
          send(ws, {
            type: 'chat:error',
            message: 'Vous êtes temporairement muet jusqu’au ' + new Date(mute.expires_at * 1000).toLocaleString('fr-FR') + '.'
          });
          return;
        }

        const item = await insertStoredChatMessage({
          userId: session.userId,
          username: session.username,
          allianceId: session.allianceId || 0,
          channelKey,
          content,
          universe: session.universe
        });

        if (item) {
          broadcastToChannel(channelKey, session.universe, {
            type: 'chat:message',
            channel: publicChannel(channelKey),
            item
          });
        }

        if (channelKey === 'bots' && isBotCommand(content)) {
          const instruction = await queueBotInstruction(session, content);
          const ackItem = await createBotAckMessage(session, instruction);

          if (ackItem) {
            broadcastToChannel('bots', session.universe, {
              type: 'chat:message',
              channel: 'bots',
              item: ackItem
            });
          }
        }
      }
    } catch (error) {
      console.error('Realtime action failed:', data.action, error);
      send(ws, {
        type: 'chat:error',
        message: 'Une erreur interne est survenue sur le relais temps réel.'
      });
    }
  });

  ws.on('close', () => {
    clearInterval(ws.notificationTimer);
    broadcastPresence(session.universe);
  });
});

server.on('upgrade', (request, socket, head) => {
  try {
    const requestUrl = new URL(request.url, 'http://localhost');
    if (requestUrl.pathname !== '/ws') {
      socket.destroy();
      return;
    }

    const session = verifyToken(requestUrl.searchParams.get('token'));
    if (!session) {
      socket.destroy();
      return;
    }

    wss.handleUpgrade(request, socket, head, (ws) => {
      wss.emit('connection', ws, request, session);
    });
  } catch (error) {
    socket.destroy();
  }
});

server.listen(port, () => {
  console.log('Astra realtime server listening on', port);
});

setInterval(() => {
  pollStoredChatMessages().catch((error) => {
    console.error('Stored chat polling failed:', error.message);
  });
}, 2000);
