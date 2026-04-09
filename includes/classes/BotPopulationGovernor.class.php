<?php

class BotPopulationGovernor
{
	protected $presenceService;
	protected $allianceService;
	protected $globalStrategyService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotAllianceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotGlobalStrategyService.class.php';

		$this->presenceService = new BotPresenceService();
		$this->allianceService = new BotAllianceService();
		$this->globalStrategyService = new BotGlobalStrategyService();
	}

	public function computeAndApply(array $config)
	{
		$db = Database::get();
		$strategy = $this->globalStrategyService->getCurrentStrategy();
		$strategicState = !empty($strategy['strategic_state']) ? $strategy['strategic_state'] : array();
		$bots = $db->select('SELECT u.id, u.username, u.bot_profile_id, u.ally_id, p.target_online, p.target_social_online,
				p.always_active, p.is_visible_socially, p.is_commander_profile, p.target_presence_min, p.target_presence_max,
				bs.presence_logical, bs.presence_social, bs.hierarchy_status, bs.paused_until, bs.current_campaign_id, bs.is_online_forced,
				bs.session_started_at, bs.session_target_until, bs.session_rest_until, bs.last_presence_change_at, bs.structural_state_json,
				bs.action_queue_size, bs.cooldown_until,
				ds.fatigue, ds.saturation_logistique, ds.disponibilite_sociale, ds.intensite_campagne, ds.excitation_offensive,
				COALESCE(hf.hostile_count, 0) AS hostile_count, COALESCE(hf.spy_count, 0) AS hostile_spy_count,
				COALESCE(hf.attack_count, 0) AS hostile_attack_count, COALESCE(hf.next_eta, 0) AS hostile_next_eta,
				pl.galaxy, pl.`system`
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN %%BOT_DYNAMIC_STATE%% ds ON ds.bot_user_id = u.id
			LEFT JOIN %%PLANETS%% pl ON pl.id = u.id_planet
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
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY COALESCE(p.always_active, 0) DESC, COALESCE(p.target_online, 0) DESC, COALESCE(bs.last_presence_change_at, 0) ASC, u.id ASC;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
			));

		$targetOnline = $this->computeHourlyTarget($bots, $config);
		$targetSocial = max(0, min((int) $config['target_social_total'], $targetOnline));
		$defaultAlliance = $this->allianceService->ensureDefaultAlliance($config);
		$selected = $this->selectOnlineBots($bots, $targetOnline, $strategicState);
		$selectedOnline = array();
		$selectedSocial = array();
		$relaySoonCount = 0;
		$restingCount = 0;
		$forcedCount = 0;

		foreach ($bots as $bot) {
			$botId = (int) $bot['id'];
			$isSelected = isset($selected[$botId]);
			$isForced = $this->isForcedOnline($bot);
			$shouldBeVisible = $this->shouldBeVisible($bot, count($selectedSocial), $targetSocial);
			$isOnline = $this->isLogicalOnline(isset($bot['presence_logical']) ? $bot['presence_logical'] : 'latent');
			$sessionMeta = array();

			if (!empty($bot['paused_until']) && (int) $bot['paused_until'] > TIMESTAMP) {
				$this->presenceService->applyPresence($botId, 'repos', 'discret', 'pause_administrative', false, array(
					'session_rest_until' => (int) $bot['paused_until'],
				));
				$this->updateStructuralState($botId, $bot, 'reserve_froide', $strategicState, false);
				$restingCount++;
				continue;
			}

			if (!empty($defaultAlliance) && (int) $config['enable_bot_alliances'] === 1 && (int) $bot['ally_id'] === 0) {
				$this->allianceService->assignBotToAlliance($botId, $defaultAlliance['alliance_id']);
			}

				if ($isSelected) {
					if ($this->requiresNewSession($bot)) {
					$duration = $this->computeSessionDurationSeconds($bot, $config);
					$sessionMeta['session_started_at'] = TIMESTAMP;
					$sessionMeta['session_target_until'] = TIMESTAMP + $duration;
					$sessionMeta['session_rest_until'] = null;
				}

					$selectionMeta = $selected[$botId];
					$logical = !empty($selectionMeta['support_alert']) ? 'coordination' : $this->resolveLogicalPresence($bot);
					$social = $shouldBeVisible
						? (!empty($selectionMeta['support_alert']) ? 'visible' : $this->resolveSocialPresence($bot))
						: 'discret';
					$this->presenceService->applyPresence($botId, $logical, $social, 'gouvernance_population', $isForced, $sessionMeta);
					$this->updateStructuralState($botId, $bot, $this->selectedReserveTier($bot, $shouldBeVisible, !empty($selectionMeta['relay_soon'])), $strategicState, true);
					$selectedOnline[] = $botId;
				if ($shouldBeVisible) {
					$selectedSocial[] = $botId;
				}

				if (!$isForced && !empty($selected[$botId]['relay_soon'])) {
					$relaySoonCount++;
				}
				if ($isForced) {
					$forcedCount++;
				}
				continue;
			}

			if ($isOnline) {
				$sessionMeta['session_started_at'] = null;
				$sessionMeta['session_target_until'] = null;
				$sessionMeta['session_rest_until'] = TIMESTAMP + $this->computeRestDurationSeconds($bot, $config);
			}

			if (!empty($bot['session_rest_until']) && (int) $bot['session_rest_until'] > TIMESTAMP) {
				$this->updateStructuralState($botId, $bot, 'reserve_froide', $strategicState, false);
				$restingCount++;
			} else {
				$this->updateStructuralState($botId, $bot, 'reserve_chaude', $strategicState, false);
			}

			$this->presenceService->applyPresence($botId, 'latent', 'discret', 'gouvernance_population', false, $sessionMeta);
		}

		return array(
			'target_online' => $targetOnline,
			'target_social' => $targetSocial,
			'selected_online' => $selectedOnline,
			'selected_social' => $selectedSocial,
			'total_bots' => count($bots),
			'forced_online' => $forcedCount,
			'relay_soon' => $relaySoonCount,
			'resting' => $restingCount,
			'strategic_coverage_zones' => !empty($strategicState['coverage_zones']) ? count($strategicState['coverage_zones']) : 0,
		);
	}

	public function computeTargetPreview(array $config, $totalBots)
	{
		return max(1, min((int) $totalBots, $this->computeConfiguredHourlyTarget((int) $totalBots, $config)));
	}

	protected function computeHourlyTarget(array $bots, array $config)
	{
		if (count($bots) === 0) {
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

		$configuredTarget = $this->computeConfiguredHourlyTarget(count($bots), $config, $multiplier);
		$demandDrivenTarget = $this->computeDemandDrivenTarget($bots, $config, $configuredTarget);

		return max(1, min($configuredTarget, $demandDrivenTarget));
	}

	protected function computeConfiguredHourlyTarget($totalBots, array $config, $multiplier = null)
	{
		if ($multiplier === null) {
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
		}

		return max(1, min((int) $totalBots, (int) round((int) $config['target_online_total'] * $multiplier)));
	}

	protected function computeDemandDrivenTarget(array $bots, array $config, $configuredTarget)
	{
		$supportAssignments = $this->buildSupportAssignments($bots);
		$forcedDemand = 0;
		$readyQueueDemand = 0;
		$continuityDemand = 0;
		$socialProfiles = 0;

		foreach ($bots as $bot) {
			if (!empty($bot['paused_until']) && (int) $bot['paused_until'] > TIMESTAMP) {
				continue;
			}

			$botId = (int) $bot['id'];
			$hasQueue = !empty($bot['action_queue_size']);
			$cooldownReady = empty($bot['cooldown_until']) || (int) $bot['cooldown_until'] <= TIMESTAMP + 900;
			$sessionActive = $this->isLogicalOnline(isset($bot['presence_logical']) ? $bot['presence_logical'] : 'latent')
				&& !empty($bot['session_target_until'])
				&& (int) $bot['session_target_until'] > TIMESTAMP;

			if ($this->isForcedOnline($bot) || isset($supportAssignments[$botId])) {
				$forcedDemand++;
				continue;
			}

			if ($hasQueue && $cooldownReady) {
				$readyQueueDemand++;
			} elseif ($hasQueue && $sessionActive) {
				$continuityDemand++;
			}

			if (!empty($bot['is_visible_socially']) || !empty($bot['target_social_online'])) {
				$socialProfiles++;
			}
		}

		$queueCap = max(
			1,
			(int) $config['max_bots_per_cycle'],
			(int) ceil((int) $config['action_budget_per_cycle'] / max(1, (int) $config['max_actions_per_bot']))
		);
		$idleReserve = max(3, (int) ceil(count($bots) * 0.01));
		$rotationReserve = max(3, min($queueCap, max(4, (int) ceil($queueCap * 0.75))));
		$socialReserve = min((int) $config['target_social_total'], $socialProfiles);
		$readyContribution = min($readyQueueDemand, $queueCap * 2);
		$continuityContribution = min($continuityDemand, $queueCap);

		return max(
			1,
			min(
				(int) $configuredTarget,
				$forcedDemand + $readyContribution + $continuityContribution + $socialReserve + $idleReserve + $rotationReserve
			)
		);
	}

	protected function selectOnlineBots(array $bots, $targetOnline, array $strategicState = array())
	{
		$selected = array();
		$supportAssignments = $this->buildSupportAssignments($bots);
		$continuity = array();
		$rotationReady = array();
		$fallback = array();

		foreach ($bots as $bot) {
			if (!empty($bot['paused_until']) && (int) $bot['paused_until'] > TIMESTAMP) {
				continue;
			}

			$botId = (int) $bot['id'];
			$isForced = $this->isForcedOnline($bot);
			$isOnline = $this->isLogicalOnline(isset($bot['presence_logical']) ? $bot['presence_logical'] : 'latent');
			$sessionActive = !empty($bot['session_target_until']) && (int) $bot['session_target_until'] > TIMESTAMP;
			$restOver = empty($bot['session_rest_until']) || (int) $bot['session_rest_until'] <= TIMESTAMP;
			$hostileWake = !empty($bot['hostile_count']);

			if ($isForced) {
				$selected[$botId] = array('relay_soon' => false, 'support_alert' => false);
				continue;
			}

			if ($hostileWake) {
				$selected[$botId] = array('relay_soon' => false, 'support_alert' => false);
				continue;
			}

			if (isset($supportAssignments[$botId])) {
				$selected[$botId] = array(
					'relay_soon' => false,
					'support_alert' => true,
				);
				continue;
			}

			if ($isOnline && $sessionActive) {
				$bot['presence_score'] = $this->scoreMaintainConnected($bot, $strategicState);
				$continuity[] = $bot;
				continue;
			}

			if ($restOver) {
				$bot['presence_score'] = $this->scoreActivation($bot, $strategicState);
				$rotationReady[] = $bot;
				continue;
			}

			$bot['presence_score'] = $this->scoreActivation($bot, $strategicState) - 12;
			$fallback[] = $bot;
		}

		usort($continuity, array($this, 'sortPresenceScoreDesc'));
		usort($rotationReady, array($this, 'sortPresenceScoreDesc'));
		usort($fallback, array($this, 'sortPresenceScoreDesc'));

		foreach (array($continuity, $rotationReady, $fallback) as $pool) {
			foreach ($pool as $bot) {
				if (count($selected) >= (int) $targetOnline) {
					break 2;
				}

				$botId = (int) $bot['id'];
				if (isset($selected[$botId])) {
					continue;
				}

				$selected[$botId] = array(
					'relay_soon' => !empty($bot['session_target_until']) && (int) $bot['session_target_until'] <= TIMESTAMP + 900,
				);
			}
		}

		return $selected;
	}

	protected function buildSupportAssignments(array $bots)
	{
		$supportAssignments = array();
		$threatened = array();
		foreach ($bots as $bot) {
			if (empty($bot['ally_id']) || empty($bot['hostile_count'])) {
				continue;
			}

			$threatened[] = $bot;
		}

		foreach ($threatened as $targetBot) {
			$selected = 0;
			foreach ($bots as $candidate) {
				if ($selected >= 3) {
					break;
				}

				if ((int) $candidate['id'] === (int) $targetBot['id']) {
					continue;
				}
				if (empty($candidate['ally_id']) || (int) $candidate['ally_id'] !== (int) $targetBot['ally_id']) {
					continue;
				}
				if (!empty($candidate['paused_until']) && (int) $candidate['paused_until'] > TIMESTAMP) {
					continue;
				}
				if (isset($supportAssignments[(int) $candidate['id']])) {
					continue;
				}

				$distance = abs((int) $candidate['galaxy'] - (int) $targetBot['galaxy']) * 200
					+ abs((int) $candidate['system'] - (int) $targetBot['system']);
				if ($distance > 30) {
					continue;
				}

				$supportAssignments[(int) $candidate['id']] = array(
					'target_bot_id' => (int) $targetBot['id'],
				);
				$selected++;
			}
		}

		return $supportAssignments;
	}

	protected function sortPresenceScoreDesc(array $left, array $right)
	{
		$leftScore = isset($left['presence_score']) ? (float) $left['presence_score'] : 0;
		$rightScore = isset($right['presence_score']) ? (float) $right['presence_score'] : 0;
		if ($leftScore === $rightScore) {
			return (int) $left['id'] <=> (int) $right['id'];
		}

		return $leftScore > $rightScore ? -1 : 1;
	}

	protected function scoreMaintainConnected(array $bot, array $strategicState = array())
	{
		$valueActions = min(30, (int) $bot['action_queue_size'] * 8);
		$importance = ($bot['hierarchy_status'] === 'chef' ? 20 : 0) + (!empty($bot['always_active']) ? 8 : 0);
		$social = !empty($bot['is_visible_socially']) ? 10 : 0;
		$urgence = !empty($bot['current_campaign_id']) ? 24 : min(18, (int) round(((int) $bot['intensite_campagne']) / 5));
		$risque = (!empty($bot['current_campaign_id']) || $bot['hierarchy_status'] === 'chef') ? 12 : 0;
		$fatigue = min(28, (int) round(((int) $bot['fatigue']) / 3));
		$cooldown = (!empty($bot['cooldown_until']) && (int) $bot['cooldown_until'] > TIMESTAMP) ? 14 : 0;
		$saturation = min(22, (int) round(((int) $bot['saturation_logistique']) / 4));
		$faibleUtilite = empty($bot['action_queue_size']) && empty($bot['current_campaign_id']) ? 12 : 0;
		$idlePenalty = empty($bot['action_queue_size']) && empty($bot['current_campaign_id']) && empty($bot['hostile_count']) ? 18 : 0;
		$zoneBias = $this->zoneBias($bot, $strategicState, 'coverage_zones') + $this->zoneBias($bot, $strategicState, 'offensive_zones');

		return $valueActions + $importance + $social + $urgence + $risque + $zoneBias - $fatigue - $cooldown - $saturation - $faibleUtilite - $idlePenalty;
	}

	protected function scoreActivation(array $bot, array $strategicState = array())
	{
		$compatibilite = min(20, (int) $bot['target_online']) + ($bot['hierarchy_status'] === 'chef' ? 12 : 0) + (!empty($bot['always_active']) ? 8 : 0);
		$besoinSocial = (!empty($bot['is_visible_socially']) ? 8 : 0) + min(10, (int) round(((int) $bot['disponibilite_sociale']) / 10));
		$campagne = !empty($bot['current_campaign_id']) ? 24 : min(14, (int) round(((int) $bot['intensite_campagne']) / 6));
		$disponibilite = empty($bot['cooldown_until']) || (int) $bot['cooldown_until'] <= TIMESTAMP ? 12 : 0;
		$queueValue = min(18, (int) $bot['action_queue_size'] * 6);
		$redondance = empty($bot['is_commander_profile']) ? 4 : 0;
		$fatigue = min(24, (int) round(((int) $bot['fatigue']) / 3));
		$saturation = min(18, (int) round(((int) $bot['saturation_logistique']) / 5));
		$idlePenalty = empty($bot['action_queue_size']) && empty($bot['current_campaign_id']) && empty($bot['hostile_count']) ? 14 : 0;
		$zoneBias = $this->zoneBias($bot, $strategicState, 'coverage_zones') + $this->zoneBias($bot, $strategicState, 'offensive_zones') + $this->zoneBias($bot, $strategicState, 'defensive_zones');

		return $compatibilite + $besoinSocial + $campagne + $disponibilite + $queueValue + $zoneBias - $redondance - $fatigue - $saturation - $idlePenalty;
	}

	protected function requiresNewSession(array $bot)
	{
		if (!$this->isLogicalOnline(isset($bot['presence_logical']) ? $bot['presence_logical'] : 'latent')) {
			return true;
		}

		return empty($bot['session_started_at']) || empty($bot['session_target_until']) || (int) $bot['session_target_until'] <= TIMESTAMP;
	}

	protected function computeSessionDurationSeconds(array $bot, array $config)
	{
		$rules = isset($config['global_presence_rules_json']['sessions']) && is_array($config['global_presence_rules_json']['sessions'])
			? $config['global_presence_rules_json']['sessions']
			: array();
		$minMinutes = max(5, (int) (!empty($bot['target_presence_min']) ? $bot['target_presence_min'] : (isset($rules['min_minutes']) ? $rules['min_minutes'] : 18)));
		$maxMinutes = max($minMinutes, (int) (!empty($bot['target_presence_max']) ? $bot['target_presence_max'] : (isset($rules['max_minutes']) ? $rules['max_minutes'] : 75)));
		$duration = $minMinutes * 60;

		if ($maxMinutes > $minMinutes) {
			$duration += mt_rand(0, ($maxMinutes - $minMinutes) * 60);
		}

		if ($bot['hierarchy_status'] === 'chef') {
			$duration += max(0, (int) $rules['commander_bonus_minutes']) * 60;
		}

		if (!empty($bot['current_campaign_id'])) {
			$duration += max(0, (int) $rules['campaign_bonus_minutes']) * 60;
		}

		if (!empty($bot['hostile_count']) || $bot['hierarchy_status'] === 'chef' || !empty($bot['current_campaign_id'])) {
			$duration = max($duration, 3 * 3600);
		}

		return $duration;
	}

	protected function computeRestDurationSeconds(array $bot, array $config)
	{
		$rules = isset($config['global_presence_rules_json']['sessions']) && is_array($config['global_presence_rules_json']['sessions'])
			? $config['global_presence_rules_json']['sessions']
			: array();
		$minRest = max(5, (int) (isset($rules['min_rest_minutes']) ? $rules['min_rest_minutes'] : 12));
		$maxRest = max($minRest, (int) (isset($rules['max_rest_minutes']) ? $rules['max_rest_minutes'] : 90));
		$ratio = isset($rules['rest_ratio']) ? (float) $rules['rest_ratio'] : 0.55;
		$sessionStart = !empty($bot['session_started_at']) ? (int) $bot['session_started_at'] : TIMESTAMP;
		$sessionEnd = !empty($bot['session_target_until']) ? (int) $bot['session_target_until'] : TIMESTAMP;
		$sessionDuration = max(300, $sessionEnd - $sessionStart);
		$restSeconds = (int) round($sessionDuration * max(0.1, $ratio));

		return max($minRest * 60, min($maxRest * 60, $restSeconds));
	}

	protected function resolveLogicalPresence(array $bot)
	{
		if (!empty($bot['hostile_attack_count'])) {
			return 'alerte';
		}

		if (!empty($bot['hostile_spy_count'])) {
			return 'engage';
		}

		if (!empty($bot['current_campaign_id'])) {
			return 'campagne';
		}

		if ($bot['hierarchy_status'] === 'chef') {
			return 'coordination';
		}

		return 'connecte';
	}

	protected function resolveSocialPresence(array $bot)
	{
		if (!empty($bot['hostile_count'])) {
			return !empty($bot['is_visible_socially']) ? 'visible' : 'discret';
		}

		if (!empty($bot['current_campaign_id'])) {
			return 'campagne';
		}

		if ($bot['hierarchy_status'] === 'chef') {
			return 'chef';
		}

		return !empty($bot['is_visible_socially']) ? 'visible' : 'discret';
	}

	protected function shouldBeVisible(array $bot, $currentVisibleCount, $targetSocial)
	{
		return $currentVisibleCount < (int) $targetSocial
			|| $bot['hierarchy_status'] === 'chef'
			|| !empty($bot['current_campaign_id'])
			|| !empty($bot['is_visible_socially']);
	}

	protected function isForcedOnline(array $bot)
	{
		return !empty($bot['hostile_count'])
			|| $bot['hierarchy_status'] === 'chef'
			|| !empty($bot['current_campaign_id']);
	}

	protected function isLogicalOnline($presence)
	{
		return in_array($presence, array('connecte', 'engage', 'alerte', 'coordination', 'campagne', 'harcelement'), true);
	}

	protected function zoneBias(array $bot, array $strategicState, $key)
	{
		if (empty($bot['galaxy']) || empty($bot['system']) || empty($strategicState[$key]) || !is_array($strategicState[$key])) {
			return 0;
		}

		$zoneReference = $bot['galaxy'].':'.$bot['system'];
		foreach ($strategicState[$key] as $zone) {
			if (!empty($zone['zone_reference']) && $zone['zone_reference'] === $zoneReference) {
				if ($key === 'coverage_zones') {
					return min(18, (int) round($zone['coverage_need'] / 8));
				}
				if ($key === 'defensive_zones') {
					return min(16, (int) round($zone['dissuasion_need'] / 10));
				}
				return min(18, (int) round($zone['pressure_need'] / 9));
			}
		}

		return 0;
	}

	protected function selectedReserveTier(array $bot, $isVisible, $relaySoon)
	{
		if (!empty($bot['current_campaign_id'])) {
			return 'mission';
		}

		if ($relaySoon) {
			return 'relai';
		}

		if ($isVisible) {
			return 'social';
		}

		return 'active';
	}

	protected function updateStructuralState($botUserId, array $bot, $reserveTier, array $strategicState, $selected)
	{
		$current = array();
		if (!empty($bot['structural_state_json'])) {
			$decoded = json_decode($bot['structural_state_json'], true);
			if (is_array($decoded)) {
				$current = $decoded;
			}
		}

		$zoneReference = (!empty($bot['galaxy']) && !empty($bot['system'])) ? $bot['galaxy'].':'.$bot['system'] : '';
		$current['reserve_tier'] = $reserveTier;
		$current['current_zone'] = $zoneReference;
		$current['selected_online'] = $selected ? 1 : 0;
		$current['coverage_bias'] = $this->zoneBias($bot, $strategicState, 'coverage_zones');
		$current['offensive_bias'] = $this->zoneBias($bot, $strategicState, 'offensive_zones');
		$current['defensive_bias'] = $this->zoneBias($bot, $strategicState, 'defensive_zones');
		$current['last_governance_at'] = TIMESTAMP;

		Database::get()->update('UPDATE %%BOT_STATE%% SET structural_state_json = :structuralStateJson, updated_at = :updatedAt WHERE bot_user_id = :botUserId;', array(
			':structuralStateJson' => json_encode($current),
			':updatedAt' => TIMESTAMP,
			':botUserId' => (int) $botUserId,
		));
	}
}
