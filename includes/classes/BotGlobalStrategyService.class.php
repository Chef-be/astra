<?php

class BotGlobalStrategyService
{
	protected $territorialMapService;
	protected $learningService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotTerritorialMapService.class.php';
		require_once ROOT_PATH.'includes/classes/BotLearningService.class.php';

		$this->territorialMapService = new BotTerritorialMapService();
		$this->learningService = new BotLearningService();
	}

	public function refreshStrategicState(array $config)
	{
		$db = Database::get();
		$universe = Universe::getEmulated();
		$offensiveZones = $this->territorialMapService->getPriorityZones('pressure_need', 6);
		$defensiveZones = $this->territorialMapService->getPriorityZones('dissuasion_need', 6);
		$coverageZones = $this->territorialMapService->getPriorityZones('coverage_need', 6);
		$learningProfiles = $this->learningService->getMetricMap('profile', 'efficacite');
		$learningCommanders = $this->learningService->getMetricMap('commander', 'cohesion');
		$activeCampaigns = $db->select('SELECT campaign_code, campaign_type, zone_reference, target_reference, intensity
			FROM %%BOT_CAMPAIGNS%%
			WHERE universe = :universe
			  AND status = \'active\'
			ORDER BY updated_at DESC
			LIMIT 12;', array(
				':universe' => $universe,
			));

		$profileFocus = array_slice($this->rankProfiles($learningProfiles), 0, 6);
		$commanderFocus = array_slice($this->rankCommanders($learningCommanders), 0, 6);
		$payload = array(
			'generated_at' => TIMESTAMP,
			'offensive_zones' => $this->normalizeZones($offensiveZones, 'offensive'),
			'defensive_zones' => $this->normalizeZones($defensiveZones, 'defensive'),
			'coverage_zones' => $this->normalizeZones($coverageZones, 'coverage'),
			'profile_focus' => $profileFocus,
			'commander_focus' => $commanderFocus,
			'campaign_targets' => $activeCampaigns,
			'presence_targets' => array(
				'hot_reserve_target' => max(4, (int) ceil((int) $config['target_online_total'] * 0.25)),
				'social_target' => (int) $config['target_social_total'],
				'offensive_target' => max(4, (int) ceil((int) $config['target_online_total'] * 0.40)),
			),
		);

		$this->persistState('strategic_state_json', $payload, 'strategic_cycle_at');

		return $payload;
	}

	public function refreshLongState(array $config)
	{
		$db = Database::get();
		$commanderMetrics = $this->learningService->getMetricMap('commander', 'cohesion');
		$profileMetrics = $this->learningService->getMetricMap('profile', 'efficacite');
		$topCommanders = $this->rankCommanders($commanderMetrics);
		$topProfiles = $this->rankProfiles($profileMetrics);

		$promoted = 0;
		foreach (array_slice($topCommanders, 0, 4) as $commander) {
			$commanderId = (int) $commander['scope_reference'];
			if ($commanderId <= 0) {
				continue;
			}

			$updated = $db->update('UPDATE %%BOT_STATE%% SET
				prestige = LEAST(100, prestige + 2),
				updated_at = :updatedAt
				WHERE bot_user_id = :botUserId;', array(
				':updatedAt' => TIMESTAMP,
				':botUserId' => $commanderId,
			));
			$promoted += (int) $updated;
		}

		$payload = array(
			'generated_at' => TIMESTAMP,
			'commander_prestige_boosts' => $promoted,
			'profile_focus' => array_slice($topProfiles, 0, 8),
			'command_focus' => array_slice($topCommanders, 0, 8),
			'engine_directives' => array(
				'prefer_visible_profiles' => array_slice(array_column($topProfiles, 'scope_reference'), 0, 3),
				'prefer_commanders' => array_slice(array_column($topCommanders, 'scope_reference'), 0, 3),
				'long_cycle_hours' => 6,
			),
		);

		$this->persistState('long_state_json', $payload, 'long_cycle_at');

		return $payload;
	}

	public function getCurrentStrategy()
	{
		$row = Database::get()->selectSingle('SELECT *
			FROM %%BOT_GLOBAL_STRATEGY%%
			WHERE universe = :universe
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
			));

		if (empty($row)) {
			return array();
		}

		$row['strategic_state'] = $this->decodeJson(isset($row['strategic_state_json']) ? $row['strategic_state_json'] : null);
		$row['long_state'] = $this->decodeJson(isset($row['long_state_json']) ? $row['long_state_json'] : null);
		return $row;
	}

	protected function persistState($column, array $payload, $cycleColumn)
	{
		$db = Database::get();
		$exists = $db->selectSingle('SELECT universe FROM %%BOT_GLOBAL_STRATEGY%% WHERE universe = :universe LIMIT 1;', array(
			':universe' => Universe::getEmulated(),
		));

		if (empty($exists)) {
			$db->insert('INSERT INTO %%BOT_GLOBAL_STRATEGY%% SET
				universe = :universe,
				'.$column.' = :payloadJson,
				'.$cycleColumn.' = :cycleAt,
				updated_at = :updatedAt;', array(
				':universe' => Universe::getEmulated(),
				':payloadJson' => json_encode($payload),
				':cycleAt' => TIMESTAMP,
				':updatedAt' => TIMESTAMP,
			));
			return;
		}

		$db->update('UPDATE %%BOT_GLOBAL_STRATEGY%% SET
			'.$column.' = :payloadJson,
			'.$cycleColumn.' = :cycleAt,
			updated_at = :updatedAt
			WHERE universe = :universe;', array(
			':payloadJson' => json_encode($payload),
			':cycleAt' => TIMESTAMP,
			':updatedAt' => TIMESTAMP,
			':universe' => Universe::getEmulated(),
		));
	}

	protected function normalizeZones(array $zones, $type)
	{
		$result = array();
		foreach ($zones as $zone) {
			$result[] = array(
				'type' => $type,
				'zone_reference' => $zone['zone_reference'],
				'pressure_need' => (int) $zone['pressure_need'],
				'coverage_need' => (int) $zone['coverage_need'],
				'dissuasion_need' => (int) $zone['dissuasion_need'],
				'strategic_importance' => (int) $zone['strategic_importance'],
				'bot_presence' => (int) $zone['bot_presence'],
				'campaign_count' => (int) $zone['campaign_count'],
			);
		}

		return $result;
	}

	protected function rankProfiles(array $metrics)
	{
		usort($metrics, function($left, $right) {
			return ((float) $right['score_value'] <=> (float) $left['score_value']);
		});

		return array_values($metrics);
	}

	protected function rankCommanders(array $metrics)
	{
		usort($metrics, function($left, $right) {
			return ((float) $right['score_value'] <=> (float) $left['score_value']);
		});

		return array_values($metrics);
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
