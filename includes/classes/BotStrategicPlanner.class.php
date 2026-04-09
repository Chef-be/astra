<?php

class BotStrategicPlanner
{
	public function buildDecision(array $snapshot, array $config, array $hierarchy = array())
	{
		$needs = $this->computeNeeds($snapshot, $config, $hierarchy);
		arsort($needs);
		$primaryNeed = key($needs);
		$strategicGoal = $this->mapNeedToGoal($primaryNeed, $snapshot, $hierarchy);
		$intention = $this->chooseIntention($primaryNeed, $strategicGoal, $snapshot, $hierarchy);
		$secondaryGoals = array_slice(array_keys($needs), 1, 3);

		return array(
			'needs' => $needs,
			'primary_need' => $primaryNeed,
			'strategic_goal' => $strategicGoal,
			'intention' => $intention,
			'secondary_goals' => $secondaryGoals,
			'threat_level' => $this->computeThreatLevel($snapshot),
			'opportunity_level' => $this->computeOpportunityLevel($snapshot),
			'social_posture' => $this->computeSocialPosture($snapshot),
			'global_posture' => $this->computeGlobalPosture($snapshot),
		);
	}

	protected function computeNeeds(array $snapshot, array $config, array $hierarchy)
	{
		$weights = isset($config['decision_weights_json']) && is_array($config['decision_weights_json'])
			? $config['decision_weights_json']
			: array();
		$traits = isset($snapshot['traits']) ? $snapshot['traits'] : array();
		$dynamic = isset($snapshot['dynamic']) ? $snapshot['dynamic'] : array();
		$planet = isset($snapshot['planet']) ? $snapshot['planet'] : array();
		$resourceLoad = isset($snapshot['resource_load']) ? $snapshot['resource_load'] : array('metal' => 0, 'crystal' => 0, 'deuterium' => 0);
		$queues = isset($snapshot['queue_state']) ? $snapshot['queue_state'] : array();
		$bestTarget = isset($snapshot['best_target']) ? $snapshot['best_target'] : array();
		$manualOrderScore = empty($snapshot['commands']) ? 0 : min(100, count($snapshot['commands']) * 25);
		$campaignScore = empty($snapshot['campaigns']) ? 0 : min(100, count($snapshot['campaigns']) * 20);
			$hostileContext = isset($snapshot['hostile_context']) ? $snapshot['hostile_context'] : array();
			$allianceAlert = isset($snapshot['alliance_alert']) ? $snapshot['alliance_alert'] : array();
			$incomingThreat = !empty($hostileContext['pressure_score'])
				? (int) $hostileContext['pressure_score']
				: min(100, count($snapshot['incoming_hostiles']) * 20);
			$alliancePressure = !empty($allianceAlert['pressure_score']) ? (int) $allianceAlert['pressure_score'] : 0;
		$attackPressure = min(100,
			((!empty($hostileContext['attack_count']) ? (int) $hostileContext['attack_count'] : 0) * 28)
			+ ((!empty($hostileContext['destruction_count']) ? (int) $hostileContext['destruction_count'] : 0) * 32)
		);
		$spyPressure = min(100, (!empty($hostileContext['spy_count']) ? (int) $hostileContext['spy_count'] : 0) * 24);
		$queuePressure = min(100, ((int) $queues['building'] + (int) $queues['shipyard'] + (int) $queues['research']) * 15);
		$deficit = (1 - (($resourceLoad['metal'] + $resourceLoad['crystal'] + $resourceLoad['deuterium']) / 3)) * 100;
		$opportunity = empty($bestTarget) ? 0 : max(0, min(100, (float) $bestTarget['target_score'] * 4));
		$freeFields = isset($snapshot['free_fields_ratio']) ? (float) $snapshot['free_fields_ratio'] * 100 : 0;
		$planetCount = isset($snapshot['planet_count']) ? (int) $snapshot['planet_count'] : 1;
		$hasFocusTarget = !empty($snapshot['current_target_focus']) || !empty($snapshot['commander_target_focus']);
		$hierarchyPressure = $hasFocusTarget ? 40 : 0;
		$memoryPressure = min(100, count(isset($snapshot['memory']) ? $snapshot['memory'] : array()) * 8);
		$relationshipPressure = min(100, count(isset($snapshot['relationships']) ? $snapshot['relationships'] : array()) * 6);
		$allianceSupport = !empty($snapshot['alliance_meta']) ? 60 : 0;
		$subordinateCount = !empty($snapshot['hierarchy']['subordinates']) ? count($snapshot['hierarchy']['subordinates']) : 0;
		$communicationReadiness = isset($dynamic['disponibilite_sociale']) ? (int) $dynamic['disponibilite_sociale'] : 40;
		$zoneContext = isset($snapshot['zone_context']['current_zone']) ? $snapshot['zone_context']['current_zone'] : array();
		$territorialZone = isset($snapshot['territorial_zone']) ? $snapshot['territorial_zone'] : array();
		$globalStrategy = isset($snapshot['global_strategy']['strategic_state']) ? $snapshot['global_strategy']['strategic_state'] : array();
		$learning = isset($snapshot['learning']) ? $snapshot['learning'] : array();
		$zonePressure = isset($zoneContext['pressure_need']) ? (int) $zoneContext['pressure_need'] : 0;
		$zoneCoverage = isset($zoneContext['coverage_need']) ? (int) $zoneContext['coverage_need'] : 0;
		$zoneDissuasion = isset($zoneContext['dissuasion_need']) ? (int) $zoneContext['dissuasion_need'] : 0;
		$zoneProfitability = isset($zoneContext['profitability_score']) ? (int) $zoneContext['profitability_score'] : 0;
		$targetInference = isset($snapshot['best_target']) ? $snapshot['best_target'] : array();
		$psychologicalPressure = isset($targetInference['psychological_score']) ? (int) $targetInference['psychological_score'] : 0;
		$territorialControl = isset($targetInference['territorial_score']) ? (int) $targetInference['territorial_score'] : 0;
		$relayNeed = min(100, max(0, $zoneCoverage + ($campaignScore * 0.25) - ((isset($snapshot['state']['action_queue_size']) ? (int) $snapshot['state']['action_queue_size'] : 0) * 8)));
		$profileEfficiency = !empty($learning['profile_metric']['score_value']) ? (float) $learning['profile_metric']['score_value'] : 50;
		$commanderCohesion = !empty($learning['commander_metric']['score_value']) ? (float) $learning['commander_metric']['score_value'] : 50;
		$zonePressureMemory = !empty($learning['zone_metric']['score_value']) ? (float) $learning['zone_metric']['score_value'] : 0;
		$targetPressureMemory = !empty($learning['target_signal']['pressure_memory']) ? (int) $learning['target_signal']['pressure_memory'] : 0;
		$globalOffensiveBias = $this->zoneBias($globalStrategy, isset($zoneContext['zone_reference']) ? $zoneContext['zone_reference'] : '', 'offensive_zones');
		$globalDefensiveBias = $this->zoneBias($globalStrategy, isset($zoneContext['zone_reference']) ? $zoneContext['zone_reference'] : '', 'defensive_zones');
		$globalCoverageBias = $this->zoneBias($globalStrategy, isset($zoneContext['zone_reference']) ? $zoneContext['zone_reference'] : '', 'coverage_zones');
		$territorialImportance = isset($territorialZone['strategic_importance']) ? (int) $territorialZone['strategic_importance'] : 0;
		$targetRevenge = isset($dynamic['desir_revanche']) ? (int) $dynamic['desir_revanche'] : 0;
		$mentalAvailability = isset($dynamic['disponibilite_mentale']) ? (int) $dynamic['disponibilite_mentale'] : 60;
		$tacticalSaturation = isset($dynamic['saturation_tactique']) ? (int) $dynamic['saturation_tactique'] : 0;

		$scores = array();
		$scores['besoin_economique'] = max(0,
			$this->weightedScore(isset($weights['economy']) ? $weights['economy'] : array(), array(
				'deficit_ressources' => $deficit,
				'retard_infrastructure' => max(0, 100 - ((int) $planet['metal_mine'] + (int) $planet['crystal_mine'] + (int) $planet['deuterium_sintetizer'])),
				'besoin_financement_objectif' => $queuePressure,
				'doctrine_economique' => isset($traits['economie']) ? $traits['economie'] : 50,
				'prudence' => isset($traits['prudence']) ? $traits['prudence'] : 50,
				'fatigue' => isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0,
				'manque_stock' => max(0, $deficit - ($incomingThreat * 0.30)),
			)) - min(26, ($incomingThreat * 0.18))
		);

		$scores['besoin_pression_offensive'] =
			$this->weightedScore(isset($weights['aggression']) ? $weights['aggression'] : array(), array(
				'agressivite' => isset($traits['aggressivite']) ? $traits['aggressivite'] : 50,
				'opportunite_raid' => max($opportunity, $zonePressure, $attackPressure),
				'superiorite_locale' => isset($dynamic['superiorite_locale']) ? $dynamic['superiorite_locale'] : 50,
				'appetit_raid' => isset($dynamic['appetit_raid']) ? $dynamic['appetit_raid'] : 40,
				'rancune' => isset($traits['rancune']) ? $traits['rancune'] : 0,
				'ordre_offensif' => max($manualOrderScore, $hierarchyPressure, (int) round($attackPressure * 0.7)),
				'intensite_campagne' => max(isset($dynamic['intensite_campagne']) ? $dynamic['intensite_campagne'] : 0, $zonePressure, $incomingThreat),
				'soutien_alliance' => !empty($snapshot['bot']['ally_id']) ? 60 : 0,
				'peur' => isset($dynamic['peur']) ? $dynamic['peur'] : 0,
				'fatigue' => isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0,
			));

		$scores['besoin_defensif'] = min(100, ($incomingThreat * 0.42) + (($zoneDissuasion + $globalDefensiveBias) * 0.22) + ($attackPressure * 0.16) + ((isset($traits['defense']) ? $traits['defense'] : 50) * 0.10) + ((isset($dynamic['vigilance']) ? $dynamic['vigilance'] : 50) * 0.05) + (max(0, 100 - $commanderCohesion) * 0.05));
		$scores['besoin_expansion'] = max(0, min(100, ($freeFields < 25 ? 45 : 15) + ((isset($traits['expansion']) ? $traits['expansion'] : 50) * 0.25) + (max(0, 4 - $planetCount) * 15) + ($campaignScore * 0.10) + ($zoneProfitability * 0.20) + (max(0, 60 - $territorialImportance) * 0.15) - ($incomingThreat * 0.28)));
		$scores['besoin_technologique'] = min(100, ((isset($traits['technologie']) ? $traits['technologie'] : 50) * 0.35) + (max(0, 100 - ((int) $snapshot['bot']['computer_tech'] * 8)) * 0.25) + ($queuePressure * 0.10) + ($deficit * 0.15) + ((isset($traits['patience_strategique']) ? $traits['patience_strategique'] : 55) * 0.15));
		$scores['besoin_communication'] =
			$this->weightedScore(isset($weights['communication']) ? $weights['communication'] : array(), array(
				'sociabilite' => isset($traits['sociabilite']) ? $traits['sociabilite'] : 50,
				'role_social' => isset($traits['aptitude_communication']) ? $traits['aptitude_communication'] : 50,
				'opportunite_diplomatique' => $manualOrderScore,
				'pression_psychologique' => $campaignScore,
				'campagne_active' => $campaignScore,
				'ordre_chef' => $hierarchyPressure,
					'discretion' => 100 - (isset($dynamic['disponibilite_sociale']) ? $dynamic['disponibilite_sociale'] : 40),
					'fatigue' => isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0,
				));
		$scores['besoin_recuperation'] = min(100, ((isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0) * 0.28) + ($incomingThreat * 0.18) + (max(0, 60 - (isset($dynamic['moral']) ? $dynamic['moral'] : 50)) * 0.18) + ($queuePressure * 0.16) + ($tacticalSaturation * 0.20));
		$scores['besoin_harcelement_continu'] = min(100, ($campaignScore * 0.25) + ((isset($traits['gout_harcelement']) ? $traits['gout_harcelement'] : 30) * 0.18) + ($opportunity * 0.14) + ((isset($dynamic['excitation_offensive']) ? $dynamic['excitation_offensive'] : 25) * 0.08) + (($psychologicalPressure + $targetPressureMemory + $globalOffensiveBias) * 0.35));
		$scores['besoin_logistique'] = min(100, ($queuePressure * 0.28) + ((isset($dynamic['saturation_logistique']) ? $dynamic['saturation_logistique'] : 0) * 0.22) + ((isset($traits['coordination']) ? $traits['coordination'] : 50) * 0.15) + ($campaignScore * 0.15) + ($globalCoverageBias * 0.20));
			$scores['besoin_soutien_coordonne'] = min(100,
				($allianceSupport * 0.12)
				+ ($hierarchyPressure * 0.18)
				+ ($campaignScore * 0.16)
				+ (min(100, $subordinateCount * 15) * 0.12)
				+ ((isset($traits['loyaute']) ? $traits['loyaute'] : 50) * 0.12)
				+ ($alliancePressure * 0.30)
			);
		$scores['besoin_diplomatique_social'] = min(100, ($communicationReadiness * 0.30) + ($relationshipPressure * 0.25) + ($memoryPressure * 0.15) + ($allianceSupport * 0.15) + ((isset($traits['sociabilite']) ? $traits['sociabilite'] : 50) * 0.15));
		$scores['besoin_recrutement'] = min(100, ((isset($traits['aptitude_communication']) ? $traits['aptitude_communication'] : 50) * 0.25) + ($communicationReadiness * 0.25) + ($allianceSupport * 0.20) + (max(0, 100 - min(100, $subordinateCount * 18)) * 0.30));
		$scores['besoin_discretion'] = min(100, ((isset($dynamic['peur']) ? $dynamic['peur'] : 0) * 0.25) + ($incomingThreat * 0.18) + ((100 - $communicationReadiness) * 0.14) + ((isset($traits['prudence']) ? $traits['prudence'] : 50) * 0.12) + ((isset($traits['discretion_sociale']) ? $traits['discretion_sociale'] : 45) * 0.18) + (max(0, 100 - $mentalAvailability) * 0.13));
		$scores['besoin_militaire'] = min(100, (max($opportunity, $territorialControl, $attackPressure) * 0.24) + ((isset($traits['intensite_offensive']) ? $traits['intensite_offensive'] : 50) * 0.18) + ($campaignScore * 0.14) + ((isset($dynamic['superiorite_locale']) ? $dynamic['superiorite_locale'] : 50) * 0.12) + (($globalOffensiveBias + $territorialImportance + $zonePressureMemory) * 0.20) + ($incomingThreat * 0.12));
		$scores['besoin_surveillance_active'] = min(100, (($zoneCoverage + $globalCoverageBias) * 0.22) + ($zonePressure * 0.10) + ($psychologicalPressure * 0.08) + ((isset($traits['espionnage']) ? $traits['espionnage'] : 50) * 0.14) + ((isset($dynamic['vigilance']) ? $dynamic['vigilance'] : 50) * 0.06) + ((isset($traits['sens_opportunite']) ? $traits['sens_opportunite'] : 55) * 0.10) + ($profileEfficiency * 0.10) + ($spyPressure * 0.20));
		$scores['besoin_presence_continue'] = min(100, ($relayNeed * 0.22) + ($campaignScore * 0.15) + ($communicationReadiness * 0.08) + ((isset($traits['coordination']) ? $traits['coordination'] : 50) * 0.10) + ((isset($traits['discipline']) ? $traits['discipline'] : 50) * 0.10) + ((isset($traits['capacite_relai']) ? $traits['capacite_relai'] : 55) * 0.15) + ((isset($traits['fidelite_plan']) ? $traits['fidelite_plan'] : 55) * 0.10) + ($globalCoverageBias * 0.10));
		$scores['besoin_pression_psychologique'] = min(100, ($psychologicalPressure * 0.20) + ($campaignScore * 0.14) + ($zonePressure * 0.10) + ($communicationReadiness * 0.08) + ((isset($traits['aptitude_communication']) ? $traits['aptitude_communication'] : 50) * 0.10) + ((isset($traits['aptitude_intimidation']) ? $traits['aptitude_intimidation'] : 40) * 0.18) + ((isset($traits['agressivite_verbale']) ? $traits['agressivite_verbale'] : 35) * 0.08) + ($targetPressureMemory * 0.08) + ($spyPressure * 0.12));
		$scores['besoin_releve'] = min(100, ($relayNeed * 0.30) + ($tacticalSaturation * 0.20) + ((isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0) * 0.15) + ((isset($traits['capacite_relai']) ? $traits['capacite_relai'] : 55) * 0.20) + (max(0, 100 - $mentalAvailability) * 0.15));
		$scores['besoin_apprentissage'] = min(100, ((100 - $profileEfficiency) * 0.25) + (max(0, 100 - $commanderCohesion) * 0.15) + ((isset($traits['patience_strategique']) ? $traits['patience_strategique'] : 55) * 0.20) + ((isset($traits['sens_opportunite']) ? $traits['sens_opportunite'] : 55) * 0.20) + (max(0, 100 - $territorialImportance) * 0.20));

		return $scores;
	}

