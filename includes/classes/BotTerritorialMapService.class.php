<?php

class BotTerritorialMapService
{
	public function rebuildMap($limitZones = 400)
	{
		$db = Database::get();
		$universe = Universe::getEmulated();
		$activeSince = TIMESTAMP - 3600;
		$idleSince = TIMESTAMP - 21600;

		$zones = $db->select('SELECT
				p.galaxy,
				p.`system`,
				COUNT(*) AS planet_count,
				SUM(CASE WHEN u.is_bot = 1 THEN 1 ELSE 0 END) AS bot_planets,
				SUM(CASE WHEN u.is_bot = 0 THEN 1 ELSE 0 END) AS player_planets,
				SUM(CASE WHEN u.is_bot = 0 AND u.onlinetime >= :activeSince THEN 1 ELSE 0 END) AS active_players,
				SUM(CASE WHEN u.is_bot = 0 AND u.onlinetime <= :idleSince THEN 1 ELSE 0 END) AS idle_players,
				AVG(COALESCE(up.total_points, 0)) AS average_points,
				AVG(COALESCE(p.metal, 0) + COALESCE(p.crystal, 0) + COALESCE(p.deuterium, 0)) AS average_resources
			FROM %%PLANETS%% p
			INNER JOIN %%USERS%% u ON u.id = p.id_owner
			LEFT JOIN %%USER_POINTS%% up ON up.id_owner = u.id
			WHERE p.universe = :universe
			  AND p.planet_type = 1
			GROUP BY p.galaxy, p.`system`
			ORDER BY p.galaxy ASC, p.`system` ASC
			LIMIT :limitZones;', array(
				':universe' => $universe,
				':activeSince' => $activeSince,
				':idleSince' => $idleSince,
				':limitZones' => max(50, (int) $limitZones),
			));

