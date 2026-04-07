<?php

class BotCommanderService
{
	public function promote($botUserId)
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';

		$presenceService = new BotPresenceService();
		$presenceService->ensureState((int) $botUserId);

		$bot = Database::get()->selectSingle('SELECT id, username FROM %%USERS%% WHERE id = :userId AND is_bot = 1 LIMIT 1;', array(
			':userId' => (int) $botUserId,
		));

		if (empty($bot)) {
			return false;
		}

		$newName = $bot['username'];
		if (strpos($newName, 'Général ') !== 0) {
			$newName = 'Général '.$newName;
		}

		Database::get()->update('UPDATE %%USERS%% SET username = :username WHERE id = :userId;', array(
			':username' => $newName,
			':userId' => (int) $botUserId,
		));

		Database::get()->update('UPDATE %%BOT_STATE%% SET
			hierarchy_status = :hierarchyStatus,
			prestige = :prestige,
			updated_at = :updatedAt
			WHERE bot_user_id = :botUserId;', array(
				':hierarchyStatus' => 'chef',
				':prestige' => 80,
				':updatedAt' => TIMESTAMP,
				':botUserId' => (int) $botUserId,
			));

		return true;
	}

	public function synchronizeHierarchy($maxSubordinatesPerCommander = 8)
	{
		$db = Database::get();
		$commanders = $db->select('SELECT u.id, u.ally_id, u.id_planet
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND bs.hierarchy_status = \'chef\'
			ORDER BY u.id ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$assigned = 0;
		foreach ($commanders as $commander) {
			$planet = $db->selectSingle('SELECT galaxy, `system`
				FROM %%PLANETS%%
				WHERE id = :planetId
				LIMIT 1;', array(
					':planetId' => (int) $commander['id_planet'],
				));

			if (empty($planet)) {
				continue;
			}

			$subordinates = $db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
				INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
				WHERE u.universe = :universe
				  AND u.is_bot = 1
				  AND u.id <> :commanderId
				  AND bs.hierarchy_status <> \'chef\'
				  AND (u.ally_id = :allyId OR :allyId = 0)
				ORDER BY
				  CASE WHEN bs.commander_bot_user_id = :commanderId THEN 0 ELSE 1 END ASC,
				  ABS(p.galaxy - :galaxy) ASC,
				  ABS(p.`system` - :system) ASC,
				  u.id ASC
				LIMIT :limit;', array(
					':universe' => Universe::getEmulated(),
					':commanderId' => (int) $commander['id'],
					':allyId' => (int) $commander['ally_id'],
					':galaxy' => (int) $planet['galaxy'],
					':system' => (int) $planet['system'],
					':limit' => max(1, (int) $maxSubordinatesPerCommander),
				));

			if (empty($subordinates)) {
				continue;
			}

			$ids = array_map('intval', array_column($subordinates, 'id'));
			$db->update('UPDATE %%BOT_STATE%% SET
				commander_bot_user_id = :commanderBotUserId,
				updated_at = :updatedAt
				WHERE bot_user_id IN ('.implode(',', $ids).');', array(
				':commanderBotUserId' => (int) $commander['id'],
				':updatedAt' => TIMESTAMP,
			));
			$assigned += count($ids);
		}

		return array(
			'commanders' => count($commanders),
			'assigned_subordinates' => $assigned,
		);
	}

	public function getHierarchyContext($botUserId)
	{
		$state = Database::get()->selectSingle('SELECT *
			FROM %%BOT_STATE%%
			WHERE bot_user_id = :botUserId
			LIMIT 1;', array(
				':botUserId' => (int) $botUserId,
			));

		if (empty($state)) {
			return array();
		}

		$commander = array();
		if (!empty($state['commander_bot_user_id'])) {
			$commander = Database::get()->selectSingle('SELECT id, username, ally_id FROM %%USERS%% WHERE id = :userId LIMIT 1;', array(
				':userId' => (int) $state['commander_bot_user_id'],
			));
		}

		$subordinates = Database::get()->select('SELECT u.id, u.username
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND bs.commander_bot_user_id = :botUserId
			ORDER BY u.username ASC;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
			));

		return array(
			'state' => $state,
			'commander' => $commander,
			'subordinates' => $subordinates,
		);
	}

	public function assignCurrentTarget($botUserId, array $target)
	{
		Database::get()->update('UPDATE %%BOT_STATE%% SET
			current_target_json = :currentTargetJson,
			updated_at = :updatedAt
			WHERE bot_user_id = :botUserId;', array(
				':currentTargetJson' => json_encode($target),
				':updatedAt' => TIMESTAMP,
				':botUserId' => (int) $botUserId,
			));
	}

	public function getSubordinateIds($commanderBotUserId)
	{
		return array_map('intval', array_column(Database::get()->select('SELECT bot_user_id
			FROM %%BOT_STATE%%
			WHERE commander_bot_user_id = :commanderBotUserId
			ORDER BY bot_user_id ASC;', array(
				':commanderBotUserId' => (int) $commanderBotUserId,
			)), 'bot_user_id'));
	}
}
