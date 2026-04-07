<?php

class BotActionScorer
{
	public function score(array $actions, array $snapshot, array $decision)
	{
		$profileDoctrine = isset($snapshot['bot']['doctrine']) ? $snapshot['bot']['doctrine'] : '';
		$role = isset($snapshot['state']['role_primary']) ? $snapshot['state']['role_primary'] : 'economiste';
		$campaignBoost = empty($snapshot['campaigns']) ? 0 : 10;
		$bestTarget = !empty($snapshot['best_target']) ? $snapshot['best_target'] : array();
		$zoneContext = isset($snapshot['zone_context']['current_zone']) ? $snapshot['zone_context']['current_zone'] : array();
		$territorialZone = isset($snapshot['territorial_zone']) ? $snapshot['territorial_zone'] : array();
		$learning = isset($snapshot['learning']) ? $snapshot['learning'] : array();
		$globalStrategy = isset($snapshot['global_strategy']['strategic_state']) ? $snapshot['global_strategy']['strategic_state'] : array();
		$actionMetrics = !empty($learning['action_metrics']) && is_array($learning['action_metrics']) ? $learning['action_metrics'] : array();
		$targetSignal = !empty($learning['target_signal']) ? $learning['target_signal'] : array();
		$results = array();

		foreach ($actions as $action) {
			$coherenceProfile = $this->profileCoherence($action['action_type'], $profileDoctrine, $role);
			$coherenceDoctrine = $this->doctrineCoherence($action['action_type'], $profileDoctrine);
			$coherenceRole = $this->roleCoherence($action['action_type'], $role);
			$opportunity = empty($bestTarget) ? 0 : min(18, max(0, (float) $bestTarget['opportunity_score'] / 6));
			$cost = $this->estimateCostPenalty($action['action_type'], isset($action['payload']) ? $action['payload'] : array());
			$queuePenalty = min(15, ((int) $snapshot['queue_state']['building'] + (int) $snapshot['queue_state']['shipyard'] + (int) $snapshot['queue_state']['research']) * 2);
			$hierarchyPriority = !empty($snapshot['hierarchy']['commander']['current_target_json']) ? 10 : 0;
			$bonusActifs = isset($snapshot['state']['bonus_score']) ? min(12, (int) $snapshot['state']['bonus_score']) : 0;
			$coherenceSociale = $this->socialCoherence($action['action_type'], $decision);
			$faisabilite = $this->estimateFeasibility($action['action_type'], $snapshot, $action);
			$chargeLogistique = min(12, isset($snapshot['dynamic']['saturation_logistique']) ? (int) round($snapshot['dynamic']['saturation_logistique'] / 10) : 0);
			$cooldownPenalty = !empty($snapshot['state']['cooldown_until']) && (int) $snapshot['state']['cooldown_until'] > TIMESTAMP ? 8 : 0;
			$tacticalPenalty = $this->tacticalIncoherencePenalty($action['action_type'], $snapshot, $decision);
			$territorialValue = min(14, isset($zoneContext['strategic_value']) ? (int) round($zoneContext['strategic_value'] / 8) : 0);
			$territorialValue += min(10, isset($territorialZone['strategic_importance']) ? (int) round($territorialZone['strategic_importance'] / 12) : 0);
			$psychologicalValue = min(12, isset($bestTarget['psychological_score']) ? (int) round($bestTarget['psychological_score'] / 10) : 0);
			$continuityValue = $this->continuityValue($action, $decision, $snapshot);
			$informationValue = $this->informationValue($action, $bestTarget);
			$directBenefit = (float) $action['benefit'];
			$deferredBenefit = $this->deferredBenefit($action, $snapshot, $decision, $territorialZone, $targetSignal);
			$relayValue = $this->relayValue($action, $decision, $snapshot, $globalStrategy);
			$learningBoost = $this->learningBoost($action, $actionMetrics, $learning);
			$psychologicalMomentum = min(10, max(0, isset($targetSignal['pressure_memory']) ? (int) round($targetSignal['pressure_memory'] / 12) : 0));
			$successProbability = min(10, max(0, (float) $action['confidence'] / 10));
			$redundancyPenalty = $this->redundancyPenalty($action, $snapshot);
			$timingPenalty = $this->timingIncoherencePenalty($action, $decision, $snapshot);
			$exposurePenalty = $this->exposurePenalty($action, $snapshot, $decision);
			$opportunityCost = $queuePenalty + (int) min(8, max(0, count(isset($snapshot['own_fleets']) ? $snapshot['own_fleets'] : array()) * 2));

			$utility = $directBenefit
				+ $deferredBenefit
				+ $coherenceProfile
				+ $coherenceDoctrine
				+ $coherenceRole
				+ $opportunity
				+ $hierarchyPriority
				+ $bonusActifs
				+ $campaignBoost
				+ $coherenceSociale
				+ $territorialValue
				+ $psychologicalValue
				+ $continuityValue
				+ $relayValue
				+ $learningBoost
				+ $psychologicalMomentum
				+ $informationValue
				+ $faisabilite
				+ $successProbability
				- (float) $cost
				- (float) $action['risk']
				- $chargeLogistique
				- $opportunityCost;
			$utility -= $cooldownPenalty;
			$utility -= $tacticalPenalty;
			$utility -= $redundancyPenalty;
			$utility -= $timingPenalty;
			$utility -= $exposurePenalty;

			$action['utility'] = round($utility, 2);
			$action['benefice_direct'] = round($directBenefit, 2);
			$action['benefice_differe'] = round($deferredBenefit, 2);
			$action['estimated_cost'] = $cost;
			$action['estimated_risk'] = (float) $action['risk'];
			$action['estimated_delay'] = !empty($action['due_delay']) ? (int) $action['due_delay'] : 0;
			$action['next_step'] = $this->guessNextStep($action['action_type']);
			$action['justification'] = $this->buildJustification($action, $decision, $snapshot);
			$results[] = $action;
		}

		usort($results, function ($left, $right) {
			if ($left['utility'] === $right['utility']) {
				return 0;
			}

			return $left['utility'] > $right['utility'] ? -1 : 1;
		});

		return $results;
	}