	protected function weightedScore(array $weights, array $values)
	{
		$total = 0;
		foreach ($weights as $key => $weight) {
			$total += ((float) $weight) * (isset($values[$key]) ? (float) $values[$key] : 0);
		}

		return max(0, min(100, round($total, 2)));
	}

	protected function computeThreatLevel(array $snapshot)
	{
		if (!empty($snapshot['hostile_context']['pressure_score'])) {
			return min(100, (int) $snapshot['hostile_context']['pressure_score']);
		}

		return min(100, count($snapshot['incoming_hostiles']) * 25);
	}

	protected function computeOpportunityLevel(array $snapshot)
	{
		return empty($snapshot['best_target']['target_score']) ? 0 : min(100, (float) $snapshot['best_target']['target_score'] * 4);
	}

	protected function computeSocialPosture(array $snapshot)
	{
		$state = isset($snapshot['state']) ? $snapshot['state'] : array();
		$dynamic = isset($snapshot['dynamic']) ? $snapshot['dynamic'] : array();

		if (!empty($snapshot['campaigns'])) {
			return 'pression';
		}

		if (!empty($state['presence_social']) && $state['presence_social'] === 'chef') {
			return 'commandement';
		}

		return (!empty($dynamic['disponibilite_sociale']) && (int) $dynamic['disponibilite_sociale'] >= 55) ? 'visible' : 'reserve';
	}

