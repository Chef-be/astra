<?php

class BotMetricsService
{
	public function getDashboardMetrics($universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		require_once ROOT_PATH.'includes/classes/BotEngineConfigService.class.php';
		$db = Database::get();
		$activeThreshold = TIMESTAMP - 900;
		$totalBots = (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1;', array(':universe' => (int) $universe), 'count');
		$configService = new BotEngineConfigService();
		$config = $configService->getConfig($universe);
		$targetOnlineCurrent = $this->computeHourlyTarget($config, $totalBots);
		$targetSocialCurrent = max(0, min((int) $config['target_social_total'], $targetOnlineCurrent));

		return array(
			'total_bots' => $totalBots,
			'active_bots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND onlinetime >= :activeThreshold;', array(':universe' => (int) $universe, ':activeThreshold' => $activeThreshold), 'count'),
			'logical_connected' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\');', array(':universe' => (int) $universe), 'count'),
			'social_visible' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND is_socially_visible = 1;', array(':universe' => (int) $universe), 'count'),
			'active_commanders' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND hierarchy_status = \'chef\';', array(':universe' => (int) $universe), 'count'),
			'forced_online' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND is_online_forced = 1;', array(':universe' => (int) $universe), 'count'),
			'resting_bots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND session_rest_until IS NOT NULL AND session_rest_until > :now;', array(':universe' => (int) $universe, ':now' => TIMESTAMP), 'count'),
			'relay_due_soon' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\') AND is_online_forced = 0 AND session_target_until IS NOT NULL AND session_target_until <= :targetAt;', array(':universe' => (int) $universe, ':targetAt' => TIMESTAMP + 900), 'count'),
			'rotation_online' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\') AND is_online_forced = 0;', array(':universe' => (int) $universe), 'count'),
			'target_online_current' => $targetOnlineCurrent,
			'target_social_current' => $targetSocialCurrent,
			'pending_orders' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_COMMANDS%% WHERE universe = :universe AND status IN (\'pending\', \'parsed\', \'queued\');', array(':universe' => (int) $universe), 'count'),
			'rejected_orders' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_COMMANDS%% WHERE universe = :universe AND status = \'rejected\';', array(':universe' => (int) $universe), 'count'),
			'queued_actions' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_ACTION_QUEUE%% WHERE universe = :universe AND status = \'queued\';', array(':universe' => (int) $universe), 'count'),
			'failed_actions' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_ACTION_QUEUE%% WHERE universe = :universe AND status = \'failed\';', array(':universe' => (int) $universe), 'count'),
			'active_campaigns' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_CAMPAIGNS%% WHERE universe = :universe AND status = \'active\';', array(':universe' => (int) $universe), 'count'),
			'validation_ok' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_MULTIACCOUNT_VALIDATION%% WHERE universe = :universe AND validation_status = \'validated_bot\';', array(':universe' => (int) $universe), 'count'),
			'compliance_issues' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_ACCOUNT_COMPLIANCE%% WHERE universe = :universe AND compliance_status <> \'ok\';', array(':universe' => (int) $universe), 'count'),
			'private_messages_sent' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_PRIVATE_MESSAGES%% WHERE universe = :universe AND status = \'sent\';', array(':universe' => (int) $universe), 'count'),
			'social_messages_sent' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_SOCIAL_MESSAGES%% WHERE universe = :universe AND status = \'sent\';', array(':universe' => (int) $universe), 'count'),
			'latest_runs' => $db->select('SELECT id, phase, status, started_at, finished_at, selected_bots, executed_actions, error_summary
				FROM %%BOT_ENGINE_RUNS%%
				WHERE universe = :universe
				ORDER BY id DESC
				LIMIT 10;', array(
					':universe' => (int) $universe,
				)),
		);
	}

	protected function computeHourlyTarget(array $config, $totalBots)
	{
		if ((int) $totalBots <= 0) {
			return 0;
		}

		$rules = !empty($config['global_presence_rules_json']) && is_array($config['global_presence_rules_json'])
			? $config['global_presence_rules_json']
			: array();
		$tranches = isset($rules['tranches']) && is_array($rules['tranches']) ? $rules['tranches'] : array();
		$hour = (int) date('G', TIMESTAMP);
		$multiplier = 1;

		foreach ($tranches as $range => $value) {
			$parts = explode('-', $range);
			if (count($parts) !== 2) {
				continue;
			}

			$start = (int) $parts[0];
			$end = (int) $parts[1];
			if ($hour >= $start && $hour < $end) {
				$multiplier = max(0.1, (float) $value);
				break;
			}
		}

		return max(1, min((int) $totalBots, (int) round((int) $config['target_online_total'] * $multiplier)));
	}
}
