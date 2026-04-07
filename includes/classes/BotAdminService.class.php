<?php

class BotAdminService
{
	protected $configService;
	protected $engineService;
	protected $metricsService;
	protected $journalService;
	protected $commandDispatcher;
	protected $provisioningService;
	protected $multiAccountService;
	protected $allianceService;
	protected $commanderService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotEngineConfigService.class.php';
		require_once ROOT_PATH.'includes/classes/BotEngineService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMetricsService.class.php';
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommandDispatcher.class.php';
		require_once ROOT_PATH.'includes/classes/BotAccountProvisioningService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMultiAccountService.class.php';
		require_once ROOT_PATH.'includes/classes/BotAllianceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommanderService.class.php';

		$this->configService = new BotEngineConfigService();
		$this->engineService = new BotEngineService();
		$this->metricsService = new BotMetricsService();
		$this->journalService = new BotJournalService();
		$this->commandDispatcher = new BotCommandDispatcher();
		$this->provisioningService = new BotAccountProvisioningService();
		$this->multiAccountService = new BotMultiAccountService();
		$this->allianceService = new BotAllianceService();
		$this->commanderService = new BotCommanderService();
	}

	public function ensureDefaults()
	{
		$this->configService->ensureDefaults();
		$this->seedDefaultProfiles();
	}

	public function getConfig()
	{
		$this->ensureDefaults();
		return $this->configService->getConfig();
	}

	public function saveConfig(array $data)
	{
		$this->configService->saveConfig($data);
		$this->provisioningService->ensureComplianceForAllBots($this->getConfig());
	}

	public function getActiveProfiles()
	{
		return Database::get()->select('SELECT *
			FROM %%BOT_PROFILES%%
			WHERE universe = :universe AND is_active = 1 AND archived_at IS NULL
			ORDER BY target_online DESC, id ASC;', array(
				':universe' => Universe::getEmulated(),
			));
	}

	public function getSnapshot()
	{
		$this->ensureDefaults();
		$db = Database::get();
		$config = $this->getConfig();
		$this->allianceService->refreshAllianceGovernance(10);
		$metrics = $this->metricsService->getDashboardMetrics();

		$profiles = $db->select('SELECT p.*,
				(SELECT COUNT(*) FROM %%USERS%% u WHERE u.universe = :universe AND u.is_bot = 1 AND u.bot_profile_id = p.id) AS assigned_bots
			FROM %%BOT_PROFILES%% p
			WHERE p.universe = :universe
			ORDER BY p.is_active DESC, p.target_online DESC, p.id ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$activity = $db->select('SELECT a.*, u.username
			FROM %%BOT_ACTIVITY%% a
			LEFT JOIN %%USERS%% u ON u.id = a.bot_user_id
			WHERE a.universe = :universe
			ORDER BY a.id DESC
			LIMIT 80;', array(
				':universe' => Universe::getEmulated(),
			));

		$botRoster = $db->select('SELECT u.id, u.username, u.email, u.onlinetime, p.name AS profile_name,
				pl.galaxy, pl.`system`, pl.planet, bs.hierarchy_status, bs.presence_logical, bs.presence_social,
				bs.session_started_at, bs.session_target_until, bs.session_rest_until, bs.is_online_forced,
				bac.compliance_status, bmv.validation_status, a.ally_tag
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%PLANETS%% pl ON pl.id = u.id_planet
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN %%BOT_ACCOUNT_COMPLIANCE%% bac ON bac.bot_user_id = u.id
			LEFT JOIN %%BOT_MULTIACCOUNT_VALIDATION%% bmv ON bmv.bot_user_id = u.id
			LEFT JOIN %%ALLIANCE%% a ON a.id = u.ally_id
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY u.onlinetime DESC, u.id ASC
			LIMIT 100;', array(
				':universe' => Universe::getEmulated(),
			));

		$onlineRoster = $db->select('SELECT u.id, u.username, p.name AS profile_name, bs.hierarchy_status, bs.presence_logical,
				bs.presence_social, bs.session_started_at, bs.session_target_until, bs.current_campaign_id, bs.is_online_forced
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND bs.presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\')
			ORDER BY COALESCE(bs.session_target_until, 2147483647) ASC, bs.is_online_forced DESC, u.id ASC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
			));

		$relayCandidates = $db->select('SELECT u.id, u.username, p.name AS profile_name, bs.hierarchy_status, bs.presence_logical,
				bs.presence_social, bs.session_rest_until, bs.last_presence_change_at, bs.current_campaign_id
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND (bs.paused_until IS NULL OR bs.paused_until <= :now)
			  AND bs.presence_logical NOT IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\')
			ORDER BY
				CASE WHEN bs.session_rest_until IS NULL OR bs.session_rest_until <= :now THEN 0 ELSE 1 END ASC,
				COALESCE(bs.session_rest_until, 0) ASC,
				COALESCE(bs.last_presence_change_at, 0) ASC,
				u.id ASC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
			));

		$orders = $db->select('SELECT *
			FROM %%BOT_COMMANDS%%
			WHERE universe = :universe
			ORDER BY id DESC
			LIMIT 30;', array(
				':universe' => Universe::getEmulated(),
			));

		$campaigns = $db->select('SELECT *
			FROM %%BOT_CAMPAIGNS%%
			WHERE universe = :universe
			ORDER BY updated_at DESC, id DESC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
			));

		foreach ($campaigns as &$campaign) {
			$campaign['payload'] = $this->decodeJson(isset($campaign['payload_json']) ? $campaign['payload_json'] : null);
			$campaign['member_count'] = (int) $db->selectSingle('SELECT COUNT(*) AS count
				FROM %%BOT_CAMPAIGN_MEMBERS%%
				WHERE campaign_id = :campaignId;', array(
					':campaignId' => (int) $campaign['id'],
				), 'count');
			$campaign['phase_label'] = !empty($campaign['payload']['phase']) ? ucfirst(str_replace('_', ' ', $campaign['payload']['phase'])) : 'Observation';
			$campaign['mode_label'] = !empty($campaign['payload']['mode']) ? ucfirst(str_replace('_', ' ', $campaign['payload']['mode'])) : ucfirst($campaign['campaign_type']);
			$campaign['narrative'] = !empty($campaign['payload']['narrative']) ? $campaign['payload']['narrative'] : 'Campagne active sans narration détaillée.';
			$campaign['visibility_strategy'] = !empty($campaign['payload']['visibility_strategy']) ? $campaign['payload']['visibility_strategy'] : 'visible';
			$campaign['relay_strategy'] = !empty($campaign['payload']['relay_strategy']) ? $campaign['payload']['relay_strategy'] : 'rotation_continue';
			$campaign['effective_intensity'] = !empty($campaign['payload']['effective_intensity']) ? (int) $campaign['payload']['effective_intensity'] : (int) $campaign['intensity'];
			$campaign['focused_target'] = !empty($campaign['target_reference']) ? $campaign['target_reference'] : $campaign['zone_reference'];
		}
		unset($campaign);

		$queuedActions = $db->select('SELECT q.*, u.username
			FROM %%BOT_ACTION_QUEUE%% q
			LEFT JOIN %%USERS%% u ON u.id = q.bot_user_id
			WHERE q.universe = :universe
			ORDER BY q.status ASC, q.priority DESC, q.id DESC
			LIMIT 30;', array(
				':universe' => Universe::getEmulated(),
			));

		$upcoming = $db->select('SELECT q.id, q.bot_user_id, q.action_type, q.objective_type, q.due_at, q.priority, q.status, u.username
			FROM %%BOT_ACTION_QUEUE%% q
			LEFT JOIN %%USERS%% u ON u.id = q.bot_user_id
			WHERE q.universe = :universe
			  AND q.status IN (\'queued\', \'running\')
			ORDER BY COALESCE(q.due_at, q.planned_at) ASC, q.priority DESC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
			));

		$profileDistribution = $db->select('SELECT COALESCE(p.name, \'Sans profil\') AS label, COUNT(*) AS total
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			WHERE u.universe = :universe AND u.is_bot = 1
			GROUP BY COALESCE(p.name, \'Sans profil\')
			ORDER BY total DESC, label ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$allianceDistribution = $db->select('SELECT COALESCE(a.ally_tag, \'Sans alliance\') AS label, COUNT(*) AS total
			FROM %%USERS%% u
			LEFT JOIN %%ALLIANCE%% a ON a.id = u.ally_id
			WHERE u.universe = :universe AND u.is_bot = 1
			GROUP BY COALESCE(a.ally_tag, \'Sans alliance\')
			ORDER BY total DESC, label ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$galaxyDistribution = $db->select('SELECT CONCAT(pl.galaxy, \':\', pl.`system`) AS label, COUNT(*) AS total
			FROM %%USERS%% u
			INNER JOIN %%PLANETS%% pl ON pl.id = u.id_planet
			WHERE u.universe = :universe AND u.is_bot = 1
			GROUP BY pl.galaxy, pl.`system`
			ORDER BY total DESC, pl.galaxy ASC, pl.`system` ASC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
			));

		$botFocus = $db->select('SELECT u.id, u.username, u.onlinetime, p.name AS profile_name, a.ally_tag,
				bs.hierarchy_status, bs.presence_logical, bs.presence_social, bs.current_campaign_id, bs.action_queue_size,
				bs.session_target_until, bs.session_rest_until, bs.cooldown_until, bs.paused_until,
				c.campaign_code, c.label AS campaign_label, c.payload_json AS campaign_payload_json,
				(SELECT q.action_type
					FROM %%BOT_ACTION_QUEUE%% q
					WHERE q.bot_user_id = u.id AND q.status IN (\'queued\', \'running\')
					ORDER BY COALESCE(q.due_at, q.planned_at) ASC, q.priority DESC
					LIMIT 1) AS next_action_type,
				(SELECT COALESCE(q.due_at, q.planned_at)
					FROM %%BOT_ACTION_QUEUE%% q
					WHERE q.bot_user_id = u.id AND q.status IN (\'queued\', \'running\')
					ORDER BY COALESCE(q.due_at, q.planned_at) ASC, q.priority DESC
					LIMIT 1) AS next_action_due,
				(SELECT a2.activity_summary
					FROM %%BOT_ACTIVITY%% a2
					WHERE a2.bot_user_id = u.id
					ORDER BY a2.id DESC
					LIMIT 1) AS last_activity_summary,
				(SELECT a2.created_at
					FROM %%BOT_ACTIVITY%% a2
					WHERE a2.bot_user_id = u.id
					ORDER BY a2.id DESC
					LIMIT 1) AS last_activity_at
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%ALLIANCE%% a ON a.id = u.ally_id
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN %%BOT_CAMPAIGNS%% c ON c.id = bs.current_campaign_id
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY
				CASE WHEN bs.current_campaign_id IS NOT NULL THEN 0 ELSE 1 END ASC,
				CASE WHEN bs.hierarchy_status = \'chef\' THEN 0 ELSE 1 END ASC,
				bs.action_queue_size DESC,
				COALESCE(bs.session_target_until, 2147483647) ASC,
				u.onlinetime DESC
			LIMIT 18;', array(
				':universe' => Universe::getEmulated(),
			));

		foreach ($botFocus as &$focus) {
			$focus['campaign_payload'] = $this->decodeJson(isset($focus['campaign_payload_json']) ? $focus['campaign_payload_json'] : null);
			$focus['campaign_phase_label'] = !empty($focus['campaign_payload']['phase']) ? ucfirst(str_replace('_', ' ', $focus['campaign_payload']['phase'])) : 'Hors campagne';
			$focus['campaign_mode_label'] = !empty($focus['campaign_payload']['mode']) ? ucfirst(str_replace('_', ' ', $focus['campaign_payload']['mode'])) : '';
		}
		unset($focus);

		$allianceSummaries = $this->allianceService->getAllianceSummaries(8);

		return array(
			'config' => $config,
			'metrics' => $metrics,
			'profiles' => $profiles,
			'activity' => $activity,
			'bot_roster' => $botRoster,
			'online_roster' => $onlineRoster,
			'relay_candidates' => $relayCandidates,
			'orders' => $orders,
			'campaigns' => $campaigns,
			'alliance_summaries' => $allianceSummaries,
			'bot_focus' => $botFocus,
			'queued_actions' => $queuedActions,
			'upcoming' => $upcoming,
			'profile_distribution' => $profileDistribution,
			'alliance_distribution' => $allianceDistribution,
			'galaxy_distribution' => $galaxyDistribution,
			'command_catalog' => $this->commandDispatcher->getCatalog(),
		);
	}

	public function saveProfile(array $data)
	{
		$db = Database::get();
		$db->insert("INSERT INTO %%BOT_PROFILES%% SET
			universe = :universe,
			name = :name,
			profile_code = :profileCode,
			description = :description,
			doctrine = :doctrine,
			role_primary = :rolePrimary,
			role_secondary = :roleSecondary,
			communication_style = :communicationStyle,
			target_online = :targetOnline,
			target_social_online = :targetSocialOnline,
			target_presence_min = :targetPresenceMin,
			target_presence_max = :targetPresenceMax,
			aggression = :aggression,
			economy_focus = :economyFocus,
			expansion_focus = :expansionFocus,
			always_active = :alwaysActive,
			is_visible_socially = :isVisibleSocially,
			is_commander_profile = :isCommanderProfile,
			is_active = :isActive,
			traits_json = :traitsJson,
			created_at = :createdAt,
			updated_at = :updatedAt;", array(
			':universe' => Universe::getEmulated(),
			':name' => trim((string) $data['name']),
			':profileCode' => !empty($data['profile_code']) ? trim((string) $data['profile_code']) : $this->slugify($data['name']),
			':description' => trim((string) $data['description']),
			':doctrine' => !empty($data['doctrine']) ? trim((string) $data['doctrine']) : 'equilibre',
			':rolePrimary' => !empty($data['role_primary']) ? trim((string) $data['role_primary']) : 'economiste',
			':roleSecondary' => !empty($data['role_secondary']) ? trim((string) $data['role_secondary']) : '',
			':communicationStyle' => !empty($data['communication_style']) ? trim((string) $data['communication_style']) : 'mesure',
			':targetOnline' => max(0, (int) $data['target_online']),
			':targetSocialOnline' => max(0, (int) $data['target_social_online']),
			':targetPresenceMin' => max(5, (int) $data['target_presence_min']),
			':targetPresenceMax' => max(10, (int) $data['target_presence_max']),
			':aggression' => max(0, min(100, (int) $data['aggression'])),
			':economyFocus' => max(0, min(100, (int) $data['economy_focus'])),
			':expansionFocus' => max(0, min(100, (int) $data['expansion_focus'])),
			':alwaysActive' => empty($data['always_active']) ? 0 : 1,
			':isVisibleSocially' => empty($data['is_visible_socially']) ? 0 : 1,
			':isCommanderProfile' => empty($data['is_commander_profile']) ? 0 : 1,
			':isActive' => empty($data['is_active']) ? 0 : 1,
			':traitsJson' => !empty($data['traits_json']) ? $data['traits_json'] : null,
			':createdAt' => TIMESTAMP,
			':updatedAt' => TIMESTAMP,
		));
	}

	public function runEngine($limit = 12, $phase = 'cycle')
	{
		$this->ensureDefaults();
		return $this->engineService->runCycle($phase, $limit);
	}

	public function dispatchPendingCommands($limit = 12)
	{
		return $this->commandDispatcher->dispatchPending($limit);
	}

	public function dispatchCommandById($commandId)
	{
		return $this->commandDispatcher->dispatchCommandById((int) $commandId);
	}

	public function createStructuredCommand($commandText, $issuedByUserId)
	{
		return $this->commandDispatcher->createStructuredCommand($commandText, $issuedByUserId);
	}

	public function refreshAllPlayerMissions()
	{
		require_once ROOT_PATH.'includes/classes/UserMissionService.class.php';
		$service = new UserMissionService();
		return $service->refreshAllUsers();
	}

	public function logAdministrativeAction($botUserId, $type, $summary, array $payload = array())
	{
		$this->journalService->logActivity($botUserId, $type, $summary, $payload);
	}

	public function createBots(array $data)
	{
		$this->ensureDefaults();
		$config = $this->getConfig();
		$created = $this->provisioningService->createBots($data, $config);
		$this->provisioningService->ensureComplianceForAllBots($config);
		return $created;
	}

	public function rotateBotPasswords(array $botUserIds)
	{
		return $this->provisioningService->rotatePasswords($botUserIds, $this->getConfig());
	}

	public function promoteCommander($botUserId)
	{
		return $this->commanderService->promote($botUserId);
	}

	public function validateBotsAsMulti(array $botUserIds)
	{
		$count = 0;
		foreach ($botUserIds as $botUserId) {
			if ($this->multiAccountService->validateBot((int) $botUserId, 'validation_administration')) {
				$count++;
			}
		}
		return $count;
	}

	public function assignAlliance(array $botUserIds, $allianceId)
	{
		foreach ($botUserIds as $botUserId) {
			$this->allianceService->assignBotToAlliance((int) $botUserId, (int) $allianceId);
		}
		return count($botUserIds);
	}

	protected function seedDefaultProfiles()
	{
		$db = Database::get();
		$defaults = $this->getDefaultProfiles();
		foreach ($defaults as $profile) {
			$exists = $db->selectSingle('SELECT id FROM %%BOT_PROFILES%% WHERE universe = :universe AND name = :name LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':name' => $profile['name'],
			));
			if (!empty($exists)) {
				continue;
			}

			$this->saveProfile($profile);
		}
	}

	protected function getDefaultProfiles()
	{
		$base = array(
			array('Économiste', 'equilibre', 'economiste', 8, 2, 20, 78, 24, 0, 1, 0),
			array('Agressif', 'guerre', 'predateur', 10, 1, 82, 22, 28, 0, 1, 0),
			array('Colonisateur', 'expansion', 'colonisateur', 7, 1, 30, 56, 84, 0, 1, 0),
			array('Opportuniste', 'opportuniste', 'raider', 6, 2, 72, 38, 40, 0, 1, 0),
			array('Défensif', 'fortification', 'protecteur', 5, 1, 22, 58, 18, 0, 1, 0),
			array('Technologue', 'recherche', 'technologue', 5, 1, 18, 74, 22, 0, 1, 0),
			array('Logisticien', 'soutien', 'logisticien', 4, 1, 18, 60, 30, 0, 0, 0),
			array('Éclaireur', 'recon', 'eclaireur', 7, 2, 52, 34, 26, 0, 1, 0),
			array('Chef de guerre', 'pression_continue', 'chef', 4, 2, 78, 28, 32, 1, 1, 1),
			array('Diplomate', 'influence', 'diplomate', 3, 2, 16, 42, 18, 0, 1, 0),
			array('Animateur', 'presence', 'animateur', 3, 3, 10, 28, 12, 0, 1, 0),
			array('Prédateur', 'predation', 'predateur', 8, 1, 88, 18, 18, 0, 0, 0),
			array('Protecteur', 'protection', 'protecteur', 4, 1, 26, 54, 16, 0, 0, 0),
			array('Pillard', 'raid', 'raider', 7, 1, 84, 20, 14, 0, 0, 0),
			array('Expansionniste', 'expansion', 'colonisateur', 8, 1, 34, 50, 86, 0, 0, 0),
			array('Solitaire', 'autonomie', 'solitaire', 3, 0, 40, 48, 28, 0, 0, 0),
			array('Loyaliste', 'soutien', 'loyaliste', 4, 1, 24, 46, 22, 0, 0, 0),
			array('Revanchard', 'vengeance', 'predateur', 5, 1, 76, 26, 20, 0, 0, 0),
			array('Coordinateur offensif', 'coordination', 'chef', 4, 2, 70, 30, 26, 1, 1, 1),
			array('Harceleur', 'harcelement', 'harceleur', 6, 1, 74, 24, 20, 0, 0, 0),
			array('Commandant de siège', 'siege', 'chef', 3, 1, 80, 26, 18, 1, 1, 1),
			array('Recruteur', 'recrutement', 'recruteur', 3, 2, 18, 32, 14, 0, 1, 0),
			array('Manipulateur social', 'pression_sociale', 'diplomate', 3, 3, 34, 20, 10, 0, 1, 0),
		);

		$profiles = array();
		foreach ($base as $row) {
			$profiles[] = array(
				'name' => $row[0],
				'description' => 'Profil '.$row[0].' pour le moteur bots Astra.',
				'profile_code' => $this->slugify($row[0]),
				'doctrine' => $row[1],
				'role_primary' => $row[2],
				'role_secondary' => '',
				'communication_style' => $row[9] ? 'fort' : 'mesure',
				'target_online' => $row[3],
				'target_social_online' => $row[4],
				'target_presence_min' => 15,
				'target_presence_max' => 90,
				'aggression' => $row[5],
				'economy_focus' => $row[6],
				'expansion_focus' => $row[7],
				'always_active' => $row[8],
				'is_visible_socially' => $row[9],
				'is_commander_profile' => $row[10],
				'is_active' => 1,
				'traits_json' => json_encode(array(
					'sociabilite' => $row[9] ? 70 : 35,
					'aptitude_commandement' => $row[10] ? 82 : 42,
					'gout_harcelement' => in_array($row[0], array('Harceleur', 'Prédateur', 'Pillard'), true) ? 78 : 26,
				)),
			);
		}

		return $profiles;
	}

	protected function slugify($value)
	{
		$value = strtolower(trim((string) $value));
		$value = preg_replace('/[^a-z0-9]+/i', '-', $value);
		return trim((string) $value, '-');
	}

	protected function decodeJson($json)
	{
		if (empty($json)) {
			return array();
		}

		$decoded = json_decode($json, true);
		return is_array($decoded) ? $decoded : array();
	}
}
