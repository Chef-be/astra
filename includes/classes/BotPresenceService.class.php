<?php

class BotPresenceService
{
	public function ensureState($botUserId, $universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$row = Database::get()->selectSingle('SELECT bot_user_id FROM %%BOT_STATE%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));

		if (!empty($row)) {
			return;
		}

		Database::get()->insert('INSERT INTO %%BOT_STATE%% SET
			bot_user_id = :botUserId,
			universe = :universe,
			role_primary = :rolePrimary,
			role_secondary = \'\',
			hierarchy_status = :hierarchyStatus,
			doctrine_active = :doctrine,
			presence_logical = \'latent\',
			presence_social = \'discret\',
			prestige = 50,
			obedience_modifier = 50,
			bonus_score = 0,
			session_started_at = NULL,
			session_target_until = NULL,
			session_rest_until = NULL,
			action_queue_size = 0,
			is_online_forced = 0,
			is_socially_visible = 0,
			last_presence_change_at = :updatedAt,
			updated_at = :updatedAt;', array(
				':botUserId' => (int) $botUserId,
				':universe' => (int) $universe,
				':rolePrimary' => 'economiste',
				':hierarchyStatus' => 'membre',
				':doctrine' => 'equilibre',
			':updatedAt' => TIMESTAMP,
		));
	}

	public function applyPresence($botUserId, $logicalPresence, $socialPresence, $reason, $forceOnline = false, array $sessionMeta = array())
	{
		$this->ensureState($botUserId);
		$current = $this->getState($botUserId);
		$logicalPresence = (string) $logicalPresence;
		$socialPresence = (string) $socialPresence;
		$isSociallyVisible = in_array($socialPresence, array('visible', 'chef', 'campagne', 'chat'), true) ? 1 : 0;
		$presenceChanged = empty($current)
			|| $current['presence_logical'] !== $logicalPresence
			|| $current['presence_social'] !== $socialPresence
			|| (int) $current['is_online_forced'] !== ($forceOnline ? 1 : 0)
			|| (int) $current['is_socially_visible'] !== $isSociallyVisible;

		$fields = array(
			'presence_logical = :logicalPresence',
			'presence_social = :socialPresence',
			'is_online_forced = :forceOnline',
			'is_socially_visible = :isSociallyVisible',
			'updated_at = :updatedAt',
		);
		$params = array(
			':logicalPresence' => $logicalPresence,
			':socialPresence' => $socialPresence,
			':forceOnline' => $forceOnline ? 1 : 0,
			':isSociallyVisible' => $isSociallyVisible,
			':updatedAt' => TIMESTAMP,
			':botUserId' => (int) $botUserId,
		);

		foreach (array('session_started_at', 'session_target_until', 'session_rest_until', 'last_presence_change_at') as $column) {
			if (!array_key_exists($column, $sessionMeta)) {
				continue;
			}

			$fields[] = $column.' = :'.$column;
			$params[':'.$column] = $sessionMeta[$column];
		}

		if ($presenceChanged && !array_key_exists('last_presence_change_at', $sessionMeta)) {
			$fields[] = 'last_presence_change_at = :lastPresenceChangeAt';
			$params[':lastPresenceChangeAt'] = TIMESTAMP;
		}

		Database::get()->update('UPDATE %%BOT_STATE%% SET
			'.implode(",\n\t\t\t", $fields).'
			WHERE bot_user_id = :botUserId;', $params);

		if ($forceOnline || in_array($logicalPresence, array('connecte', 'engage', 'alerte', 'coordination', 'campagne', 'harcelement'), true)) {
			Database::get()->update('UPDATE %%USERS%% SET onlinetime = :onlineTime WHERE id = :userId;', array(
				':onlineTime' => TIMESTAMP,
				':userId' => (int) $botUserId,
			));
		}

		if (!$presenceChanged && empty($sessionMeta['force_snapshot'])) {
			return;
		}

		Database::get()->insert('INSERT INTO %%BOT_PRESENCE_SNAPSHOTS%% SET
			universe = :universe,
			bot_user_id = :botUserId,
			logical_presence = :logicalPresence,
			social_presence = :socialPresence,
			snapshot_reason = :snapshotReason,
			created_at = :createdAt;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':logicalPresence' => (string) $logicalPresence,
				':socialPresence' => (string) $socialPresence,
				':snapshotReason' => (string) $reason,
				':createdAt' => TIMESTAMP,
			));
	}

	public function getState($botUserId)
	{
		return Database::get()->selectSingle('SELECT * FROM %%BOT_STATE%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));
	}
}
