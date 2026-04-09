<?php

class BotActionGenerator
{
	public function generate(array $snapshot, array $decision)
	{
		$goal = isset($decision['strategic_goal']) ? $decision['strategic_goal'] : 'stabilisation';
		$intention = isset($decision['intention']) ? $decision['intention'] : 'observer';
		$planet = isset($snapshot['planet']) ? $snapshot['planet'] : array();
		$bestTarget = isset($snapshot['best_target']) ? $snapshot['best_target'] : array();
			$focusTarget = $this->resolveFocusTarget($snapshot, $bestTarget);
			$manualCommands = isset($snapshot['commands']) ? $snapshot['commands'] : array();
			$currentCampaign = isset($snapshot['current_campaign']) ? $snapshot['current_campaign'] : array();
			$hostileContext = isset($snapshot['hostile_context']) ? $snapshot['hostile_context'] : array();
			$allianceAlert = isset($snapshot['alliance_alert']) ? $snapshot['alliance_alert'] : array();
			$actions = array();

		if ($goal === 'croissance_economique' || $goal === 'stabilisation') {
			$actions[] = $this->action('enqueue_building', $goal, 55, 10, 75, array('element_id' => $this->pickEconomicBuilding($planet)));
			$actions[] = $this->action('enqueue_research', $goal, 48, 8, 65, array('element_id' => $this->pickResearch($snapshot)));
			$actions[] = $this->action('enqueue_shipyard', $goal, 42, 6, 70, array('element_id' => 210, 'amount' => 1));
			$actions[] = $this->action('queue_social_message', $goal, 39, 5, 63, array(
				'channel_key' => 'auto',
				'channel_preference' => 'global',
				'template_key' => 'croissance_signal',
				'social_value' => 1,
			));
		}

		if ($goal === 'rattrapage_technologique') {
			$actions[] = $this->action('enqueue_research', $goal, 62, 8, 82, array('element_id' => $this->pickResearch($snapshot)));
			$actions[] = $this->action('enqueue_building', $goal, 40, 10, 60, array('element_id' => 31));
		}

		if ($goal === 'expansion_coloniale') {
			$actions[] = $this->action('enqueue_shipyard', $goal, 65, 12, 80, array('element_id' => 208, 'amount' => 1));
			$actions[] = $this->action('enqueue_building', $goal, 45, 10, 68, array('element_id' => 23));
			$actions[] = $this->action('queue_social_message', $goal, 37, 5, 61, array(
				'channel_key' => 'auto',
				'channel_preference' => 'alliance',
				'template_key' => 'expansion_signal',
				'social_value' => 1,
				'coverage_sociale' => 1,
			));
		}

		if (in_array($goal, array('pression_locale', 'campagne_harcelement'), true)) {
			if (!empty($focusTarget['target_coordinates'])) {
				$coordinates = $focusTarget['target_coordinates'];
				$actions[] = $this->action('send_spy', $goal, 75, 22, 85, array(
					'target_coordinates' => $coordinates,
					'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
					'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'retaliation_value' => !empty($hostileContext['retaliation_target']) ? 1 : 0,
				));
				$actions[] = $this->action('send_raid', $goal, 70, 34, 72, array(
					'target_coordinates' => $coordinates,
					'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
					'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'continuity_value' => 1,
					'retaliation_value' => !empty($hostileContext['retaliation_target']) ? 1 : 0,
				));
				$actions[] = $this->action('queue_social_message', $goal, 35, 14, 58, array(
					'channel_key' => 'bots',
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'target_coordinates' => $coordinates,
					'template_key' => !empty($hostileContext['retaliation_target']) ? 'riposte_zone' : 'pression_locale',
					'psychological_value' => 1,
				));
			}

			$actions[] = $this->action('enqueue_shipyard', $goal, 58, 12, 78, array('element_id' => 210, 'amount' => 3));
			$actions[] = $this->action('enqueue_shipyard', $goal, 52, 14, 74, array('element_id' => 202, 'amount' => 4));
		}

		if ($goal === 'defense_zone') {
			$actions[] = $this->action('enqueue_shipyard', $goal, 72, 18, 84, array('element_id' => 401, 'amount' => 8));
			$actions[] = $this->action('enqueue_shipyard', $goal, 64, 16, 80, array('element_id' => 402, 'amount' => 2));
			if (!empty($focusTarget['target_coordinates'])) {
				$actions[] = $this->action('send_spy', $goal, 58, 9, 86, array(
					'target_coordinates' => $focusTarget['target_coordinates'],
					'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
					'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'information_value' => 1,
					'retaliation_value' => !empty($hostileContext['retaliation_target']) ? 1 : 0,
				));
			}
			$actions[] = $this->action('queue_social_message', $goal, 25, 8, 60, array(
				'channel_key' => 'auto',
				'channel_preference' => 'alliance',
				'template_key' => !empty($hostileContext['spy_count']) ? 'contre_espionnage' : 'defense_zone',
				'target_coordinates' => !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '',
				'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
				'psychological_value' => 1,
			));
		}

		if ($goal === 'surveillance_active') {
			if (!empty($focusTarget['target_coordinates'])) {
				$coordinates = $focusTarget['target_coordinates'];
				$actions[] = $this->action('send_spy', $goal, 72, 14, 88, array(
					'target_coordinates' => $coordinates,
					'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
					'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'information_value' => 1,
					'retaliation_value' => !empty($hostileContext['retaliation_target']) ? 1 : 0,
				));
			}

			$actions[] = $this->action('presence_ping', $goal, 24, 2, 95, array('relay_value' => 1));
			$actions[] = $this->action('queue_social_message', $goal, 26, 6, 64, array(
				'channel_key' => 'auto',
				'channel_preference' => 'global',
				'template_key' => !empty($hostileContext['spy_count']) ? 'contre_espionnage' : 'presence_visible',
				'target_coordinates' => !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '',
				'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
				'information_value' => 1,
				'social_value' => 1,
			));
		}

		if ($goal === 'relai_offensif') {
			$actions[] = $this->action('presence_ping', $goal, 34, 2, 96, array('relay_value' => 1, 'continuity_value' => 1, 'target_social' => 'visible'));
			$actions[] = $this->action('queue_social_message', $goal, 28, 4, 70, array('channel_key' => 'auto', 'channel_preference' => 'alliance', 'template_key' => 'presence_continue', 'coverage_sociale' => 1));
			if (!empty($focusTarget['target_coordinates'])) {
				$coordinates = $focusTarget['target_coordinates'];
				$actions[] = $this->action('send_spy', $goal, 48, 12, 84, array(
					'target_coordinates' => $coordinates,
					'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
					'prepare_hidden' => 1,
				));
			}
		}

		if ($goal === 'pression_psychologique') {
			$actions[] = $this->action('queue_social_message', $goal, 62, 6, 82, array('channel_key' => 'bots', 'template_key' => 'brouillage', 'psychological_value' => 1, 'bluff_value' => 1));
			if (!empty($focusTarget['target_user_id'])) {
				$actions[] = $this->action('queue_private_message', $goal, 64, 8, 80, array(
					'target_user_id' => (int) $focusTarget['target_user_id'],
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'target_coordinates' => !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '',
					'template_key' => !empty($hostileContext['retaliation_target']) ? 'riposte_directe' : 'intimidation',
					'psychological_value' => 1,
				));
			}
			$actions[] = $this->action('presence_ping', $goal, 18, 1, 94, array('coverage_sociale' => 1));
		}

			if ($goal === 'soutien_alliance') {
				$supportCoordinates = !empty($allianceAlert['primary_ally']['coordinates']) ? $allianceAlert['primary_ally']['coordinates'] : '';
				$supportUsername = !empty($allianceAlert['primary_ally']['username']) ? $allianceAlert['primary_ally']['username'] : '';
				$actions[] = $this->action('presence_ping', $goal, 34, 2, 94, array(
					'target_logical' => !empty($allianceAlert['primary_ally']['attack_count']) ? 'coordination' : 'engage',
					'target_social' => 'visible',
					'relay_value' => 1,
					'continuity_value' => 1,
				));
				$actions[] = $this->action('queue_social_message', $goal, 42, 4, 78, array(
					'channel_key' => 'auto',
					'channel_preference' => 'alliance',
					'template_key' => 'soutien_alliance',
					'target_coordinates' => $supportCoordinates,
					'target_username' => $supportUsername,
					'coverage_sociale' => 1,
					'relay_value' => 1,
				));
				$actions[] = $this->action('enqueue_shipyard', $goal, 52, 12, 76, array('element_id' => 210, 'amount' => 2));
				if (!empty($allianceAlert['primary_ally']['attack_count'])) {
					$actions[] = $this->action('enqueue_shipyard', $goal, 56, 14, 78, array('element_id' => 401, 'amount' => 6));
				}
			}

		if ($goal === 'recrutement') {
			$actions[] = $this->action('queue_social_message', $goal, 58, 4, 82, array('channel_key' => 'bots', 'message' => 'Recherche de soutien et de relais tactiques pour les opérations en cours.'));
		}

		if ($goal === 'camouflage_discret') {
			$actions[] = $this->action('presence_ping', $goal, 20, 1, 90, array('force_discretion' => 1, 'prepare_hidden' => 1));
		}

		if ($goal === 'communication_ciblee') {
			$actions[] = $this->action('queue_social_message', $goal, 66, 5, 80, array('channel_key' => 'bots', 'template_key' => 'supervision'));
			if (!empty($focusTarget['target_user_id'])) {
				$actions[] = $this->action('queue_private_message', $goal, 60, 8, 76, array(
					'target_user_id' => (int) $focusTarget['target_user_id'],
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'target_coordinates' => !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '',
					'template_key' => 'test_diplomatique',
				));
			}
		}

		if (!empty($currentCampaign) && !empty($currentCampaign['target_reference'])) {
			$actions[] = $this->action('send_spy', 'campagne', 74, 18, 83, array(
				'target_coordinates' => $currentCampaign['target_reference'],
				'campaign_id' => (int) $currentCampaign['id'],
			));
			$actions[] = $this->action('send_raid', 'campagne', 72, 28, 76, array(
				'target_coordinates' => $currentCampaign['target_reference'],
				'campaign_id' => (int) $currentCampaign['id'],
			));
		}

		if (!empty($manualCommands)) {
			$actions[] = $this->action('presence_ping', 'ordre_manuel', 18, 2, 96, array('manual_order_count' => count($manualCommands)));
		}

		$actions = array_merge($actions, $this->buildIntentionActions($intention, $goal, $snapshot, $focusTarget));

		return $actions;
	}

