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
		));

		$this->display('page.bots.default.tpl');
	}

	public function saveConfig()
	{
		$current = $this->service->getConfig();
		$presenceRules = $this->decodeJsonInput(HTTP::_GP('global_presence_rules_json', '', true), $current['global_presence_rules_json']);
		$decisionWeights = $this->decodeJsonInput(HTTP::_GP('decision_weights_json', '', true), $current['decision_weights_json']);

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
		$created = $this->service->createBots(array(
			'count' => HTTP::_GP('bots_number', 0),
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