	protected function mapNeedToGoal($needKey, array $snapshot, array $hierarchy)
	{
		$map = array(
			'besoin_economique' => 'croissance_economique',
			'besoin_militaire' => 'pression_locale',
			'besoin_defensif' => 'defense_zone',
			'besoin_technologique' => 'rattrapage_technologique',
			'besoin_expansion' => 'expansion_coloniale',
			'besoin_diplomatique_social' => 'communication_ciblee',
			'besoin_logistique' => 'stabilisation',
			'besoin_recuperation' => 'stabilisation',
			'besoin_communication' => 'communication_ciblee',
			'besoin_pression_offensive' => 'pression_locale',
			'besoin_harcelement_continu' => 'campagne_harcelement',
			'besoin_soutien_coordonne' => 'soutien_alliance',
			'besoin_discretion' => 'camouflage_discret',
			'besoin_recrutement' => 'recrutement',
			'besoin_surveillance_active' => 'surveillance_active',
			'besoin_presence_continue' => 'relai_offensif',
			'besoin_pression_psychologique' => 'pression_psychologique',
			'besoin_releve' => 'relai_offensif',
			'besoin_apprentissage' => 'surveillance_active',
		);

		if ((!empty($snapshot['current_target_focus']) || !empty($snapshot['commander_target_focus'])) && in_array($needKey, array('besoin_pression_offensive', 'besoin_soutien_coordonne', 'besoin_militaire'), true)) {
			return 'pression_locale';
		}

		if (!empty($snapshot['campaigns']) && in_array($needKey, array('besoin_harcelement_continu', 'besoin_soutien_coordonne', 'besoin_pression_offensive'), true)) {
			return 'campagne_harcelement';
		}

		return isset($map[$needKey]) ? $map[$needKey] : 'stabilisation';
	}

