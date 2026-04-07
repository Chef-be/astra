<?php

class ShowBotsPage extends AbstractAdminPage
{
	protected $service;

	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/BotAdminService.class.php';
		$this->service = new BotAdminService();
	}

	public function show()
	{
		global $USER, $LNG;

		$snapshot = $this->service->getSnapshot();
		foreach ($snapshot['activity'] as &$row) {
			$row['created_at_formatted'] = _date($LNG['php_tdformat'], $row['created_at'], $USER['timezone']);
		}
		unset($row);

		foreach ($snapshot['bot_roster'] as &$row) {
			$row['onlinetime_formatted'] = _date($LNG['php_tdformat'], $row['onlinetime'], $USER['timezone']);
			$row['session_target_until_formatted'] = !empty($row['session_target_until']) ? _date($LNG['php_tdformat'], $row['session_target_until'], $USER['timezone']) : '';
			$row['session_rest_until_formatted'] = !empty($row['session_rest_until']) ? _date($LNG['php_tdformat'], $row['session_rest_until'], $USER['timezone']) : '';
			$row['session_target_in_label'] = $this->formatDeltaLabel(!empty($row['session_target_until']) ? ((int) $row['session_target_until'] - TIMESTAMP) : null, 'fin');
			$row['session_rest_in_label'] = $this->formatDeltaLabel(!empty($row['session_rest_until']) ? ((int) $row['session_rest_until'] - TIMESTAMP) : null, 'relève');
		}
		unset($row);

		foreach ($snapshot['online_roster'] as &$row) {
			$row['session_started_at_formatted'] = !empty($row['session_started_at']) ? _date($LNG['php_tdformat'], $row['session_started_at'], $USER['timezone']) : '';
			$row['session_target_until_formatted'] = !empty($row['session_target_until']) ? _date($LNG['php_tdformat'], $row['session_target_until'], $USER['timezone']) : '';
			$row['session_target_in_label'] = $this->formatDeltaLabel(!empty($row['session_target_until']) ? ((int) $row['session_target_until'] - TIMESTAMP) : null, 'relève');
		}
		unset($row);

		foreach ($snapshot['relay_candidates'] as &$row) {
			$row['session_rest_until_formatted'] = !empty($row['session_rest_until']) ? _date($LNG['php_tdformat'], $row['session_rest_until'], $USER['timezone']) : '';
			$row['session_rest_in_label'] = $this->formatDeltaLabel(!empty($row['session_rest_until']) ? ((int) $row['session_rest_until'] - TIMESTAMP) : null, 'disponible');
		}
		unset($row);

		foreach ($snapshot['orders'] as &$row) {
			$row['created_at_formatted'] = _date($LNG['php_tdformat'], $row['created_at'], $USER['timezone']);
			$row['executed_at_formatted'] = !empty($row['executed_at']) ? _date($LNG['php_tdformat'], $row['executed_at'], $USER['timezone']) : '';
		}
		unset($row);

		foreach ($snapshot['campaigns'] as &$row) {
			$row['updated_at_formatted'] = _date($LNG['php_tdformat'], $row['updated_at'], $USER['timezone']);
			$row['cooldown_until_formatted'] = !empty($row['payload']['cooldown_until']) ? _date($LNG['php_tdformat'], $row['payload']['cooldown_until'], $USER['timezone']) : '';
			$row['last_execution_at_formatted'] = !empty($row['payload']['last_execution_at']) ? _date($LNG['php_tdformat'], $row['payload']['last_execution_at'], $USER['timezone']) : '';
		}
		unset($row);

		foreach ($snapshot['alliance_summaries'] as &$row) {
			$row['updated_at_formatted'] = _date($LNG['php_tdformat'], $row['updated_at'], $USER['timezone']);
		}
		unset($row);

		foreach ($snapshot['bot_focus'] as &$row) {
			$row['next_action_due_formatted'] = !empty($row['next_action_due']) ? _date($LNG['php_tdformat'], $row['next_action_due'], $USER['timezone']) : '';
			$row['last_activity_at_formatted'] = !empty($row['last_activity_at']) ? _date($LNG['php_tdformat'], $row['last_activity_at'], $USER['timezone']) : '';
			$row['session_target_in_label'] = $this->formatDeltaLabel(!empty($row['session_target_until']) ? ((int) $row['session_target_until'] - TIMESTAMP) : null, 'relève');
			$row['session_rest_in_label'] = $this->formatDeltaLabel(!empty($row['session_rest_until']) ? ((int) $row['session_rest_until'] - TIMESTAMP) : null, 'repos');
		}
		unset($row);

		foreach ($snapshot['queued_actions'] as &$row) {
			$row['planned_at_formatted'] = !empty($row['planned_at']) ? _date($LNG['php_tdformat'], $row['planned_at'], $USER['timezone']) : '';
			$row['due_at_formatted'] = !empty($row['due_at']) ? _date($LNG['php_tdformat'], $row['due_at'], $USER['timezone']) : '';
			$row['finished_at_formatted'] = !empty($row['finished_at']) ? _date($LNG['php_tdformat'], $row['finished_at'], $USER['timezone']) : '';
		}
		unset($row);

		foreach ($snapshot['upcoming'] as &$row) {
			$row['due_at_formatted'] = !empty($row['due_at']) ? _date($LNG['php_tdformat'], $row['due_at'], $USER['timezone']) : '';
		}
		unset($row);

		foreach ($snapshot['metrics']['latest_runs'] as &$run) {
			$run['started_at_formatted'] = _date($LNG['php_tdformat'], $run['started_at'], $USER['timezone']);
			$run['finished_at_formatted'] = !empty($run['finished_at']) ? _date($LNG['php_tdformat'], $run['finished_at'], $USER['timezone']) : '';
		}
		unset($run);

		$this->assign(array(
			'botSnapshot' => $snapshot,
			'botProfiles' => $snapshot['profiles'],
			'botPresenceEditor' => $this->buildPresenceEditor(isset($snapshot['config']['global_presence_rules_json']) ? $snapshot['config']['global_presence_rules_json'] : array()),
			'botDecisionEditor' => $this->buildDecisionEditor(isset($snapshot['config']['decision_weights_json']) ? $snapshot['config']['decision_weights_json'] : array()),
			'botProfileEditor' => $this->service->getProfileEditorCatalog(),
		));

		$this->display('page.bots.default.tpl');
	}

	public function saveConfig()
	{
		$current = $this->service->getConfig();
		$presenceRules = $this->extractPresenceRules(isset($current['global_presence_rules_json']) ? $current['global_presence_rules_json'] : array());
		$decisionWeights = $this->extractDecisionWeights(isset($current['decision_weights_json']) ? $current['decision_weights_json'] : array());

		$this->service->saveConfig(array(
			'engine_enabled' => HTTP::_GP('engine_enabled', 'off') === 'on' ? 1 : 0,
			'target_online_total' => HTTP::_GP('target_online_total', 24),
			'target_social_total' => HTTP::_GP('target_social_total', 8),
			'action_budget_per_cycle' => HTTP::_GP('action_budget_per_cycle', 24),
			'max_bots_per_cycle' => HTTP::_GP('max_bots_per_cycle', 12),
			'max_actions_per_bot' => HTTP::_GP('max_actions_per_bot', 3),
			'enable_bot_alliances' => HTTP::_GP('enable_bot_alliances', 'off') === 'on' ? 1 : 0,
			'enable_command_hierarchy' => HTTP::_GP('enable_command_hierarchy', 'off') === 'on' ? 1 : 0,
			'enable_bonuses' => HTTP::_GP('enable_bonuses', 'off') === 'on' ? 1 : 0,
			'enable_private_messages' => HTTP::_GP('enable_private_messages', 'off') === 'on' ? 1 : 0,
			'enable_social_messages' => HTTP::_GP('enable_social_messages', 'off') === 'on' ? 1 : 0,
			'enable_campaigns' => HTTP::_GP('enable_campaigns', 'off') === 'on' ? 1 : 0,
			'shared_email' => HTTP::_GP('shared_email', '', true),
			'password_policy' => HTTP::_GP('password_policy', 'rotation_mensuelle', true),
			'multiaccount_policy' => HTTP::_GP('multiaccount_policy', 'bots_valides', true),
			'default_bot_alliance_tag' => HTTP::_GP('default_bot_alliance_tag', 'ASTRA', true),
			'default_bot_alliance_name' => HTTP::_GP('default_bot_alliance_name', 'Commandement Astra', true),
			'global_presence_rules_json' => $presenceRules,
			'decision_weights_json' => $decisionWeights,
		));

		$this->redirectTo('admin.php?page=bots');
	}

	public function saveProfile()
	{
		$this->service->saveProfile(array(
			'name' => HTTP::_GP('name', '', true),
			'description' => HTTP::_GP('description', '', true),
			'profile_code' => HTTP::_GP('profile_code', '', true),
			'doctrine' => HTTP::_GP('doctrine', 'equilibre', true),
			'role_primary' => HTTP::_GP('role_primary', 'economiste', true),
			'role_secondary' => HTTP::_GP('role_secondary', '', true),
			'communication_style' => HTTP::_GP('communication_style', 'mesure', true),
			'target_online' => HTTP::_GP('target_online', 0),
			'target_social_online' => HTTP::_GP('target_social_online', 0),
			'target_presence_min' => HTTP::_GP('target_presence_min', 15),
			'target_presence_max' => HTTP::_GP('target_presence_max', 90),
			'aggression' => HTTP::_GP('aggression', 0),
			'economy_focus' => HTTP::_GP('economy_focus', 0),
			'expansion_focus' => HTTP::_GP('expansion_focus', 0),
			'always_active' => HTTP::_GP('always_active', 'off') === 'on' ? 1 : 0,
			'is_visible_socially' => HTTP::_GP('is_visible_socially', 'off') === 'on' ? 1 : 0,
			'is_commander_profile' => HTTP::_GP('is_commander_profile', 'off') === 'on' ? 1 : 0,
			'is_active' => HTTP::_GP('is_active', 'off') === 'on' ? 1 : 0,
			'traits_json' => HTTP::_GP('traits_json', '', true),
		));

		$this->redirectTo('admin.php?page=bots');
	}

	public function create()
	{
		$this->service->ensureDefaults();
		$this->assign(array(
			'botProfiles' => $this->service->getActiveProfiles(),
			'botConfig' => $this->service->getConfig(),
		));
		$this->display('page.bots.create.tpl');
	}

	public function createSend()
	{
		$count = max(1, HTTP::_GP('bots_number', 0));
		$this->boostExecutionLimitsForMassCreation($count);

		$created = $this->service->createBots(array(
			'count' => $count,
			'name_mode' => HTTP::_GP('bot_name_type', 'random', true) === '1' ? 'numbered' : 'random',
			'profile_id' => HTTP::_GP('bot_profile_id', 0),
			'target_galaxy' => HTTP::_GP('target_galaxy', 1),
			'darkmatter' => HTTP::_GP('bots_dm', 0),
			'metal' => HTTP::_GP('planet_metal', 10000),
			'crystal' => HTTP::_GP('planet_crystal', 10000),
			'deuterium' => HTTP::_GP('planet_deuterium', 10000),
			'field_max' => HTTP::_GP('planet_field_max', 163),
		));

		$this->printMessage(sprintf('%d bot(s) créé(s) avec mots de passe aléatoires distincts et conformité multi-compte appliquée.', count($created)));
	}

	public function runEngine()
	{
		$phase = HTTP::_GP('phase', 'cycle', true);
		$result = $this->service->runEngine(max(1, HTTP::_GP('limit', 12)), $phase);

		$this->printMessage(sprintf(
			'Phase bots « %s » exécutée. Statut : %s. Bots planifiés : %d. Actions exécutées : %d.',
			$phase,
			$result['status'],
			!empty($result['selectedBots']) ? (int) $result['selectedBots'] : 0,
			!empty($result['executedActions']) ? (int) $result['executedActions'] : 0
		), array(
			array(
				'url' => 'admin.php?page=bots',
				'label' => 'Retour à l’administration bots',
			),
		));
	}

	public function massAction()
	{
		$botIds = HTTP::_GP('bot_ids', array());
		if (!is_array($botIds) || empty($botIds)) {
			$this->printMessage('Sélectionnez au moins un bot.');
		}

		$action = HTTP::_GP('mass_action', '', true);
		switch ($action) {
			case 'resume':
				$count = Database::get()->update('UPDATE %%BOT_STATE%% SET paused_until = NULL, updated_at = :updatedAt WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
					':updatedAt' => TIMESTAMP,
				));
				$this->printMessage('Bots relancés.');
				break;
			case 'pause':
				Database::get()->update('UPDATE %%BOT_STATE%% SET paused_until = :pausedUntil, updated_at = :updatedAt WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
					':pausedUntil' => TIMESTAMP + 1800,
					':updatedAt' => TIMESTAMP,
				));
				$this->printMessage('Bots mis en pause pour 30 minutes.');
				break;
			case 'promote':
				foreach ($botIds as $botId) {
					$this->service->promoteCommander((int) $botId);
				}
				$this->printMessage('Promotion chef appliquée.');
				break;
			case 'rotate-passwords':
				$result = $this->service->rotateBotPasswords(array_map('intval', $botIds));
				$this->printMessage(sprintf('%d mot(s) de passe bots régénéré(s).', count($result)));
				break;
			case 'validate-multi':
				$count = $this->service->validateBotsAsMulti(array_map('intval', $botIds));
				$this->printMessage(sprintf('%d validation(s) multi-compte bots enregistrée(s).', $count));
				break;
			default:
				$this->printMessage('Action de masse inconnue.');
		}
	}

	protected function decodeJsonInput($json, array $fallback)
	{
		$json = trim((string) $json);
		if ($json === '') {
			return $fallback;
		}

		$decoded = json_decode($json, true);
		return is_array($decoded) ? $decoded : $fallback;
	}

	protected function buildPresenceEditor(array $rules)
	{
		$defaults = array(
			'tranches' => array(
				'00-06' => 0.45,
				'06-12' => 0.65,
				'12-18' => 0.85,
				'18-24' => 1.00,
			),
			'sessions' => array(
				'min_minutes' => 18,
				'max_minutes' => 75,
				'min_rest_minutes' => 12,
				'max_rest_minutes' => 90,
				'rest_ratio' => 0.55,
				'commander_bonus_minutes' => 40,
				'campaign_bonus_minutes' => 55,
			),
			'always_visible_roles' => array('chef', 'animateur'),
		);

		$merged = array_replace_recursive($defaults, $rules);
		$trancheLabels = array(
			'00-06' => 'Nuit profonde',
			'06-12' => 'Matinée',
			'12-18' => 'Journée',
			'18-24' => 'Prime time',
		);
		$sessionLabels = array(
			'min_minutes' => 'Session min',
			'max_minutes' => 'Session max',
			'min_rest_minutes' => 'Repos min',
			'max_rest_minutes' => 'Repos max',
			'rest_ratio' => 'Ratio de repos',
			'commander_bonus_minutes' => 'Bonus chef',
			'campaign_bonus_minutes' => 'Bonus campagne',
		);

		$tranches = array();
		foreach ($merged['tranches'] as $key => $value) {
			$tranches[] = array(
				'key' => $key,
				'label' => isset($trancheLabels[$key]) ? $trancheLabels[$key] : $key,
				'value' => $value,
			);
		}

		$sessions = array();
		foreach ($merged['sessions'] as $key => $value) {
			$sessions[] = array(
				'key' => $key,
				'label' => isset($sessionLabels[$key]) ? $sessionLabels[$key] : $key,
				'value' => $value,
				'step' => $key === 'rest_ratio' ? '0.05' : '1',
			);
		}

		return array(
			'tranches' => $tranches,
			'sessions' => $sessions,
			'always_visible_roles_text' => implode(', ', $merged['always_visible_roles']),
		);
	}

	protected function buildDecisionEditor(array $weights)
	{
		$labels = array(
			'economy' => 'Économie',
			'aggression' => 'Agression',
			'pression_continue' => 'Pression continue',
			'communication' => 'Communication',
		);
		$fieldLabels = array(
			'deficit_ressources' => 'Déficit ressources',
			'retard_infrastructure' => 'Retard infrastructure',
			'besoin_financement_objectif' => 'Financement objectif',
			'doctrine_economique' => 'Doctrine éco',
			'prudence' => 'Prudence',
			'fatigue' => 'Fatigue',
			'manque_stock' => 'Manque de stock',
			'agressivite' => 'Agressivité',
			'opportunite_raid' => 'Opportunité de raid',
			'superiorite_locale' => 'Supériorité locale',
			'appetit_raid' => 'Appétit de raid',
			'rancune' => 'Rancune',
			'ordre_offensif' => 'Ordre offensif',
			'intensite_campagne' => 'Intensité campagne',
			'soutien_alliance' => 'Soutien alliance',
			'peur' => 'Peur',
			'campagne_active' => 'Campagne active',
			'persistance_tactique' => 'Persistance tactique',
			'objectif_alliance' => 'Objectif alliance',
			'bonus_chef' => 'Bonus chef',
			'rotation_disponible' => 'Rotation disponible',
			'logistique_disponible' => 'Logistique disponible',
			'usure' => 'Usure',
			'saturation_logistique' => 'Saturation logistique',
			'sociabilite' => 'Sociabilité',
			'role_social' => 'Rôle social',
			'opportunite_diplomatique' => 'Opportunité diplomatique',
			'pression_psychologique' => 'Pression psychologique',
			'ordre_chef' => 'Ordre de chef',
			'discretion' => 'Discrétion',
		);

		$groups = array();
		foreach ($weights as $groupKey => $groupValues) {
			$fields = array();
			foreach ($groupValues as $fieldKey => $value) {
				$fields[] = array(
					'key' => $fieldKey,
					'label' => isset($fieldLabels[$fieldKey]) ? $fieldLabels[$fieldKey] : $fieldKey,
					'value' => $value,
				);
			}

			$groups[] = array(
				'key' => $groupKey,
				'label' => isset($labels[$groupKey]) ? $labels[$groupKey] : $groupKey,
				'fields' => $fields,
			);
		}

		return $groups;
	}

	protected function extractPresenceRules(array $fallback)
	{
		$current = $this->buildPresenceEditor($fallback);
		$rules = array(
			'tranches' => array(),
			'sessions' => array(),
			'always_visible_roles' => array(),
		);

		$postedTranches = isset($_POST['presence_tranches']) && is_array($_POST['presence_tranches']) ? $_POST['presence_tranches'] : array();
		foreach ($current['tranches'] as $tranche) {
			$key = $tranche['key'];
			$value = isset($postedTranches[$key]) ? (float) $postedTranches[$key] : (float) $tranche['value'];
			$rules['tranches'][$key] = max(0.1, min(3.0, round($value, 2)));
		}

		$postedSessions = isset($_POST['presence_sessions']) && is_array($_POST['presence_sessions']) ? $_POST['presence_sessions'] : array();
		foreach ($current['sessions'] as $session) {
			$key = $session['key'];
			$value = isset($postedSessions[$key]) ? $postedSessions[$key] : $session['value'];
			if ($key === 'rest_ratio') {
				$rules['sessions'][$key] = max(0.10, min(2.00, round((float) $value, 2)));
				continue;
			}

			$rules['sessions'][$key] = max(1, (int) $value);
		}

		$rolesText = trim(HTTP::_GP('always_visible_roles_text', $current['always_visible_roles_text'], true));
		$roles = array_filter(array_map('trim', explode(',', $rolesText)));
		$rules['always_visible_roles'] = empty($roles) ? array('chef', 'animateur') : array_values(array_unique($roles));

		return $rules;
	}

	protected function extractDecisionWeights(array $fallback)
	{
		$groups = $this->buildDecisionEditor($fallback);
		$postedWeights = isset($_POST['decision_weight']) && is_array($_POST['decision_weight']) ? $_POST['decision_weight'] : array();
		$weights = array();

		foreach ($groups as $group) {
			$weights[$group['key']] = array();
			foreach ($group['fields'] as $field) {
				$value = isset($postedWeights[$group['key']][$field['key']]) ? (float) $postedWeights[$group['key']][$field['key']] : (float) $field['value'];
				$weights[$group['key']][$field['key']] = max(-1.0, min(1.0, round($value, 2)));
			}
		}

		return $weights;
	}

	protected function boostExecutionLimitsForMassCreation($count)
	{
		if ($count < 100) {
			return;
		}

		@ignore_user_abort(true);
		@set_time_limit(max(300, $count * 3));
		@ini_set('max_execution_time', '0');
		@ini_set('memory_limit', '1024M');
	}

	protected function formatDeltaLabel($seconds, $readyLabel)
	{
		if ($seconds === null) {
			return '-';
		}

		$seconds = (int) $seconds;
		if ($seconds <= 0) {
			return $readyLabel.' maintenant';
		}

		$minutes = (int) ceil($seconds / 60);
		if ($minutes >= 60) {
			$hours = floor($minutes / 60);
			$remainingMinutes = $minutes % 60;
			if ($remainingMinutes === 0) {
				return sprintf('%s dans %dh', $readyLabel, $hours);
			}

			return sprintf('%s dans %dh%02d', $readyLabel, $hours, $remainingMinutes);
		}

		return sprintf('%s dans %d min', $readyLabel, $minutes);
	}
}
