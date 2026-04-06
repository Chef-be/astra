<?php

class MissionAdminService
{
	public function ensureDefaults()
	{
		$db = Database::get();
		$count = $db->selectSingle('SELECT COUNT(*) AS count FROM %%MISSION_DEFINITIONS%% WHERE universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		), 'count');

		if ((int) $count > 0) {
			return;
		}

		$definitions = array(
			array(
				'title' => 'Développer la mine de métal',
				'frequency' => 'daily',
				'description' => 'Atteignez le niveau 5 sur une mine de métal.',
				'objective_type' => 'building_level',
				'objective_key' => '1',
				'target_value' => 5,
				'reward_type' => 'resource',
				'reward_key' => 'metal',
				'reward_value' => 25000,
			),
			array(
				'title' => 'Armer la flotte légère',
				'frequency' => 'daily',
				'description' => 'Possédez au moins 20 chasseurs légers sur votre empire.',
				'objective_type' => 'ship_total',
				'objective_key' => '204',
				'target_value' => 20,
				'reward_type' => 'resource',
				'reward_key' => 'crystal',
				'reward_value' => 18000,
			),
			array(
				'title' => 'Réserve stratégique',
				'frequency' => 'weekly',
				'description' => 'Accumulez 50 000 unités de deutérium dans votre empire.',
				'objective_type' => 'resource_total',
				'objective_key' => 'deuterium',
				'target_value' => 50000,
				'reward_type' => 'darkmatter',
				'reward_key' => 'darkmatter',
				'reward_value' => 250,
			),
		);

		foreach ($definitions as $definition) {
			$this->saveDefinition($definition);
		}
	}

	public function getSnapshot()
	{
		$db = Database::get();
		$universe = Universe::getEmulated();

		return array(
			'definitions' => $db->select("SELECT d.*, r.reward_type, r.reward_key, r.reward_value
				FROM %%MISSION_DEFINITIONS%% d
				LEFT JOIN %%MISSION_REWARDS%% r ON r.mission_id = d.id
				WHERE d.universe = :universe
				ORDER BY d.is_active DESC, d.id ASC;", array(':universe' => $universe)),
			'inProgress' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USER_MISSIONS%% WHERE universe = :universe AND status = :status;', array(':universe' => $universe, ':status' => 'in_progress'), 'count'),
			'claimable' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USER_MISSIONS%% WHERE universe = :universe AND status = :status;', array(':universe' => $universe, ':status' => 'claimable'), 'count'),
			'completed' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USER_MISSIONS%% WHERE universe = :universe AND status = :status;', array(':universe' => $universe, ':status' => 'claimed'), 'count'),
			'assignedUsers' => (int) $db->selectSingle('SELECT COUNT(DISTINCT user_id) AS count FROM %%USER_MISSIONS%% WHERE universe = :universe;', array(':universe' => $universe), 'count'),
		);
	}

	public function saveDefinition(array $data)
	{
		$db = Database::get();
		$db->insert("INSERT INTO %%MISSION_DEFINITIONS%% SET
			universe = :universe,
			title = :title,
			frequency = :frequency,
			description = :description,
			objective_type = :objectiveType,
			objective_key = :objectiveKey,
			target_value = :targetValue,
			is_active = :isActive,
			created_at = :createdAt;", array(
			':universe' => Universe::getEmulated(),
			':title' => $data['title'],
			':frequency' => $data['frequency'],
			':description' => $data['description'],
			':objectiveType' => $data['objective_type'],
			':objectiveKey' => $data['objective_key'],
			':targetValue' => (int) $data['target_value'],
			':isActive' => $data['is_active'],
			':createdAt' => TIMESTAMP,
		));

		$missionId = $db->lastInsertId();
		$db->insert("INSERT INTO %%MISSION_REWARDS%% SET
			mission_id = :missionId,
			reward_type = :rewardType,
			reward_key = :rewardKey,
			reward_value = :rewardValue;", array(
			':missionId' => $missionId,
			':rewardType' => $data['reward_type'],
			':rewardKey' => $data['reward_key'],
			':rewardValue' => (int) $data['reward_value'],
		));
	}
}
