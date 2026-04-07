<?php

class BotInferenceService
{
	public function inferTargets(array $bot, array $planet, array $targets, array $memory, array $relationships)
	{
		$relationshipIndex = $this->indexRelationships($relationships);
		$memorySignals = $this->extractMemorySignals($memory);
		$inferred = array();

		foreach ($targets as $target) {
			$targetUserId = (int) $target['id_owner'];
			$relationship = isset($relationshipIndex['player:'.$targetUserId]) ? $relationshipIndex['player:'.$targetUserId] : array();
			$memorySignal = isset($memorySignals[$targetUserId]) ? $memorySignals[$targetUserId] : array();
			$distance = abs((int) $planet['system'] - (int) $target['system']);
			$richesse = min(100, (int) round((((float) $target['metal'] + (float) $target['crystal'] + (float) $target['deuterium']) / 30000)));
			$inactivite = min(100, max(0, (int) round((TIMESTAMP - (int) $target['onlinetime']) / 1800)));
			$danger = min(100, (int) round((((float) $target['total_points']) / max(1, (float) $bot['total_points'] ?: 1)) * 40));
			$vulnerabilite = max(0, min(100, $richesse + $inactivite - min(40, $distance * 2)));
			$hostilite = min(100, max(
				isset($relationship['resentment']) ? (int) $relationship['resentment'] : 0,
				isset($memorySignal['hostility']) ? (int) $memorySignal['hostility'] : 0
			));
			$diplomatie = max(
				0,
				100
				- (isset($relationship['fear']) ? (int) $relationship['fear'] : 0)
				- (isset($relationship['resentment']) ? (int) $relationship['resentment'] : 0)
			);
			$psychologique = min(100, (int) round(($inactivite * 0.35) + ($hostilite * 0.30) + ($vulnerabilite * 0.35)));
			$prestige = min(100, max(0, (int) round((((float) $target['total_points']) / 100000) * 12)));
			$revanche = min(100, (int) ($memorySignal['revenge'] ?? 0));
			$territorial = min(100, max(0, 75 - min(60, $distance * 3)));
			$nuisance = min(100, (int) round(($danger * 0.45) + ($hostilite * 0.35) + ($prestige * 0.20)));
			$opportunite = min(100, (int) round(($vulnerabilite * 0.45) + ($richesse * 0.25) + ($territorial * 0.20) + ($revanche * 0.10)));
			$rentabilite = min(100, (int) round(($richesse * 0.55) + ($inactivite * 0.25) + (max(0, 100 - $danger) * 0.20)));
			$pression = min(100, (int) round(($psychologique * 0.45) + ($territorial * 0.20) + ($hostilite * 0.20) + ($revanche * 0.15)));
			$controle = min(100, (int) round(($territorial * 0.45) + ($prestige * 0.20) + ($danger * 0.20) + ($rentabilite * 0.15)));

			$target['threat_score'] = $danger;
			$target['opportunity_score'] = $opportunite;
			$target['nuisance_score'] = $nuisance;
			$target['profitability_score'] = $rentabilite;
			$target['prestige_score'] = $prestige;
			$target['revenge_score'] = $revanche;
			$target['psychological_score'] = $pression;
			$target['territorial_score'] = $controle;
			$target['diplomatic_score'] = $diplomatie;
			$target['target_score'] = round(
				($opportunite * 0.34)
				+ ($rentabilite * 0.18)
				+ ($pression * 0.16)
				+ ($controle * 0.16)
				- ($danger * 0.18),
				2
			);

			$inferred[] = $target;
		}

		usort($inferred, function($left, $right) {
			if ($left['target_score'] === $right['target_score']) {
				return 0;
			}

			return $left['target_score'] > $right['target_score'] ? -1 : 1;
		});

		return $inferred;
	}

	public function buildZoneContext(array $planet, array $inferredTargets, array $incomingHostiles, array $campaigns, $allianceId)
	{
		$db = Database::get();
		$currentZone = (int) $planet['galaxy'].':'.(int) $planet['system'];
		$botPresence = (int) $db->selectSingle('SELECT COUNT(*) AS total
			FROM %%USERS%% u
			INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND p.galaxy = :galaxy
			  AND p.`system` = :system;', array(
				':universe' => Universe::getEmulated(),
				':galaxy' => (int) $planet['galaxy'],
				':system' => (int) $planet['system'],
			), 'total');

