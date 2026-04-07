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
				p.always_active, p.is_visible_socially, p.is_commander_profile,
				bs.presence_logical, bs.presence_social, bs.hierarchy_status, bs.paused_until, bs.current_campaign_id, bs.is_online_forced
			FROM %%USERS%% u
			LEFT JOIN %%BOT_PROFILES%% p ON p.id = u.bot_profile_id
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.universe = :universe AND u.is_bot = 1
			ORDER BY COALESCE(p.always_active, 0) DESC, COALESCE(p.target_online, 0) DESC, u.onlinetime DESC, u.id ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$targetOnline = $this->computeHourlyTarget($bots, $config);
		$targetSocial = max(0, min((int) $config['target_social_total'], $targetOnline));
		$defaultAlliance = $this->allianceService->ensureDefaultAlliance($config);

		$selectedOnline = array();
		$selectedSocial = array();
		$index = 0;
		foreach ($bots as $bot) {
			if (!empty($bot['paused_until']) && (int) $bot['paused_until'] > TIMESTAMP) {
				$this->presenceService->applyPresence($bot['id'], 'repos', 'discret', 'pause_administrative');
				continue;
			}

			if (!empty($defaultAlliance) && (int) $config['enable_bot_alliances'] === 1 && (int) $bot['ally_id'] === 0) {
				$this->allianceService->assignBotToAlliance($bot['id'], $defaultAlliance['alliance_id']);
			}

			$isForced = !empty($bot['always_active']) || !empty($bot['is_online_forced']) || $bot['hierarchy_status'] === 'chef';
			$shouldBeOnline = $isForced || $index < $targetOnline;
			$shouldBeVisible = ($index < $targetSocial) || $bot['hierarchy_status'] === 'chef' || !empty($bot['current_campaign_id']);

			if ($shouldBeOnline) {
				$logical = !empty($bot['current_campaign_id']) ? 'campagne' : ($bot['hierarchy_status'] === 'chef' ? 'coordination' : 'connecte');
				$social = $shouldBeVisible ? ($bot['hierarchy_status'] === 'chef' ? 'chef' : 'visible') : 'discret';
				$this->presenceService->applyPresence($bot['id'], $logical, $social, 'gouvernance_population', $isForced);
				$selectedOnline[] = (int) $bot['id'];
				if ($shouldBeVisible) {
					$selectedSocial[] = (int) $bot['id'];
				}
				$index++;
			} else {
				$this->presenceService->applyPresence($bot['id'], 'latent', 'discret', 'gouvernance_population');
			}
		}

		return array(
			'target_online' => $targetOnline,
			'target_social' => $targetSocial,
			'selected_online' => $selectedOnline,
			'selected_social' => $selectedSocial,
			'total_bots' => count($bots),
		);
	}

	protected function computeHourlyTarget(array $bots, array $config)
	{
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
}