	protected function profileCoherence($actionType, $doctrine, $role)
	{
		$score = 6;
		if (strpos($actionType, 'send_') === 0 && in_array($doctrine, array('guerre', 'pression_continue', 'opportuniste'), true)) {
			$score += 12;
		}

		if (strpos($actionType, 'enqueue_building') === 0 && in_array($role, array('economiste', 'technologue', 'colonisateur'), true)) {
			$score += 10;
		}

		if (strpos($actionType, 'queue_') === 0 && in_array($role, array('animateur', 'diplomate', 'recruteur'), true)) {
			$score += 10;
		}

		return $score;
	}

	protected function doctrineCoherence($actionType, $doctrine)
	{
		if (strpos($actionType, 'send_') === 0 && in_array($doctrine, array('guerre', 'pression_continue', 'raid', 'predation', 'harcelement'), true)) {
			return 10;
		}

		if (strpos($actionType, 'enqueue_research') === 0 && in_array($doctrine, array('recherche', 'equilibre'), true)) {
			return 8;
		}

		if (strpos($actionType, 'queue_') === 0 && in_array($doctrine, array('influence', 'presence', 'pression_sociale'), true)) {
			return 8;
		}

		return 4;
	}

	protected function roleCoherence($actionType, $role)
	{
		if (strpos($actionType, 'send_') === 0 && in_array($role, array('predateur', 'raider', 'harceleur', 'chef'), true)) {
			return 10;
		}

		if (strpos($actionType, 'enqueue_shipyard') === 0 && in_array($role, array('protecteur', 'logisticien', 'chef', 'predateur'), true)) {
			return 7;
		}

		return 3;
	}

	protected function estimateCostPenalty($actionType, array $payload)
	{
		if ($actionType === 'send_raid') {
			return 16;
		}

		if ($actionType === 'send_spy') {
			return 8;
		}

		if ($actionType === 'enqueue_shipyard') {
			return 12 + max(0, ((int) $payload['amount'] - 1));
		}

		if ($actionType === 'queue_private_message') {
			return 3;
		}

		return 6;
	}

	protected function socialCoherence($actionType, array $decision)
	{
		if (strpos($actionType, 'queue_') === 0) {
			return isset($decision['social_posture']) && $decision['social_posture'] !== 'reserve' ? 8 : 3;
		}

		return 2;
	}

