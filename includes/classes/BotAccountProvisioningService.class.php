<?php

class BotAccountProvisioningService
{
	public function ensureComplianceForAllBots(array $config)
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTraitService.class.php';
		require_once ROOT_PATH.'includes/classes/BotDynamicStateService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMultiAccountService.class.php';

		$db = Database::get();
		$presenceService = new BotPresenceService();
		$traitService = new BotTraitService();
		$dynamicService = new BotDynamicStateService();
		$bots = $db->select('SELECT id, universe FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 ORDER BY id ASC;', array(
			':universe' => Universe::getEmulated(),
		));

		$multiService = new BotMultiAccountService();
		foreach ($bots as $bot) {
			$db->update('UPDATE %%USERS%% SET email = :sharedEmail, email_2 = :sharedEmail WHERE id = :userId;', array(
				':sharedEmail' => $config['shared_email'],
				':userId' => (int) $bot['id'],
			));

			$presenceService->ensureState((int) $bot['id']);
			$traitService->ensureDefaults((int) $bot['id']);
			$dynamicService->ensureDefaults((int) $bot['id']);
			$multiService->validateBot($bot['id'], 'conformite_bots');
			$this->markCompliance($bot['id'], $config['shared_email'], $config['password_policy'], 'ok', array(
				'source' => 'ensureComplianceForAllBots',
			));
		}

