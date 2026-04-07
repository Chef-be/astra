<?php

class BotMetricsService
{
	public function getDashboardMetrics($universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$db = Database::get();
		$activeThreshold = TIMESTAMP - 900;

		return array(
			'total_bots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1;', array(':universe' => (int) $universe), 'count'),
			'active_bots' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND onlinetime >= :activeThreshold;', array(':universe' => (int) $universe, ':activeThreshold' => $activeThreshold), 'count'),
			'logical_connected' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\');', array(':universe' => (int) $universe), 'count'),
			'social_visible' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND is_socially_visible = 1;', array(':universe' => (int) $universe), 'count'),
			'active_commanders' => (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_STATE%% WHERE universe = :universe AND hierarchy_status = \'chef\';', array(':universe' => (int) $universe), 'count'),
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
}
