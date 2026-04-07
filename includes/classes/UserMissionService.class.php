<?php

require_once ROOT_PATH.'includes/classes/NotificationService.class.php';

class UserMissionService
{
	public function getPlayerSummary($userId)
	{
		$this->ensureAssignmentsForUser($userId);
		$this->refreshUserProgress($userId);

		$rows = Database::get()->select('SELECT status, COUNT(*) AS count
			FROM %%USER_MISSIONS%%
			WHERE user_id = :userId AND universe = :universe
			GROUP BY status;', array(
				':userId' => (int) $userId,
				':universe' => Universe::current(),
			));

		$summary = array(
			'inProgress' => 0,
			'claimable' => 0,
			'claimed' => 0,
		);

		foreach ($rows as $row) {
			switch ($row['status']) {
				case 'in_progress':
					$summary['inProgress'] = (int) $row['count'];
					break;
				case 'claimable':
					$summary['claimable'] = (int) $row['count'];
					break;
				case 'claimed':
					$summary['claimed'] = (int) $row['count'];
					break;
			}
		}

		$summary['badgeCount'] = $summary['claimable'] > 0 ? $summary['claimable'] : $summary['inProgress'];
		$summary['badgeVariant'] = $summary['claimable'] > 0 ? 'warning' : 'secondary';