		return count($bots);
	}

	public function rotatePasswords(array $botUserIds, array $config)
	{
		$db = Database::get();
		$result = array();

		foreach ($botUserIds as $botUserId) {
			$plainPassword = $this->generateRandomPassword();
			$db->update('UPDATE %%USERS%% SET password = :password WHERE id = :userId AND is_bot = 1;', array(
				':password' => PlayerUtil::cryptPassword($plainPassword),
				':userId' => (int) $botUserId,
			));

			$this->markCompliance((int) $botUserId, $config['shared_email'], $config['password_policy'], 'ok', array(
				'source' => 'rotatePasswords',
				'rotated' => true,
			));

			$result[] = array(
				'bot_user_id' => (int) $botUserId,
				'plain_password' => $plainPassword,
			);
		}

		return $result;
	}

	public function createBots(array $data, array $config)
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTraitService.class.php';
		require_once ROOT_PATH.'includes/classes/BotDynamicStateService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMultiAccountService.class.php';
		require_once ROOT_PATH.'includes/classes/BotAllianceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommanderService.class.php';

		$db = Database::get();
		$presenceService = new BotPresenceService();
		$traitService = new BotTraitService();
		$dynamicService = new BotDynamicStateService();
		$multiService = new BotMultiAccountService();
		$allianceService = new BotAllianceService();
		$commanderService = new BotCommanderService();
		$created = array();
		$count = max(1, (int) $data['count']);
		$targetGalaxy = max(1, (int) $data['target_galaxy']);
		$profileId = empty($data['profile_id']) ? null : (int) $data['profile_id'];
		$configUni = Config::get(Universe::getEmulated());
		$profile = array();
		if (!empty($profileId)) {
			$profile = $db->selectSingle('SELECT * FROM %%BOT_PROFILES%% WHERE id = :id LIMIT 1;', array(
				':id' => $profileId,
			));
		}

		$occupied = $db->select('SELECT galaxy, `system`, planet
			FROM %%PLANETS%%
			WHERE universe = :universe AND galaxy = :galaxy;', array(
				':universe' => Universe::getEmulated(),
				':galaxy' => $targetGalaxy,
			));

		$used = array();
		foreach ($occupied as $planet) {
			$used[$planet['system'].':'.$planet['planet']] = true;
		}

		$positions = array();
		for ($system = 1; $system <= $configUni->max_system; $system++) {
			for ($planet = 1; $planet <= $configUni->max_planets; $planet++) {
				$key = $system.':'.$planet;
				if (!isset($used[$key])) {
					$positions[] = array($targetGalaxy, $system, $planet);
				}
			}
		}

		shuffle($positions);

		for ($index = 0; $index < $count && isset($positions[$index]); $index++) {
			$coords = $positions[$index];
			$username = $this->generateBotName($index + 1, !empty($data['name_mode']) ? $data['name_mode'] : 'random');
			$plainPassword = $this->generateRandomPassword();

			list($userId, $planetId) = PlayerUtil::createPlayer(
				Universe::getEmulated(),
				$username,
				PlayerUtil::cryptPassword($plainPassword),
				$config['shared_email'],
				'fr',
				$coords[0],
				$coords[1],
				$coords[2],
				'Main Planet',
				0,
				'127.0.0.1'
			);

			$db->update('UPDATE %%USERS%% SET
				is_bot = 1,
				bot_profile_id = :profileId,
				email = :sharedEmail,
				email_2 = :sharedEmail,
				darkmatter = darkmatter + :darkmatter
				WHERE id = :userId;', array(
					':profileId' => $profileId,
					':sharedEmail' => $config['shared_email'],
					':darkmatter' => max(0, (int) $data['darkmatter']),
					':userId' => (int) $userId,
				));

			$db->update('UPDATE %%PLANETS%% SET
				is_bot = 1,
				metal = :metal,
				crystal = :crystal,
				deuterium = :deuterium,
				field_max = :fieldMax
				WHERE id = :planetId;', array(
					':metal' => max(0, (int) $data['metal']),
					':crystal' => max(0, (int) $data['crystal']),
					':deuterium' => max(0, (int) $data['deuterium']),
					':fieldMax' => max(50, (int) $data['field_max']),
					':planetId' => (int) $planetId,
				));

			$created[] = array(
				'user_id' => (int) $userId,
				'planet_id' => (int) $planetId,
				'username' => $username,
				'plain_password' => $plainPassword,
			);

			$presenceService->ensureState((int) $userId);
			$traitService->ensureDefaults((int) $userId, $profile);
			$dynamicService->ensureDefaults((int) $userId);
			$multiService->validateBot((int) $userId, 'creation_massive_bots');
			$this->markCompliance((int) $userId, $config['shared_email'], $config['password_policy'], 'ok', array(
				'source' => 'createBots',
			));

			if (!empty($config['enable_bot_alliances'])) {
				$allianceMeta = $allianceService->ensureDefaultAlliance($config);
				if (!empty($allianceMeta['alliance_id'])) {
					$allianceService->assignBotToAlliance((int) $userId, (int) $allianceMeta['alliance_id']);
				}
			}

			if (!empty($profile['is_commander_profile'])) {
				$commanderService->promote((int) $userId);
			}
		}

		return $created;
	}

	public function markCompliance($botUserId, $sharedEmail, $passwordPolicy, $status, array $details = array())
	{
		$db = Database::get();
		$row = $db->selectSingle('SELECT id FROM %%BOT_ACCOUNT_COMPLIANCE%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));

		if (empty($row)) {
			$db->insert('INSERT INTO %%BOT_ACCOUNT_COMPLIANCE%% SET
				universe = :universe,
				bot_user_id = :botUserId,
				shared_email = :sharedEmail,
				password_rotated_at = :passwordRotatedAt,
				password_policy = :passwordPolicy,
				multiaccount_sync_at = :multiaccountSyncAt,
				compliance_status = :complianceStatus,
				details_json = :detailsJson,
				updated_at = :updatedAt;', array(
					':universe' => Universe::getEmulated(),
					':botUserId' => (int) $botUserId,
					':sharedEmail' => $sharedEmail,
					':passwordRotatedAt' => TIMESTAMP,
					':passwordPolicy' => $passwordPolicy,
					':multiaccountSyncAt' => TIMESTAMP,
					':complianceStatus' => $status,
					':detailsJson' => json_encode($details),
					':updatedAt' => TIMESTAMP,
				));
			return;
		}

		$db->update('UPDATE %%BOT_ACCOUNT_COMPLIANCE%% SET
			shared_email = :sharedEmail,
			password_rotated_at = :passwordRotatedAt,
			password_policy = :passwordPolicy,
			multiaccount_sync_at = :multiaccountSyncAt,
			compliance_status = :complianceStatus,
			details_json = :detailsJson,
			updated_at = :updatedAt
			WHERE id = :id;', array(
				':sharedEmail' => $sharedEmail,
				':passwordRotatedAt' => TIMESTAMP,
				':passwordPolicy' => $passwordPolicy,
				':multiaccountSyncAt' => TIMESTAMP,
				':complianceStatus' => $status,
				':detailsJson' => json_encode($details),
				':updatedAt' => TIMESTAMP,
				':id' => (int) $row['id'],
			));
	}

	protected function generateRandomPassword($length = 24)
	{
		return substr(bin2hex(random_bytes(max(12, (int) ceil($length / 2)))), 0, $length);
	}

	protected function generateBotName($index, $mode = 'random')
	{
		$firstNames = array(
			'Orion', 'Lyra', 'Cassian', 'Selene', 'Aurel', 'Nova', 'Mira', 'Soren', 'Kael', 'Elara',
			'Nereis', 'Tiber', 'Astra', 'Maelis', 'Darian', 'Vesper', 'Nael', 'Ilyan', 'Celia', 'Valen',
			'Thalia', 'Corvin', 'Saphir', 'Alaric', 'Iris', 'Riven', 'Seren', 'Lorian', 'Nyx', 'Elyas',
			'Calista', 'Dorian', 'Leora', 'Sylas', 'Talia', 'Marek', 'Zorane', 'Aelis', 'Velor', 'Mylan'
		);
		$lastNames = array(
			'Valmont', 'Rochefort', 'Dargent', 'Solarys', 'Noctis', 'Virel', 'Marwick', 'Auren', 'Caelum', 'Veridian',
			'Kestrel', 'Dravik', 'Lysandre', 'Sorell', 'Mornac', 'Eidren', 'Valkor', 'Seralis', 'Theron', 'Meral',
			'Quint', 'Orsen', 'Dorlac', 'Vaelis', 'Cendre', 'Ravenn', 'Helion', 'Nerath', 'Coralis', 'Aster'
		);
		$firstName = $firstNames[($index - 1) % count($firstNames)];
		$lastName = $lastNames[(int) floor(($index - 1) / count($firstNames)) % count($lastNames)];
		$baseName = $firstName.' '.$lastName;

		if ($mode === 'numbered') {
			return $baseName.' '.$index;
		}

		return $baseName;
	}
}