	protected function action($type, $goal, $benefit, $risk, $confidence, array $payload)
	{
		return array(
			'action_type' => $type,
			'goal' => $goal,
			'benefit' => $benefit,
			'risk' => $risk,
			'confidence' => $confidence,
			'payload' => $payload,
		);
	}

	protected function pickEconomicBuilding(array $planet)
	{
		$options = array(
			1 => isset($planet['metal_mine']) ? (int) $planet['metal_mine'] : 0,
			2 => isset($planet['crystal_mine']) ? (int) $planet['crystal_mine'] : 0,
			3 => isset($planet['deuterium_sintetizer']) ? (int) $planet['deuterium_sintetizer'] : 0,
			4 => isset($planet['solar_plant']) ? (int) $planet['solar_plant'] : 0,
			22 => isset($planet['metal_store']) ? (int) $planet['metal_store'] : 0,
			23 => isset($planet['crystal_store']) ? (int) $planet['crystal_store'] : 0,
			24 => isset($planet['deuterium_store']) ? (int) $planet['deuterium_store'] : 0,
		);

		asort($options);
		return (int) key($options);
	}

	protected function pickResearch(array $snapshot)
	{
		$bot = isset($snapshot['bot']) ? $snapshot['bot'] : array();
		$options = array(
			106 => isset($bot['spy_tech']) ? (int) $bot['spy_tech'] : (isset($bot['espionage_tech']) ? (int) $bot['espionage_tech'] : 0),
			108 => isset($bot['computer_tech']) ? (int) $bot['computer_tech'] : 0,
			109 => isset($bot['military_tech']) ? (int) $bot['military_tech'] : 0,
			110 => isset($bot['defence_tech']) ? (int) $bot['defence_tech'] : 0,
			111 => isset($bot['shield_tech']) ? (int) $bot['shield_tech'] : 0,
			113 => isset($bot['energy_tech']) ? (int) $bot['energy_tech'] : 0,
			114 => isset($bot['hyperspace_tech']) ? (int) $bot['hyperspace_tech'] : 0,
			124 => isset($bot['astrophysics']) ? (int) $bot['astrophysics'] : 0,
		);

		asort($options);
		return (int) key($options);
	}

