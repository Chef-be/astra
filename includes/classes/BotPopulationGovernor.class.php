<?php

class BotPopulationGovernor
{
	protected $presenceService;
	protected $allianceService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotAllianceService.class.php';

		$this->presenceService = new BotPresenceService();
		$this->allianceService = new BotAllianceService();
	}

	public function computeAndApply(array $config)
	{
		$db = Database::get();
		$bots = $db->select('SELECT u.id, u.username, u.bot_profile_id, u.ally_id, p.target_online, p.target_social_online,
				p.always_active, p.is_visible_socially, p.is_commander_profile, p.target_presence_min, p.target_presence_max,
				bs.presence_logical, bs.presence_social, bs.hierarchy_status, bs.paused_until, bs.current_campaign_id, bs.is_online_forced,
				bs.session_started_at, bs.session_target_until, bs.session_rest_until, bs.last_presence_change_at
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY COALESCE(p.always_active, 0) DESC, COALESCE(p.target_online, 0) DESC, COALESCE(bs.last_presence_change_at, 0) ASC, u.id ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$targetOnline = $this->computeHourlyTarget($bots, $config);
		$targetSocial = max(0, min((int) $config['target_social_total'], $targetOnline));
		$defaultAlliance = $this->allianceService->ensureDefaultAlliance($config);
		$selected = $this->selectOnlineBots($bots, $targetOnline);
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

				$logical = $this->resolveLogicalPresence($bot);
				$social = $shouldBeVisible ? $this->resolveSocialPresence($bot) : 'discret';
				$this->presenceService->applyPresence($botId, $logical, $social, 'gouvernance_population', $isForced, $sessionMeta);
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
				$restingCount++;
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
		);
	}

	public function computeTargetPreview(array $config, $totalBots)
	{
		return max(1, min((int) $totalBots, $this->computeHourlyTarget(array_fill(0, (int) $totalBots, 1), $config)));
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

		return max(1, min(count($bots), (int) round((int) $config['target_online_total'] * $multiplier)));
	}

	protected function selectOnlineBots(array $bots, $targetOnline)
	{
		$selected = array();
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

			if ($isForced) {
				$selected[$botId] = array('relay_soon' => false);
				continue;
			}

			if ($isOnline && $sessionActive) {
				$continuity[] = $bot;
				continue;
			}

			if ($restOver) {
				$rotationReady[] = $bot;
				continue;
			}

			$fallback[] = $bot;
		}

		usort($continuity, array($this, 'sortContinuityBots'));
		usort($rotationReady, array($this, 'sortRotationBots'));
		usort($fallback, array($this, 'sortFallbackBots'));

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

	protected function sortContinuityBots(array $left, array $right)
	{
		$leftTarget = !empty($left['session_target_until']) ? (int) $left['session_target_until'] : PHP_INT_MAX;
		$rightTarget = !empty($right['session_target_until']) ? (int) $right['session_target_until'] : PHP_INT_MAX;
		if ($leftTarget === $rightTarget) {
			return (int) $left['id'] <=> (int) $right['id'];
		}

		return $leftTarget <=> $rightTarget;
	}

	protected function sortRotationBots(array $left, array $right)
	{
		$leftChanged = !empty($left['last_presence_change_at']) ? (int) $left['last_presence_change_at'] : 0;
		$rightChanged = !empty($right['last_presence_change_at']) ? (int) $right['last_presence_change_at'] : 0;
		if ($leftChanged === $rightChanged) {
			return (int) $left['id'] <=> (int) $right['id'];
		}

		return $leftChanged <=> $rightChanged;
	}

	protected function sortFallbackBots(array $left, array $right)
	{
		$leftRest = !empty($left['session_rest_until']) ? (int) $left['session_rest_until'] : PHP_INT_MAX;
		$rightRest = !empty($right['session_rest_until']) ? (int) $right['session_rest_until'] : PHP_INT_MAX;
		if ($leftRest === $rightRest) {
			return (int) $left['id'] <=> (int) $right['id'];
		}

		return $leftRest <=> $rightRest;
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

		if (!empty($bot['always_active']) || !empty($bot['is_online_forced'])) {
			$duration = max($duration, 4 * 3600);
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
		return !empty($bot['always_active'])
			|| !empty($bot['is_online_forced'])
			|| $bot['hierarchy_status'] === 'chef'
			|| !empty($bot['current_campaign_id']);
	}

	protected function isLogicalOnline($presence)
	{
		return in_array($presence, array('connecte', 'engage', 'alerte', 'coordination', 'campagne', 'harcelement'), true);
	}
}