	protected function estimateFeasibility($actionType, array $snapshot, array $action)
	{
		$planet = isset($snapshot['planet']) ? $snapshot['planet'] : array();
		if ($actionType === 'send_spy') {
			return !empty($planet['espionage_probe']) ? 10 : -4;
		}

		if ($actionType === 'send_raid') {
			$combatShips = (int) (isset($planet['light_hunter']) ? $planet['light_hunter'] : 0) + (int) (isset($planet['small_ship_cargo']) ? $planet['small_ship_cargo'] : 0);
			return $combatShips >= 4 ? 8 : -8;
		}

		if ($actionType === 'enqueue_building' || $actionType === 'enqueue_research' || $actionType === 'enqueue_shipyard') {
			return 8;
		}

		return 4;
	}

	protected function tacticalIncoherencePenalty($actionType, array $snapshot, array $decision)
	{
		$threatLevel = isset($decision['threat_level']) ? (int) $decision['threat_level'] : 0;
		if ($threatLevel >= 60 && in_array($actionType, array('send_raid', 'queue_private_message', 'queue_social_message'), true)) {
			return 8;
		}

		return 0;
	}

	protected function guessNextStep($actionType)
	{
		$map = array(
			'enqueue_building' => 'Consolidation économique et nouvelle évaluation.',
			'enqueue_research' => 'Montée technologique puis ajustement doctrinal.',
			'enqueue_shipyard' => 'Renforcement de flotte puis nouvelle projection.',
			'send_spy' => 'Analyse du rapport d’espionnage et arbitrage.',
			'send_raid' => 'Suivi du combat et réévaluation de la cible.',
			'queue_private_message' => 'Observation de la réaction du joueur ciblé.',
			'queue_social_message' => 'Mesure de la visibilité sociale obtenue.',
			'presence_ping' => 'Maintien de présence avant prochain cycle.',
		);

		return isset($map[$actionType]) ? $map[$actionType] : 'Analyse du prochain cycle.';
	}

	protected function buildJustification(array $action, array $decision, array $snapshot)
	{
		$target = '';
		if (!empty($action['payload']['target_coordinates'])) {
			$target = ' sur '.$action['payload']['target_coordinates'];
		}

		return sprintf(
			'Objectif %s, besoin dominant %s, posture %s, menace %d, opportunité %d, confiance %d, prochaine étape %s%s.',
			$action['goal'],
			isset($decision['primary_need']) ? $decision['primary_need'] : 'stabilisation',
			isset($decision['social_posture']) ? $decision['social_posture'] : 'reserve',
			isset($decision['threat_level']) ? (int) $decision['threat_level'] : 0,
			isset($decision['opportunity_level']) ? (int) $decision['opportunity_level'] : 0,
			isset($action['confidence']) ? (int) $action['confidence'] : 0,
			isset($action['next_step']) ? $action['next_step'] : 'analyse',
			$target
		);
	}

	protected function continuityValue(array $action, array $decision, array $snapshot)
	{
		$value = 0;
		if ($action['action_type'] === 'presence_ping') {
			$value += 6;
		}

		if (!empty($action['payload']['relay_value'])) {
			$value += 8;
		}

		if (!empty($action['payload']['continuity_value'])) {
			$value += 6;
		}

		if (!empty($snapshot['campaigns'])) {
			$value += 4;
		}

		if (isset($decision['primary_need']) && $decision['primary_need'] === 'besoin_presence_continue') {
			$value += 8;
		}

		return $value;
	}

	protected function informationValue(array $action, array $bestTarget)
	{
		if ($action['action_type'] !== 'send_spy') {
			return 0;
		}

		$value = 8;
		if (!empty($action['payload']['information_value'])) {
			$value += 4;
		}

		if (!empty($bestTarget['threat_score'])) {
			$value += min(6, (int) round($bestTarget['threat_score'] / 20));
		}

		return $value;
	}

	protected function deferredBenefit(array $action, array $snapshot, array $decision, array $territorialZone, array $targetSignal)
	{
		$value = 0;
		if (!empty($action['payload']['prepare_hidden'])) {
			$value += 6;
		}

		if ($action['action_type'] === 'send_spy') {
			$value += 5;
		}

		if ($action['action_type'] === 'presence_ping' && isset($decision['primary_need']) && in_array($decision['primary_need'], array('besoin_presence_continue', 'besoin_releve'), true)) {
			$value += 7;
		}

		if (!empty($territorialZone['pressure_need'])) {
			$value += min(8, (int) round($territorialZone['pressure_need'] / 18));
		}

		if (!empty($targetSignal['territorial_window'])) {
			$value += min(6, (int) round($targetSignal['territorial_window'] / 18));
		}

		return $value;
	}

