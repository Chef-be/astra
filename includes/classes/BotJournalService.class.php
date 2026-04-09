<?php

class BotJournalService
{
	public function logActivity($botUserId, $type, $summary, array $payload = array())
	{
		$summary = $this->truncateText($summary, 250);

		Database::get()->insert('INSERT INTO %%BOT_ACTIVITY%% SET
			bot_user_id = :botUserId,
			universe = :universe,
			activity_type = :activityType,
			activity_summary = :activitySummary,
			activity_payload = :activityPayload,
			created_at = :createdAt;', array(
				':botUserId' => empty($botUserId) ? 0 : (int) $botUserId,
				':universe' => Universe::getEmulated(),
				':activityType' => (string) $type,
				':activitySummary' => (string) $summary,
				':activityPayload' => empty($payload) ? null : json_encode($payload),
				':createdAt' => TIMESTAMP,
			));
	}

	public function logDecision($botUserId, array $context)
	{
		if (!empty($context['ordre_hierarchique'])) {
			$context['ordre_hierarchique'] = $this->truncateText($context['ordre_hierarchique'], 64);
		}
		if (!empty($context['opportunite_dominante'])) {
			$context['opportunite_dominante'] = $this->truncateText($context['opportunite_dominante'], 48);
		}
		if (!empty($context['next_step'])) {
			$context['next_step'] = $this->truncateText($context['next_step'], 72);
		}

		$summary = sprintf(
			'%s [%s/%s] besoin=%s opportunité=%s ordre=%s action=%s confiance=%d risque=%d suite=%s.',
			isset($context['bot_name']) ? $context['bot_name'] : 'Bot',
			isset($context['role']) ? $context['role'] : 'membre',
			isset($context['etat']) ? $context['etat'] : 'latent',
			isset($context['besoin_dominant']) ? $context['besoin_dominant'] : 'stabilisation',
			isset($context['opportunite_dominante']) ? $context['opportunite_dominante'] : 'aucune',
			isset($context['ordre_hierarchique']) ? $context['ordre_hierarchique'] : 'aucun',
			isset($context['action']) ? $context['action'] : 'aucune action',
			isset($context['confidence']) ? (int) $context['confidence'] : 0,
			isset($context['risk']) ? (int) $context['risk'] : 0,
			isset($context['next_step']) ? $context['next_step'] : 'veille'
		);

		$this->logActivity($botUserId, 'decision', $summary, $context);
	}

	public function openRun($phase, array $summary = array())
	{
		$lockToken = md5($phase.'-'.TIMESTAMP.'-'.mt_rand(1000, 999999));
		Database::get()->insert('INSERT INTO %%BOT_ENGINE_RUNS%% SET
			universe = :universe,
			phase = :phase,
			status = :status,
			lock_name = :lockName,
			lock_token = :lockToken,
			started_at = :startedAt,
			summary_json = :summaryJson;', array(
				':universe' => Universe::getEmulated(),
				':phase' => (string) $phase,
				':status' => 'running',
				':lockName' => 'bot_engine_'.Universe::getEmulated().'_'.$phase,
				':lockToken' => $lockToken,
				':startedAt' => TIMESTAMP,
				':summaryJson' => json_encode($summary),
			));

		return array(
			'id' => (int) Database::get()->lastInsertId(),
			'lock_token' => $lockToken,
		);
	}

	public function closeRun($runId, $status, array $summary = array(), $selectedBots = 0, $executedActions = 0, $errorSummary = null)
	{
		$errorSummary = $this->truncateText($errorSummary, 245);
		Database::get()->update('UPDATE %%BOT_ENGINE_RUNS%% SET
			status = :status,
			finished_at = :finishedAt,
			selected_bots = :selectedBots,
			executed_actions = :executedActions,
			summary_json = :summaryJson,
			error_summary = :errorSummary
			WHERE id = :id;', array(
				':status' => (string) $status,
				':finishedAt' => TIMESTAMP,
				':selectedBots' => (int) $selectedBots,
				':executedActions' => (int) $executedActions,
				':summaryJson' => json_encode($summary),
				':errorSummary' => $errorSummary,
				':id' => (int) $runId,
			));
	}

	protected function truncateText($value, $maxLength)
	{
		if ($value === null) {
			return null;
		}

		$value = (string) $value;
		if (strlen($value) <= (int) $maxLength) {
			return $value;
		}

		return substr($value, 0, max(0, (int) $maxLength - 3)).'...';
	}
}
