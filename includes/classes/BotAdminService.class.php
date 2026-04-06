<?php

class BotAdminService
{
	public function ensureDefaults()
	{
		$db = Database::get();
		$count = $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_PROFILES%% WHERE universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		), 'count');

		if ((int) $count > 0) {
			return;
		}

		$defaults = array(
			array('Éclaireur', 'Reconnaissance active, raids légers et présence connectée régulière.', 18, 35, 45, 20),
			array('Colonisateur', 'Développement économique, extension et défense progressive.', 12, 15, 65, 55),
			array('Prédateur', 'Activité offensive élevée, présence soutenue et comportement agressif.', 24, 80, 30, 10),
		);

		foreach ($defaults as $profile) {
			$db->insert("INSERT INTO %%BOT_PROFILES%% SET
				universe = :universe,
				name = :name,
				description = :description,
				target_online = :targetOnline,
				aggression = :aggression,
				economy_focus = :economyFocus,
				expansion_focus = :expansionFocus,
				is_active = 1,
				created_at = :createdAt;", array(
				':universe' => Universe::getEmulated(),
				':name' => $profile[0],
				':description' => $profile[1],
				':targetOnline' => $profile[2],
				':aggression' => $profile[3],
				':economyFocus' => $profile[4],
				':expansionFocus' => $profile[5],
				':createdAt' => TIMESTAMP,
			));
		}
	}

	public function getActiveProfiles()
	{
		return Database::get()->select('SELECT * FROM %%BOT_PROFILES%% WHERE universe = :universe AND is_active = 1 ORDER BY id ASC;', array(
			':universe' => Universe::getEmulated(),
		));
	}

	public function getSnapshot()
	{
		$db = Database::get();
		$universe = Universe::getEmulated();
		$activeThreshold = TIMESTAMP - 900;
		$profiles = $db->select('SELECT p.*,
				(SELECT COUNT(*) FROM %%USERS%% u WHERE u.universe = :universe AND u.is_bot = 1 AND u.bot_profile_id = p.id) AS assigned_bots
			FROM %%BOT_PROFILES%% p
			WHERE p.universe = :universe
			ORDER BY p.is_active DESC, p.id ASC;', array(':universe' => $universe));
		$activity = $db->select('SELECT a.*, u.username
			FROM %%BOT_ACTIVITY%% a
			LEFT JOIN %%USERS%% u ON u.id = a.bot_user_id
			WHERE a.universe = :universe
			ORDER BY a.id DESC
			LIMIT 50;', array(':universe' => $universe));

		$upcoming = array();
		foreach ($activity as &$row) {
			$row['activity_payload_decoded'] = array();
			if (!empty($row['activity_payload'])) {
				$decoded = json_decode($row['activity_payload'], true);
				if (is_array($decoded)) {
					$row['activity_payload_decoded'] = $decoded;
					if (!empty($decoded['next_action_at']) && count($upcoming) < 20) {
						$upcoming[] = array(
							'username' => $row['username'],
							'activity_type' => $decoded['next_action_type'],
							'activity_summary' => $decoded['next_action_summary'],
							'next_action_at' => (int) $decoded['next_action_at'],
							'next_action_at_formatted' => date('d/m/Y H:i', (int) $decoded['next_action_at']),
						);
					}
				}
			}
		}
		unset($row);

		usort($upcoming, function ($left, $right) {
			return $left['next_action_at'] <=> $right['next_action_at'];
		});

		$botRoster = $db->select('SELECT u.id, u.username, u.onlinetime, p.name AS profile_name,
				pl.galaxy, pl.`system`, pl.planet
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%PLANETS%% pl ON pl.id = u.id_planet
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY u.onlinetime DESC, u.id ASC
			LIMIT 30;', array(':universe' => $universe));

		return array(
			'totalBots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1;', array(':universe' => $universe), 'count'),
			'activeBots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND onlinetime >= :activeThreshold;', array(':universe' => $universe, ':activeThreshold' => $activeThreshold), 'count'),
			'profiles' => $profiles,
			'activity' => $activity,
			'botRoster' => $botRoster,
			'upcoming' => array_slice($upcoming, 0, 8),
		);
	}

	public function saveProfile(array $data)
	{
		$db = Database::get();
		$db->insert("INSERT INTO %%BOT_PROFILES%% SET
			universe = :universe,
			name = :name,
			description = :description,
			target_online = :targetOnline,
			aggression = :aggression,
			economy_focus = :economyFocus,
			expansion_focus = :expansionFocus,
			is_active = :isActive,
			created_at = :createdAt;", array(
			':universe' => Universe::getEmulated(),
			':name' => $data['name'],
			':description' => $data['description'],
			':targetOnline' => $data['target_online'],
			':aggression' => $data['aggression'],
			':economyFocus' => $data['economy_focus'],
			':expansionFocus' => $data['expansion_focus'],
			':isActive' => $data['is_active'],
			':createdAt' => TIMESTAMP,
		));
	}

	public function runEngine($limit = 12)
	{
		$this->ensureDefaults();
		$this->ensureBotProfilesAssigned();
		$this->dispatchPendingCommands(max(1, (int) ceil($limit / 2)));

		$db = Database::get();
		$profiles = $this->getActiveProfiles();
		$onlineBots = 0;
		$actionsLogged = 0;

		foreach ($profiles as $profile) {
			$profileLimit = max(1, (int) $profile['target_online']);
			$bots = $db->select('SELECT id, username, id_planet, bot_profile_id
				FROM %%USERS%%
				WHERE universe = :universe AND is_bot = 1 AND bot_profile_id = :profileId
				ORDER BY onlinetime DESC, id ASC
				LIMIT '.$profileLimit.';', array(
					':universe' => Universe::getEmulated(),
					':profileId' => $profile['id'],
				));

			foreach ($bots as $bot) {
				$db->update('UPDATE %%USERS%% SET onlinetime = :onlineTime WHERE id = :userId;', array(
					':onlineTime' => TIMESTAMP,
					':userId' => $bot['id'],
				));
				$onlineBots++;
			}

			$executed = 0;
			foreach ($bots as $bot) {
				if ($actionsLogged >= $limit) {
					break 2;
				}
				if ($executed >= max(1, min(4, (int) ceil($profile['target_online'] / 6)))) {
					break;
				}

				$this->executeBotAction($bot, $profile);
				$actionsLogged++;
				$executed++;
			}
		}

		return array(
			'profiles' => count($profiles),
			'onlineBots' => $onlineBots,
			'actionsLogged' => $actionsLogged,
		);
	}

	public function dispatchPendingCommands($limit = 6)
	{
		return $this->processPendingCommands($limit);
	}

	public function refreshAllPlayerMissions()
	{
		require_once ROOT_PATH.'includes/classes/UserMissionService.class.php';
		$service = new UserMissionService();
		return $service->refreshAllUsers();
	}

	public function logAdministrativeAction($botUserId, $type, $summary, array $payload = array())
	{
		$this->insertActivity($botUserId, $type, $summary, $payload);
	}

	private function ensureBotProfilesAssigned()
	{
		$db = Database::get();
		$profiles = $this->getActiveProfiles();
		if (empty($profiles)) {
			return;
		}

		$bots = $db->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND (bot_profile_id IS NULL OR bot_profile_id = 0);', array(
			':universe' => Universe::getEmulated(),
		));

		foreach ($bots as $index => $bot) {
			$profile = $profiles[$index % count($profiles)];
			$db->update('UPDATE %%USERS%% SET bot_profile_id = :profileId WHERE id = :userId;', array(
				':profileId' => $profile['id'],
				':userId' => $bot['id'],
			));
		}
	}

	private function executeBotAction(array $bot, array $profile)
	{
		$planet = $this->getBotPlanet($bot['id'], $bot['id_planet']);
		if (empty($planet)) {
			$this->insertActivity($bot['id'], 'anomalie', 'Impossible de localiser la planète principale du bot.', array(
				'profile' => $profile['name'],
			));
			return;
		}

		$weights = array(
			'eco' => max(1, (int) $profile['economy_focus']),
			'raid' => max(1, (int) $profile['aggression']),
			'expansion' => max(1, (int) $profile['expansion_focus']),
		);
		$total = array_sum($weights);
		$roll = mt_rand(1, $total);

		if ($roll <= $weights['eco']) {
			$this->runEconomyAction($bot, $profile, $planet);
			return;
		}

		if ($roll <= ($weights['eco'] + $weights['raid'])) {
			$this->runRaidPreparationAction($bot, $profile, $planet);
			return;
		}

		$this->runExpansionAction($bot, $profile, $planet);
	}

	private function processPendingCommands($limit = 6)
	{
		$db = Database::get();
		$commands = $db->select('SELECT *
			FROM %%BOT_COMMANDS%%
			WHERE universe = :universe AND status = :status
			ORDER BY id ASC
			LIMIT :limit;', array(
			':universe' => Universe::getEmulated(),
			':status' => 'pending',
			':limit' => (int) $limit,
		));

		$results = array(
			'processed' => 0,
			'done' => 0,
			'rejected' => 0,
		);

		foreach ($commands as $command) {
			$executed = $this->executeCommand($command);
			$db->update('UPDATE %%BOT_COMMANDS%% SET
				status = :status,
				response_text = :responseText,
				executed_at = :executedAt
				WHERE id = :commandId;', array(
				':status' => $executed['status'],
				':responseText' => $executed['responseText'],
				':executedAt' => TIMESTAMP,
				':commandId' => $command['id'],
			));
			$results['processed']++;
			if ($executed['status'] === 'done') {
				$results['done']++;
			} else {
				$results['rejected']++;
			}
		}

		return $results;
	}

	private function executeCommand(array $command)
	{
		$db = Database::get();
		$selector = trim((string) $command['target_selector']);
		$commandText = trim((string) $command['command_text']);
		$targets = array();

		if (!empty($command['target_bot_user_id'])) {
			$target = $db->selectSingle('SELECT id, username, id_planet, bot_profile_id
				FROM %%USERS%%
				WHERE id = :userId AND universe = :universe AND is_bot = 1
				LIMIT 1;', array(
				':userId' => (int) $command['target_bot_user_id'],
				':universe' => Universe::getEmulated(),
			));
			if (!empty($target)) {
				$targets[] = $target;
			}
		}

		if (empty($targets)) {
			$targets = $db->select('SELECT id, username, id_planet, bot_profile_id
				FROM %%USERS%%
				WHERE universe = :universe AND is_bot = 1
				ORDER BY onlinetime DESC, id ASC
				LIMIT 3;', array(
				':universe' => Universe::getEmulated(),
			));
		}

		if (empty($targets)) {
			return array(
				'status' => 'rejected',
				'responseText' => 'Aucun bot disponible pour exécuter cette consigne.',
			);
		}

		$profiles = $this->getActiveProfiles();
		$profileMap = array();
		foreach ($profiles as $profile) {
			$profileMap[$profile['id']] = $profile;
		}

		$executedCount = 0;
		foreach ($targets as $bot) {
			$profile = isset($profileMap[$bot['bot_profile_id']]) ? $profileMap[$bot['bot_profile_id']] : array(
				'id' => 0,
				'name' => 'Pilotage manuel',
				'aggression' => 40,
				'economy_focus' => 40,
				'expansion_focus' => 40,
				'target_online' => 1,
			);
			$planet = $this->getBotPlanet($bot['id'], $bot['id_planet']);
			if (empty($planet)) {
				continue;
			}

			$text = mb_strtolower($commandText, 'UTF-8');
			if (strpos($text, 'recon') !== false || strpos($text, 'repér') !== false || strpos($text, 'raid') !== false) {
				$this->runRaidPreparationAction($bot, $profile, $planet);
			} elseif (strpos($text, 'expan') !== false || strpos($text, 'colo') !== false) {
				$this->runExpansionAction($bot, $profile, $planet);
			} else {
				$this->runEconomyAction($bot, $profile, $planet);
			}

			$this->insertActivity($bot['id'], 'commande', sprintf('%s applique la consigne « %s ».', $bot['username'], $commandText), array(
				'target_selector' => $selector,
				'command_text' => $commandText,
				'next_action_type' => 'commande',
				'next_action_summary' => $commandText,
				'next_action_at' => TIMESTAMP + mt_rand(180, 600),
			));
			$executedCount++;
		}

		if ($executedCount === 0) {
			return array(
				'status' => 'rejected',
				'responseText' => 'La consigne n’a pu être appliquée à aucun bot.',
			);
		}

		return array(
			'status' => 'done',
			'responseText' => sprintf('Consigne appliquée à %d bot(s) pour la cible « %s ».', $executedCount, $selector),
		);
	}

	private function runEconomyAction(array $bot, array $profile, array $planet)
	{
		$db = Database::get();
		$metal = mt_rand(4000, 14000);
		$crystal = mt_rand(2500, 9000);
		$deuterium = mt_rand(1200, 5000);

		$db->update('UPDATE %%PLANETS%% SET
			metal = metal + :metal,
			crystal = crystal + :crystal,
			deuterium = deuterium + :deuterium,
			last_update = :updatedAt
			WHERE id = :planetId;', array(
				':metal' => $metal,
				':crystal' => $crystal,
				':deuterium' => $deuterium,
				':updatedAt' => TIMESTAMP,
				':planetId' => $planet['id'],
			));

		$this->insertActivity(
			$bot['id'],
			'production',
			sprintf('%s consolide %s et engrange %s métal, %s cristal, %s deutérium.',
				$bot['username'],
				$planet['name'],
				number_format($metal, 0, ',', ' '),
				number_format($crystal, 0, ',', ' '),
				number_format($deuterium, 0, ',', ' ')
			),
			array(
				'profile' => $profile['name'],
				'planet_id' => (int) $planet['id'],
				'resources' => array(
					'metal' => $metal,
					'crystal' => $crystal,
					'deuterium' => $deuterium,
				),
				'next_action_type' => 'surveillance',
				'next_action_summary' => 'Relance de la production et contrôle des stocks.',
				'next_action_at' => TIMESTAMP + mt_rand(300, 900),
			)
		);
	}

	private function runRaidPreparationAction(array $bot, array $profile, array $planet)
	{
		$db = Database::get();
		$scouts = mt_rand(1, 6);
		$activityLevel = mt_rand(1, 100);
		$db->update('UPDATE %%USERS%% SET onlinetime = :onlineTime WHERE id = :userId;', array(
			':onlineTime' => TIMESTAMP,
			':userId' => $bot['id'],
		));

		$this->insertActivity(
			$bot['id'],
			'repérage',
			sprintf('%s prépare un raid depuis %s avec %d sonde(s) et une agressivité de %d%%.',
				$bot['username'],
				$planet['name'],
				$scouts,
				$activityLevel
			),
			array(
				'profile' => $profile['name'],
				'planet_id' => (int) $planet['id'],
				'scouts' => $scouts,
				'activity_level' => $activityLevel,
				'next_action_type' => 'attaque',
				'next_action_summary' => 'Fenêtre de raid en préparation sur une cible voisine.',
				'next_action_at' => TIMESTAMP + mt_rand(600, 1800),
			)
		);
	}

	private function runExpansionAction(array $bot, array $profile, array $planet)
	{
		$db = Database::get();
		$fieldGain = mt_rand(1, 3);
		$db->update('UPDATE %%PLANETS%% SET
			field_max = field_max + :fieldGain,
			last_update = :updatedAt
			WHERE id = :planetId;', array(
				':fieldGain' => $fieldGain,
				':updatedAt' => TIMESTAMP,
				':planetId' => $planet['id'],
			));

		$this->insertActivity(
			$bot['id'],
			'expansion',
			sprintf('%s prépare l’extension de %s et réserve %d champ(s) supplémentaire(s).',
				$bot['username'],
				$planet['name'],
				$fieldGain
			),
			array(
				'profile' => $profile['name'],
				'planet_id' => (int) $planet['id'],
				'field_gain' => $fieldGain,
				'next_action_type' => 'colonisation',
				'next_action_summary' => 'Analyse d’un nouvel emplacement de colonie.',
				'next_action_at' => TIMESTAMP + mt_rand(900, 2400),
			)
		);
	}

	private function getBotPlanet($userId, $planetId)
	{
		$db = Database::get();
		$planet = null;

		if (!empty($planetId)) {
			$planet = $db->selectSingle('SELECT id, name, galaxy, `system`, planet FROM %%PLANETS%% WHERE id = :planetId LIMIT 1;', array(
				':planetId' => $planetId,
			));
		}

		if (!empty($planet)) {
			return $planet;
		}

		return $db->selectSingle('SELECT id, name, galaxy, `system`, planet
			FROM %%PLANETS%%
			WHERE id_owner = :userId AND planet_type = 1
			ORDER BY id ASC
			LIMIT 1;', array(
				':userId' => $userId,
			));
	}

	private function insertActivity($botUserId, $type, $summary, array $payload = array())
	{
		Database::get()->insert("INSERT INTO %%BOT_ACTIVITY%% SET
			bot_user_id = :botUserId,
			universe = :universe,
			activity_type = :activityType,
			activity_summary = :activitySummary,
			activity_payload = :activityPayload,
			created_at = :createdAt;", array(
				':botUserId' => empty($botUserId) ? 0 : (int) $botUserId,
				':universe' => Universe::getEmulated(),
				':activityType' => $type,
				':activitySummary' => $summary,
				':activityPayload' => empty($payload) ? null : json_encode($payload),
				':createdAt' => TIMESTAMP,
			));

		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';

		$username = 'Supervision bots';
		if (!empty($botUserId)) {
			$botUsername = Database::get()->selectSingle('SELECT username FROM %%USERS%% WHERE id = :userId LIMIT 1;', array(
				':userId' => (int) $botUserId,
			), 'username');

			if (!empty($botUsername)) {
				$username = $botUsername;
			}
		}

		LiveChatService::createBotFeedEntry($username, $summary, $botUserId, Universe::getEmulated());
	}
}