	protected function relayValue(array $action, array $decision, array $snapshot, array $globalStrategy)
	{
		$value = 0;
		if (!empty($action['payload']['relay_value'])) {
			$value += 8;
		}

		if (!empty($action['payload']['coverage_sociale'])) {
			$value += 5;
		}

		if (!empty($action['payload']['continuity_value'])) {
			$value += 5;
		}

		if (isset($decision['intention']) && in_array($decision['intention'], array('relayer_offensive', 'preparer_releve', 'rester_visible'), true)) {
			$value += 4;
		}

		$currentZone = !empty($snapshot['zone_context']['current_zone']['zone_reference']) ? $snapshot['zone_context']['current_zone']['zone_reference'] : '';
		if ($currentZone !== '' && !empty($globalStrategy['coverage_zones'])) {
			foreach ($globalStrategy['coverage_zones'] as $zone) {
				if (!empty($zone['zone_reference']) && $zone['zone_reference'] === $currentZone) {
					$value += min(8, (int) round($zone['coverage_need'] / 15));
					break;
				}
			}
		}

		return $value;
	}

	protected function learningBoost(array $action, array $actionMetrics, array $learning)
	{
		$value = 0;
		if (!empty($actionMetrics[$action['action_type']]['score_value'])) {
			$value += min(10, max(-6, (((float) $actionMetrics[$action['action_type']]['score_value']) - 50) / 8));
		}

		if (!empty($learning['profile_metric']['score_value'])) {
			$value += min(6, max(-4, (((float) $learning['profile_metric']['score_value']) - 50) / 12));
		}

		if (!empty($learning['commander_metric']['score_value'])) {
			$value += min(5, max(-4, (((float) $learning['commander_metric']['score_value']) - 50) / 14));
		}

		return $value;
	}

	protected function redundancyPenalty(array $action, array $snapshot)
	{
		$penalty = 0;
		if ($action['action_type'] === 'presence_ping' && !empty($snapshot['state']['action_queue_size']) && (int) $snapshot['state']['action_queue_size'] >= 3) {
			$penalty += 4;
		}

		if (in_array($action['action_type'], array('send_spy', 'send_raid'), true) && !empty($snapshot['own_fleets'])) {
			$penalty += min(10, count($snapshot['own_fleets']) * 2);
		}

		return $penalty;
	}

	protected function timingIncoherencePenalty(array $action, array $decision, array $snapshot)
	{
		$penalty = 0;
		if (!empty($snapshot['state']['paused_until']) && (int) $snapshot['state']['paused_until'] > TIMESTAMP) {
			$penalty += 20;
		}

		if (!empty($action['payload']['target_logical']) && $action['payload']['target_logical'] === 'latent' && in_array($action['action_type'], array('send_spy', 'send_raid'), true)) {
			$penalty += 12;
		}

		if (isset($decision['primary_need']) && $decision['primary_need'] === 'besoin_discretion' && !empty($action['payload']['target_social']) && $action['payload']['target_social'] === 'visible') {
			$penalty += 10;
		}

		return $penalty;
	}

	protected function exposurePenalty(array $action, array $snapshot, array $decision)
	{
		$fatigue = isset($snapshot['dynamic']['fatigue']) ? (int) $snapshot['dynamic']['fatigue'] : 0;
		$saturation = isset($snapshot['dynamic']['saturation_tactique']) ? (int) $snapshot['dynamic']['saturation_tactique'] : 0;
		$pressure = isset($decision['threat_level']) ? (int) $decision['threat_level'] : 0;
		$penalty = 0;

		if ($action['action_type'] === 'queue_social_message' && $pressure >= 65 && $fatigue >= 55) {
			$penalty += 6;
		}

		if ($action['action_type'] === 'send_raid') {
			$penalty += min(12, (int) round(($fatigue + $saturation + $pressure) / 25));
		}

		return $penalty;
	}
}
