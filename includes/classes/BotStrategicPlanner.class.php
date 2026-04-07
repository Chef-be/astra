<?php

class BotStrategicPlanner
{
	public function buildDecision(array $snapshot, array $config, array $hierarchy = array())
	{
		$needs = $this->computeNeeds($snapshot, $config, $hierarchy);
		arsort($needs);
		$primaryNeed = key($needs);
		$strategicGoal = $this->mapNeedToGoal($primaryNeed, $snapshot, $hierarchy);
		$secondaryGoals = array_slice(array_keys($needs), 1, 3);

		return array(
			'needs' => $needs,
			'primary_need' => $primaryNeed,
			'strategic_goal' => $strategicGoal,
			'secondary_goals' => $secondaryGoals,
			'threat_level' => $this->computeThreatLevel($snapshot),
			'opportunity_level' => $this->computeOpportunityLevel($snapshot),
			'social_posture' => $this->computeSocialPosture($snapshot),
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
		$incomingThreat = min(100, count($snapshot['incoming_hostiles']) * 20);
		$queuePressure = min(100, ((int) $queues['building'] + (int) $queues['shipyard'] + (int) $queues['research']) * 15);
		$deficit = (1 - (($resourceLoad['metal'] + $resourceLoad['crystal'] + $resourceLoad['deuterium']) / 3)) * 100;
		$opportunity = empty($bestTarget) ? 0 : max(0, min(100, (float) $bestTarget['target_score'] * 4));
		$freeFields = isset($snapshot['free_fields_ratio']) ? (float) $snapshot['free_fields_ratio'] * 100 : 0;
		$planetCount = isset($snapshot['planet_count']) ? (int) $snapshot['planet_count'] : 1;
		$hierarchyPressure = !empty($hierarchy['state']['current_target_json']) ? 40 : 0;
		$memoryPressure = min(100, count(isset($snapshot['memory']) ? $snapshot['memory'] : array()) * 8);
		$relationshipPressure = min(100, count(isset($snapshot['relationships']) ? $snapshot['relationships'] : array()) * 6);
		$allianceSupport = !empty($snapshot['alliance_meta']) ? 60 : 0;
		$subordinateCount = !empty($snapshot['hierarchy']['subordinates']) ? count($snapshot['hierarchy']['subordinates']) : 0;
		$communicationReadiness = isset($dynamic['disponibilite_sociale']) ? (int) $dynamic['disponibilite_sociale'] : 40;

		$scores = array();
		$scores['besoin_economique'] =
			$this->weightedScore(isset($weights['economy']) ? $weights['economy'] : array(), array(
				'deficit_ressources' => $deficit,
				'retard_infrastructure' => max(0, 100 - ((int) $planet['metal_mine'] + (int) $planet['crystal_mine'] + (int) $planet['deuterium_sintetizer'])),
				'besoin_financement_objectif' => $queuePressure,
				'doctrine_economique' => isset($traits['economie']) ? $traits['economie'] : 50,
				'prudence' => isset($traits['prudence']) ? $traits['prudence'] : 50,
				'fatigue' => isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0,
				'manque_stock' => $deficit,
			));

		$scores['besoin_pression_offensive'] =
			$this->weightedScore(isset($weights['aggression']) ? $weights['aggression'] : array(), array(
				'agressivite' => isset($traits['aggressivite']) ? $traits['aggressivite'] : 50,
				'opportunite_raid' => $opportunity,
				'superiorite_locale' => isset($dynamic['superiorite_locale']) ? $dynamic['superiorite_locale'] : 50,
				'appetit_raid' => isset($dynamic['appetit_raid']) ? $dynamic['appetit_raid'] : 40,
				'rancune' => isset($traits['rancune']) ? $traits['rancune'] : 0,
				'ordre_offensif' => max($manualOrderScore, $hierarchyPressure),
				'intensite_campagne' => isset($dynamic['intensite_campagne']) ? $dynamic['intensite_campagne'] : 0,
				'soutien_alliance' => !empty($snapshot['bot']['ally_id']) ? 60 : 0,
				'peur' => isset($dynamic['peur']) ? $dynamic['peur'] : 0,
				'fatigue' => isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0,
			));

		$scores['besoin_defensif'] = min(100, ($incomingThreat * 0.65) + ((isset($traits['defense']) ? $traits['defense'] : 50) * 0.20) + ((isset($dynamic['vigilance']) ? $dynamic['vigilance'] : 50) * 0.15));
		$scores['besoin_expansion'] = min(100, ($freeFields < 25 ? 45 : 15) + ((isset($traits['expansion']) ? $traits['expansion'] : 50) * 0.35) + (max(0, 4 - $planetCount) * 15) + ($campaignScore * 0.10));
		$scores['besoin_technologique'] = min(100, ((isset($traits['technologie']) ? $traits['technologie'] : 50) * 0.45) + (max(0, 100 - ((int) $snapshot['bot']['computer_tech'] * 8)) * 0.30) + ($queuePressure * 0.10) + ($deficit * 0.15));
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
		$scores['besoin_recuperation'] = min(100, ((isset($dynamic['fatigue']) ? $dynamic['fatigue'] : 0) * 0.35) + ($incomingThreat * 0.20) + (max(0, 60 - (isset($dynamic['moral']) ? $dynamic['moral'] : 50)) * 0.20) + ($queuePressure * 0.25));
		$scores['besoin_harcelement_continu'] = min(100, ($campaignScore * 0.40) + ((isset($traits['gout_harcelement']) ? $traits['gout_harcelement'] : 30) * 0.30) + ($opportunity * 0.20) + ((isset($dynamic['excitation_offensive']) ? $dynamic['excitation_offensive'] : 25) * 0.10));
		$scores['besoin_logistique'] = min(100, ($queuePressure * 0.35) + ((isset($dynamic['saturation_logistique']) ? $dynamic['saturation_logistique'] : 0) * 0.30) + ((isset($traits['coordination']) ? $traits['coordination'] : 50) * 0.15) + ($campaignScore * 0.20));
		$scores['besoin_soutien_coordonne'] = min(100, ($allianceSupport * 0.20) + ($hierarchyPressure * 0.30) + ($campaignScore * 0.20) + (min(100, $subordinateCount * 15) * 0.15) + ((isset($traits['loyaute']) ? $traits['loyaute'] : 50) * 0.15));
		$scores['besoin_diplomatique_social'] = min(100, ($communicationReadiness * 0.30) + ($relationshipPressure * 0.25) + ($memoryPressure * 0.15) + ($allianceSupport * 0.15) + ((isset($traits['sociabilite']) ? $traits['sociabilite'] : 50) * 0.15));
		$scores['besoin_recrutement'] = min(100, ((isset($traits['aptitude_communication']) ? $traits['aptitude_communication'] : 50) * 0.25) + ($communicationReadiness * 0.25) + ($allianceSupport * 0.20) + (max(0, 100 - min(100, $subordinateCount * 18)) * 0.30));
		$scores['besoin_discretion'] = min(100, ((isset($dynamic['peur']) ? $dynamic['peur'] : 0) * 0.35) + ($incomingThreat * 0.25) + ((100 - $communicationReadiness) * 0.20) + ((isset($traits['prudence']) ? $traits['prudence'] : 50) * 0.20));
		$scores['besoin_militaire'] = min(100, ($opportunity * 0.35) + ((isset($traits['intensite_offensive']) ? $traits['intensite_offensive'] : 50) * 0.25) + ($campaignScore * 0.20) + ((isset($dynamic['superiorite_locale']) ? $dynamic['superiorite_locale'] : 50) * 0.20));

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
		);

		if (!empty($hierarchy['state']['current_target_json']) && in_array($needKey, array('besoin_pression_offensive', 'besoin_soutien_coordonne', 'besoin_militaire'), true)) {
			return 'pression_locale';
		}

		if (!empty($snapshot['campaigns']) && in_array($needKey, array('besoin_harcelement_continu', 'besoin_soutien_coordonne', 'besoin_pression_offensive'), true)) {
			return 'campagne_harcelement';
		}

		return isset($map[$needKey]) ? $map[$needKey] : 'stabilisation';
	}
}
