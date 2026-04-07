<?php

class LiveChatService
{
	public static function getChatSettings($universe = null)
	{
		if ($universe === null) {
			$config = Config::get(Universe::getEmulated());
		} else {
			$config = Config::get((int) $universe);
		}

		return array(
			'retentionDays' => max(1, (int) $config->chat_retention_days),
			'historyLimit' => max(20, min(300, (int) $config->chat_history_limit)),
		);
	}

	public static function ensureChannelDefaults()
	{
		$db = Database::get();
		$channels = array(
			'global' => array(
				'label' => 'Canal général',
				'description' => 'Discussion ouverte à tous les joueurs connectés.',
				'requires_admin' => 0,
				'settings_json' => json_encode(array('minAuthLevel' => AUTH_USR, 'isSystem' => true)),
			),
			'alliance' => array(
				'label' => 'Canal de clan',
				'description' => 'Discussion réservée aux membres d’un même clan.',
				'requires_admin' => 0,
				'settings_json' => json_encode(array('minAuthLevel' => AUTH_USR, 'isSystem' => true)),
			),
			'admin' => array(
				'label' => 'Canal administrateur',
				'description' => 'Échanges réservés à l’équipe d’administration.',
				'requires_admin' => 1,
				'settings_json' => json_encode(array('minAuthLevel' => AUTH_ADM, 'isSystem' => true)),
			),
			'bots' => array(
				'label' => 'Canal bots',
				'description' => 'Suivi en temps réel des bots et diffusion des consignes.',
				'requires_admin' => 1,
				'settings_json' => json_encode(array('minAuthLevel' => AUTH_ADM, 'isSystem' => true)),
			),
		);

		foreach ($channels as $channelKey => $channelData) {
			$exists = $db->selectSingle('SELECT channel_key FROM %%LIVE_CHAT_CHANNELS%% WHERE channel_key = :channelKey LIMIT 1;', array(
				':channelKey' => $channelKey,
			));

			if (!empty($exists)) {
				continue;
			}

			$db->insert('INSERT INTO %%LIVE_CHAT_CHANNELS%% SET
				channel_key = :channelKey,
				label = :label,
				description = :description,
				is_active = 1,
				requires_admin = :requiresAdmin,
				settings_json = :settingsJson,
				created_at = :createdAt,
				updated_at = :updatedAt;', array(
				':channelKey' => $channelKey,
				':label' => $channelData['label'],
				':description' => $channelData['description'],
				':requiresAdmin' => (int) $channelData['requires_admin'],
				':settingsJson' => $channelData['settings_json'],
				':createdAt' => TIMESTAMP,
				':updatedAt' => TIMESTAMP,
			));
		}
	}

	public static function getChannels()
	{
		self::ensureChannelDefaults();
		$channels = Database::get()->select('SELECT c.*, u.username AS moderator_name
			FROM %%LIVE_CHAT_CHANNELS%% c
			LEFT JOIN %%USERS%% u ON u.id = c.moderator_user_id
			ORDER BY FIELD(c.channel_key, "global", "alliance", "admin", "bots"), c.channel_key ASC;');

		foreach ($channels as &$channel) {
			$settings = array();
			if (!empty($channel['settings_json'])) {
				$decoded = json_decode($channel['settings_json'], true);
				if (is_array($decoded)) {
					$settings = $decoded;
				}
			}

			$channel['settings'] = $settings;
			$channel['min_authlevel'] = isset($settings['minAuthLevel']) ? (int) $settings['minAuthLevel'] : ((int) $channel['requires_admin'] === 1 ? AUTH_ADM : AUTH_USR);
			$channel['is_system'] = !empty($settings['isSystem']) ? 1 : 0;
		}
		unset($channel);

		return $channels;
	}

	public static function getChannelByKey($channelKey)
	{
		foreach (self::getChannels() as $channel) {
			if ($channel['channel_key'] === $channelKey) {
				return $channel;
			}
		}

		return null;
	}

	public static function getAvailableChannelsForUser(array $user)
	{
		$availableChannels = array();

		foreach (self::getChannels() as $channel) {
			if ((int) $channel['is_active'] !== 1) {
				continue;
			}

			if ($channel['channel_key'] === 'alliance' && empty($user['ally_id'])) {
				continue;
			}

			if ((int) $user['authlevel'] < (int) $channel['min_authlevel']) {
				continue;
			}

			$availableChannels[] = array(
				'id' => $channel['channel_key'],
				'label' => $channel['label'],
				'description' => $channel['description'],
				'moderatorName' => !empty($channel['moderator_name']) ? $channel['moderator_name'] : '',
				'moderatorUserId' => empty($channel['moderator_user_id']) ? 0 : (int) $channel['moderator_user_id'],
				'canModerate' => self::userCanModerateChannel($user, $channel),
				'isAdminOnly' => (int) $channel['min_authlevel'] >= AUTH_ADM,
				'isSystem' => (int) $channel['is_system'],
			);
		}

		return $availableChannels;
	}

	public static function saveChannelSettings($channelKey, $label, $description, $isActive, $moderatorUserId = null, $requiresAdmin = null)
	{
		self::ensureChannelDefaults();
		$current = Database::get()->selectSingle('SELECT channel_key, requires_admin, settings_json FROM %%LIVE_CHAT_CHANNELS%% WHERE channel_key = :channelKey LIMIT 1;', array(
			':channelKey' => $channelKey,
		));
		if (empty($current)) {
			return false;
		}

		$settings = array();
		if (!empty($current['settings_json'])) {
			$decoded = json_decode($current['settings_json'], true);
			if (is_array($decoded)) {
				$settings = $decoded;
			}
		}

		$isSystem = !empty($settings['isSystem']);
		$resolvedRequiresAdmin = is_null($requiresAdmin) ? (int) $current['requires_admin'] : (int) $requiresAdmin;
		if ($isSystem && in_array($channelKey, array('admin', 'bots'), true)) {
			$resolvedRequiresAdmin = 1;
			$settings['minAuthLevel'] = AUTH_ADM;
		} elseif ($isSystem) {
			$resolvedRequiresAdmin = 0;
			$settings['minAuthLevel'] = AUTH_USR;
		} else {
			$settings['minAuthLevel'] = $resolvedRequiresAdmin === 1 ? AUTH_ADM : AUTH_USR;
		}

		Database::get()->update('UPDATE %%LIVE_CHAT_CHANNELS%% SET
			label = :label,
			description = :description,
			is_active = :isActive,
			requires_admin = :requiresAdmin,
			moderator_user_id = :moderatorUserId,
			settings_json = :settingsJson,
			updated_at = :updatedAt
			WHERE channel_key = :channelKey;', array(
			':label' => trim((string) $label),
			':description' => trim((string) $description),
			':isActive' => (int) $isActive,
			':requiresAdmin' => $resolvedRequiresAdmin,
			':moderatorUserId' => empty($moderatorUserId) ? null : (int) $moderatorUserId,
			':settingsJson' => json_encode($settings),
			':updatedAt' => TIMESTAMP,
			':channelKey' => $channelKey,
		));

		return true;
	}

	public static function deleteChannel($channelKey)
	{
		$channel = self::getChannelByKey($channelKey);
		if (empty($channel) || (int) $channel['is_system'] === 1) {
			return false;
		}

		Database::get()->delete('DELETE FROM %%LIVE_CHAT_CHANNELS%% WHERE channel_key = :channelKey LIMIT 1;', array(
			':channelKey' => $channelKey,
		));

		return true;
	}

	public static function createChannel($key, $label, $description, $requiresAdmin, $moderatorUserId = null)
	{
		self::ensureChannelDefaults();
		$key = self::sanitizeChannelKey($key);

		if ($key === '' || in_array($key, array('global', 'alliance', 'admin', 'bots'), true)) {
			return false;
		}

		$exists = Database::get()->selectSingle('SELECT channel_key FROM %%LIVE_CHAT_CHANNELS%% WHERE channel_key = :channelKey LIMIT 1;', array(
			':channelKey' => $key,
		));
		if (!empty($exists)) {
			return false;
		}

		$settings = array(
			'minAuthLevel' => (int) $requiresAdmin === 1 ? AUTH_ADM : AUTH_USR,
			'isSystem' => false,
		);

		Database::get()->insert('INSERT INTO %%LIVE_CHAT_CHANNELS%% SET
			channel_key = :channelKey,
			label = :label,
			description = :description,
			is_active = 1,
			requires_admin = :requiresAdmin,
			moderator_user_id = :moderatorUserId,
			settings_json = :settingsJson,
			created_at = :createdAt,
			updated_at = :updatedAt;', array(
			':channelKey' => $key,
			':label' => trim((string) $label),
			':description' => trim((string) $description),
			':requiresAdmin' => (int) $requiresAdmin,
			':moderatorUserId' => empty($moderatorUserId) ? null : (int) $moderatorUserId,
			':settingsJson' => json_encode($settings),
			':createdAt' => TIMESTAMP,
			':updatedAt' => TIMESTAMP,
		));

		return $key;
	}

	public static function getRecentMessages($channel, $limit = 100)
	{
		$sql = "SELECT m.id, m.channel_key, m.user_id, m.username, m.message_text, m.created_at, m.is_deleted,
			IFNULL(u.authlevel, 0) AS authlevel
			FROM %%LIVE_CHAT_MESSAGES%% m
			LEFT JOIN %%USERS%% u ON u.id = m.user_id
			WHERE m.channel_key = :channel
			ORDER BY m.id DESC
			LIMIT :limit;";

		$rows = Database::get()->select($sql, array(
			':channel' => $channel,
			':limit' => (int) $limit,
		));

		return array_reverse($rows);
	}

	public static function getRecentAdminMessages($limit = 200)
	{
		$sql = "SELECT m.id, m.channel_key, m.user_id, m.username, m.message_text, m.created_at, m.is_deleted,
			IFNULL(u.authlevel, 0) AS authlevel
			FROM %%LIVE_CHAT_MESSAGES%% m
			LEFT JOIN %%USERS%% u ON u.id = m.user_id
			ORDER BY m.id DESC
			LIMIT :limit;";

		return Database::get()->select($sql, array(':limit' => (int) $limit));
	}

	public static function countAdminMessages()
	{
		return (int) Database::get()->selectSingle('SELECT COUNT(*) AS count FROM %%LIVE_CHAT_MESSAGES%%;', array(), 'count');
	}

	public static function getRecentAdminMessagesPage($page = 1, $limit = 40)
	{
		$page = max(1, (int) $page);
		$limit = max(1, min(100, (int) $limit));
		$offset = ($page - 1) * $limit;

		$sql = "SELECT m.id, m.channel_key, m.user_id, m.username, m.message_text, m.created_at, m.is_deleted,
				IFNULL(u.authlevel, 0) AS authlevel
			 FROM %%LIVE_CHAT_MESSAGES%% m
			 LEFT JOIN %%USERS%% u ON u.id = m.user_id
			 ORDER BY m.id DESC
			 LIMIT ".(int) $offset.", ".(int) $limit.';';

		return Database::get()->select($sql);
	}

	public static function getMessageById($messageId)
	{
		return Database::get()->selectSingle('SELECT *
			FROM %%LIVE_CHAT_MESSAGES%%
			WHERE id = :messageId
			LIMIT 1;', array(
			':messageId' => (int) $messageId,
		));
	}

	public static function createBotFeedEntry($username, $messageText, $userId = 0, $universe = null)
	{
		return self::createChannelMessage('bots', $username, $messageText, $userId, $universe, 0);
	}

	public static function createChannelMessage($channelKey, $username, $messageText, $userId = 0, $universe = null, $allianceId = 0)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$channelKey = trim((string) $channelKey);
		if ($channelKey === 'alliance' && !empty($allianceId)) {
			$channelKey = 'alliance:'.(int) $allianceId;
		}

		Database::get()->insert("INSERT INTO %%LIVE_CHAT_MESSAGES%% SET
			user_id = :userId,
			username = :username,
			alliance_id = :allianceId,
			channel_key = :channelKey,
			message_text = :messageText,
			universe = :universe,
			created_at = :createdAt,
			is_deleted = 0;", array(
			':userId' => (int) $userId,
			':username' => (string) $username,
			':allianceId' => (int) $allianceId,
			':channelKey' => (string) $channelKey,
			':messageText' => (string) $messageText,
			':universe' => (int) $universe,
			':createdAt' => TIMESTAMP,
		));

		$messageId = (int) Database::get()->lastInsertId();
		return self::getMessageById($messageId);
	}

	public static function getActiveMutes()
	{
		$sql = "SELECT m.id, m.user_id, m.reason, m.expires_at, m.created_at, u.username, a.username AS moderator_name
			FROM %%LIVE_CHAT_MUTES%% m
			LEFT JOIN %%USERS%% u ON u.id = m.user_id
			LEFT JOIN %%USERS%% a ON a.id = m.moderator_id
			WHERE m.expires_at > :now
			ORDER BY m.expires_at ASC;";

		return Database::get()->select($sql, array(':now' => TIMESTAMP));
	}

	public static function countActiveMutes()
	{
		return (int) Database::get()->selectSingle('SELECT COUNT(*) AS count FROM %%LIVE_CHAT_MUTES%% WHERE expires_at > :now;', array(
			':now' => TIMESTAMP,
		), 'count');
	}

	public static function getActiveMutesPage($page = 1, $limit = 20)
	{
		$page = max(1, (int) $page);
		$limit = max(1, min(100, (int) $limit));
		$offset = ($page - 1) * $limit;

		$sql = "SELECT m.id, m.user_id, m.reason, m.expires_at, m.created_at, u.username, a.username AS moderator_name
			 FROM %%LIVE_CHAT_MUTES%% m
			 LEFT JOIN %%USERS%% u ON u.id = m.user_id
			 LEFT JOIN %%USERS%% a ON a.id = m.moderator_id
			 WHERE m.expires_at > ".TIMESTAMP."
			 ORDER BY m.expires_at ASC
			 LIMIT ".(int) $offset.", ".(int) $limit.';';

		return Database::get()->select($sql);
	}

	public static function muteUser($userId, $moderatorId, $durationMinutes, $reason)
	{
		$expiresAt = ((int) $durationMinutes === 0) ? 4102444800 : TIMESTAMP + max(1, (int) $durationMinutes) * 60;
		$sql = "INSERT INTO %%LIVE_CHAT_MUTES%% SET
			user_id = :userId,
			moderator_id = :moderatorId,
			reason = :reason,
			created_at = :createdAt,
			expires_at = :expiresAt;";

		Database::get()->insert($sql, array(
			':userId' => (int) $userId,
			':moderatorId' => (int) $moderatorId,
			':reason' => $reason,
			':createdAt' => TIMESTAMP,
			':expiresAt' => $expiresAt,
		));
	}

	public static function unmute($muteId)
	{
		$sql = "DELETE FROM %%LIVE_CHAT_MUTES%% WHERE id = :muteId;";
		Database::get()->delete($sql, array(':muteId' => (int) $muteId));
	}

	public static function deleteMessage($messageId)
	{
		$sql = "UPDATE %%LIVE_CHAT_MESSAGES%% SET is_deleted = 1, deleted_at = :deletedAt WHERE id = :messageId;";
		Database::get()->update($sql, array(
			':deletedAt' => TIMESTAMP,
			':messageId' => (int) $messageId,
		));
	}

	public static function userCanModerateChannel(array $user, $channel)
	{
		if (!is_array($channel)) {
			$channel = self::getChannelByKey($channel);
		}

		if (empty($channel)) {
			return false;
		}

		if ((int) $channel['min_authlevel'] >= AUTH_ADM) {
			return (int) $user['authlevel'] >= AUTH_ADM;
		}

		if ((int) $user['authlevel'] >= AUTH_MOD) {
			return true;
		}

		return !empty($channel['moderator_user_id']) && (int) $channel['moderator_user_id'] === (int) $user['id'];
	}

	public static function purgeExpiredMessages($universeId = null, $retentionDays = null)
	{
		if ($universeId === null) {
			$universeId = Universe::getEmulated();
		}

		if ($retentionDays === null) {
			$settings = self::getChatSettings($universeId);
			$retentionDays = $settings['retentionDays'];
		}

		$cutoff = TIMESTAMP - (max(1, (int) $retentionDays) * 86400);

		Database::get()->delete('DELETE FROM %%LIVE_CHAT_MESSAGES%% WHERE universe = :universe AND created_at < :cutoff;', array(
			':universe' => (int) $universeId,
			':cutoff' => (int) $cutoff,
		));

		return Database::get()->rowCount();
	}

	public static function sanitizeChannelKey($value)
	{
		$value = strtolower(trim((string) $value));
		$value = preg_replace('/[^a-z0-9_-]+/', '-', $value);
		$value = preg_replace('/-+/', '-', $value);
		return trim((string) $value, '-');
	}
}
