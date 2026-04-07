(function(window, $) {
  'use strict';

  if (!$) {
    return;
  }

  var AstraRealtime = {
    socket: null,
    wsUrl: '',
    token: '',
    connected: false,
    currentUserId: 0,
    currentUsername: '',
    reconnectTimer: null,
    historyRefreshTimer: null,
    isNavigatingAway: false,
    chatMounts: {},
    chatChannels: [],
    botCommandCatalog: [],
    chatHistories: {},
    chatHistorySignatures: {},
    chatDrafts: {},
    connectedUsers: [],
    mentionStates: {},
    notifications: [],
    unreadCount: 0,
    mentionCount: 0,
    emojiGroups: [
      ['😀','😁','😂','🤣','😊','😍','😘','😎','🤖','😇','😉','😅','🙌','👏','👍','👎'],
      ['🤝','🙏','💪','🧠','👀','🫡','😴','🤯','😡','🥶','🥳','🤩','😬','🤔','🫠','😈'],
      ['🚀','🛸','🛰️','🌌','🌍','🌕','⭐','☄️','🪐','⚙️','🧪','🔭','📡','🛰','🗺️','📍'],
      ['🔥','⚡','💥','🛡️','🧱','🔒','🔓','⚔️','🏴','🎯','📦','⛏️','🏗️','🏭','💎','🪙'],
      ['🧬','🧲','🖥️','💾','🧾','📊','📈','📉','🧭','🪓','🛠️','🔧','🧰','🪫','🔋','💡'],
      ['❤️','💙','💚','💛','🧡','💜','🖤','🤍','💬','📣','📢','✅','❌','⚠️','ℹ️','⏱️'],
      ['🌠','🌟','🌙','☀️','🌈','🌊','🌪️','🌋','🧊','🍀','🎉','🎖️','🏆','🎮','🎵','📯'],
      ['👑','🧑‍🚀','🧑‍💻','🧑‍🔧','🕹️','🎲','🪄','🧿','🔮','📜','🪪','🪩','🧨','🛸','🚨','🆘']
    ],
    emojiShortcodes: {
      ':smile:': '😀',
      ':grin:': '😁',
      ':joy:': '😂',
      ':wave:': '👋',
      ':heart:': '❤️',
      ':blue_heart:': '💙',
      ':green_heart:': '💚',
      ':yellow_heart:': '💛',
      ':orange_heart:': '🧡',
      ':purple_heart:': '💜',
      ':black_heart:': '🖤',
      ':white_heart:': '🤍',
      ':laugh:': '🤣',
      ':wink:': '😉',
      ':cool:': '😎',
      ':thinking:': '🤔',
      ':salute:': '🫡',
      ':eyes:': '👀',
      ':clap:': '👏',
      ':pray:': '🙏',
      ':muscle:': '💪',
      ':rocket:': '🚀',
      ':fusee:': '🚀',
      ':shield:': '🛡️',
      ':bouclier:': '🛡️',
      ':fire:': '🔥',
      ':feu:': '🔥',
      ':star:': '⭐',
      ':etoile:': '⭐',
      ':planet:': '🪐',
      ':planete:': '🪐',
      ':bot:': '🤖',
      ':fleet:': '🛸',
      ':flotte:': '🛸',
      ':satellite:': '🛰️',
      ':galaxy:': '🌌',
      ':galaxie:': '🌌',
      ':radar:': '📡',
      ':attack:': '⚔️',
      ':attaque:': '⚔️',
      ':ok:': '✅',
      ':no:': '❌',
      ':warn:': '⚠️',
      ':alerte:': '⚠️',
      ':clock:': '⏱️',
      ':temps:': '⏱️',
      ':metal:': '🪙',
      ':crystal:': '💎',
      ':cristal:': '💎',
      ':energy:': '⚡',
      ':energie:': '⚡',
      ':tools:': '🛠️',
      ':outils:': '🛠️',
      ':factory:': '🏭',
      ':usine:': '🏭',
      ':medal:': '🎖️',
      ':medaille:': '🎖️',
      ':trophy:': '🏆',
      ':trophee:': '🏆',
      ':boom:': '💥',
      ':explosion:': '💥',
      ':target:': '🎯',
      ':cible:': '🎯',
      ':news:': '📣',
      ':annonce:': '📣',
      ':message:': '💬',
      ':discussion:': '💬',
      ':coeur:': '❤️',
      ':joie:': '😂',
      ':sourire:': '😀',
      ':salut:': '🫡',
      ':victoire:': '🏆'
    },
    emojiAliasesFr: {
      '😀': ['sourire', 'heureux', 'content'],
      '😁': ['grand sourire', 'rire'],
      '😂': ['joie', 'rire', 'mdr'],
      '🤣': ['éclat de rire', 'mort de rire'],
      '😊': ['souriant', 'gentil'],
      '😍': ['amour', 'adoration'],
      '😘': ['bisou', 'baiser'],
      '😎': ['cool', 'lunettes'],
      '🤖': ['bot', 'robot', 'automate'],
      '😇': ['ange', 'sage'],
      '😉': ['clin d oeil', 'malin'],
      '😅': ['soulagement', 'oups'],
      '🙌': ['victoire', 'bravo', 'hourra'],
      '👏': ['applaudissements', 'bravo'],
      '👍': ['accord', 'oui', 'pouce haut'],
      '👎': ['désaccord', 'non', 'pouce bas'],
      '🤝': ['alliance', 'entente', 'accord'],
      '🙏': ['merci', 'prière', 'respect'],
      '💪': ['force', 'muscle'],
      '🧠': ['stratégie', 'intelligence', 'cerveau'],
      '👀': ['regarde', 'surveillance', 'yeux'],
      '🫡': ['salut', 'respect'],
      '😴': ['sommeil', 'repos'],
      '🤯': ['incroyable', 'explosion cerveau'],
      '😡': ['colère', 'furieux'],
      '🥶': ['froid', 'gel'],
      '🥳': ['fête', 'célébration'],
      '🤩': ['étoiles', 'émerveillement'],
      '😬': ['gêne', 'tension'],
      '🤔': ['réflexion', 'question'],
      '🫠': ['fondu', 'lassé'],
      '😈': ['diable', 'malice'],
      '🚀': ['fusée', 'départ', 'exploration'],
      '🛸': ['flotte', 'vaisseau', 'ovni'],
      '🛰️': ['satellite', 'orbite'],
      '🌌': ['galaxie', 'espace', 'voie lactée'],
      '🌍': ['terre', 'monde', 'planète'],
      '🌕': ['lune', 'pleine lune'],
      '⭐': ['étoile', 'favori'],
      '☄️': ['comète', 'météore'],
      '🪐': ['planète', 'saturne'],
      '⚙️': ['réglages', 'engrenage'],
      '🧪': ['laboratoire', 'science'],
      '🔭': ['télescope', 'observation'],
      '📡': ['radar', 'signal', 'antenne'],
      '🗺️': ['carte', 'navigation'],
      '📍': ['position', 'coordonnée'],
      '🔥': ['feu', 'attaque', 'intense'],
      '⚡': ['énergie', 'vitesse', 'éclair'],
      '💥': ['explosion', 'impact'],
      '🛡️': ['bouclier', 'défense', 'protection'],
      '🧱': ['mur', 'bloc', 'fortification'],
      '🔒': ['verrou', 'sécurité'],
      '🔓': ['ouvert', 'déverrouillé'],
      '⚔️': ['attaque', 'combat', 'guerre'],
      '🏴': ['drapeau', 'signal'],
      '🎯': ['cible', 'objectif', 'mission'],
      '📦': ['cargo', 'colis', 'stock'],
      '⛏️': ['mine', 'extraction'],
      '🏗️': ['chantier', 'construction'],
      '🏭': ['usine', 'production'],
      '💎': ['cristal', 'gemme'],
      '🪙': ['métal', 'pièce', 'ressource'],
      '🧬': ['recherche', 'génétique'],
      '🧲': ['aimant', 'traction'],
      '🖥️': ['ordinateur', 'terminal'],
      '💾': ['sauvegarde', 'données'],
      '🧾': ['rapport', 'journal'],
      '📊': ['statistiques', 'graphique'],
      '📈': ['hausse', 'progression'],
      '📉': ['baisse', 'recul'],
      '🧭': ['orientation', 'cap'],
      '🪓': ['coupe', 'destruction'],
      '🛠️': ['outils', 'maintenance'],
      '🔧': ['réparation', 'outil'],
      '🧰': ['boîte à outils', 'maintenance'],
      '🪫': ['batterie vide', 'panne'],
      '🔋': ['batterie', 'charge'],
      '💡': ['idée', 'astuce'],
      '❤️': ['cœur', 'amour', 'sympathie'],
      '💙': ['cœur bleu'],
      '💚': ['cœur vert'],
      '💛': ['cœur jaune'],
      '🧡': ['cœur orange'],
      '💜': ['cœur violet'],
      '🖤': ['cœur noir'],
      '🤍': ['cœur blanc'],
      '💬': ['message', 'discussion', 'chat'],
      '📣': ['annonce', 'actualités'],
      '📢': ['haut parleur', 'diffusion'],
      '✅': ['valider', 'oui', 'succès'],
      '❌': ['erreur', 'non', 'refus'],
      '⚠️': ['alerte', 'danger', 'attention'],
      'ℹ️': ['information', 'info'],
      '⏱️': ['temps', 'chrono', 'durée'],
      '🌠': ['étoile filante'],
      '🌟': ['étoile brillante'],
      '🌙': ['croissant de lune'],
      '☀️': ['soleil'],
      '🌈': ['arc en ciel'],
      '🌊': ['vague'],
      '🌪️': ['tempête', 'tourbillon'],
      '🌋': ['volcan'],
      '🧊': ['glace'],
      '🍀': ['chance', 'porte bonheur'],
      '🎉': ['fête', 'succès'],
      '🎖️': ['médaille', 'récompense'],
      '🏆': ['trophée', 'victoire'],
      '🎮': ['jeu', 'gaming'],
      '🎵': ['musique'],
      '📯': ['signal', 'annonce'],
      '👑': ['roi', 'couronne', 'élite'],
      '🧑‍🚀': ['astronaute', 'espace'],
      '🧑‍💻': ['développeur', 'ordinateur'],
      '🧑‍🔧': ['technicien', 'maintenance'],
      '🕹️': ['manette', 'jeu'],
      '🎲': ['hasard', 'dés'],
      '🪄': ['magie'],
      '🧿': ['protection'],
      '🔮': ['prédiction', 'vision'],
      '📜': ['parchemin', 'mission'],
      '🪪': ['identité', 'badge'],
      '🪩': ['fête', 'danse'],
      '🧨': ['explosif', 'dynamite'],
      '🚨': ['urgence', 'alerte'],
      '🆘': ['secours', 'aide']
    },
    initDone: false,

    init: function() {
      if (this.initDone) {
        return;
      }

      this.initDone = true;
      this.bindLifecycleEvents();
      this.loadConnectionState();
      this.bindNotificationUi();
      this.bootstrap();
    },

    bindLifecycleEvents: function() {
      var self = this;

      window.addEventListener('beforeunload', function() {
        self.isNavigatingAway = true;
      });

      window.addEventListener('pagehide', function() {
        self.isNavigatingAway = true;
      });

      window.addEventListener('pageshow', function() {
        self.isNavigatingAway = false;
      });
    },

    getConnectionStorageKey: function() {
      return 'astra-chat-connected-state';
    },

    loadConnectionState: function() {
      var raw = '0';

      try {
        raw = window.sessionStorage.getItem(this.getConnectionStorageKey()) || '0';
      } catch (error) {
        raw = '0';
      }

      this.connected = raw === '1';
      this.updateChatIndicator();
    },

    persistConnectionState: function(isConnected) {
      try {
        window.sessionStorage.setItem(this.getConnectionStorageKey(), isConnected ? '1' : '0');
      } catch (error) {}
    },

    bootstrap: function() {
      var self = this;
      $.getJSON('game.php?page=realtime&mode=token&ajax=1')
        .done(function(payload) {
          if (!payload || payload.status !== 'ok') {
            return;
          }

          self.wsUrl = payload.wsUrl;
          self.token = payload.token;
          self.currentUserId = parseInt(payload.currentUserId || 0, 10) || 0;
          self.currentUsername = payload.currentUsername || '';
          self.chatChannels = payload.channels || [];
          self.notifications = payload.notifications || [];
          self.unreadCount = payload.unreadCount || 0;
          self.loadBotCommandCatalog();
          self.loadMentionCount();
          self.renderNotifications();
          self.updateChatMentionBadge();
          self.renderAllChatMounts();
          self.bindChatBadgeUi();
          self.connect();
        });
    },

    connect: function() {
      var self = this;

      self.isNavigatingAway = false;

      if (!self.wsUrl || !self.token) {
        return;
      }

      if (self.socket) {
        try {
          self.socket.close();
        } catch (e) {}
      }

      self.socket = new WebSocket(self.wsUrl + '?token=' + encodeURIComponent(self.token));

      self.socket.onopen = function() {
        self.connected = true;
        self.persistConnectionState(true);
        self.updateChatIndicator();
        self.requestNotificationSync();
        self.renderAllChatMounts();
        clearInterval(self.historyRefreshTimer);
        self.historyRefreshTimer = setInterval(function() {
          Object.keys(self.chatMounts).forEach(function(rootId) {
            self.requestChatHistory(self.chatMounts[rootId].activeChannel);
          });
        }, 6000);
        Object.keys(self.chatMounts).forEach(function(rootId) {
          self.requestChatHistory(self.chatMounts[rootId].activeChannel);
        });
      };

      self.socket.onmessage = function(event) {
        var data;

        try {
          data = JSON.parse(event.data);
        } catch (e) {
          return;
        }

        self.handleMessage(data);
      };

      self.socket.onclose = function() {
        if (self.isNavigatingAway) {
          clearInterval(self.historyRefreshTimer);
          clearTimeout(self.reconnectTimer);
          return;
        }

        self.connected = false;
        self.persistConnectionState(false);
        self.updateChatIndicator();
        self.renderAllChatMounts();
        clearInterval(self.historyRefreshTimer);
        clearTimeout(self.reconnectTimer);
        self.reconnectTimer = setTimeout(function() {
          self.connect();
        }, 2500);
      };
    },

    handleMessage: function(data) {
      if (!data || !data.type) {
        return;
      }

      if (data.type === 'chat:history') {
        this.updateChatHistory(data.channel, data.items || []);
        return;
      }

      if (data.type === 'chat:message') {
        if (this.isMentionForCurrentUser(data.item)) {
          this.incrementMentionCount();
        }
        this.pushChatMessage(data.channel, data.item);
        return;
      }

      if (data.type === 'chat:error') {
        this.showChatError(data.message || 'Action impossible.');
        return;
      }

      if (data.type === 'presence:snapshot') {
        this.connectedUsers = data.items || [];
        this.renderAllChatMounts();
        return;
      }

      if (data.type === 'notifications:snapshot') {
        this.notifications = data.items || [];
        this.unreadCount = data.unreadCount || 0;
        this.renderNotifications();
        return;
      }

      if (data.type === 'notifications:new') {
        var self = this;
        (data.items || []).reverse().forEach(function(item) {
          self.notifications.unshift(item);
        });

        this.notifications = this.uniqueNotifications(this.notifications).slice(0, 30);
        this.unreadCount = data.unreadCount || this.notifications.length;
        this.renderNotifications();
        return;
      }

      if (data.type === 'notifications:count') {
        this.unreadCount = data.unreadCount || 0;
        if (!this.unreadCount) {
          this.notifications = [];
        }
        this.renderNotifications();
      }
    },

    uniqueNotifications: function(items) {
      var seen = {};
      return items.filter(function(item) {
        if (!item || seen[item.id]) {
          return false;
        }

        seen[item.id] = true;
        return true;
      });
    },

    bindNotificationUi: function() {
      var self = this;

      $(document).on('click', '#astraNotificationToggle', function(event) {
        event.preventDefault();
        $('#astraNotificationPanel').toggleClass('d-none');
      });

      $(document).on('click', function(event) {
        if (!$(event.target).closest('#astraNotificationPanel, #astraNotificationToggle').length) {
          $('#astraNotificationPanel').addClass('d-none');
        }
      });

      $(document).on('click', '#astraNotificationReadAll', function(event) {
        event.preventDefault();
        $.post('game.php?page=realtime&mode=markNotificationsRead&ajax=1').done(function() {
          self.notifications = [];
          self.unreadCount = 0;
          self.renderNotifications();
        });
      });

      $(document).on('click', '[data-notification-id]', function(event) {
        event.preventDefault();

        var notificationId = $(this).data('notification-id');
        $.getJSON('game.php?page=realtime&mode=notificationDetail&ajax=1&notificationId=' + notificationId)
          .done(function(payload) {
            if (!payload || payload.status !== 'ok' || !payload.item) {
              return;
            }

            self.markNotificationRead(notificationId);
            self.openNotificationModal(payload.item);
          });
      });
    },

    markNotificationRead: function(notificationId) {
      var self = this;

      $.post('game.php?page=realtime&mode=markNotificationRead&ajax=1', {
        notificationId: notificationId
      }).done(function(payload) {
        if (payload && typeof payload.unreadCount !== 'undefined') {
          self.unreadCount = parseInt(payload.unreadCount, 10) || 0;
        }

        self.notifications = self.notifications.filter(function(item) {
          return parseInt(item.id, 10) !== parseInt(notificationId, 10);
        });

        self.renderNotifications();
      });
    },

    openNotificationModal: function(item) {
      $('#astraNotificationModalTitle').text(item.title || 'Notification');
      $('#astraNotificationModalBody').html(this.escapeHtml(item.body || '').replace(/\n/g, '<br>'));

      if (item.link_url) {
        $('#astraNotificationModalLink').removeClass('d-none').attr('href', item.link_url);
      } else {
        $('#astraNotificationModalLink').addClass('d-none').attr('href', '#');
      }

      var modal = new bootstrap.Modal(document.getElementById('astraNotificationModal'));
      modal.show();
    },

    renderNotifications: function() {
      var badge = $('#astraNotificationBadge');
      var list = $('#astraNotificationList');
      var html = '';

      if (this.unreadCount > 0) {
        badge.text(this.unreadCount > 99 ? '99+' : this.unreadCount).show();
      } else {
        badge.hide();
      }

      if (!this.notifications.length) {
        list.html('<div class="p-3 text-white-50 small">Aucune notification non lue.</div>');
        return;
      }

      this.notifications.slice(0, 20).forEach(function(item) {
        html += '<a href="#" data-notification-id="' + item.id + '" class="d-block px-3 py-3 text-decoration-none text-white border-bottom border-secondary" style="background:rgba(255,255,255,0.06);">';
        html += '<div class="d-flex justify-content-between gap-2">';
        html += '<div class="fw-bold small">' + AstraRealtime.escapeHtml(item.title || 'Notification') + '</div>';
        html += '<div class="text-white-50 small">' + AstraRealtime.formatDate(item.created_at) + '</div>';
        html += '</div>';
        html += '<div class="small text-white-50 mt-1">' + AstraRealtime.escapeHtml((item.body || '').substring(0, 120)) + '</div>';
        html += '</a>';
      });

      list.html(html);
    },

    formatDate: function(unixTime) {
      if (!unixTime) {
        return '';
      }

      var date = new Date(parseInt(unixTime, 10) * 1000);
      return date.toLocaleString('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      });
    },

    updateChatIndicator: function() {
      $('#astraChatIcon').css('color', this.connected ? '#22c55e' : '#94a3b8');
    },

    bindChatBadgeUi: function() {
      var self = this;

      $(document).off('click.chatBadge').on('click.chatBadge', 'a[href="game.php?page=chat"]', function() {
        self.clearMentionCount();
      });

      if (this.isChatPage()) {
        this.clearMentionCount();
      }
    },

    getMentionStorageKey: function() {
      return 'astra-chat-mentions::' + (this.currentUserId || 0) + '::' + (this.currentUsername || '');
    },

    loadMentionCount: function() {
      var raw = '0';

      try {
        raw = window.localStorage.getItem(this.getMentionStorageKey()) || '0';
      } catch (error) {
        raw = '0';
      }

      this.mentionCount = Math.max(0, parseInt(raw, 10) || 0);
    },

    persistMentionCount: function() {
      try {
        window.localStorage.setItem(this.getMentionStorageKey(), String(this.mentionCount || 0));
      } catch (error) {}
    },

    updateChatMentionBadge: function() {
      var badge = $('#astraChatMentionBadge');

      if (!badge.length) {
        return;
      }

      if (this.mentionCount > 0 && !this.isChatPage()) {
        badge.text(this.mentionCount > 99 ? '99+' : this.mentionCount).show();
      } else {
        badge.hide();
      }
    },

    clearMentionCount: function() {
      this.mentionCount = 0;
      this.persistMentionCount();
      this.updateChatMentionBadge();
    },

    incrementMentionCount: function() {
      if (this.isChatPage() && document.visibilityState === 'visible') {
        this.clearMentionCount();
        return;
      }

      this.mentionCount = (this.mentionCount || 0) + 1;
      this.persistMentionCount();
      this.updateChatMentionBadge();
    },

    isChatPage: function() {
      return $('#astra-live-chat').length > 0 || /(?:\?|&)page=chat(?:&|$)/.test(window.location.search || '');
    },

    isMentionForCurrentUser: function(item) {
      var message;
      var username;
      var escapedUsername;
      var mentionPattern;

      if (!item || !this.currentUsername) {
        return false;
      }

      if (parseInt(item.user_id || 0, 10) === this.currentUserId) {
        return false;
      }

      message = String(item.message_text || '');
      username = String(this.currentUsername || '').trim();
      if (!username) {
        return false;
      }

      escapedUsername = username.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      mentionPattern = new RegExp('(^|[^\\w])@' + escapedUsername + '(?=$|[^\\w])', 'i');
      return mentionPattern.test(message);
    },

    requestNotificationSync: function() {
      this.sendSocket({
        action: 'notifications:sync'
      });
    },

    requestChatHistory: function(channel) {
      if (!channel) {
        return;
      }

      this.sendSocket({
        action: 'chat:history',
        channel: channel
      });
    },

    mountChat: function(rootId, channel) {
      var root = document.getElementById(rootId);

      if (!root) {
        return;
      }

      this.chatMounts[rootId] = {
        rootId: rootId,
        requestedChannel: channel || 'global',
        activeChannel: this.normalizeChannel(channel || 'global')
      };

      this.renderChat(rootId);
      this.requestChatHistory(this.chatMounts[rootId].activeChannel);
    },

    normalizeChannel: function(channelId) {
      var channel = String(channelId || 'global');
      var available = this.chatChannels.map(function(item) {
        return item.id;
      });

      if (available.indexOf(channel) !== -1) {
        return channel;
      }

      return available.length ? available[0] : 'global';
    },

    getChannelMeta: function(channelId) {
      var match = null;

      this.chatChannels.forEach(function(channel) {
        if (channel.id === channelId) {
          match = channel;
        }
      });

      return match || {
        id: channelId,
        label: 'Discussion',
        description: '',
        moderatorName: '',
        canModerate: false,
        isAdminOnly: false
      };
    },

    renderAllChatMounts: function() {
      var self = this;
      Object.keys(this.chatMounts).forEach(function(rootId) {
        self.chatMounts[rootId].activeChannel = self.normalizeChannel(self.chatMounts[rootId].activeChannel);
        self.renderChat(rootId);
      });
    },

    updateChatHistory: function(channel, items) {
      var normalizedItems = items || [];
      var nextSignature = this.getChatHistorySignature(normalizedItems);

      if (this.chatHistorySignatures[channel] === nextSignature) {
        return;
      }

      this.chatHistories[channel] = normalizedItems;
      this.chatHistorySignatures[channel] = nextSignature;

      var self = this;
      Object.keys(this.chatMounts).forEach(function(rootId) {
        if (self.chatMounts[rootId].activeChannel === channel) {
          self.renderChat(rootId);
        }
      });
    },

    pushChatMessage: function(channel, item) {
      if (!this.chatHistories[channel]) {
        this.chatHistories[channel] = [];
      }

      this.chatHistories[channel].push(item);
      this.chatHistories[channel] = this.chatHistories[channel].slice(-150);
      this.chatHistorySignatures[channel] = this.getChatHistorySignature(this.chatHistories[channel]);

      var self = this;
      Object.keys(this.chatMounts).forEach(function(rootId) {
        if (self.chatMounts[rootId].activeChannel === channel) {
          self.renderChat(rootId);
        }
      });
    },

    setChatChannel: function(rootId, channelId) {
      if (!this.chatMounts[rootId]) {
        return;
      }

      this.chatMounts[rootId].activeChannel = this.normalizeChannel(channelId);
      this.renderChat(rootId);
      this.requestChatHistory(this.chatMounts[rootId].activeChannel);
    },

    renderChat: function(rootId) {
      var mount = this.chatMounts[rootId];
      var meta;
      var messages;
      var html = '';
      var state;

      if (!mount) {
        return;
      }

      state = this.captureChatState(rootId);
      mount.activeChannel = this.normalizeChannel(mount.activeChannel);
      meta = this.getChannelMeta(mount.activeChannel);
      messages = this.chatHistories[mount.activeChannel] || [];

      html += '<div class="row g-3">';
      html += '  <div class="col-12">';
      html += '    <div class="p-3 rounded-4" style="background:linear-gradient(180deg, rgba(7,12,18,0.96) 0%, rgba(10,18,28,0.92) 100%);border:1px solid rgba(255,255,255,0.10);box-shadow:0 20px 50px rgba(0,0,0,0.32);">';
      html += '      <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">';
      html += '        <div>';
      html += '          <div class="text-white fw-bold fs-4">' + this.escapeHtml(meta.label || 'Discussion') + '</div>';
      html += '          <div class="small text-white-50">' + this.escapeHtml(meta.description || 'Messagerie instantanée en temps réel.') + '</div>';
      if (meta.moderatorName) {
        html += '          <div class="small text-info mt-1">Modération référente : ' + this.escapeHtml(meta.moderatorName) + '</div>';
      }
      if (meta.isAdminOnly) {
        html += '          <div class="small text-warning mt-1">Canal réservé à l’administration.</div>';
      }
      html += '        </div>';
      html += '        <div class="small ' + (this.connected ? 'text-success' : 'text-white-50') + '">' + (this.connected ? 'Connecté en temps réel' : 'Reconnexion en cours…') + '</div>';
      html += '      </div>';
      html += '      <div class="d-flex flex-wrap gap-2 mb-3">';

      if (this.chatChannels.length) {
        this.chatChannels.forEach(function(channel) {
          html += '<button type="button" class="btn btn-sm ' + (channel.id === mount.activeChannel ? 'btn-primary' : 'btn-outline-light') + '" data-chat-channel="' + channel.id + '" data-chat-root="' + rootId + '">' + AstraRealtime.escapeHtml(channel.label || channel.id) + '</button>';
        });
      } else {
        html += '<span class="badge bg-secondary">Chargement des canaux…</span>';
      }

      html += '      </div>';
      html += '      <div id="' + rootId + '-messages" style="height:520px;overflow-y:auto;background:rgba(0,0,0,0.28);border-radius:16px;padding:16px;border:1px solid rgba(255,255,255,0.06);">';

      if (!messages.length) {
        html += '<div class="text-white-50 small">Aucun message pour le moment dans ce canal.</div>';
      } else {
        messages.forEach(function(item) {
          html += '<div class="mb-3 p-3 rounded-3" style="background:rgba(255,255,255,0.03);">';
          html += '<div class="d-flex justify-content-between align-items-center gap-2 mb-1">';
          html += '<button type="button" class="btn btn-link p-0 text-decoration-none fw-bold text-info" data-chat-mention-username="' + AstraRealtime.escapeHtml(item.username || 'Inconnu') + '" data-chat-root="' + rootId + '">' + AstraRealtime.escapeHtml(item.username || 'Inconnu') + '</button>';
          html += '<div class="d-flex align-items-center gap-2">';
          html += '<div class="small text-white-50">' + AstraRealtime.formatDate(item.created_at) + '</div>';
          if (meta.canModerate && parseInt(item.user_id || 0, 10) > 0) {
            html += '<button type="button" class="btn btn-sm btn-outline-danger" data-chat-delete="' + item.id + '" data-chat-channel="' + mount.activeChannel + '" data-chat-root="' + rootId + '" title="Supprimer le message"><i class="bi bi-trash"></i></button>';
            html += '<button type="button" class="btn btn-sm btn-outline-warning" data-chat-mute="' + (item.user_id || 0) + '" data-chat-username="' + AstraRealtime.escapeHtml(item.username || 'Joueur') + '" data-chat-channel="' + mount.activeChannel + '" data-chat-root="' + rootId + '" title="Restreindre cet utilisateur"><i class="bi bi-slash-circle"></i></button>';
          }
          html += '</div>';
          html += '</div>';
          html += '<div class="text-white small" style="white-space:normal;">' + AstraRealtime.renderChatMessage(item.message_text || '') + '</div>';
          html += '</div>';
        });
      }

      html += '      </div>';
      html += '      <div id="' + rootId + '-error" class="text-danger small mt-2" style="display:none;"></div>';
      html += '      <div class="mt-3 d-flex flex-wrap gap-2">';
      html += '        <button type="button" class="btn btn-sm btn-outline-light" data-chat-tool="bold" data-chat-root="' + rootId + '"><strong>B</strong></button>';
      html += '        <button type="button" class="btn btn-sm btn-outline-light" data-chat-tool="italic" data-chat-root="' + rootId + '"><em>I</em></button>';
      html += '        <button type="button" class="btn btn-sm btn-outline-light" data-chat-tool="code" data-chat-root="' + rootId + '"><code>{ }</code></button>';
      html += '        <button type="button" class="btn btn-sm btn-outline-light" data-chat-tool="link" data-chat-root="' + rootId + '">Lien</button>';
      html += '        <button type="button" class="btn btn-sm btn-outline-light" data-chat-toggle-emojis="' + rootId + '">Bibliothèque d’emojis</button>';
      html += '      </div>';
      html += '      <div id="' + rootId + '-emoji-panel" class="mt-2 d-none">';
      html += this.buildEmojiPanel(rootId);
      html += '      </div>';
      html += '      <div class="mt-2">';
      html += '        <textarea id="' + rootId + '-input" class="form-control bg-dark text-white border-secondary" rows="4" maxlength="500" placeholder="Rédiger un message, une consigne ou une information…"></textarea>';
      html += '      </div>';
      html += '      <div id="' + rootId + '-mention-panel" class="mt-2 d-none rounded-3 overflow-hidden" style="background:rgba(8,15,26,0.98);border:1px solid rgba(255,255,255,0.10);"></div>';
      html += '      <div id="' + rootId + '-slash-panel" class="mt-2 d-none rounded-3 overflow-hidden" style="background:rgba(8,15,26,0.98);border:1px solid rgba(255,255,255,0.10);"></div>';
      html += '      <div class="mt-2 d-flex justify-content-between align-items-center gap-3 flex-wrap">';
      html += '        <div class="small text-white-50">Entrée pour envoyer. Maj + Entrée ajoute une nouvelle ligne. Le brouillon est conservé automatiquement.</div>';
      html += '        <button type="button" class="btn btn-primary" data-chat-send="' + rootId + '">Envoyer</button>';
      html += '      </div>';
      if (mount.activeChannel === 'bots') {
        html += '      <div class="small text-info mt-2">Console de commandement bots : tapez <code>/</code> pour afficher l’autocomplétion.</div>';
      }
      html += '    </div>';
      html += '  </div>';
      html += '</div>';

      $('#' + rootId).html(html);
      this.bindChatEvents(rootId);
      this.restoreChatState(rootId, state);
    },

    bindChatEvents: function(rootId) {
      var self = this;

      $(document).off('click.chatSend' + rootId).on('click.chatSend' + rootId, '[data-chat-send="' + rootId + '"]', function() {
        self.sendChat(rootId);
      });

      $(document).off('keydown.chatSend' + rootId).on('keydown.chatSend' + rootId, '#' + rootId + '-input', function(event) {
        if (self.handleMentionKeydown(rootId, event)) {
          return;
        }

        if (event.key === 'Enter' && !event.shiftKey) {
          event.preventDefault();
          self.sendChat(rootId);
        }
      });

      $(document).off('input.chatInput' + rootId).on('input.chatInput' + rootId, '#' + rootId + '-input', function() {
        self.replaceEmojiShortcodesInInput(rootId);
        self.saveChatDraft(rootId);
        self.updateMentionSuggestions(rootId);
        self.updateSlashSuggestions(rootId);
      });

      $(document).off('click.chatInput' + rootId).on('click.chatInput' + rootId, '#' + rootId + '-input', function() {
        self.updateMentionSuggestions(rootId);
        self.updateSlashSuggestions(rootId);
      });

      $(document).off('click.chatChannel' + rootId).on('click.chatChannel' + rootId, '[data-chat-root="' + rootId + '"][data-chat-channel]', function() {
        self.setChatChannel(rootId, $(this).data('chat-channel'));
      });

      $(document).off('click.chatEmoji' + rootId).on('click.chatEmoji' + rootId, '[data-chat-root="' + rootId + '"][data-chat-emoji]', function() {
        self.insertChatText(rootId, ' ' + $(this).data('chat-emoji'));
        $('#' + rootId + '-emoji-panel').addClass('d-none');
      });

      $(document).off('click.chatMentionUser' + rootId).on('click.chatMentionUser' + rootId, '[data-chat-root="' + rootId + '"][data-chat-mention-username]', function() {
        self.insertMention(rootId, $(this).data('chat-mention-username'));
      });

      $(document).off('click.chatMentionChoice' + rootId).on('click.chatMentionChoice' + rootId, '[data-chat-root="' + rootId + '"][data-chat-mention-choice]', function() {
        self.insertMention(rootId, $(this).data('chat-mention-choice'));
      });

      $(document).off('click.chatTool' + rootId).on('click.chatTool' + rootId, '[data-chat-root="' + rootId + '"][data-chat-tool]', function() {
        self.applyChatTool(rootId, $(this).data('chat-tool'));
      });

      $(document).off('click.chatToggleEmoji' + rootId).on('click.chatToggleEmoji' + rootId, '[data-chat-toggle-emojis="' + rootId + '"]', function() {
        $('#' + rootId + '-emoji-panel').toggleClass('d-none');
      });

      $(document).off('input.chatEmojiSearch' + rootId).on('input.chatEmojiSearch' + rootId, '#' + rootId + '-emoji-search', function() {
        self.filterEmojiPanel(rootId, $(this).val());
      });

      $(document).off('click.chatDelete' + rootId).on('click.chatDelete' + rootId, '[data-chat-root="' + rootId + '"][data-chat-delete]', function() {
        self.deleteChatMessage(rootId, $(this).data('chat-delete'));
      });

      $(document).off('click.chatMute' + rootId).on('click.chatMute' + rootId, '[data-chat-root="' + rootId + '"][data-chat-mute]', function() {
        self.muteChatUser(rootId, $(this).data('chat-channel'), $(this).data('chat-mute'), $(this).data('chat-username'));
      });

      $(document).off('click.chatMentionOutside' + rootId).on('click.chatMentionOutside' + rootId, function(event) {
        if (!$(event.target).closest('#' + rootId + '-input, #' + rootId + '-mention-panel, #' + rootId + '-slash-panel, [data-chat-mention-username], [data-chat-slash-command]').length) {
          self.hideMentionSuggestions(rootId);
          self.hideSlashSuggestions(rootId);
        }
      });

      $(document).off('click.chatSlashChoice' + rootId).on('click.chatSlashChoice' + rootId, '[data-chat-root="' + rootId + '"][data-chat-slash-command]', function() {
        self.insertSlashCommand(rootId, $(this).data('chat-slash-command'));
      });
    },

    buildEmojiPanel: function(rootId) {
      var html = '<div class="rounded-3 p-3" style="background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);">';
      html += '<div class="mb-2"><input id="' + rootId + '-emoji-search" type="text" class="form-control bg-dark text-white border-secondary" placeholder="Rechercher un emoji en français ou avec un raccourci, ex. fusée ou :rocket:"></div>';
      html += '<div class="d-flex flex-wrap gap-2" id="' + rootId + '-emoji-grid">';
      this.emojiGroups.forEach(function(group) {
        group.forEach(function(emoji) {
          html += '<button type="button" class="btn btn-outline-light d-flex flex-column align-items-center justify-content-center text-center" style="width:82px;min-height:82px;padding:8px 6px;" data-chat-emoji="' + emoji + '" data-chat-root="' + rootId + '" data-emoji-search="' + AstraRealtime.escapeHtml(AstraRealtime.getEmojiSearchText(emoji)) + '">';
          html += '<span style="font-size:1.7rem;line-height:1;">' + emoji + '</span>';
          html += '<span class="small mt-2 text-white-50" style="line-height:1.2;white-space:normal;word-break:break-word;overflow-wrap:anywhere;max-width:100%;">' + AstraRealtime.escapeHtml(AstraRealtime.getEmojiPrimaryLabel(emoji)) + '</span>';
          html += '</button>';
        });
      });
      html += '</div></div>';
      return html;
    },

    filterEmojiPanel: function(rootId, value) {
      var query = this.normalizeSearchTerm(value);
      $('#' + rootId + '-emoji-grid [data-emoji-search]').each(function() {
        var search = AstraRealtime.normalizeSearchTerm($(this).data('emoji-search') || '');
        $(this).toggleClass('d-none', query !== '' && search.indexOf(query) === -1);
      });
    },

    getEmojiSearchText: function(emoji) {
      var search = [emoji];
      var aliases = this.emojiAliasesFr[emoji] || [];
      Object.keys(this.emojiShortcodes).forEach(function(shortcode) {
        if (AstraRealtime.emojiShortcodes[shortcode] === emoji) {
          search.push(shortcode);
          search.push(shortcode.replace(/:/g, ''));
        }
      });

      aliases.forEach(function(alias) {
        search.push(alias);
      });

      return search.join(' ').toLowerCase();
    },

    getEmojiPrimaryLabel: function(emoji) {
      var aliases = this.emojiAliasesFr[emoji] || [];
      return aliases.length ? aliases[0] : 'Emoji';
    },

    normalizeSearchTerm: function(value) {
      var normalized = String(value || '').toLowerCase().trim();

      if (typeof normalized.normalize === 'function') {
        normalized = normalized.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
      }

      return normalized;
    },

    getChatDraftKey: function(rootId) {
      var mount = this.chatMounts[rootId];
      var channel = mount ? this.normalizeChannel(mount.activeChannel) : 'global';
      return rootId + '::' + channel;
    },

    saveChatDraft: function(rootId) {
      var input = document.getElementById(rootId + '-input');

      if (!input) {
        return;
      }

      this.chatDrafts[this.getChatDraftKey(rootId)] = input.value || '';
    },

    getConnectedUsersForMentions: function() {
      var seen = {};
      return (this.connectedUsers || []).filter(function(user) {
        if (!user || !user.username) {
          return false;
        }

        if (seen[user.username]) {
          return false;
        }

        seen[user.username] = true;
        return true;
      });
    },

    captureChatState: function(rootId) {
      var input = document.getElementById(rootId + '-input');
      var box = document.getElementById(rootId + '-messages');
      var emojiPanel = document.getElementById(rootId + '-emoji-panel');
      var emojiSearch = document.getElementById(rootId + '-emoji-search');
      var active = document.activeElement;
      var state = {
        draft: this.chatDrafts[this.getChatDraftKey(rootId)] || '',
        focusInput: !!(active && input && active.id === input.id),
        focusEmojiSearch: !!(active && emojiSearch && active.id === emojiSearch.id),
        selectionStart: input ? (input.selectionStart || 0) : 0,
        selectionEnd: input ? (input.selectionEnd || 0) : 0,
        keepBottom: true,
        scrollTop: 0,
        emojiPanelOpen: !!(emojiPanel && !emojiPanel.classList.contains('d-none')),
        emojiSearchValue: emojiSearch ? (emojiSearch.value || '') : ''
      };

      if (input) {
        state.draft = input.value || state.draft;
        this.chatDrafts[this.getChatDraftKey(rootId)] = state.draft;
      }

      if (box) {
        state.scrollTop = box.scrollTop;
        state.keepBottom = (box.scrollHeight - box.scrollTop - box.clientHeight) < 48;
      }

      return state;
    },

    restoreChatState: function(rootId, state) {
      var input = document.getElementById(rootId + '-input');
      var box = document.getElementById(rootId + '-messages');
      var emojiPanel = document.getElementById(rootId + '-emoji-panel');
      var emojiSearch = document.getElementById(rootId + '-emoji-search');
      var draft = this.chatDrafts[this.getChatDraftKey(rootId)] || '';

      if (input) {
        input.value = draft;

        if (state && state.focusInput) {
          this.focusWithoutScroll(input);
          input.selectionStart = Math.min(state.selectionStart || 0, draft.length);
          input.selectionEnd = Math.min(state.selectionEnd || 0, draft.length);
        }
      }

      if (emojiPanel) {
        emojiPanel.classList.toggle('d-none', !(state && state.emojiPanelOpen));
      }

      if (emojiSearch) {
        emojiSearch.value = state && state.emojiSearchValue ? state.emojiSearchValue : '';
        this.filterEmojiPanel(rootId, emojiSearch.value);

        if (state && state.focusEmojiSearch) {
          this.focusWithoutScroll(emojiSearch);
          if (typeof emojiSearch.setSelectionRange === 'function') {
            emojiSearch.setSelectionRange(emojiSearch.value.length, emojiSearch.value.length);
          }
        }
      }

      if (box) {
        if (!state || state.keepBottom) {
          box.scrollTop = box.scrollHeight;
        } else {
          box.scrollTop = Math.min(state.scrollTop || 0, Math.max(0, box.scrollHeight - box.clientHeight));
        }
      }

      this.updateMentionSuggestions(rootId);
      this.updateSlashSuggestions(rootId);
    },

    insertChatText: function(rootId, content) {
      var input = document.getElementById(rootId + '-input');
      var start;
      var end;
      var value;

      if (!input) {
        return;
      }

      start = input.selectionStart || 0;
      end = input.selectionEnd || 0;
      value = input.value || '';
      input.value = value.substring(0, start) + content + value.substring(end);
      input.selectionStart = input.selectionEnd = start + content.length;
      this.focusWithoutScroll(input);
      this.saveChatDraft(rootId);
      this.updateMentionSuggestions(rootId);
    },

    getMentionContext: function(value, cursor) {
      var before = String(value || '').substring(0, cursor);
      var match = before.match(/(^|\s)@([^\s@]*)$/);

      if (!match) {
        return null;
      }

      return {
        query: match[2] || '',
        start: before.length - match[2].length - 1,
        end: cursor
      };
    },

    updateMentionSuggestions: function(rootId) {
      var input = document.getElementById(rootId + '-input');
      var panel = $('#' + rootId + '-mention-panel');
      var users;
      var context;
      var query;
      var suggestions;
      var html = '';
      var state;

      if (!input || !panel.length) {
        return;
      }

      users = this.getConnectedUsersForMentions();
      context = this.getMentionContext(input.value || '', input.selectionStart || 0);

      if (!context) {
        this.hideMentionSuggestions(rootId);
        return;
      }

      query = this.normalizeSearchTerm(context.query);
      suggestions = users.filter(function(user) {
        return AstraRealtime.normalizeSearchTerm(user.username).indexOf(query) === 0;
      }).slice(0, 8);

      if (!suggestions.length) {
        this.hideMentionSuggestions(rootId);
        return;
      }

      state = this.mentionStates[rootId] || { index: 0 };
      state.query = context.query;
      state.start = context.start;
      state.end = context.end;
      state.items = suggestions;
      state.index = Math.max(0, Math.min(state.index || 0, suggestions.length - 1));
      this.mentionStates[rootId] = state;

      suggestions.forEach(function(user, index) {
        html += '<button type="button" class="btn w-100 text-start rounded-0 border-0 ' + (index === state.index ? 'btn-primary' : 'btn-dark') + '" data-chat-root="' + rootId + '" data-chat-mention-choice="' + AstraRealtime.escapeHtml(user.username) + '">';
        html += '<span class="fw-semibold">' + AstraRealtime.escapeHtml(user.username) + '</span>';
        if ((user.authlevel || 0) >= 3) {
          html += '<span class="ms-2 small text-warning">Admin</span>';
        }
        html += '</button>';
      });

      panel.html(html).removeClass('d-none');
    },

    hideMentionSuggestions: function(rootId) {
      $('#' + rootId + '-mention-panel').addClass('d-none').empty();
      delete this.mentionStates[rootId];
    },

    loadBotCommandCatalog: function() {
      var self = this;

      $.getJSON('game.php?page=realtime&mode=botCommandCatalog&ajax=1')
        .done(function(payload) {
          if (!payload || payload.status !== 'ok') {
            return;
          }

          self.botCommandCatalog = payload.items || [];
        });
    },

    getSlashSuggestions: function(query) {
      var normalized = this.normalizeSearchTerm(query);
      return (this.botCommandCatalog || []).filter(function(item) {
        if (!item) {
          return false;
        }

        var haystack = [
          item.command_key || '',
          item.family_key || '',
          item.label || '',
          item.help_text || '',
          item.syntax_example || ''
        ].join(' ');

        return AstraRealtime.normalizeSearchTerm(haystack).indexOf(normalized) !== -1;
      }).slice(0, 8);
    },

    updateSlashSuggestions: function(rootId) {
      var mount = this.chatMounts[rootId];
      var input = document.getElementById(rootId + '-input');
      var panel = $('#' + rootId + '-slash-panel');
      var value;
      var suggestions;
      var html = '';

      if (!mount || mount.activeChannel !== 'bots' || !input || !panel.length) {
        return;
      }

      value = input.value || '';
      if (!value.length || value.charAt(0) !== '/') {
        this.hideSlashSuggestions(rootId);
        return;
      }

      suggestions = this.getSlashSuggestions(value.substring(1));
      if (!suggestions.length) {
        this.hideSlashSuggestions(rootId);
        return;
      }

      suggestions.forEach(function(item) {
        var syntax = item.syntax_example || '';
        html += '<button type="button" class="btn w-100 text-start rounded-0 border-0 btn-dark" data-chat-root="' + rootId + '" data-chat-slash-command="' + AstraRealtime.escapeHtml(syntax) + '">';
        html += '<div class="fw-semibold text-info">/' + AstraRealtime.escapeHtml(item.family_key || '') + ' ' + AstraRealtime.escapeHtml(item.command_key || '') + '</div>';
        html += '<div class="small text-white-50 mt-1">' + AstraRealtime.escapeHtml(item.help_text || '') + '</div>';
        if (syntax) {
          html += '<div class="small text-white-50 mt-1"><code>' + AstraRealtime.escapeHtml(syntax) + '</code></div>';
        }
        html += '</button>';
      });

      panel.html(html).removeClass('d-none');
    },

    hideSlashSuggestions: function(rootId) {
      $('#' + rootId + '-slash-panel').addClass('d-none').empty();
    },

    insertSlashCommand: function(rootId, commandText) {
      var input = document.getElementById(rootId + '-input');

      if (!input) {
        return;
      }

      input.value = commandText || '';
      this.focusWithoutScroll(input);
      this.saveChatDraft(rootId);
      this.updateSlashSuggestions(rootId);
    },

    submitBotCommand: function(rootId, commandText) {
      var self = this;

      $.post('game.php?page=realtime&mode=submitBotCommand&ajax=1', {
        command: commandText
      }).done(function(payload) {
        if (!payload || payload.status !== 'ok') {
          self.showChatError(payload && payload.message ? payload.message : 'La commande bots a été rejetée.');
          return;
        }

        $.post('game.php?page=realtime&mode=dispatchBotCommands&ajax=1', {
          limit: 8
        }).always(function() {
          self.hideChatError(rootId);
          self.requestChatHistory('bots');
        });
      }).fail(function() {
        self.showChatError('Échec de l’enregistrement de la commande bots.');
      });
    },

    handleMentionKeydown: function(rootId, event) {
      var state = this.mentionStates[rootId];

      if (!state || !state.items || !state.items.length) {
        return false;
      }

      if (event.key === 'ArrowDown') {
        event.preventDefault();
        state.index = (state.index + 1) % state.items.length;
        this.updateMentionSuggestions(rootId);
        return true;
      }

      if (event.key === 'ArrowUp') {
        event.preventDefault();
        state.index = (state.index - 1 + state.items.length) % state.items.length;
        this.updateMentionSuggestions(rootId);
        return true;
      }

      if (event.key === 'Enter' || event.key === 'Tab') {
        event.preventDefault();
        this.insertMention(rootId, state.items[state.index].username);
        return true;
      }

      if (event.key === 'Escape') {
        event.preventDefault();
        this.hideMentionSuggestions(rootId);
        return true;
      }

      return false;
    },

    insertMention: function(rootId, username) {
      var input = document.getElementById(rootId + '-input');
      var state = this.mentionStates[rootId];
      var value;
      var start;
      var end;
      var mentionText;

      if (!input || !username) {
        return;
      }

      value = input.value || '';
      mentionText = '@' + username + ' ';

      if (state && typeof state.start !== 'undefined' && typeof state.end !== 'undefined') {
        start = state.start;
        end = state.end;
      } else {
        start = input.selectionStart || 0;
        end = input.selectionEnd || 0;
      }

      input.value = value.substring(0, start) + mentionText + value.substring(end);
      input.selectionStart = input.selectionEnd = start + mentionText.length;
      this.focusWithoutScroll(input);
      this.saveChatDraft(rootId);
      this.hideMentionSuggestions(rootId);
    },

    applyChatTool: function(rootId, tool) {
      var input = document.getElementById(rootId + '-input');
      var value;
      var start;
      var end;
      var selected;
      var prefix = '';
      var suffix = '';

      if (!input) {
        return;
      }

      value = input.value || '';
      start = input.selectionStart || 0;
      end = input.selectionEnd || 0;
      selected = value.substring(start, end) || 'texte';

      if (tool === 'bold') {
        prefix = '**';
        suffix = '**';
      } else if (tool === 'italic') {
        prefix = '_';
        suffix = '_';
      } else if (tool === 'code') {
        prefix = '`';
        suffix = '`';
      } else if (tool === 'link') {
        prefix = '[';
        suffix = '](https://)';
      }

      input.value = value.substring(0, start) + prefix + selected + suffix + value.substring(end);
      this.focusWithoutScroll(input);
      this.saveChatDraft(rootId);
    },

    sendChat: function(rootId) {
      var mount = this.chatMounts[rootId];
      var input = $('#' + rootId + '-input');
      var content = $.trim(input.val());
      var normalizedContent = '';

      if (!mount || !content) {
        return;
      }

      content = this.replaceEmojiShortcodes(content);
      normalizedContent = String(content || '').toLowerCase();

      this.hideChatError(rootId);

      if (mount.activeChannel === 'bots' && normalizedContent.indexOf('/') === 0) {
        this.submitBotCommand(rootId, content);
        input.val('');
        this.chatDrafts[this.getChatDraftKey(rootId)] = '';
        this.hideSlashSuggestions(rootId);
        return;
      }

      if (!this.sendSocket({
        action: 'chat:send',
        channel: mount.activeChannel,
        content: content
      })) {
        this.showChatError('Connexion temps réel indisponible. Réessayez dans quelques secondes.');
        return;
      }

      input.val('');
      this.chatDrafts[this.getChatDraftKey(rootId)] = '';

      if (mount.activeChannel === 'bots' && (normalizedContent.indexOf('/bot ') === 0 || normalizedContent.indexOf('/bots ') === 0)) {
        this.dispatchBotCommands();
      }
    },

    showChatError: function(message) {
      Object.keys(this.chatMounts).forEach(function(rootId) {
        $('#' + rootId + '-error').text(message).show();
      });
    },

    hideChatError: function(rootId) {
      $('#' + rootId + '-error').hide().text('');
    },

    sendSocket: function(payload) {
      if (!this.socket || this.socket.readyState !== WebSocket.OPEN) {
        return false;
      }

      this.socket.send(JSON.stringify(payload));
      return true;
    },

    replaceEmojiShortcodes: function(content) {
      var output = String(content || '');
      Object.keys(this.emojiShortcodes).forEach(function(shortcode) {
        output = output.split(shortcode).join(AstraRealtime.emojiShortcodes[shortcode]);
      });
      return output;
    },

    renderChatMessage: function(content) {
      var placeholders = [];
      var rendered = this.escapeHtml(String(content || ''));

      rendered = rendered.replace(/`([^`]+)`/g, function(match, codeText) {
        var token = '%%CHAT_CODE_' + placeholders.length + '%%';
        placeholders.push('<code class="px-1 py-0 rounded" style="background:rgba(255,255,255,0.08);color:#ffd666;">' + codeText + '</code>');
        return token;
      });

      rendered = rendered.replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g, function(match, label, url) {
        return '<a href="' + url + '" target="_blank" rel="noopener noreferrer" class="text-info text-decoration-none">' + label + '</a>';
      });

      rendered = rendered.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
      rendered = rendered.replace(/(^|[\s(>])_([^_]+)_(?=[$\s).,!?:;<])/gm, '$1<em>$2</em>');
      rendered = rendered.replace(/\n/g, '<br>');

      placeholders.forEach(function(html, index) {
        rendered = rendered.split('%%CHAT_CODE_' + index + '%%').join(html);
      });

      return rendered;
    },

    replaceEmojiShortcodesInInput: function(rootId) {
      var input = document.getElementById(rootId + '-input');
      var originalValue;
      var replacedValue;
      var cursor;

      if (!input) {
        return;
      }

      originalValue = input.value || '';
      replacedValue = this.replaceEmojiShortcodes(originalValue);
      if (replacedValue === originalValue) {
        return;
      }

      cursor = input.selectionStart || replacedValue.length;
      input.value = replacedValue;
      input.selectionStart = input.selectionEnd = Math.min(cursor, replacedValue.length);
      this.saveChatDraft(rootId);
    },

    getChatHistorySignature: function(items) {
      return (items || []).map(function(item) {
        return [
          item && item.id ? item.id : 0,
          item && item.user_id ? item.user_id : 0,
          item && item.created_at ? item.created_at : 0,
          item && item.message_text ? item.message_text : ''
        ].join(':');
      }).join('|');
    },

    focusWithoutScroll: function(element) {
      if (!element || typeof element.focus !== 'function') {
        return;
      }

      try {
        element.focus({ preventScroll: true });
      } catch (error) {
        element.focus();
      }
    },

    deleteChatMessage: function(rootId, messageId) {
      var self = this;

      if (!window.confirm('Supprimer ce message du chat ?')) {
        return;
      }

      $.post('game.php?page=realtime&mode=deleteChatMessage&ajax=1', {
        messageId: messageId
      }).done(function(payload) {
        var mount = self.chatMounts[rootId];
        if (!payload || payload.status !== 'ok') {
          self.showChatError((payload && payload.message) || 'Suppression impossible.');
          return;
        }

        if (mount) {
          self.requestChatHistory(mount.activeChannel);
        }
      });
    },

    muteChatUser: function(rootId, channelId, targetUserId, username) {
      var self = this;
      var duration = window.prompt('Durée de restriction en minutes. Utilisez 0 pour un bannissement jusqu’à levée manuelle.', '30');
      var reason;

      if (duration === null) {
        return;
      }

      reason = window.prompt('Motif de la restriction pour ' + username + ' :', 'Modération du chat');
      if (reason === null) {
        return;
      }

      $.post('game.php?page=realtime&mode=muteChatUser&ajax=1', {
        channelKey: channelId,
        targetUserId: targetUserId,
        durationMinutes: duration,
        reason: reason
      }).done(function(payload) {
        if (!payload || payload.status !== 'ok') {
          self.showChatError((payload && payload.message) || 'Restriction impossible.');
          return;
        }

        self.hideChatError(rootId);
      });
    },

    dispatchBotCommands: function() {
      var self = this;

      window.setTimeout(function() {
        $.post('game.php?page=realtime&mode=dispatchBotCommands&ajax=1', {
          limit: 6
        }).done(function(payload) {
          if (payload && payload.status === 'ok') {
            Object.keys(self.chatMounts).forEach(function(rootId) {
              if (self.chatMounts[rootId].activeChannel === 'bots') {
                self.requestChatHistory('bots');
              }
            });
          }
        });
      }, 700);
    },

    escapeHtml: function(text) {
      return String(text || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }
  };

  window.AstraRealtime = AstraRealtime;
  $(function() {
    AstraRealtime.init();
  });
})(window, window.jQuery);