	protected function chooseIntention($needKey, $goal, array $snapshot, array $hierarchy)
	{
		$map = array(
			'croissance_economique' => 'croitre',
			'stabilisation' => 'se_stabiliser',
			'rattrapage_technologique' => 'preparer',
			'expansion_coloniale' => 'croitre',
			'defense_zone' => 'defendre',
			'soutien_alliance' => 'soutenir',
			'surveillance_active' => 'observer',
			'pression_locale' => 'lancer_pression',
			'campagne_harcelement' => 'harceler',
			'recrutement' => 'recruter',
			'communication_ciblee' => 'influencer',
			'camouflage_discret' => 'se_faire_oublier',
			'relai_offensif' => 'relayer_offensive',
			'pression_psychologique' => 'tromper',
		);

		if ($needKey === 'besoin_releve') {
			return 'preparer_releve';
		}

		if (!empty($snapshot['campaigns']) && in_array($goal, array('pression_locale', 'campagne_harcelement', 'relai_offensif'), true)) {
			return 'relayer_offensive';
		}

		if ((!empty($snapshot['current_target_focus']) || !empty($snapshot['commander_target_focus'])) && in_array($goal, array('pression_locale', 'surveillance_active'), true)) {
			return 'tester_cible';
		}

		if (!empty($snapshot['global_strategy']['strategic_state']['coverage_zones'])) {
			$currentZone = !empty($snapshot['zone_context']['current_zone']['zone_reference']) ? $snapshot['zone_context']['current_zone']['zone_reference'] : '';
			foreach ($snapshot['global_strategy']['strategic_state']['coverage_zones'] as $zone) {
				if (!empty($zone['zone_reference']) && $zone['zone_reference'] === $currentZone && $needKey === 'besoin_presence_continue') {
					return 'rester_visible';
				}
			}
		}

		return isset($map[$goal]) ? $map[$goal] : 'observer';
	}

	protected function computeGlobalPosture(array $snapshot)
	{
		$strategy = isset($snapshot['global_strategy']['strategic_state']) ? $snapshot['global_strategy']['strategic_state'] : array();
		if (!empty($strategy['offensive_zones'])) {
			return 'offensive';
		}
		if (!empty($strategy['defensive_zones'])) {
			return 'defensive';
		}
		return 'equilibree';
	}

	protected function zoneBias(array $strategy, $zoneReference, $key)
	{
		if ($zoneReference === '' || empty($strategy[$key]) || !is_array($strategy[$key])) {
			return 0;
		}

		foreach ($strategy[$key] as $zone) {
			if (!empty($zone['zone_reference']) && $zone['zone_reference'] === $zoneReference) {
				return isset($zone['strategic_importance']) ? (int) $zone['strategic_importance'] : 0;
			}
		}

		return 0;
	}
}
