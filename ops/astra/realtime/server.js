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

  return rows[0] || null;
}

async function queueBotInstruction(session, content) {
  const cleanContent = String(content || '').trim();
  let targetSelector = 'all';
  let targetBotUserId = null;
  let commandText = cleanContent;

  if (cleanContent.toLowerCase().startsWith('/bot ')) {
    const segments = cleanContent.split(/\s+/);
    if (segments.length >= 3) {
      targetSelector = segments[1];
      commandText = segments.slice(2).join(' ');

      const [rows] = await pool.query(
        `SELECT id
         FROM ${dbPrefix}users
         WHERE universe = ? AND is_bot = 1 AND username = ?
         LIMIT 1`,
        [session.universe, targetSelector]
      );

      if (rows[0]) {
        targetBotUserId = rows[0].id;
      }
    }
  } else if (cleanContent.toLowerCase().startsWith('/bots ')) {
    targetSelector = 'all';
    commandText = cleanContent.substring(6).trim();
  }

  const [result] = await pool.query(
    `INSERT INTO ${dbPrefix}bot_commands
      (universe, issued_by_user_id, target_bot_user_id, target_selector, command_text, status, created_at)
     VALUES (?, ?, ?, ?, ?, 'pending', UNIX_TIMESTAMP())`,
    [session.universe, session.userId, targetBotUserId, targetSelector, commandText]
  );

  await pool.query(
    `INSERT INTO ${dbPrefix}bot_activity
      (bot_user_id, universe, activity_type, activity_summary, activity_payload, created_at)
     VALUES (?, ?, 'instruction', ?, ?, UNIX_TIMESTAMP())`,
    [
      targetBotUserId || 0,
      session.universe,
      `Instruction de ${session.username} vers ${targetSelector} : ${commandText}`,
      JSON.stringify({
        source: 'chat',
        commandId: result.insertId,
        issued_by: session.username,
        target: targetSelector,
        command: commandText,
        next_action_type: 'instruction',
        next_action_summary: commandText,
        next_action_at: Math.floor(Date.now() / 1000) + 180
      })
    ]
  );

  return {
    commandId: result.insertId,
    targetSelector,
    commandText
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

function send(ws, payload) {
  if (ws.readyState === 1) {
    ws.send(JSON.stringify(payload));
  }
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

wss.on('connection', async (ws, request, session) => {
  ws.session = session;
  ws.channels = new Set();
  await syncSocketChannels(ws);

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

        if (channelKey === 'bots' && (content.toLowerCase().startsWith('/bot ') || content.toLowerCase().startsWith('/bots '))) {
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