		$zones = array();
		foreach ($inferredTargets as $target) {
			$key = $target['galaxy'].':'.$target['system'];
			if (!isset($zones[$key])) {
				$zones[$key] = array(
					'zone_reference' => $key,
					'target_count' => 0,
					'wealth' => 0,
					'hostility' => 0,
					'raid_potential' => 0,
					'strategic_value' => 0,
					'psychological_value' => 0,
				);
			}

			$zones[$key]['target_count']++;
			$zones[$key]['wealth'] += (int) $target['profitability_score'];
			$zones[$key]['hostility'] += (int) $target['threat_score'];
			$zones[$key]['raid_potential'] += (int) $target['opportunity_score'];
			$zones[$key]['strategic_value'] += (int) $target['territorial_score'];
			$zones[$key]['psychological_value'] += (int) $target['psychological_score'];
		}

		foreach ($zones as &$zone) {
			$count = max(1, (int) $zone['target_count']);
			$zone['wealth'] = (int) round($zone['wealth'] / $count);
			$zone['hostility'] = (int) round($zone['hostility'] / $count);
			$zone['raid_potential'] = (int) round($zone['raid_potential'] / $count);
			$zone['strategic_value'] = (int) round($zone['strategic_value'] / $count);
			$zone['psychological_value'] = (int) round($zone['psychological_value'] / $count);
			$zone['campaign_pressure'] = (int) count(array_filter($campaigns, function($campaign) use ($zone) {
				return !empty($campaign['zone_reference']) && $campaign['zone_reference'] === $zone['zone_reference'];
			})) * 20;
		}
		unset($zone);

		$current = isset($zones[$currentZone]) ? $zones[$currentZone] : array(
			'zone_reference' => $currentZone,
			'target_count' => 0,
			'wealth' => 0,
			'hostility' => 0,
			'raid_potential' => 0,
			'strategic_value' => 0,
			'psychological_value' => 0,
			'campaign_pressure' => 0,
		);

		$current['bot_presence'] = $botPresence;
		$current['incoming_hostiles'] = count($incomingHostiles);
		$current['tension_score'] = min(100, (int) round(($current['hostility'] * 0.45) + (count($incomingHostiles) * 14) + ($current['campaign_pressure'] * 0.20)));
		$current['control_score'] = max(0, min(100, (int) round(($botPresence * 11) + ($current['strategic_value'] * 0.25) - ($current['hostility'] * 0.20))));
		$current['profitability_score'] = min(100, (int) round(($current['wealth'] * 0.50) + ($current['raid_potential'] * 0.35) + ($current['psychological_value'] * 0.15)));
		$current['coverage_need'] = min(100, max(0, 70 - ($botPresence * 8) + (int) round($current['hostility'] * 0.20)));
		$current['pressure_need'] = min(100, (int) round(($current['raid_potential'] * 0.45) + ($current['psychological_value'] * 0.20) + ($current['campaign_pressure'] * 0.35)));
		$current['dissuasion_need'] = min(100, (int) round(($current['hostility'] * 0.55) + (count($incomingHostiles) * 10) + (max(0, 50 - $current['control_score']) * 0.35)));
		$current['alliance_anchor'] = (int) $allianceId > 0 ? 1 : 0;

		usort($inferredTargets, function($left, $right) {
			return ($right['territorial_score'] <=> $left['territorial_score']);
		});
		$priorityTargets = array_slice($inferredTargets, 0, 5);

		return array(
			'current_zone' => $current,
			'priority_targets' => $priorityTargets,
			'nearby_zones' => array_values($zones),
		);
	}

	protected function indexRelationships(array $relationships)
	{
		$indexed = array();
		foreach ($relationships as $relationship) {
			$indexed[$relationship['target_type'].':'.$relationship['target_reference']] = $relationship;
		}

		return $indexed;
	}

	protected function extractMemorySignals(array $memory)
	{
		$signals = array();
		foreach ($memory as $entry) {
			$value = array();
			if (!empty($entry['memory_value_json'])) {
				$decoded = json_decode($entry['memory_value_json'], true);
				if (is_array($decoded)) {
					$value = $decoded;
				}
			}

			$targetUserId = !empty($value['target_user_id']) ? (int) $value['target_user_id'] : 0;
			if ($targetUserId <= 0) {
				continue;
			}

			if (!isset($signals[$targetUserId])) {
				$signals[$targetUserId] = array(
					'hostility' => 0,
					'revenge' => 0,
				);
			}

			if (!empty($value['hostility'])) {
				$signals[$targetUserId]['hostility'] = max($signals[$targetUserId]['hostility'], (int) $value['hostility']);
			}

			if (!empty($value['revenge'])) {
				$signals[$targetUserId]['revenge'] = max($signals[$targetUserId]['revenge'], (int) $value['revenge']);
			}
		}

		return $signals;
	}
}