		return $summary;
	}

	public function getPlayerSnapshot($userId)
	{
		global $LNG;

		$this->ensureAssignmentsForUser($userId);
		$this->refreshUserProgress($userId);

		$missions = Database::get()->select("SELECT um.*, d.title, d.frequency, d.description, d.objective_type, d.objective_key,
				d.target_value AS definition_target_value, r.reward_type, r.reward_key, r.reward_value
			FROM %%USER_MISSIONS%% um
			INNER JOIN %%MISSION_DEFINITIONS%% d ON d.id = um.mission_id
			LEFT JOIN %%MISSION_REWARDS%% r ON r.mission_id = d.id
			WHERE um.user_id = :userId AND um.universe = :universe
			ORDER BY FIELD(um.status, 'claimable', 'in_progress', 'claimed'), um.id ASC;", array(
				':userId' => (int) $userId,
				':universe' => Universe::current(),
			));

		foreach ($missions as &$mission) {
			$mission['frequency_label'] = $this->getFrequencyLabel($mission['frequency']);
			$mission['status_label'] = $this->getStatusLabel($mission['status']);
			$mission['reward_label'] = $this->getRewardLabel($mission, $LNG);
		}
		unset($mission);

		return array(
			'missions' => $missions,
			'inProgress' => count(array_filter($missions, function ($mission) {
				return $mission['status'] === 'in_progress';
			})),
			'claimable' => count(array_filter($missions, function ($mission) {
				return $mission['status'] === 'claimable';
			})),
			'claimed' => count(array_filter($missions, function ($mission) {
				return $mission['status'] === 'claimed';
			})),
		);
	}

	public function ensureAssignmentsForUser($userId)
	{
		$db = Database::get();
		$definitions = $db->select('SELECT * FROM %%MISSION_DEFINITIONS%% WHERE universe = :universe AND is_active = 1 ORDER BY id ASC;', array(
			':universe' => Universe::current(),
		));

		foreach ($definitions as $definition) {
			$existing = $db->selectSingle('SELECT id FROM %%USER_MISSIONS%% WHERE mission_id = :missionId AND user_id = :userId AND universe = :universe LIMIT 1;', array(
				':missionId' => $definition['id'],
				':userId' => (int) $userId,
				':universe' => Universe::current(),
			), 'id');

			if (!empty($existing)) {
				continue;
			}

			$db->insert("INSERT INTO %%USER_MISSIONS%% SET
				mission_id = :missionId,
				user_id = :userId,
				universe = :universe,
				status = 'in_progress',
				progress_value = 0,
				target_value = :targetValue,
				assigned_at = :assignedAt;", array(
					':missionId' => $definition['id'],
					':userId' => (int) $userId,
					':universe' => Universe::current(),
					':targetValue' => (int) $definition['target_value'],
					':assignedAt' => TIMESTAMP,
				));
		}
	}

	public function refreshUserProgress($userId)
	{
		$db = Database::get();
		$assignments = $db->select('SELECT um.*, d.title, d.objective_type, d.objective_key, d.target_value
			FROM %%USER_MISSIONS%% um
			INNER JOIN %%MISSION_DEFINITIONS%% d ON d.id = um.mission_id
			WHERE um.user_id = :userId AND um.universe = :universe AND d.is_active = 1;', array(
				':userId' => (int) $userId,
				':universe' => Universe::current(),
			));

		foreach ($assignments as $assignment) {
			$progress = $this->calculateProgress($userId, $assignment['objective_type'], $assignment['objective_key']);
			$target = max(1, (int) $assignment['target_value']);
			$newStatus = $progress >= $target ? ($assignment['status'] === 'claimed' ? 'claimed' : 'claimable') : 'in_progress';
			$completedAt = $newStatus === 'claimable' && empty($assignment['completed_at']) ? TIMESTAMP : $assignment['completed_at'];

			$db->update("UPDATE %%USER_MISSIONS%% SET
				progress_value = :progressValue,
				target_value = :targetValue,
				status = :status,
				completed_at = :completedAt
				WHERE id = :assignmentId;", array(
					':progressValue' => min($progress, $target),
					':targetValue' => $target,
					':status' => $newStatus,
					':completedAt' => empty($completedAt) ? null : $completedAt,
					':assignmentId' => $assignment['id'],
				));

			if ($assignment['status'] !== 'claimable' && $assignment['status'] !== 'claimed' && $newStatus === 'claimable') {
				NotificationService::create(
					$userId,
					'mission_ready',
					'Mission terminée',
					sprintf('Votre mission « %s » est prête à être réclamée.', $assignment['title']),
					'game.php?page=missions'
				);
			}
		}
	}

	public function claimReward($userId, $userMissionId)
	{
		global $resource;

		$db = Database::get();
		$mission = $db->selectSingle("SELECT um.*, d.title, r.reward_type, r.reward_key, r.reward_value
			FROM %%USER_MISSIONS%% um
			INNER JOIN %%MISSION_DEFINITIONS%% d ON d.id = um.mission_id
			LEFT JOIN %%MISSION_REWARDS%% r ON r.mission_id = d.id
			WHERE um.id = :missionId AND um.user_id = :userId AND um.universe = :universe
			LIMIT 1;", array(
				':missionId' => (int) $userMissionId,
				':userId' => (int) $userId,
				':universe' => Universe::current(),
			));

		if (empty($mission) || $mission['status'] !== 'claimable') {
			return false;
		}

		if ($mission['reward_type'] === 'darkmatter') {
			$db->update('UPDATE %%USERS%% SET darkmatter = darkmatter + :rewardValue WHERE id = :userId;', array(
				':rewardValue' => (int) $mission['reward_value'],
				':userId' => (int) $userId,
			));
		} else {
			$planet = $this->getPrimaryPlanet($userId);
			if (empty($planet)) {
				return false;
			}

			$column = $mission['reward_key'];
			if ($mission['reward_type'] === 'ship' && is_numeric($mission['reward_key']) && isset($resource[(int) $mission['reward_key']])) {
				$column = $resource[(int) $mission['reward_key']];
			}

			$allowedColumns = array('metal', 'crystal', 'deuterium');
			if ($mission['reward_type'] === 'ship') {
				$allowedColumns[] = $column;
			}

			if (!in_array($column, $allowedColumns)) {
				return false;
			}

			$query = 'UPDATE %%PLANETS%% SET `'.$column.'` = `'.$column.'` + :rewardValue WHERE id = :planetId;';
			$db->update($query, array(
				':rewardValue' => (int) $mission['reward_value'],
				':planetId' => $planet['id'],
			));
		}

		$db->update("UPDATE %%USER_MISSIONS%% SET
			status = 'claimed',
			completed_at = :completedAt
			WHERE id = :missionId;", array(
				':completedAt' => TIMESTAMP,
				':missionId' => (int) $userMissionId,
			));

		NotificationService::create(
			$userId,
			'mission_reward',
			'Récompense de mission',
			sprintf('La récompense de la mission « %s » a bien été créditée.', $mission['title']),
			'game.php?page=missions'
		);

		return true;
	}

	public function refreshAllUsers()
	{
		$db = Database::get();
		$userIds = $db->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 0;', array(
			':universe' => Universe::current(),
		));

		$count = 0;
		foreach ($userIds as $row) {
			$this->ensureAssignmentsForUser($row['id']);
			$this->refreshUserProgress($row['id']);
			$count++;
		}

		return $count;
	}

	private function calculateProgress($userId, $objectiveType, $objectiveKey)
	{
		global $resource;

		$db = Database::get();
		switch ($objectiveType) {
			case 'building_level':
				if (!is_numeric($objectiveKey) || empty($resource[(int) $objectiveKey])) {
					return 0;
				}
				$column = $resource[(int) $objectiveKey];
				$query = 'SELECT MAX(`'.$column.'`) AS progress FROM %%PLANETS%% WHERE id_owner = :userId AND planet_type = 1;';
				return (int) $db->selectSingle($query, array(
					':userId' => (int) $userId,
				), 'progress');

			case 'ship_total':
				if (!is_numeric($objectiveKey) || empty($resource[(int) $objectiveKey])) {
					return 0;
				}
				$column = $resource[(int) $objectiveKey];
				$query = 'SELECT COALESCE(SUM(`'.$column.'`), 0) AS progress FROM %%PLANETS%% WHERE id_owner = :userId AND planet_type = 1;';
				return (int) $db->selectSingle($query, array(
					':userId' => (int) $userId,
				), 'progress');

			case 'resource_total':
				if (!in_array($objectiveKey, array('metal', 'crystal', 'deuterium'))) {
					return 0;
				}
				$query = 'SELECT COALESCE(SUM(`'.$objectiveKey.'`), 0) AS progress FROM %%PLANETS%% WHERE id_owner = :userId AND planet_type = 1;';
				return (int) $db->selectSingle($query, array(
					':userId' => (int) $userId,
				), 'progress');
		}

		return 0;
	}

	private function getPrimaryPlanet($userId)
	{
		return Database::get()->selectSingle('SELECT id, name FROM %%PLANETS%% WHERE id_owner = :userId AND planet_type = 1 ORDER BY id ASC LIMIT 1;', array(
			':userId' => (int) $userId,
		));
	}

	private function getFrequencyLabel($frequency)
	{
		switch ((string) $frequency) {
			case 'daily':
				return 'Journalière';
			case 'weekly':
				return 'Hebdomadaire';
			case 'event':
				return 'Événement';
			case 'permanent':
				return 'Permanente';
			default:
				return ucfirst((string) $frequency);
		}
	}

	private function getStatusLabel($status)
	{
		switch ((string) $status) {
			case 'claimable':
				return 'À réclamer';
			case 'claimed':
				return 'Réclamée';
			default:
				return 'En cours';
		}
	}

	private function getRewardLabel(array $mission, $LNG)
	{
		global $resource;

		if ($mission['reward_type'] === 'darkmatter') {
			return 'matière noire';
		}

		if ($mission['reward_type'] === 'resource') {
			$labels = array(
				'metal' => $LNG['tech'][901] ?? 'Métal',
				'crystal' => $LNG['tech'][902] ?? 'Cristal',
				'deuterium' => $LNG['tech'][903] ?? 'Deutérium',
			);

			return $labels[$mission['reward_key']] ?? ucfirst((string) $mission['reward_key']);
		}

		if ($mission['reward_type'] === 'ship' && is_numeric($mission['reward_key'])) {
			$techId = (int) $mission['reward_key'];
			if (isset($resource[$techId]) && isset($LNG['tech'][$techId])) {
				return $LNG['tech'][$techId];
			}
		}

		return 'unité(s)';
	}
}
