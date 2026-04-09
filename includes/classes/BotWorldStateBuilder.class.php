<?php

class BotWorldStateBuilder
{
	public function build($botUserId)
	{
		require_once ROOT_PATH.'includes/classes/BotInferenceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotGlobalStrategyService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTerritorialMapService.class.php';
		require_once ROOT_PATH.'includes/classes/BotLearningService.class.php';
		$db = Database::get();
		$inferenceService = new BotInferenceService();
		$globalStrategyService = new BotGlobalStrategyService();
		$territorialMapService = new BotTerritorialMapService();
		$learningService = new BotLearningService();
		$bot = $db->selectSingle('SELECT u.*, p.*, COALESCE(up.total_points, 0) AS total_points
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%USER_POINTS%% up ON up.id_owner = u.id AND up.universe = u.universe
			WHERE u.id = :userId AND u.is_bot = 1
			LIMIT 1;', array(
				':userId' => (int) $botUserId,
			));

		if (empty($bot)) {
			return array();
		}

		$planet = $db->selectSingle('SELECT *
			FROM %%PLANETS%%
			WHERE id = :planetId
			LIMIT 1;', array(
				':planetId' => (int) $bot['id_planet'],
			));

		if (empty($planet)) {
			$planet = $db->selectSingle('SELECT *
				FROM %%PLANETS%%
				WHERE id_owner = :userId AND planet_type = 1
				ORDER BY id ASC
				LIMIT 1;', array(
					':userId' => (int) $botUserId,
				));
		}

		if (empty($planet)) {
			return array();
		}

		$bot['factor'] = getFactors($bot);
		$state = Database::get()->selectSingle('SELECT *
			FROM %%BOT_STATE%%
			WHERE bot_user_id = :userId
			LIMIT 1;', array(
				':userId' => (int) $botUserId,
			));

		$traits = Database::get()->selectSingle('SELECT *
			FROM %%BOT_TRAITS%%
			WHERE bot_user_id = :userId
			LIMIT 1;', array(
				':userId' => (int) $botUserId,
			));

		$dynamic = Database::get()->selectSingle('SELECT *
			FROM %%BOT_DYNAMIC_STATE%%
			WHERE bot_user_id = :userId
			LIMIT 1;', array(
				':userId' => (int) $botUserId,
			));

		$memory = $db->select('SELECT *
			FROM %%BOT_MEMORY%%
			WHERE bot_user_id = :botUserId
			  AND (expires_at IS NULL OR expires_at >= :now)
			ORDER BY intensity DESC, updated_at DESC
			LIMIT 25;', array(
				':botUserId' => (int) $botUserId,
				':now' => TIMESTAMP,
			));

		$relationships = $db->select('SELECT *
			FROM %%BOT_RELATIONSHIPS%%
			WHERE bot_user_id = :botUserId
			ORDER BY updated_at DESC
			LIMIT 25;', array(
				':botUserId' => (int) $botUserId,
			));

		$commands = $db->select('SELECT *
			FROM %%BOT_COMMANDS%%
			WHERE universe = :universe
			  AND status IN (\'pending\', \'parsed\', \'queued\')
			  AND (
				target_bot_user_id = :botUserId
				OR (target_type = \'all\' AND target_reference = \'all\')
			  )
			ORDER BY priority DESC, id ASC
			LIMIT 12;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
			));

		$activeCampaigns = $db->select('SELECT c.*
			FROM %%BOT_CAMPAIGNS%% c
			LEFT JOIN %%BOT_CAMPAIGN_MEMBERS%% m ON m.campaign_id = c.id AND m.bot_user_id = :botUserId
			WHERE c.universe = :universe
			  AND c.status = \'active\'
			  AND (
				c.responsible_bot_user_id = :botUserId
				OR m.bot_user_id = :botUserId
				OR (c.responsible_alliance_meta_id IS NOT NULL AND c.responsible_alliance_meta_id = (
					SELECT bam.id FROM %%BOT_ALLIANCE_META%% bam WHERE bam.alliance_id = :allyId LIMIT 1
				))
				  )
				ORDER BY c.updated_at DESC
				LIMIT 8;', array(
					':universe' => Universe::getEmulated(),
					':botUserId' => (int) $botUserId,
					':allyId' => (int) $bot['ally_id'],
				));

		$allianceMeta = array();
		if (!empty($bot['ally_id'])) {
			$allianceMeta = $db->selectSingle('SELECT *
				FROM %%BOT_ALLIANCE_META%%
				WHERE alliance_id = :allianceId
				LIMIT 1;', array(
					':allianceId' => (int) $bot['ally_id'],
				));
		}

		$hierarchy = array(
			'commander' => array(),
			'subordinates' => array(),
		);
		if (!empty($state['commander_bot_user_id'])) {
			$hierarchy['commander'] = $db->selectSingle('SELECT u.id, u.username, bs.current_target_json
				FROM %%USERS%% u
				LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
				WHERE u.id = :commanderBotUserId
				LIMIT 1;', array(
					':commanderBotUserId' => (int) $state['commander_bot_user_id'],
				));
		}

		if (!empty($state['hierarchy_status']) && $state['hierarchy_status'] === 'chef') {
			$hierarchy['subordinates'] = $db->select('SELECT u.id, u.username
				FROM %%USERS%% u
				INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
				WHERE bs.commander_bot_user_id = :botUserId
				ORDER BY u.username ASC
				LIMIT 24;', array(
					':botUserId' => (int) $botUserId,
				));
		}

		$currentTarget = $this->decodeTargetJson(isset($state['current_target_json']) ? $state['current_target_json'] : null);
		if (!empty($hierarchy['commander']['current_target_json'])) {
			$hierarchy['commander']['current_target'] = $this->decodeTargetJson($hierarchy['commander']['current_target_json']);
		}

		$nearbyTargets = $db->select('SELECT p.id, p.id_owner, p.galaxy, p.`system`, p.planet, p.name,
					p.metal, p.crystal, p.deuterium, p.small_ship_cargo, p.big_ship_cargo, p.light_hunter,
				u.username, u.ally_id, u.onlinetime,
				up.total_points
			FROM %%PLANETS%% p
			INNER JOIN %%USERS%% u ON u.id = p.id_owner
			LEFT JOIN %%USER_POINTS%% up ON up.id_owner = u.id
			WHERE p.universe = :universe
			  AND p.planet_type = 1
			  AND p.id_owner <> :botUserId
			  AND p.galaxy = :galaxy
			  AND ABS(p.`system` - :system) <= 20
			ORDER BY ABS(p.`system` - :system) ASC, u.onlinetime ASC
			LIMIT 25;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':galaxy' => (int) $planet['galaxy'],
				':system' => (int) $planet['system'],
			));

		$incomingHostiles = $db->select('SELECT f.*,
				u.username AS owner_username,
				u.ally_id AS owner_ally_id,
				COALESCE(up.total_points, 0) AS owner_total_points
			FROM %%FLEETS%% f
			LEFT JOIN %%USERS%% u ON u.id = f.fleet_owner
			LEFT JOIN %%USER_POINTS%% up ON up.id_owner = u.id AND up.universe = f.fleet_universe
			WHERE f.fleet_universe = :universe
			  AND f.fleet_target_owner = :botUserId
			  AND f.fleet_owner <> :botUserId
			  AND f.fleet_mission IN (1, 6, 9, 10)
			  AND f.fleet_mess = 0
			  AND f.hasCanceled = 0
			  AND f.fleet_end_time >= :now
			ORDER BY f.fleet_end_time ASC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':now' => TIMESTAMP,
			));

		$ownFleets = $db->select('SELECT *
			FROM %%FLEETS%%
			WHERE fleet_universe = :universe
			  AND fleet_owner = :botUserId
			  AND fleet_start_time >= :now
			ORDER BY fleet_start_time ASC
			LIMIT 20;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':now' => TIMESTAMP,
			));

		$botPlanets = $db->select('SELECT id, galaxy, `system`, planet, name
			FROM %%PLANETS%%
			WHERE id_owner = :botUserId AND planet_type = 1
			ORDER BY galaxy ASC, `system` ASC, planet ASC;', array(
				':botUserId' => (int) $botUserId,
			));

		$freeFieldsRatio = empty($planet['field_max']) ? 0 : max(0, min(1, ($planet['field_max'] - $planet['field_current']) / max(1, $planet['field_max'])));
		$resourceLoad = $this->computeResourceLoad($planet);
		$currentCampaign = array();
		if (!empty($state['current_campaign_id'])) {
			$currentCampaign = $db->selectSingle('SELECT *
				FROM %%BOT_CAMPAIGNS%%
				WHERE id = :campaignId
				LIMIT 1;', array(
					':campaignId' => (int) $state['current_campaign_id'],
				));
		}
		$inferredTargets = $inferenceService->inferTargets($bot, $planet, $nearbyTargets, $memory, $relationships);
		$bestTarget = !empty($inferredTargets[0]) ? $inferredTargets[0] : array();
		$currentTargetFocus = $this->resolveTargetFocus($currentTarget, $inferredTargets, $nearbyTargets);
		$commanderTargetFocus = $this->resolveTargetFocus(
			!empty($hierarchy['commander']['current_target']) ? $hierarchy['commander']['current_target'] : array(),
			$inferredTargets,
			$nearbyTargets
		);
		$hostileContext = $this->buildHostileContext($incomingHostiles, $planet);
		$allianceAlert = $this->buildAllianceAlert((int) $botUserId, isset($bot['ally_id']) ? (int) $bot['ally_id'] : 0, $planet);
		$zoneContext = $inferenceService->buildZoneContext(
			$planet,
			$inferredTargets,
			$incomingHostiles,
			$activeCampaigns,
			isset($bot['ally_id']) ? (int) $bot['ally_id'] : 0
		);
		$territorialZone = $territorialMapService->getZone($planet['galaxy'].':'.$planet['system']);
		$globalStrategy = $globalStrategyService->getCurrentStrategy();
		$learning = $learningService->getSnapshotInsights((int) $botUserId, $bot, empty($state) ? array() : $state, $bestTarget, $zoneContext['current_zone']);

		return array(
			'bot' => $bot,
			'planet' => $planet,
			'state' => empty($state) ? array() : $state,
			'traits' => empty($traits) ? array() : $traits,
			'dynamic' => empty($dynamic) ? array() : $dynamic,
			'memory' => $memory,
			'relationships' => $relationships,
			'commands' => $commands,
			'campaigns' => $activeCampaigns,
			'current_campaign' => $currentCampaign,
			'alliance_meta' => empty($allianceMeta) ? array() : $allianceMeta,
			'hierarchy' => $hierarchy,
			'nearby_targets' => $nearbyTargets,
			'inferred_targets' => $inferredTargets,
			'best_target' => $bestTarget,
			'zone_context' => $zoneContext,
			'territorial_zone' => $territorialZone,
			'global_strategy' => $globalStrategy,
			'learning' => $learning,
			'incoming_hostiles' => $incomingHostiles,
			'hostile_context' => $hostileContext,
			'alliance_alert' => $allianceAlert,
			'current_target' => $currentTarget,
			'current_target_focus' => $currentTargetFocus,
			'commander_target_focus' => $commanderTargetFocus,
			'own_fleets' => $ownFleets,
			'planet_count' => count($botPlanets),
			'bot_planets' => $botPlanets,
			'free_fields_ratio' => $freeFieldsRatio,
			'resource_load' => $resourceLoad,
			'queue_state' => array(
				'building' => $this->countQueueEntries(isset($planet['b_building_id']) ? $planet['b_building_id'] : null),
				'shipyard' => $this->countQueueEntries(isset($planet['b_hangar_id']) ? $planet['b_hangar_id'] : null),
				'research' => $this->countQueueEntries(isset($bot['b_tech_queue']) ? $bot['b_tech_queue'] : null),
			),
		);
	}

	protected function computeResourceLoad(array $planet)
	{
		$ratios = array();
		foreach (array('metal', 'crystal', 'deuterium') as $resourceKey) {
			$maxKey = $resourceKey.'_max';
			$ratios[$resourceKey] = empty($planet[$maxKey]) ? 0 : round(min(1, max(0, $planet[$resourceKey] / max(1, $planet[$maxKey]))), 4);
		}

		return $ratios;
	}

	protected function countQueueEntries($serializedQueue)
	{
		if (empty($serializedQueue)) {
			return 0;
		}

		$queue = @unserialize($serializedQueue);
		return is_array($queue) ? count($queue) : 0;
	}

	protected function decodeTargetJson($json)
	{
		if (empty($json)) {
			return array();
		}

		$decoded = json_decode($json, true);
		if (!is_array($decoded)) {
			return array();
		}

		if (!$this->isFreshTarget($decoded)) {
			return array();
		}

		return $decoded;
	}

	protected function resolveTargetFocus(array $target, array $inferredTargets, array $nearbyTargets)
	{
		if (empty($target)) {
			return array();
		}

		$reference = !empty($target['reference']) ? trim((string) $target['reference']) : '';
		$coordinates = !empty($target['target_coordinates']) ? trim((string) $target['target_coordinates']) : '';
		$zoneReference = '';
		if ($coordinates === '' && preg_match('/^\d+:\d+:\d+$/', $reference)) {
			$coordinates = $reference;
		}
		if (preg_match('/^\d+:\d+$/', $reference)) {
			$zoneReference = $reference;
		}

		$candidate = array();
		if ($coordinates !== '') {
			$candidate = $this->findTargetByCoordinates($coordinates, $inferredTargets, $nearbyTargets);
		} elseif ($zoneReference !== '') {
			$candidate = $this->findTargetByZone($zoneReference, $inferredTargets, $nearbyTargets);
		}

		$focus = $target;
		$focus['reference'] = $reference;
		$focus['target_coordinates'] = $coordinates;
		if ($zoneReference !== '') {
			$focus['zone_reference'] = $zoneReference;
		}

		if (!empty($candidate)) {
			$focus['target_coordinates'] = $candidate['galaxy'].':'.$candidate['system'].':'.$candidate['planet'];
			$focus['target_planet_id'] = (int) $candidate['id'];
			$focus['target_user_id'] = (int) $candidate['id_owner'];
			$focus['target_username'] = isset($candidate['username']) ? $candidate['username'] : '';
			$focus['zone_reference'] = $candidate['galaxy'].':'.$candidate['system'];
		}

		return $focus;
	}

	protected function findTargetByCoordinates($coordinates, array $inferredTargets, array $nearbyTargets)
	{
		foreach (array_merge($inferredTargets, $nearbyTargets) as $target) {
			$targetCoordinates = $target['galaxy'].':'.$target['system'].':'.$target['planet'];
			if ($targetCoordinates === $coordinates) {
				return $target;
			}
		}

		if (!preg_match('/^(\d+):(\d+):(\d+)$/', $coordinates, $matches)) {
			return array();
		}

		return Database::get()->selectSingle('SELECT p.id, p.id_owner, p.galaxy, p.`system`, p.planet, p.name, u.username
			FROM %%PLANETS%% p
			LEFT JOIN %%USERS%% u ON u.id = p.id_owner
			WHERE p.universe = :universe
			  AND p.galaxy = :galaxy
			  AND p.`system` = :system
			  AND p.planet = :planet
			  AND p.planet_type = 1
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':galaxy' => (int) $matches[1],
				':system' => (int) $matches[2],
				':planet' => (int) $matches[3],
			));
	}

	protected function findTargetByZone($zoneReference, array $inferredTargets, array $nearbyTargets)
	{
		foreach ($inferredTargets as $target) {
			if ($target['galaxy'].':'.$target['system'] === $zoneReference) {
				return $target;
			}
		}

		foreach ($nearbyTargets as $target) {
			if ($target['galaxy'].':'.$target['system'] === $zoneReference) {
				return $target;
			}
		}

		return array();
	}

	protected function buildHostileContext(array $incomingHostiles, array $planet)
	{
		$context = array(
			'pressure_score' => 0,
			'incoming_count' => count($incomingHostiles),
			'attack_count' => 0,
			'spy_count' => 0,
			'destruction_count' => 0,
			'transport_count' => 0,
			'hostile_players' => 0,
			'primary_hostile' => array(),
			'retaliation_target' => array(),
		);
		if (empty($incomingHostiles)) {
			return $context;
		}

		$owners = array();
		$primaryHostile = array();
		$primaryWeight = -1;
		$imminentCount = 0;

		foreach ($incomingHostiles as $hostile) {
			$ownerId = isset($hostile['fleet_owner']) ? (int) $hostile['fleet_owner'] : 0;
			if ($ownerId > 0) {
				$owners[$ownerId] = true;
			}

			$mission = isset($hostile['fleet_mission']) ? (int) $hostile['fleet_mission'] : 0;
			if ($mission === 6) {
				$context['spy_count']++;
			} elseif ($mission === 9) {
				$context['destruction_count']++;
			} elseif ($mission === 10) {
				$context['transport_count']++;
			} else {
				$context['attack_count']++;
			}

			$eta = max(0, (int) $hostile['fleet_end_time'] - TIMESTAMP);
			if ($eta <= 900) {
				$imminentCount++;
			}

			$missionWeight = 40;
			if ($mission === 9) {
				$missionWeight = 100;
			} elseif ($mission === 1) {
				$missionWeight = 85;
			} elseif ($mission === 6) {
				$missionWeight = 60;
			} elseif ($mission === 10) {
				$missionWeight = 45;
			}

			$distance = abs((int) $hostile['fleet_start_galaxy'] - (int) $planet['galaxy']) * 200
				+ abs((int) $hostile['fleet_start_system'] - (int) $planet['system']) * 5
				+ abs((int) $hostile['fleet_start_planet'] - (int) $planet['planet']);
			$threatWeight = $missionWeight
				+ min(14, (int) round((float) $hostile['owner_total_points'] / 100000))
				+ max(0, 12 - min(12, (int) floor($eta / 300)))
				+ max(0, 8 - min(8, $distance));

			if ($threatWeight > $primaryWeight) {
				$primaryWeight = $threatWeight;
				$primaryHostile = array(
					'mission' => $mission,
					'owner_id' => $ownerId,
					'owner_username' => isset($hostile['owner_username']) ? $hostile['owner_username'] : '',
					'owner_total_points' => isset($hostile['owner_total_points']) ? (float) $hostile['owner_total_points'] : 0,
					'coordinates' => $hostile['fleet_start_galaxy'].':'.$hostile['fleet_start_system'].':'.$hostile['fleet_start_planet'],
					'arrival_coordinates' => $hostile['fleet_end_galaxy'].':'.$hostile['fleet_end_system'].':'.$hostile['fleet_end_planet'],
					'eta' => $eta,
					'threat_weight' => $threatWeight,
				);
			}
		}

		$context['hostile_players'] = count($owners);
		$context['pressure_score'] = min(
			100,
			($context['attack_count'] * 26)
			+ ($context['spy_count'] * 18)
			+ ($context['destruction_count'] * 30)
			+ ($context['transport_count'] * 10)
			+ (count($owners) * 8)
			+ ($imminentCount * 10)
		);
		$context['primary_hostile'] = $primaryHostile;

		if (!empty($primaryHostile['coordinates'])) {
			$zoneReference = '';
			if (preg_match('/^(\d+:\d+):\d+$/', $primaryHostile['coordinates'], $matches)) {
				$zoneReference = $matches[1];
			}

			$context['retaliation_target'] = array(
				'type' => 'coordonnees',
				'reference' => $primaryHostile['coordinates'],
				'target_coordinates' => $primaryHostile['coordinates'],
				'target_user_id' => !empty($primaryHostile['owner_id']) ? (int) $primaryHostile['owner_id'] : 0,
				'target_username' => !empty($primaryHostile['owner_username']) ? $primaryHostile['owner_username'] : '',
				'zone_reference' => $zoneReference,
				'threat_weight' => $primaryWeight,
			);
		}

		return $context;
	}

	protected function buildAllianceAlert($botUserId, $allianceId, array $planet)
	{
		$alert = array(
			'pressure_score' => 0,
			'threatened_allies' => 0,
			'primary_ally' => array(),
			'nearby_threatened' => 0,
		);
		if ($allianceId <= 0) {
			return $alert;
		}

		$rows = Database::get()->select('SELECT u.id, u.username, p.galaxy, p.`system`, p.planet,
				COALESCE(hf.hostile_count, 0) AS hostile_count,
				COALESCE(hf.spy_count, 0) AS spy_count,
				COALESCE(hf.attack_count, 0) AS attack_count,
				COALESCE(hf.next_eta, 0) AS next_eta
			FROM %%USERS%% u
			INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
			LEFT JOIN (
				SELECT fleet_target_owner AS bot_user_id,
					COUNT(*) AS hostile_count,
					SUM(CASE WHEN fleet_mission = 6 THEN 1 ELSE 0 END) AS spy_count,
					SUM(CASE WHEN fleet_mission IN (1, 9) THEN 1 ELSE 0 END) AS attack_count,
					MIN(fleet_end_time) AS next_eta
				FROM %%FLEETS%%
				WHERE fleet_universe = :universe
				  AND fleet_mess = 0
				  AND hasCanceled = 0
				  AND fleet_end_time >= :now
				  AND fleet_mission IN (1, 6, 9, 10)
				GROUP BY fleet_target_owner
			) hf ON hf.bot_user_id = u.id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND u.ally_id = :allianceId
			  AND u.id <> :botUserId
			  AND COALESCE(hf.hostile_count, 0) > 0
			ORDER BY COALESCE(hf.attack_count, 0) DESC, COALESCE(hf.spy_count, 0) DESC, COALESCE(hf.next_eta, 0) ASC, u.id ASC
			LIMIT 6;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
				':allianceId' => (int) $allianceId,
				':botUserId' => (int) $botUserId,
			));
		if (empty($rows)) {
			return $alert;
		}

		$pressure = 0;
		$nearby = 0;
		$primary = array();
		$primaryWeight = -1;
		foreach ($rows as $row) {
			$distance = abs((int) $row['galaxy'] - (int) $planet['galaxy']) * 200
				+ abs((int) $row['system'] - (int) $planet['system']) * 5
				+ abs((int) $row['planet'] - (int) $planet['planet']);
			if ($distance <= 35) {
				$nearby++;
			}

			$eta = !empty($row['next_eta']) ? max(0, (int) $row['next_eta'] - TIMESTAMP) : 3600;
			$weight = ((int) $row['attack_count'] * 24)
				+ ((int) $row['spy_count'] * 16)
				+ ((int) $row['hostile_count'] * 10)
				+ max(0, 12 - min(12, (int) floor($eta / 300)))
				+ max(0, 8 - min(8, $distance));
			$pressure += $weight;

			if ($weight > $primaryWeight) {
				$primaryWeight = $weight;
				$primary = array(
					'bot_user_id' => (int) $row['id'],
					'username' => (string) $row['username'],
					'coordinates' => $row['galaxy'].':'.$row['system'].':'.$row['planet'],
					'attack_count' => (int) $row['attack_count'],
					'spy_count' => (int) $row['spy_count'],
					'hostile_count' => (int) $row['hostile_count'],
					'eta' => $eta,
					'distance' => $distance,
				);
			}
		}

		$alert['pressure_score'] = min(100, $pressure);
		$alert['threatened_allies'] = count($rows);
		$alert['primary_ally'] = $primary;
		$alert['nearby_threatened'] = $nearby;

		return $alert;
	}

	protected function isFreshTarget(array $target)
	{
		if (empty($target['updated_at'])) {
			return true;
		}

		return (int) $target['updated_at'] >= (TIMESTAMP - 21600);
	}
}