	protected function buildIntentionActions($intention, $goal, array $snapshot, array $focusTarget)
	{
		$actions = array();
		$coordinates = !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '';

		switch ($intention) {
			case 'observer':
				if ($coordinates !== '') {
					$actions[] = $this->action('send_spy', $goal, 68, 10, 88, array(
						'target_coordinates' => $coordinates,
						'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
						'information_value' => 1,
					));
				}
				break;

			case 'lancer_pression':
				if ($coordinates !== '') {
					$actions[] = $this->action('send_raid', $goal, 78, 28, 78, array(
						'target_coordinates' => $coordinates,
						'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
						'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
						'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
						'continuity_value' => 1,
					));
				}
				$actions[] = $this->action('queue_social_message', $goal, 52, 6, 76, array(
					'channel_key' => 'bots',
					'template_key' => 'pression_locale',
					'target_coordinates' => $coordinates,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'psychological_value' => 1,
				));
				break;

			case 'harceler':
				if ($coordinates !== '') {
					$actions[] = $this->action('send_spy', $goal, 72, 12, 86, array(
						'target_coordinates' => $coordinates,
						'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
						'prepare_hidden' => 1,
					));
				}
				if (!empty($focusTarget['target_user_id'])) {
					$actions[] = $this->action('queue_private_message', $goal, 48, 8, 74, array(
						'target_user_id' => (int) $focusTarget['target_user_id'],
						'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
						'target_coordinates' => $coordinates,
						'template_key' => 'mise_en_garde',
					));
				}
				break;

			case 'influencer':
				$actions[] = $this->action('queue_social_message', $goal, 54, 4, 80, array(
					'channel_key' => 'bots',
					'template_key' => 'ambiance_zone',
					'target_coordinates' => $coordinates,
				));
				break;

			case 'tromper':
				$actions[] = $this->action('queue_social_message', $goal, 58, 5, 78, array(
					'channel_key' => 'bots',
					'template_key' => 'brouillage',
					'target_coordinates' => $coordinates,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'bluff_value' => 1,
				));
				$actions[] = $this->action('presence_ping', $goal, 22, 2, 92, array(
					'target_social' => 'discret',
					'prepare_hidden' => 1,
				));
				break;

			case 'rester_visible':
				$actions[] = $this->action('presence_ping', $goal, 32, 2, 96, array(
					'target_social' => 'visible',
					'continuity_value' => 1,
					'coverage_sociale' => 1,
				));
				break;

			case 'se_faire_oublier':
				$actions[] = $this->action('presence_ping', $goal, 26, 1, 95, array(
					'target_social' => 'discret',
					'target_logical' => 'latent',
					'prepare_hidden' => 1,
				));
				break;

			case 'relayer_offensive':
			case 'preparer_releve':
				$actions[] = $this->action('presence_ping', $goal, 38, 2, 96, array(
					'target_social' => $intention === 'preparer_releve' ? 'discret' : 'visible',
					'relay_value' => 1,
					'continuity_value' => 1,
				));
				$actions[] = $this->action('queue_social_message', $goal, 34, 4, 72, array(
					'channel_key' => 'bots',
					'template_key' => 'presence_continue',
				));
				break;

			case 'tester_cible':
				if ($coordinates !== '') {
					$actions[] = $this->action('send_spy', $goal, 70, 11, 88, array(
						'target_coordinates' => $coordinates,
						'target_planet_id' => !empty($focusTarget['target_planet_id']) ? (int) $focusTarget['target_planet_id'] : 0,
						'information_value' => 1,
						'prepare_hidden' => 1,
					));
				}
				if (!empty($focusTarget['target_user_id'])) {
					$actions[] = $this->action('queue_private_message', $goal, 36, 6, 66, array(
						'target_user_id' => (int) $focusTarget['target_user_id'],
						'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
						'target_coordinates' => $coordinates,
						'template_key' => 'test_diplomatique',
					));
				}
				break;
		}

		return $actions;
	}

	protected function resolveFocusTarget(array $snapshot, array $bestTarget)
	{
		$candidates = array(
			isset($snapshot['hostile_context']['retaliation_target']) ? $snapshot['hostile_context']['retaliation_target'] : array(),
			isset($snapshot['current_target_focus']) ? $snapshot['current_target_focus'] : array(),
			isset($snapshot['commander_target_focus']) ? $snapshot['commander_target_focus'] : array(),
		);

		foreach ($candidates as $candidate) {
			if (!empty($candidate['target_coordinates'])) {
				return $candidate;
			}
		}

		if (!empty($bestTarget)) {
			return array(
				'target_coordinates' => $bestTarget['galaxy'].':'.$bestTarget['system'].':'.$bestTarget['planet'],
				'target_planet_id' => (int) $bestTarget['id'],
				'target_user_id' => (int) $bestTarget['id_owner'],
				'target_username' => isset($bestTarget['username']) ? $bestTarget['username'] : '',
			);
		}

		return array();
	}
}
