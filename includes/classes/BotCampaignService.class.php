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
			$row['payload'] = $this->decodePayload(isset($row['payload_json']) ? $row['payload_json'] : null);
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

		$actionExecutor = new BotActionExecutor();
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
			$lastExecutionAt = !empty($payload['last_execution_at']) ? (int) $payload['last_execution_at'] : 0;
			$intervalSeconds = max(300, ((int) $campaign['interval_minutes']) * 60);
			if ($lastExecutionAt > 0 && ($lastExecutionAt + $intervalSeconds) > TIMESTAMP) {
				continue;
			}

			$members = $this->getEligibleMembers($campaign);
			if (empty($members)) {
				continue;
			}

			$waveSize = max(1, min(count($members), (int) ceil(max(1, (int) $campaign['intensity']) / 30)));
			$rotationCursor = !empty($payload['rotation_cursor']) ? (int) $payload['rotation_cursor'] : 0;
			$selectedMembers = array();
			for ($index = 0; $index < $waveSize; $index++) {
				$member = $members[($rotationCursor + $index) % count($members)];
				$selectedMembers[] = $member;
			}

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
			$payload['rotation_cursor'] = ($rotationCursor + $waveSize) % max(1, count($members));
			$payload['execution_count'] = !empty($payload['execution_count']) ? ((int) $payload['execution_count'] + 1) : 1;
			$payload['last_selected_members'] = array_map('intval', array_column($selectedMembers, 'bot_user_id'));

			Database::get()->update('UPDATE %%BOT_CAMPAIGNS%% SET
				payload_json = :payloadJson,
				updated_at = :updatedAt
				WHERE id = :id;', array(
				':payloadJson' => json_encode($payload),
				':updatedAt' => TIMESTAMP,
				':id' => (int) $campaign['id'],
			));
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
		$payload = isset($campaign['payload']) ? $campaign['payload'] : array();
		$mode = !empty($payload['mode']) ? trim((string) $payload['mode']) : trim((string) $campaign['campaign_type']);
		$targetCoordinates = !empty($payload['target_coordinates'])
			? $payload['target_coordinates']
			: (!empty($campaign['target_reference']) ? $campaign['target_reference'] : '');
		$targetUsername = !empty($payload['target_username']) ? $payload['target_username'] : '';
		$dueDelay = $memberIndex * max(60, ((int) $campaign['rhythm_minutes']) * 60);
		$actions = array();

		if ($targetCoordinates !== '') {
			$actions[] = array(
				'action_type' => 'send_spy',
				'goal' => 'campagne_'.$mode,
				'utility' => 88,
				'confidence' => 84,
				'estimated_cost' => 8,
				'estimated_risk' => 14,
				'payload' => array_merge($payload, array('target_coordinates' => $targetCoordinates)),
				'justification' => 'Reconnaissance préparatoire de campagne.',
				'due_delay' => $dueDelay,
			);
		}

		if (in_array($campaign['campaign_type'], array('campagne', 'harcelement', 'rotation-attaque', 'vague', 'siege'), true) && $targetCoordinates !== '') {
			$actions[] = array(
				'action_type' => 'send_raid',
				'goal' => 'campagne_'.$mode,
				'utility' => max(80, (int) $campaign['intensity']),
				'confidence' => 78,
				'estimated_cost' => 18,
				'estimated_risk' => in_array($campaign['campaign_type'], array('siege', 'vague'), true) ? 32 : 24,
				'payload' => array_merge($payload, array('target_coordinates' => $targetCoordinates)),
				'justification' => 'Offensive coordonnée de campagne.',
				'due_delay' => $dueDelay + 120,
			);
		}

		if ($targetUsername !== '' || !empty($payload['message'])) {
			$actions[] = array(
				'action_type' => 'queue_social_message',
				'goal' => 'campagne_'.$mode,
				'utility' => 52,
				'confidence' => 76,
				'estimated_cost' => 4,
				'estimated_risk' => 8,
				'payload' => array_merge($payload, array(
					'channel_key' => 'bots',
					'target_username' => $targetUsername,
					'template_key' => in_array($campaign['campaign_type'], array('harcelement', 'siege'), true) ? 'intimidation' : 'pression_locale',
					'target_coordinates' => $targetCoordinates,
				)),
				'justification' => 'Communication de campagne coordonnée.',
				'due_delay' => $dueDelay + 180,
			);
		}

		return $actions;
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
}
