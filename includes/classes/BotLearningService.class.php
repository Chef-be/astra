<?php

class BotLearningService
{
	public function rebuildMetrics($windowDays = 7)
	{
		$db = Database::get();
		$universe = Universe::getEmulated();
		$since = TIMESTAMP - (max(1, (int) $windowDays) * 86400);

		$db->delete('DELETE FROM %%BOT_LEARNING_METRICS%% WHERE universe = :universe;', array(
			':universe' => $universe,
		));

		$actionMetrics = $db->select('SELECT
				q.action_type AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN r.status = \'done\' THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN r.status <> \'done\' THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_ACTION_RESULTS%% r
			INNER JOIN %%BOT_ACTION_QUEUE%% q ON q.id = r.action_queue_id
			WHERE r.universe = :universe
			  AND r.created_at >= :since
			GROUP BY q.action_type;', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($actionMetrics as $metric) {
			$this->insertMetric('action', $metric['scope_reference'], 'efficacite', $metric);
		}

		$profileMetrics = $db->select('SELECT
				COALESCE(bp.name, \'Sans profil\') AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN r.status = \'done\' THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN r.status <> \'done\' THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_ACTION_RESULTS%% r
			INNER JOIN %%BOT_ACTION_QUEUE%% q ON q.id = r.action_queue_id
			INNER JOIN %%USERS%% u ON u.id = q.bot_user_id
			LEFT JOIN %%BOT_PROFILES%% bp ON bp.id = u.bot_profile_id
			WHERE r.universe = :universe
			  AND r.created_at >= :since
			GROUP BY COALESCE(bp.name, \'Sans profil\');', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($profileMetrics as $metric) {
			$this->insertMetric('profile', $metric['scope_reference'], 'efficacite', $metric);
		}

		$commanderMetrics = $db->select('SELECT
				CAST(COALESCE(bs.commander_bot_user_id, CASE WHEN bs.hierarchy_status = \'chef\' THEN q.bot_user_id ELSE 0 END) AS CHAR) AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN r.status = \'done\' THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN r.status <> \'done\' THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_ACTION_RESULTS%% r
			INNER JOIN %%BOT_ACTION_QUEUE%% q ON q.id = r.action_queue_id
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = q.bot_user_id
			WHERE r.universe = :universe
			  AND r.created_at >= :since
			  AND COALESCE(bs.commander_bot_user_id, CASE WHEN bs.hierarchy_status = \'chef\' THEN q.bot_user_id ELSE 0 END) > 0
			GROUP BY scope_reference;', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($commanderMetrics as $metric) {
			$this->insertMetric('commander', $metric['scope_reference'], 'cohesion', $metric);
		}

		$messageMetrics = $db->select('SELECT
				COALESCE(JSON_UNQUOTE(JSON_EXTRACT(payload_json, \'$.template_key\')), \'libre\') AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN status = \'sent\' THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN status <> \'sent\' THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_SOCIAL_MESSAGES%%
			WHERE universe = :universe
			  AND (sent_at IS NULL OR sent_at >= :since)
			GROUP BY scope_reference;', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($messageMetrics as $metric) {
			$this->insertMetric('message', $metric['scope_reference'], 'pertinence_sociale', $metric);
		}

		$campaignMetrics = $db->select('SELECT
				campaign_type AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN status IN (\'active\', \'completed\') THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN status NOT IN (\'active\', \'completed\') THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_CAMPAIGNS%%
			WHERE universe = :universe
			  AND updated_at >= :since
			GROUP BY campaign_type;', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($campaignMetrics as $metric) {
			$this->insertMetric('campaign', $metric['scope_reference'], 'stabilite', $metric);
		}

		$zoneMetrics = $db->select('SELECT
				zone_reference AS scope_reference,
				COUNT(*) AS sample_count,
				SUM(CASE WHEN status = \'active\' THEN 1 ELSE 0 END) AS success_count,
				SUM(CASE WHEN status <> \'active\' THEN 1 ELSE 0 END) AS failure_count
			FROM %%BOT_CAMPAIGNS%%
			WHERE universe = :universe
			  AND updated_at >= :since
			  AND zone_reference <> \'\'
			GROUP BY zone_reference;', array(
				':universe' => $universe,
				':since' => $since,
			));
		foreach ($zoneMetrics as $metric) {
			$this->insertMetric('zone', $metric['scope_reference'], 'pression', $metric);
		}

		return (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%BOT_LEARNING_METRICS%% WHERE universe = :universe;', array(
			':universe' => $universe,
		), 'count');
	}

	public function getMetricMap($scopeType, $metricType)
	{
		$rows = Database::get()->select('SELECT *
			FROM %%BOT_LEARNING_METRICS%%
			WHERE universe = :universe
			  AND scope_type = :scopeType
			  AND metric_type = :metricType;', array(
				':universe' => Universe::getEmulated(),
				':scopeType' => (string) $scopeType,
				':metricType' => (string) $metricType,
			));

		$map = array();
		foreach ($rows as $row) {
			$map[$row['scope_reference']] = $row;
		}

		return $map;
	}

	public function getSnapshotInsights($botUserId, array $bot, array $state, array $bestTarget, array $zoneContext = array())
	{
		$actionMetrics = $this->getMetricMap('action', 'efficacite');
		$profileMetrics = $this->getMetricMap('profile', 'efficacite');
		$commanderMetrics = $this->getMetricMap('commander', 'cohesion');
		$zoneMetrics = $this->getMetricMap('zone', 'pression');

		$profileName = !empty($bot['name']) ? $bot['name'] : 'Sans profil';
		$commanderId = !empty($state['commander_bot_user_id']) ? (string) (int) $state['commander_bot_user_id'] : (!empty($state['hierarchy_status']) && $state['hierarchy_status'] === 'chef' ? (string) (int) $botUserId : '');
		$zoneReference = !empty($zoneContext['zone_reference']) ? $zoneContext['zone_reference'] : '';

		return array(
			'action_metrics' => $actionMetrics,
			'profile_metric' => isset($profileMetrics[$profileName]) ? $profileMetrics[$profileName] : array(),
			'commander_metric' => ($commanderId !== '' && isset($commanderMetrics[$commanderId])) ? $commanderMetrics[$commanderId] : array(),
			'zone_metric' => ($zoneReference !== '' && isset($zoneMetrics[$zoneReference])) ? $zoneMetrics[$zoneReference] : array(),
			'target_signal' => !empty($bestTarget['username']) ? $this->buildTargetSignal($bestTarget, $zoneReference, $zoneMetrics) : array(),
		);
	}

	protected function buildTargetSignal(array $bestTarget, $zoneReference, array $zoneMetrics)
	{
		$zoneMetric = ($zoneReference !== '' && isset($zoneMetrics[$zoneReference])) ? $zoneMetrics[$zoneReference] : array();

		return array(
			'pressure_memory' => !empty($zoneMetric['score_value']) ? (int) round($zoneMetric['score_value']) : 0,
			'psychological_window' => !empty($bestTarget['psychological_score']) ? (int) $bestTarget['psychological_score'] : 0,
			'territorial_window' => !empty($bestTarget['territorial_score']) ? (int) $bestTarget['territorial_score'] : 0,
		);
	}

	protected function insertMetric($scopeType, $scopeReference, $metricType, array $metric)
	{
		$sampleCount = max(0, (int) $metric['sample_count']);
		$successCount = max(0, (int) $metric['success_count']);
		$failureCount = max(0, (int) $metric['failure_count']);
		$scoreValue = $sampleCount > 0 ? round(($successCount / $sampleCount) * 100, 2) : 0;

		Database::get()->insert('INSERT INTO %%BOT_LEARNING_METRICS%% SET
			universe = :universe,
			scope_type = :scopeType,
			scope_reference = :scopeReference,
			metric_type = :metricType,
			sample_count = :sampleCount,
			success_count = :successCount,
			failure_count = :failureCount,
			score_value = :scoreValue,
			payload_json = :payloadJson,
			updated_at = :updatedAt;', array(
				':universe' => Universe::getEmulated(),
				':scopeType' => (string) $scopeType,
				':scopeReference' => (string) $scopeReference,
				':metricType' => (string) $metricType,
				':sampleCount' => $sampleCount,
				':successCount' => $successCount,
				':failureCount' => $failureCount,
				':scoreValue' => $scoreValue,
				':payloadJson' => json_encode(array(
					'window_days' => 7,
				)),
				':updatedAt' => TIMESTAMP,
			));
	}
}
