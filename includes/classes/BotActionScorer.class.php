<?php

class BotActionScorer
{
	public function score(array $actions, array $snapshot, array $decision)
	{
		$profileDoctrine = isset($snapshot['bot']['doctrine']) ? $snapshot['bot']['doctrine'] : '';
		$role = isset($snapshot['state']['role_primary']) ? $snapshot['state']['role_primary'] : 'economiste';
		$campaignBoost = empty($snapshot['campaigns']) ? 0 : 10;
		$results = array();

		foreach ($actions as $action) {
			$coherenceProfile = $this->profileCoherence($action['action_type'], $profileDoctrine, $role);
			$coherenceDoctrine = $this->doctrineCoherence($action['action_type'], $profileDoctrine);
			$coherenceRole = $this->roleCoherence($action['action_type'], $role);
			$bestTarget = !empty($snapshot['best_target']) ? $snapshot['best_target'] : array();
			$zoneContext = isset($snapshot['zone_context']['current_zone']) ? $snapshot['zone_context']['current_zone'] : array();
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
			$psychologicalValue = min(12, isset($bestTarget['psychological_score']) ? (int) round($bestTarget['psychological_score'] / 10) : 0);
			$continuityValue = $this->continuityValue($action, $decision, $snapshot);
			$informationValue = $this->informationValue($action, $bestTarget);

			$utility = (float) $action['benefit']
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
				+ $informationValue
				+ $faisabilite
				+ min(10, (float) $action['confidence'] / 10)
				- (float) $cost
				- (float) $action['risk']
				- $chargeLogistique
				- $queuePenalty;
			$utility -= $cooldownPenalty;
			$utility -= $tacticalPenalty;

			$action['utility'] = round($utility, 2);
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
}
