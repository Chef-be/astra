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
			action_queue_size = 0,
			is_online_forced = 0,
			is_socially_visible = 0,
			updated_at = :updatedAt;', array(
				':botUserId' => (int) $botUserId,
				':universe' => (int) $universe,
				':rolePrimary' => 'economiste',
				':hierarchyStatus' => 'membre',
				':doctrine' => 'equilibre',
				':updatedAt' => TIMESTAMP,
			));
	}

	public function applyPresence($botUserId, $logicalPresence, $socialPresence, $reason, $forceOnline = false)
	{
		$this->ensureState($botUserId);

		Database::get()->update('UPDATE %%BOT_STATE%% SET
			presence_logical = :logicalPresence,
			presence_social = :socialPresence,
			is_online_forced = :forceOnline,
			is_socially_visible = :isSociallyVisible,
			updated_at = :updatedAt
			WHERE bot_user_id = :botUserId;', array(
				':logicalPresence' => (string) $logicalPresence,
				':socialPresence' => (string) $socialPresence,
				':forceOnline' => $forceOnline ? 1 : 0,
				':isSociallyVisible' => in_array($socialPresence, array('visible', 'chef', 'campagne', 'chat'), true) ? 1 : 0,
				':updatedAt' => TIMESTAMP,
				':botUserId' => (int) $botUserId,
			));

		if ($forceOnline || in_array($logicalPresence, array('connecte', 'engage', 'alerte', 'coordination', 'campagne', 'harcelement'), true)) {
			Database::get()->update('UPDATE %%USERS%% SET onlinetime = :onlineTime WHERE id = :userId;', array(
				':onlineTime' => TIMESTAMP,
				':userId' => (int) $botUserId,
			));
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