		$botPresence = $db->select('SELECT
				p.galaxy,
				p.`system`,
				COUNT(*) AS online_bots
			FROM %%BOT_STATE%% bs
			INNER JOIN %%USERS%% u ON u.id = bs.bot_user_id
			INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
			WHERE bs.universe = :universe
			  AND bs.presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\')
			GROUP BY p.galaxy, p.`system`;', array(
				':universe' => $universe,
			));

		$campaignRows = $db->select('SELECT zone_reference, COUNT(*) AS total, SUM(intensity) AS intensity_total
			FROM %%BOT_CAMPAIGNS%%
			WHERE universe = :universe
			  AND status = \'active\'
			GROUP BY zone_reference;', array(
				':universe' => $universe,
			));

		$presenceIndex = array();
		foreach ($botPresence as $row) {
			$presenceIndex[$row['galaxy'].':'.$row['system']] = (int) $row['online_bots'];
		}

		$campaignIndex = array();
		foreach ($campaignRows as $row) {
			if (trim((string) $row['zone_reference']) === '') {
				continue;
			}

			$campaignIndex[$row['zone_reference']] = array(
				'total' => (int) $row['total'],
				'intensity_total' => (int) $row['intensity_total'],
			);
		}

		$db->delete('DELETE FROM %%BOT_TERRITORIAL_ZONES%% WHERE universe = :universe;', array(
			':universe' => $universe,
		));

		$count = 0;
		foreach ($zones as $zone) {
			$zoneReference = $zone['galaxy'].':'.$zone['system'];
			$botOnline = isset($presenceIndex[$zoneReference]) ? (int) $presenceIndex[$zoneReference] : 0;
			$campaignCount = isset($campaignIndex[$zoneReference]['total']) ? (int) $campaignIndex[$zoneReference]['total'] : 0;
			$campaignIntensity = isset($campaignIndex[$zoneReference]['intensity_total']) ? (int) $campaignIndex[$zoneReference]['intensity_total'] : 0;
			$activityDensity = $this->clamp(
				((int) $zone['player_planets'] * 6)
				+ ((int) $zone['active_players'] * 10)
				+ ((int) $zone['idle_players'] * 2)
			);
			$richness = $this->clamp((int) round(((float) $zone['average_resources']) / 50000));
			$hostility = $this->clamp((int) round(min(40, ((float) $zone['average_points']) / 10000) + ((int) $zone['active_players'] * 8) + ($campaignIntensity * 0.15)));
			$raidPotential = $this->clamp((int) round(($richness * 0.35) + ((int) $zone['idle_players'] * 12) + max(0, 40 - ((int) $zone['active_players'] * 4)) + ($campaignIntensity * 0.10)));
			$expansionInterest = $this->clamp((int) round(max(0, 60 - ((int) $zone['planet_count'] * 2)) + max(0, 40 - (((int) $zone['bot_planets'] + $botOnline) * 8)) + ($richness * 0.15)));
			$strategicImportance = $this->clamp((int) round(($activityDensity * 0.25) + ($richness * 0.15) + ($hostility * 0.20) + ($raidPotential * 0.20) + ($campaignIntensity * 0.20)));
			$coverageNeed = $this->clamp((int) round($strategicImportance + ($campaignIntensity * 0.25) - ($botOnline * 10)));
			$pressureNeed = $this->clamp((int) round(($raidPotential * 0.40) + ($richness * 0.15) + ($campaignIntensity * 0.25) + (max(0, 50 - ($botOnline * 8)) * 0.20)));
			$dissuasionNeed = $this->clamp((int) round(($hostility * 0.50) + ($activityDensity * 0.15) + (max(0, 50 - ($botOnline * 8)) * 0.35)));
			$controlScore = $this->clamp((int) round(($botOnline * 12) + ($campaignIntensity * 0.15) - ($hostility * 0.25) + ($strategicImportance * 0.15)));
			$profitabilityScore = $this->clamp((int) round(($richness * 0.55) + ($raidPotential * 0.30) + ((int) $zone['idle_players'] * 4)));
			$tensionScore = $this->clamp((int) round(($hostility * 0.55) + ($campaignIntensity * 0.20) + ($activityDensity * 0.25)));
			$payload = array(
				'planet_count' => (int) $zone['planet_count'],
				'player_planets' => (int) $zone['player_planets'],
				'bot_planets' => (int) $zone['bot_planets'],
				'active_players' => (int) $zone['active_players'],
				'idle_players' => (int) $zone['idle_players'],
				'average_points' => (int) round((float) $zone['average_points']),
				'average_resources' => (int) round((float) $zone['average_resources']),
			);

			$db->insert('INSERT INTO %%BOT_TERRITORIAL_ZONES%% SET
				universe = :universe,
				zone_reference = :zoneReference,
				galaxy = :galaxy,
				`system` = :system,
				activity_density = :activityDensity,
				richness_score = :richnessScore,
				hostility_score = :hostilityScore,
				raid_potential = :raidPotential,
				expansion_interest = :expansionInterest,
				strategic_importance = :strategicImportance,
				bot_presence = :botPresence,
				campaign_count = :campaignCount,
				coverage_need = :coverageNeed,
				pressure_need = :pressureNeed,
				dissuasion_need = :dissuasionNeed,
				tension_score = :tensionScore,
				control_score = :controlScore,
				profitability_score = :profitabilityScore,
				tension_state = :tensionState,
				control_state = :controlState,
				rentability_state = :rentabilityState,
				social_visibility_state = :socialVisibilityState,
				campaign_state = :campaignState,
				payload_json = :payloadJson,
				updated_at = :updatedAt;', array(
				':universe' => $universe,
				':zoneReference' => $zoneReference,
				':galaxy' => (int) $zone['galaxy'],
				':system' => (int) $zone['system'],
				':activityDensity' => $activityDensity,
				':richnessScore' => $richness,
				':hostilityScore' => $hostility,
				':raidPotential' => $raidPotential,
				':expansionInterest' => $expansionInterest,
				':strategicImportance' => $strategicImportance,
				':botPresence' => $botOnline,
				':campaignCount' => $campaignCount,
				':coverageNeed' => $coverageNeed,
				':pressureNeed' => $pressureNeed,
				':dissuasionNeed' => $dissuasionNeed,
				':tensionScore' => $tensionScore,
				':controlScore' => $controlScore,
				':profitabilityScore' => $profitabilityScore,
				':tensionState' => $this->labelState($tensionScore),
				':controlState' => $this->labelState($controlScore),
				':rentabilityState' => $this->labelState($profitabilityScore),
				':socialVisibilityState' => $this->labelVisibilityState($activityDensity, $botOnline, $campaignCount),
				':campaignState' => $campaignCount > 0 ? 'active' : 'idle',
				':payloadJson' => json_encode($payload),
				':updatedAt' => TIMESTAMP,
			));
			$count++;
		}

		return array(
			'updated_zones' => $count,
		);
	}

	public function getZone($zoneReference)
	{
		$row = Database::get()->selectSingle('SELECT *
			FROM %%BOT_TERRITORIAL_ZONES%%
			WHERE universe = :universe
			  AND zone_reference = :zoneReference
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':zoneReference' => (string) $zoneReference,
			));

		return $this->decodePayload($row);
	}

	public function getPriorityZones($field, $limit = 6)
	{
		$allowed = array(
			'pressure_need',
			'coverage_need',
			'dissuasion_need',
			'strategic_importance',
			'profitability_score',
			'tension_score',
		);
		$field = in_array($field, $allowed, true) ? $field : 'strategic_importance';
		$rows = Database::get()->select('SELECT *
			FROM %%BOT_TERRITORIAL_ZONES%%
			WHERE universe = :universe
			ORDER BY '.$field.' DESC, updated_at DESC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':limit' => max(1, (int) $limit),
			));

		foreach ($rows as &$row) {
			$row = $this->decodePayload($row);
		}
		unset($row);

		return $rows;
	}

	protected function decodePayload($row)
	{
		if (empty($row)) {
			return array();
		}

		$row['payload'] = array();
		if (!empty($row['payload_json'])) {
			$decoded = json_decode($row['payload_json'], true);
			if (is_array($decoded)) {
				$row['payload'] = $decoded;
			}
		}

		return $row;
	}

	protected function clamp($value)
	{
		return max(0, min(100, (int) round($value)));
	}

	protected function labelState($score)
	{
		if ($score >= 75) {
			return 'fort';
		}
		if ($score >= 45) {
			return 'moyen';
		}
		return 'faible';
	}

	protected function labelVisibilityState($activityDensity, $botPresence, $campaignCount)
	{
		if ($campaignCount > 0 || $botPresence >= 4) {
			return 'forte';
		}
		if ($activityDensity >= 45 || $botPresence >= 2) {
			return 'moyenne';
		}
		return 'faible';
	}
}
