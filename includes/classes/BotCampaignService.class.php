<?php

class BotCampaignService
{
	public function getActiveCampaigns($includePayload = true)
	{
		$rows = Database::get()->select('SELECT *
				FROM %%BOT_CAMPAIGNS%%
				WHERE universe = :universe AND status = :status
				ORDER BY updated_at DESC;', array(
					':universe' => Universe::getEmulated(),
					':status' => 'active',
				));

		if (!$includePayload) {
			return $rows;
		}

		foreach ($rows as &$row) {
			$row['payload'] = $this->normalizePayload($row, $this->decodePayload(isset($row['payload_json']) ? $row['payload_json'] : null));
			$row['members'] = $this->getCampaignMembers((int) $row['id']);
		}
		unset($row);

		return $rows;
	}

	public function createCampaign(array $data)
	{
		$payload = isset($data['payload']) && is_array($data['payload'])
			? $data['payload']
			: (!empty($data['payload_json']) && is_array($data['payload_json']) ? $data['payload_json'] : array());
		$members = !empty($data['member_bot_user_ids']) && is_array($data['member_bot_user_ids']) ? array_values(array_unique(array_map('intval', $data['member_bot_user_ids']))) : array();
		$campaignCode = trim(!empty($data['campaign_code']) ? (string) $data['campaign_code'] : 'campagne-'.substr(md5(TIMESTAMP.'-'.mt_rand(1000, 999999)), 0, 12));

		Database::get()->insert('INSERT INTO %%BOT_CAMPAIGNS%% SET
			universe = :universe,
			campaign_code = :campaignCode,
			label = :label,
			campaign_type = :campaignType,
			status = :status,
			target_type = :targetType,
			target_reference = :targetReference,
			zone_reference = :zoneReference,
			responsible_alliance_meta_id = :responsibleAllianceMetaId,
			responsible_bot_user_id = :responsibleBotUserId,
			rhythm_minutes = :rhythmMinutes,
			interval_minutes = :intervalMinutes,
			duration_minutes = :durationMinutes,
			budget_actions = :budgetActions,
			intensity = :intensity,
			objective_exit = :objectiveExit,
			payload_json = :payloadJson,
			created_at = :createdAt,
			updated_at = :updatedAt;', array(
				':universe' => Universe::getEmulated(),
				':campaignCode' => $campaignCode,
				':label' => trim((string) $data['label']),
				':campaignType' => trim((string) $data['campaign_type']),
				':status' => !empty($data['status']) ? $data['status'] : 'active',
				':targetType' => !empty($data['target_type']) ? $data['target_type'] : '',
				':targetReference' => !empty($data['target_reference']) ? $data['target_reference'] : '',
				':zoneReference' => !empty($data['zone_reference']) ? $data['zone_reference'] : '',
				':responsibleAllianceMetaId' => empty($data['responsible_alliance_meta_id']) ? null : (int) $data['responsible_alliance_meta_id'],
				':responsibleBotUserId' => empty($data['responsible_bot_user_id']) ? null : (int) $data['responsible_bot_user_id'],
				':rhythmMinutes' => max(5, !empty($data['rhythm_minutes']) ? (int) $data['rhythm_minutes'] : 30),
				':intervalMinutes' => max(5, !empty($data['interval_minutes']) ? (int) $data['interval_minutes'] : 15),
				':durationMinutes' => max(30, !empty($data['duration_minutes']) ? (int) $data['duration_minutes'] : 360),
				':budgetActions' => max(1, !empty($data['budget_actions']) ? (int) $data['budget_actions'] : 24),
				':intensity' => max(0, min(100, (int) $data['intensity'])),
				':objectiveExit' => !empty($data['objective_exit']) ? $data['objective_exit'] : '',
				':payloadJson' => json_encode($payload),
				':createdAt' => TIMESTAMP,
				':updatedAt' => TIMESTAMP,
			));

		$campaignId = (int) Database::get()->lastInsertId();
		$campaign = Database::get()->selectSingle('SELECT * FROM %%BOT_CAMPAIGNS%% WHERE id = :id LIMIT 1;', array(
			':id' => $campaignId,
		));

		if (!empty($members)) {
			$this->attachMembers($campaignId, $members);
		}

		return $campaign;
	}

	public function attachMembers($campaignId, array $botUserIds, $roleName = 'membre')
	{
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';

		$presenceService = new BotPresenceService();
		$campaign = Database::get()->selectSingle('SELECT id, status FROM %%BOT_CAMPAIGNS%% WHERE id = :id LIMIT 1;', array(
			':id' => (int) $campaignId,
		));

		if (empty($campaign)) {
			return 0;
		}

		$count = 0;
		foreach (array_values(array_unique(array_map('intval', $botUserIds))) as $botUserId) {
			if ($botUserId <= 0) {
				continue;
			}

			$exists = Database::get()->selectSingle('SELECT id
				FROM %%BOT_CAMPAIGN_MEMBERS%%
				WHERE campaign_id = :campaignId AND bot_user_id = :botUserId
				LIMIT 1;', array(
					':campaignId' => (int) $campaignId,
					':botUserId' => (int) $botUserId,
				));

			if (empty($exists)) {
				Database::get()->insert('INSERT INTO %%BOT_CAMPAIGN_MEMBERS%% SET
					campaign_id = :campaignId,
					bot_user_id = :botUserId,
					squad_id = NULL,
					role_name = :roleName,
					joined_at = :joinedAt;', array(
						':campaignId' => (int) $campaignId,
						':botUserId' => (int) $botUserId,
						':roleName' => (string) $roleName,
						':joinedAt' => TIMESTAMP,
					));
			}

			Database::get()->update('UPDATE %%BOT_STATE%% SET
				current_campaign_id = :campaignId,
				presence_logical = :presenceLogical,
				presence_social = :presenceSocial,
				is_socially_visible = 1,
				updated_at = :updatedAt
				WHERE bot_user_id = :botUserId;', array(
					':campaignId' => (int) $campaignId,
					':presenceLogical' => 'campagne',
					':presenceSocial' => 'campagne',
					':updatedAt' => TIMESTAMP,
					':botUserId' => (int) $botUserId,
				));
			$presenceService->applyPresence((int) $botUserId, 'campagne', 'campagne', 'rattachement_campagne');
			$count++;
		}

		return $count;
	}

	public function getCampaignMembers($campaignId)
	{
		return Database::get()->select('SELECT m.*, u.username
			FROM %%BOT_CAMPAIGN_MEMBERS%% m
			LEFT JOIN %%USERS%% u ON u.id = m.bot_user_id
			WHERE m.campaign_id = :campaignId
			ORDER BY m.id ASC;', array(
				':campaignId' => (int) $campaignId,
			));
	}

	public function maintainActiveCampaigns($budget = 12)
	{
		require_once ROOT_PATH.'includes/classes/BotActionExecutor.class.php';
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';

		$actionExecutor = new BotActionExecutor();
		$journalService = new BotJournalService();
		$campaigns = $this->getActiveCampaigns();
		$queuedActions = 0;
		$updatedCampaigns = 0;

		foreach ($campaigns as $campaign) {
			if ($queuedActions >= $budget) {
				break;
			}

			if ($this->isCampaignExpired($campaign)) {
				$this->closeCampaign((int) $campaign['id'], 'completed', 'Durée de campagne atteinte.');
				continue;
			}

			$payload = isset($campaign['payload']) ? $campaign['payload'] : array();
			$payload = $this->advanceCampaignState($campaign, $payload);
			$lastExecutionAt = !empty($payload['last_execution_at']) ? (int) $payload['last_execution_at'] : 0;
			$intervalSeconds = max(300, ((int) $campaign['interval_minutes']) * 60);
			if (!empty($payload['cooldown_until']) && (int) $payload['cooldown_until'] > TIMESTAMP) {
				$this->persistPayload((int) $campaign['id'], $payload);
				continue;
			}

			if ($lastExecutionAt > 0 && ($lastExecutionAt + $intervalSeconds) > TIMESTAMP) {
				$this->persistPayload((int) $campaign['id'], $payload);
				continue;
			}

			$members = $this->getEligibleMembers($campaign);
			if (empty($members)) {
				$payload['phase'] = 'releve';
				$payload['narrative'] = 'Relève imposée en attente de membres disponibles.';
				$this->persistPayload((int) $campaign['id'], $payload);
				continue;
			}

			$waveSize = $this->computeWaveSize($campaign, $payload, count($members));
			$selectedMembers = $this->selectWaveMembers($members, $payload, $waveSize);

			foreach ($selectedMembers as $memberIndex => $member) {
				if ($queuedActions >= $budget) {
					break 2;
				}

				$actions = $this->buildCampaignActions($campaign, $member, $memberIndex);
				if (empty($actions)) {
					continue;
				}

				$actionExecutor->enqueueActions((int) $member['bot_user_id'], $actions, 'campagne', $campaign['campaign_code']);
				$queuedActions += count($actions);
			}

			$payload['last_execution_at'] = TIMESTAMP;
			$payload['rotation_cursor'] = (($payload['rotation_cursor']) + $waveSize) % max(1, count($members));
			$payload['execution_count'] = !empty($payload['execution_count']) ? ((int) $payload['execution_count'] + 1) : 1;
			$payload['last_selected_members'] = array_map('intval', array_column($selectedMembers, 'bot_user_id'));
			$payload['last_wave_size'] = count($selectedMembers);
			$payload['last_queued_actions'] = max(0, $queuedActions);
			$this->persistPayload((int) $campaign['id'], $payload);
			$journalService->logActivity(
				!empty($campaign['responsible_bot_user_id']) ? (int) $campaign['responsible_bot_user_id'] : 0,
				'campagne',
				sprintf('Campagne %s en phase %s, mode %s, %d bot(s) relayé(s).', $campaign['campaign_code'], $payload['phase'], $payload['mode'], count($selectedMembers)),
				array(
					'campaign_id' => (int) $campaign['id'],
					'campaign_code' => $campaign['campaign_code'],
					'phase' => $payload['phase'],
					'mode' => $payload['mode'],
					'narrative' => $payload['narrative'],
					'selected_members' => $payload['last_selected_members'],
				)
			);
			$updatedCampaigns++;
		}

		return array(
			'active_campaigns' => count($campaigns),
			'updated_campaigns' => $updatedCampaigns,
			'queued_actions' => $queuedActions,
		);
	}

	public function recoverCampaigns()
	{
		$completed = 0;
		foreach ($this->getActiveCampaigns() as $campaign) {
			if ($this->isCampaignExpired($campaign)) {
				$this->closeCampaign((int) $campaign['id'], 'completed', 'Campagne clôturée par la maintenance.');
				$completed++;
			}
		}

		return $completed;
	}

	public function closeCampaign($campaignId, $status, $reason = '')
	{
		Database::get()->update('UPDATE %%BOT_CAMPAIGNS%% SET
			status = :status,
			updated_at = :updatedAt
			WHERE id = :id;', array(
			':status' => (string) $status,
			':updatedAt' => TIMESTAMP,
			':id' => (int) $campaignId,
		));

		Database::get()->update('UPDATE %%BOT_STATE%% SET
			current_campaign_id = NULL,
			updated_at = :updatedAt
			WHERE current_campaign_id = :campaignId;', array(
			':updatedAt' => TIMESTAMP,
			':campaignId' => (int) $campaignId,
		));

		if ($reason !== '') {
			$campaign = Database::get()->selectSingle('SELECT responsible_bot_user_id FROM %%BOT_CAMPAIGNS%% WHERE id = :id LIMIT 1;', array(
				':id' => (int) $campaignId,
			));
			if (!empty($campaign['responsible_bot_user_id'])) {
				Database::get()->insert('INSERT INTO %%BOT_ACTIVITY%% SET
					bot_user_id = :botUserId,
					universe = :universe,
					activity_type = :activityType,
					activity_summary = :activitySummary,
					activity_payload = :activityPayload,
					created_at = :createdAt;', array(
						':botUserId' => (int) $campaign['responsible_bot_user_id'],
						':universe' => Universe::getEmulated(),
						':activityType' => 'campagne',
						':activitySummary' => $reason,
						':activityPayload' => json_encode(array('campaign_id' => (int) $campaignId, 'status' => (string) $status)),
						':createdAt' => TIMESTAMP,
					));
			}
		}
	}

	protected function getEligibleMembers(array $campaign)
	{
		return Database::get()->select('SELECT m.bot_user_id, u.username
			FROM %%BOT_CAMPAIGN_MEMBERS%% m
			INNER JOIN %%USERS%% u ON u.id = m.bot_user_id
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE m.campaign_id = :campaignId
			  AND (bs.paused_until IS NULL OR bs.paused_until <= :now)
			  AND (bs.cooldown_until IS NULL OR bs.cooldown_until <= :now)
			ORDER BY COALESCE(bs.last_action_at, 0) ASC, m.id ASC;', array(
				':campaignId' => (int) $campaign['id'],
				':now' => TIMESTAMP,
			));
	}

	protected function buildCampaignActions(array $campaign, array $member, $memberIndex)
	{
		$payload = $this->normalizePayload($campaign, isset($campaign['payload']) ? $campaign['payload'] : array());
		$mode = $payload['mode'];
		$phase = $payload['phase'];
		$targetCoordinates = !empty($payload['target_coordinates'])
			? $payload['target_coordinates']
			: (!empty($campaign['target_reference']) ? $campaign['target_reference'] : '');
		$targetUsername = !empty($payload['target_username']) ? $payload['target_username'] : '';
		$dueDelay = $memberIndex * max(60, ((int) $campaign['rhythm_minutes']) * 60);
		$actions = array();

		if ($targetCoordinates !== '' && in_array($phase, array('observation', 'preparation', 'pression', 'exploitation', 'faux_calme'), true)) {
			$actions[] = array(
				'action_type' => 'send_spy',
				'goal' => 'campagne_'.$mode,
				'utility' => in_array($phase, array('pression', 'exploitation'), true) ? 82 : 88,
				'confidence' => 84,
				'estimated_cost' => 8,
				'estimated_risk' => in_array($phase, array('pression', 'exploitation'), true) ? 18 : 12,
				'payload' => array_merge($payload, array('target_coordinates' => $targetCoordinates, 'campaign_phase' => $phase)),
				'justification' => sprintf('Reconnaissance de campagne en phase %s.', $phase),
				'due_delay' => $dueDelay,
			);
		}

		if ($targetCoordinates !== '' && in_array($phase, array('pression', 'exploitation'), true) && !in_array($mode, array('test', 'pression_silencieuse'), true)) {
			$actions[] = array(
				'action_type' => 'send_raid',
				'goal' => 'campagne_'.$mode,
				'utility' => max(80, min(98, (int) $payload['effective_intensity'])),
				'confidence' => $phase === 'exploitation' ? 84 : 78,
				'estimated_cost' => $phase === 'exploitation' ? 22 : 18,
				'estimated_risk' => in_array($mode, array('siege', 'saturation_alternee'), true) ? 34 : 24,
				'payload' => array_merge($payload, array('target_coordinates' => $targetCoordinates, 'campaign_phase' => $phase)),
				'justification' => sprintf('Offensive coordonnée de campagne en phase %s.', $phase),
				'due_delay' => $dueDelay + 120,
			);
		}

		if (in_array($phase, array('preparation', 'pression', 'exploitation', 'faux_calme', 'releve'), true)) {
			$actions[] = array(
				'action_type' => 'presence_ping',
				'goal' => 'campagne_'.$mode,
				'utility' => $phase === 'releve' ? 66 : 58,
				'confidence' => 80,
				'estimated_cost' => 2,
				'estimated_risk' => 3,
				'payload' => array_merge($payload, array('campaign_phase' => $phase)),
				'justification' => 'Maintien de présence pour la relève et la continuité visible.',
				'due_delay' => $dueDelay + 60,
			);
		}

		if (($targetUsername !== '' || !empty($payload['message'])) && !in_array($mode, array('test'), true)) {
			$messageAction = $targetUsername !== '' && in_array($mode, array('intimidation', 'pression_silencieuse', 'chasse_ciblee'), true)
				? 'queue_private_message'
				: 'queue_social_message';
			$actions[] = array(
				'action_type' => $messageAction,
				'goal' => 'campagne_'.$mode,
				'utility' => in_array($phase, array('pression', 'exploitation'), true) ? 58 : 46,
				'confidence' => 76,
				'estimated_cost' => 4,
				'estimated_risk' => in_array($mode, array('intimidation', 'chasse_ciblee'), true) ? 12 : 8,
				'payload' => array_merge($payload, array(
					'channel_key' => 'bots',
					'target_username' => $targetUsername,
					'template_key' => $this->resolveCommunicationTemplate($mode, $phase),
					'target_coordinates' => $targetCoordinates,
					'campaign_phase' => $phase,
				)),
				'justification' => sprintf('Communication de campagne %s en phase %s.', $mode, $phase),
				'due_delay' => $dueDelay + 180,
			);
		}

		return array_slice($actions, 0, 3);
	}

	protected function isCampaignExpired(array $campaign)
	{
		$startedAt = !empty($campaign['created_at']) ? (int) $campaign['created_at'] : TIMESTAMP;
		$durationSeconds = max(1800, ((int) $campaign['duration_minutes']) * 60);
		return ($startedAt + $durationSeconds) <= TIMESTAMP;
	}

	protected function decodePayload($payloadJson)
	{
		if (empty($payloadJson)) {
			return array();
		}

		$decoded = json_decode($payloadJson, true);
		return is_array($decoded) ? $decoded : array();
	}

	protected function normalizePayload(array $campaign, array $payload)
	{
		$mode = !empty($payload['mode']) ? trim((string) $payload['mode']) : trim((string) $campaign['campaign_type']);
		$modeMap = array(
			'campagne' => 'usure',
			'harcelement' => 'intimidation',
			'rotation-attaque' => 'saturation_alternee',
			'vague' => 'demonstration',
			'siege' => 'siege',
		);
		$mode = isset($modeMap[$mode]) ? $modeMap[$mode] : $mode;
		$phase = !empty($payload['phase']) ? trim((string) $payload['phase']) : 'observation';
		$relayStrategy = !empty($payload['relay_strategy']) ? trim((string) $payload['relay_strategy']) : 'rotation_continue';
		$visibility = !empty($payload['visibility_strategy']) ? trim((string) $payload['visibility_strategy']) : 'visible';
		$communication = !empty($payload['communication_strategy']) ? trim((string) $payload['communication_strategy']) : 'pression';
		$effectiveIntensity = isset($payload['effective_intensity']) ? (int) $payload['effective_intensity'] : (int) $campaign['intensity'];

		return array_merge(array(
			'mode' => $mode,
			'phase' => $phase,
			'relay_strategy' => $relayStrategy,
			'visibility_strategy' => $visibility,
			'communication_strategy' => $communication,
			'rotation_cursor' => !empty($payload['rotation_cursor']) ? (int) $payload['rotation_cursor'] : 0,
			'execution_count' => !empty($payload['execution_count']) ? (int) $payload['execution_count'] : 0,
			'last_selected_members' => !empty($payload['last_selected_members']) && is_array($payload['last_selected_members']) ? array_values(array_unique(array_map('intval', $payload['last_selected_members']))) : array(),
			'false_calm_every' => !empty($payload['false_calm_every']) ? max(2, (int) $payload['false_calm_every']) : 4,
			'pause_minutes' => !empty($payload['pause_minutes']) ? max(5, (int) $payload['pause_minutes']) : 18,
			'effective_intensity' => max(15, min(100, $effectiveIntensity)),
			'narrative' => !empty($payload['narrative']) ? (string) $payload['narrative'] : 'Campagne active en surveillance.',
		), $payload);
	}

	protected function advanceCampaignState(array $campaign, array $payload)
	{
		$payload = $this->normalizePayload($campaign, $payload);
		$ageMinutes = max(0, (int) floor((TIMESTAMP - (int) $campaign['created_at']) / 60));
		$executionCount = (int) $payload['execution_count'];
		$phase = 'observation';

		if (!empty($payload['cooldown_until']) && (int) $payload['cooldown_until'] > TIMESTAMP) {
			$phase = 'faux_calme';
		} elseif ($ageMinutes >= 20 || $executionCount >= 2) {
			$phase = 'preparation';
		}

		if ($ageMinutes >= 45 || $executionCount >= 4) {
			$phase = 'pression';
		}

		if ($ageMinutes >= 90 || $executionCount >= 7) {
			$phase = 'exploitation';
		}

		if ($executionCount > 0 && ($executionCount % max(2, (int) $payload['false_calm_every'])) === 0) {
			$phase = 'faux_calme';
			$payload['cooldown_until'] = TIMESTAMP + (((int) $payload['pause_minutes']) * 60);
		}

		if (in_array($payload['mode'], array('test', 'pression_silencieuse'), true)) {
			$phase = $executionCount >= 3 ? 'releve' : ($executionCount >= 1 ? 'preparation' : 'observation');
		}

		if ($payload['mode'] === 'siege' && $executionCount >= 2) {
			$phase = ($executionCount % 3 === 0) ? 'releve' : 'pression';
		}

		if ($payload['mode'] === 'saturation_alternee' && $executionCount >= 1) {
			$phase = ($executionCount % 2 === 0) ? 'pression' : 'releve';
		}

		$payload['phase'] = $phase;
		$payload['effective_intensity'] = $this->computeEffectiveIntensity($campaign, $payload, $phase);
		$payload['narrative'] = $this->buildCampaignNarrative($payload['mode'], $phase, $payload['effective_intensity']);
		$payload['last_state_refresh_at'] = TIMESTAMP;

		return $payload;
	}

	protected function computeEffectiveIntensity(array $campaign, array $payload, $phase)
	{
		$intensity = (int) $campaign['intensity'];
		$modeAdjustments = array(
			'test' => -18,
			'usure' => 8,
			'intimidation' => 12,
			'siege' => 18,
			'demonstration' => 10,
			'saturation_alternee' => 16,
			'chasse_ciblee' => 14,
			'pression_silencieuse' => -10,
		);
		$phaseAdjustments = array(
			'observation' => -12,
			'preparation' => -4,
			'pression' => 8,
			'exploitation' => 15,
			'faux_calme' => -20,
			'releve' => -8,
		);

		$intensity += isset($modeAdjustments[$payload['mode']]) ? $modeAdjustments[$payload['mode']] : 0;
		$intensity += isset($phaseAdjustments[$phase]) ? $phaseAdjustments[$phase] : 0;

		return max(15, min(100, $intensity));
	}

	protected function buildCampaignNarrative($mode, $phase, $intensity)
	{
		$modeLabels = array(
			'test' => 'test de réaction',
			'usure' => 'usure graduelle',
			'intimidation' => 'intimidation contrôlée',
			'siege' => 'siège prolongé',
			'demonstration' => 'démonstration de force',
			'saturation_alternee' => 'saturation alternée',
			'chasse_ciblee' => 'chasse ciblée',
			'pression_silencieuse' => 'pression silencieuse',
		);
		$phaseLabels = array(
			'observation' => 'observation',
			'preparation' => 'préparation',
			'pression' => 'pression',
			'exploitation' => 'exploitation',
			'faux_calme' => 'faux calme',
			'releve' => 'relève',
		);

		return sprintf(
			'%s en phase %s avec intensité %d.',
			isset($modeLabels[$mode]) ? $modeLabels[$mode] : $mode,
			isset($phaseLabels[$phase]) ? $phaseLabels[$phase] : $phase,
			(int) $intensity
		);
	}

	protected function computeWaveSize(array $campaign, array $payload, $memberCount)
	{
		$wave = max(1, min((int) $memberCount, (int) ceil(max(1, (int) $payload['effective_intensity']) / 30)));
		if ($payload['phase'] === 'releve') {
			return max(1, min($wave, 2));
		}
		if ($payload['phase'] === 'exploitation') {
			return min((int) $memberCount, $wave + 1);
		}

		return $wave;
	}

	protected function selectWaveMembers(array $members, array $payload, $waveSize)
	{
		$rotationCursor = !empty($payload['rotation_cursor']) ? (int) $payload['rotation_cursor'] : 0;
		$lastSelected = !empty($payload['last_selected_members']) ? array_map('intval', $payload['last_selected_members']) : array();
		$ordered = array();

		for ($index = 0, $count = count($members); $index < $count; $index++) {
			$ordered[] = $members[($rotationCursor + $index) % $count];
		}

		if (count($ordered) > $waveSize && !empty($lastSelected)) {
			usort($ordered, function ($left, $right) use ($lastSelected) {
				$leftPenalty = in_array((int) $left['bot_user_id'], $lastSelected, true) ? 1 : 0;
				$rightPenalty = in_array((int) $right['bot_user_id'], $lastSelected, true) ? 1 : 0;
				if ($leftPenalty === $rightPenalty) {
					return (int) $left['bot_user_id'] <=> (int) $right['bot_user_id'];
				}
				return $leftPenalty < $rightPenalty ? -1 : 1;
			});
		}

		return array_slice($ordered, 0, max(1, (int) $waveSize));
	}

	protected function resolveCommunicationTemplate($mode, $phase)
	{
		if (in_array($mode, array('intimidation', 'chasse_ciblee'), true)) {
			return 'intimidation';
		}
		if ($phase === 'faux_calme') {
			return 'brouillage';
		}
		if ($phase === 'releve') {
			return 'presence_continue';
		}

		return 'pression_locale';
	}

	protected function persistPayload($campaignId, array $payload)
	{
		Database::get()->update('UPDATE %%BOT_CAMPAIGNS%% SET
			payload_json = :payloadJson,
			updated_at = :updatedAt
			WHERE id = :id;', array(
			':payloadJson' => json_encode($payload),
			':updatedAt' => TIMESTAMP,
			':id' => (int) $campaignId,
		));
	}
}
