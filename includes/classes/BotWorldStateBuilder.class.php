<?php

class BotWorldStateBuilder
{
	public function build($botUserId)
	{
		$db = Database::get();
		$bot = $db->selectSingle('SELECT u.*, p.*
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
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

		$incomingHostiles = $db->select('SELECT *
			FROM %%FLEETS%%
			WHERE fleet_universe = :universe
			  AND fleet_target_owner = :botUserId
			  AND fleet_owner <> :botUserId
			  AND fleet_mission IN (1, 6, 9, 10)
			  AND fleet_start_time >= :now
			ORDER BY fleet_start_time ASC
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
		$bestTarget = $this->findBestTarget($nearbyTargets, $bot, $planet);
		$currentCampaign = array();
		if (!empty($state['current_campaign_id'])) {
			$currentCampaign = $db->selectSingle('SELECT *
				FROM %%BOT_CAMPAIGNS%%
				WHERE id = :campaignId
				LIMIT 1;', array(
					':campaignId' => (int) $state['current_campaign_id'],
				));
		}

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
			'best_target' => $bestTarget,
			'incoming_hostiles' => $incomingHostiles,
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

	protected function findBestTarget(array $targets, array $bot, array $planet)
	{
		$best = array();
		$bestScore = -1;

		foreach ($targets as $target) {
			$loot = ((float) $target['metal'] + (float) $target['crystal'] + (float) $target['deuterium']) / 10000;
			$inactivity = max(0, (TIMESTAMP - (int) $target['onlinetime']) / 3600);
			$distance = abs((int) $planet['system'] - (int) $target['system']);
			$pointsPenalty = min(60, ((float) $target['total_points']) / 50000);
			$score = ($loot * 8) + min(30, $inactivity) - min(18, $distance) - $pointsPenalty;

			if ((int) $bot['ally_id'] > 0 && (int) $bot['ally_id'] === (int) $target['ally_id']) {
				$score -= 100;
			}

			if ($score > $bestScore) {
				$bestScore = $score;
				$best = $target;
				$best['target_score'] = round($score, 2);
			}
		}

		return $best;
	}

	protected function countQueueEntries($serializedQueue)
	{
		if (empty($serializedQueue)) {
			return 0;
		}

		$queue = @unserialize($serializedQueue);
		return is_array($queue) ? count($queue) : 0;
	}
}
