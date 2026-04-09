<?php

class BotActionExecutor
{
	protected $journalService;
	protected $dynamicStateService;
	protected $traitService;
	protected $messagingService;
	protected $presenceService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';
		require_once ROOT_PATH.'includes/classes/BotDynamicStateService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTraitService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMessagingService.class.php';
		require_once ROOT_PATH.'includes/classes/BotPresenceService.class.php';
		require_once ROOT_PATH.'includes/classes/class.PlanetRessUpdate.php';
		require_once ROOT_PATH.'includes/classes/class.BuildFunctions.php';
		require_once ROOT_PATH.'includes/classes/class.FleetFunctions.php';

		$this->journalService = new BotJournalService();
		$this->dynamicStateService = new BotDynamicStateService();
		$this->traitService = new BotTraitService();
		$this->messagingService = new BotMessagingService();
		$this->presenceService = new BotPresenceService();
	}

	public function enqueueActions($botUserId, array $actions, $sourceType = 'engine', $sourceReference = '')
	{
		$db = Database::get();
		$queuedCount = (int) $db->selectSingle('SELECT COUNT(*) AS total
			FROM %%BOT_ACTION_QUEUE%%
			WHERE bot_user_id = :botUserId
			  AND status = \'queued\';', array(
				':botUserId' => (int) $botUserId,
			), 'total');

			foreach ($actions as $action) {
			$payload = isset($action['payload']) && is_array($action['payload']) ? $action['payload'] : array();
			$payloadJson = json_encode($payload);
			if ($this->shouldSkipQueueInsertion((int) $botUserId, $action, $payloadJson, $queuedCount)) {
				continue;
			}

			$plannedAt = isset($action['planned_at']) ? (int) $action['planned_at'] : TIMESTAMP;
			if (!empty($action['due_delay'])) {
				$plannedAt += max(0, (int) $action['due_delay']);
			}
			$dueAt = isset($action['due_at']) ? (int) $action['due_at'] : $plannedAt;

			$db->insert('INSERT INTO %%BOT_ACTION_QUEUE%% SET
				universe = :universe,
				bot_user_id = :botUserId,
				source_type = :sourceType,
				source_reference = :sourceReference,
				action_type = :actionType,
				objective_type = :objectiveType,
				priority = :priority,
				planned_at = :plannedAt,
				due_at = :dueAt,
				status = :status,
				estimated_cost = :estimatedCost,
				estimated_risk = :estimatedRisk,
				confidence = :confidence,
				payload_json = :payloadJson,
				justification = :justification;', array(
					':universe' => Universe::getEmulated(),
					':botUserId' => (int) $botUserId,
					':sourceType' => (string) $sourceType,
					':sourceReference' => (string) $sourceReference,
					':actionType' => (string) $action['action_type'],
					':objectiveType' => isset($action['goal']) ? (string) $action['goal'] : '',
					':priority' => max(1, min(100, (int) round($action['utility']))),
					':plannedAt' => $plannedAt,
					':dueAt' => $dueAt,
					':status' => 'queued',
					':estimatedCost' => isset($action['estimated_cost']) ? (float) $action['estimated_cost'] : 0,
					':estimatedRisk' => isset($action['estimated_risk']) ? (float) $action['estimated_risk'] : 0,
					':confidence' => isset($action['confidence']) ? (int) $action['confidence'] : 0,
					':payloadJson' => $payloadJson,
					':justification' => isset($action['justification']) ? (string) $action['justification'] : '',
				));
			$queuedCount++;
		}

		$db->update('UPDATE %%BOT_STATE%% SET action_queue_size = (
			SELECT COUNT(*) FROM %%BOT_ACTION_QUEUE%% WHERE bot_user_id = :botUserId AND status = \'queued\'
		), updated_at = :updatedAt WHERE bot_user_id = :botUserId;', array(
			':botUserId' => (int) $botUserId,
			':updatedAt' => TIMESTAMP,
		));
	}

	public function executeQueued($limit = 12)
	{
		$db = Database::get();
		$actions = $db->select('SELECT *
			FROM %%BOT_ACTION_QUEUE%%
			WHERE universe = :universe
			  AND status = \'queued\'
			  AND COALESCE(due_at, planned_at) <= :now
			ORDER BY priority DESC, id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
				':limit' => (int) $limit,
			));

		$executed = 0;
		foreach ($actions as $action) {
			$payload = !empty($action['payload_json']) ? json_decode($action['payload_json'], true) : array();
			if (!is_array($payload)) {
				$payload = array();
			}

			$db->update('UPDATE %%BOT_ACTION_QUEUE%% SET status = :status, locked_at = :lockedAt, started_at = :startedAt WHERE id = :id AND status = \'queued\';', array(
				':status' => 'running',
				':lockedAt' => TIMESTAMP,
				':startedAt' => TIMESTAMP,
				':id' => (int) $action['id'],
			));

				$result = $this->executeAction($action);
				$isDeferred = empty($result['success']) && !empty($result['defer']);
				$queueStatus = $isDeferred ? 'queued' : (!empty($result['success']) ? 'done' : 'failed');
				$resultStatus = $isDeferred ? 'deferred' : $queueStatus;
				$retryAt = !empty($result['retry_at']) ? (int) $result['retry_at'] : TIMESTAMP;

				if ($isDeferred) {
					$db->update('UPDATE %%BOT_ACTION_QUEUE%% SET
						status = :status,
						locked_at = NULL,
						started_at = NULL,
						due_at = :dueAt,
						finished_at = NULL,
						result_summary = :resultSummary
						WHERE id = :id;', array(
							':status' => 'queued',
							':dueAt' => $retryAt,
							':resultSummary' => isset($result['summary']) ? $result['summary'] : 'Action reportée.',
							':id' => (int) $action['id'],
						));
				} else {
					$db->update('UPDATE %%BOT_ACTION_QUEUE%% SET
						status = :status,
						finished_at = :finishedAt,
						result_summary = :resultSummary
						WHERE id = :id;', array(
							':status' => $queueStatus,
							':finishedAt' => TIMESTAMP,
							':resultSummary' => isset($result['summary']) ? $result['summary'] : 'Action exécutée.',
							':id' => (int) $action['id'],
						));
				}

				$db->insert('INSERT INTO %%BOT_ACTION_RESULTS%% SET
					action_queue_id = :actionQueueId,
				universe = :universe,
				bot_user_id = :botUserId,
				status = :status,
				result_json = :resultJson,
				created_at = :createdAt;', array(
					':actionQueueId' => (int) $action['id'],
					':universe' => Universe::getEmulated(),
					':botUserId' => (int) $action['bot_user_id'],
						':status' => $resultStatus,
						':resultJson' => json_encode($result),
						':createdAt' => TIMESTAMP,
					));

			$cooldownUntil = !empty($result['cooldown_until'])
				? (int) $result['cooldown_until']
				: (TIMESTAMP + (!empty($result['cooldown']) ? (int) $result['cooldown'] : 120));
			$sessionRestUntil = !empty($result['session_rest_until']) ? (int) $result['session_rest_until'] : null;

			$db->update('UPDATE %%BOT_STATE%% SET
				last_action_at = :lastActionAt,
				cooldown_until = :cooldownUntil,
				session_rest_until = :sessionRestUntil,
				action_queue_size = (
					SELECT COUNT(*) FROM %%BOT_ACTION_QUEUE%% WHERE bot_user_id = :botUserId AND status = \'queued\'
				),
				updated_at = :updatedAt
				WHERE bot_user_id = :botUserId;', array(
					':lastActionAt' => TIMESTAMP,
					':cooldownUntil' => $cooldownUntil,
					':sessionRestUntil' => $sessionRestUntil,
					':botUserId' => (int) $action['bot_user_id'],
					':updatedAt' => TIMESTAMP,
				));

			if (!empty($result['dynamic_delta']) && is_array($result['dynamic_delta'])) {
				$this->dynamicStateService->applyDelta((int) $action['bot_user_id'], $result['dynamic_delta']);
			}
				if (!$isDeferred) {
					$this->traitService->applyActionFeedback(
						(int) $action['bot_user_id'],
						$action['action_type'],
						$queueStatus === 'done',
						isset($action['objective_type']) ? $action['objective_type'] : '',
						$payload
					);
				}

				if ($queueStatus !== 'failed' && $sessionRestUntil !== null && $sessionRestUntil > TIMESTAMP + 60) {
					$this->presenceService->applyPresence((int) $action['bot_user_id'], 'latent', 'discret', 'attente_action', false, array(
						'session_started_at' => null,
						'session_target_until' => null,
					'session_rest_until' => $sessionRestUntil,
					'force_snapshot' => true,
				));
			}

			$this->journalService->logActivity((int) $action['bot_user_id'], 'execution', isset($result['summary']) ? $result['summary'] : 'Action exécutée.', array(
				'action_type' => $action['action_type'],
				'queue_id' => (int) $action['id'],
				'result' => $result,
			));
			$executed++;
		}

		return $executed;
	}

	public function recoverStaleActions($maxRuntime = 1800)
	{
		$threshold = TIMESTAMP - max(300, (int) $maxRuntime);
		$stale = Database::get()->update('UPDATE %%BOT_ACTION_QUEUE%% SET
			status = :status,
			finished_at = :finishedAt,
			result_summary = :resultSummary
			WHERE universe = :universe
			  AND status = \'running\'
			  AND started_at IS NOT NULL
			  AND started_at <= :threshold;', array(
			':status' => 'failed',
			':finishedAt' => TIMESTAMP,
			':resultSummary' => 'Action abandonnée par la maintenance après dépassement du délai maximal.',
			':universe' => Universe::getEmulated(),
			':threshold' => $threshold,
		));

		Database::get()->update('UPDATE %%BOT_STATE%% SET
			action_queue_size = (
				SELECT COUNT(*) FROM %%BOT_ACTION_QUEUE%% q
				WHERE q.bot_user_id = %%BOT_STATE%%.bot_user_id
				  AND q.status = \'queued\'
			),
			updated_at = :updatedAt
			WHERE universe = :universe;', array(
			':updatedAt' => TIMESTAMP,
			':universe' => Universe::getEmulated(),
		));

		return (int) $stale;
	}

	public function compactQueue($maxQueuedPerBot = 12)
	{
		$db = Database::get();
		$rows = $db->select('SELECT id, bot_user_id, action_type, objective_type, payload_json, priority
			FROM %%BOT_ACTION_QUEUE%%
			WHERE universe = :universe
			  AND status = \'queued\'
			ORDER BY bot_user_id ASC, priority DESC, id ASC;', array(
				':universe' => Universe::getEmulated(),
			));

		$keepByBot = array();
		$seen = array();
		$deleteIds = array();
		foreach ($rows as $row) {
			$botUserId = (int) $row['bot_user_id'];
			if (!isset($keepByBot[$botUserId])) {
				$keepByBot[$botUserId] = 0;
			}

			$signature = $this->buildQueueSignature($row['action_type'], $row['objective_type'], $row['payload_json']);
			if (isset($seen[$botUserId][$signature])) {
				$deleteIds[] = (int) $row['id'];
				continue;
			}

			if ($keepByBot[$botUserId] >= (int) $maxQueuedPerBot) {
				$deleteIds[] = (int) $row['id'];
				continue;
			}

			$seen[$botUserId][$signature] = true;
			$keepByBot[$botUserId]++;
		}

		if (!empty($deleteIds)) {
			$db->delete('DELETE FROM %%BOT_ACTION_QUEUE%% WHERE id IN ('.implode(',', array_map('intval', $deleteIds)).');');
			$db->update('UPDATE %%BOT_STATE%% SET
				action_queue_size = (
					SELECT COUNT(*) FROM %%BOT_ACTION_QUEUE%% q
					WHERE q.bot_user_id = %%BOT_STATE%%.bot_user_id
					  AND q.status = \'queued\'
				),
				updated_at = :updatedAt
				WHERE universe = :universe;', array(
				':updatedAt' => TIMESTAMP,
				':universe' => Universe::getEmulated(),
			));
		}

		return count($deleteIds);
	}

	public function purgeHistoricalFailures($maxAgeSeconds = 21600, $keepRecentPerSignature = 1)
	{
		$db = Database::get();
		$threshold = TIMESTAMP - max(3600, (int) $maxAgeSeconds);
		$rows = $db->select('SELECT id, bot_user_id, action_type, result_summary, finished_at
			FROM %%BOT_ACTION_QUEUE%%
			WHERE universe = :universe
			  AND status = \'failed\'
			  AND finished_at IS NOT NULL
			  AND finished_at <= :threshold
			ORDER BY bot_user_id ASC, action_type ASC, result_summary ASC, finished_at DESC, id DESC;', array(
				':universe' => Universe::getEmulated(),
				':threshold' => $threshold,
			));

		$kept = array();
		$deleteIds = array();
		$obsoleteSummaries = array(
			'Pré-requis du chantier non atteints.',
			'Ressources insuffisantes pour lancer ce bâtiment.',
			'Recherche indisponible pour ce bot.',
		);
		foreach ($rows as $row) {
			if (in_array((string) $row['result_summary'], $obsoleteSummaries, true)) {
				$deleteIds[] = (int) $row['id'];
				continue;
			}

			$signature = implode('|', array(
				(int) $row['bot_user_id'],
				(string) $row['action_type'],
				(string) $row['result_summary'],
			));
			if (!isset($kept[$signature])) {
				$kept[$signature] = 0;
			}

			if ($kept[$signature] >= max(0, (int) $keepRecentPerSignature)) {
				$deleteIds[] = (int) $row['id'];
				continue;
			}

			$kept[$signature]++;
		}

		if (!empty($deleteIds)) {
			$db->delete('DELETE FROM %%BOT_ACTION_QUEUE%% WHERE id IN ('.implode(',', array_map('intval', $deleteIds)).');');
		}

		return count($deleteIds);
	}

	protected function executeAction(array $action)
	{
		$payload = !empty($action['payload_json']) ? json_decode($action['payload_json'], true) : array();
		if (!is_array($payload)) {
			$payload = array();
		}

		switch ($action['action_type']) {
			case 'enqueue_building':
				return $this->enqueueBuilding((int) $action['bot_user_id'], (int) $payload['element_id']);
			case 'enqueue_research':
				return $this->enqueueResearch((int) $action['bot_user_id'], (int) $payload['element_id']);
			case 'enqueue_shipyard':
				return $this->enqueueShipyard((int) $action['bot_user_id'], (int) $payload['element_id'], max(1, (int) $payload['amount']));
			case 'send_spy':
				return $this->sendSpy((int) $action['bot_user_id'], isset($payload['target_coordinates']) ? $payload['target_coordinates'] : '');
			case 'send_raid':
				return $this->sendRaid((int) $action['bot_user_id'], isset($payload['target_coordinates']) ? $payload['target_coordinates'] : '');
			case 'queue_private_message':
				return $this->queuePrivateMessageAction((int) $action['bot_user_id'], $payload);
			case 'queue_social_message':
				return $this->queueSocialMessageAction((int) $action['bot_user_id'], $payload);
			case 'presence_ping':
				return $this->applyPresencePing((int) $action['bot_user_id'], $payload);
			default:
				return array('success' => false, 'summary' => 'Type d’action inconnu.', 'cooldown' => 60);
		}
	}

	protected function applyPresencePing($botUserId, array $payload)
	{
		$targetLogical = !empty($payload['target_logical']) ? (string) $payload['target_logical'] : 'connecte';
		$targetSocial = !empty($payload['target_social']) ? (string) $payload['target_social'] : (!empty($payload['force_discretion']) ? 'discret' : 'visible');
		$isOnline = in_array($targetLogical, array('connecte', 'engage', 'alerte', 'coordination', 'campagne', 'harcelement'), true);
		$cooldown = $isOnline ? 90 : 45;

		$this->presenceService->applyPresence($botUserId, $targetLogical, $targetSocial, 'presence_ping', $isOnline, array(
			'force_snapshot' => !empty($payload['relay_value']) || !empty($payload['coverage_sociale']) || !empty($payload['prepare_hidden']),
		));

		return array(
			'success' => true,
			'summary' => sprintf('Présence ajustée en %s / %s.', $targetLogical, $targetSocial),
			'cooldown' => $cooldown,
			'dynamic_delta' => array(
				'fatigue' => $isOnline ? 1 : -2,
				'disponibilite_sociale' => $targetSocial === 'visible' ? 2 : -2,
				'stabilite_operationnelle' => !empty($payload['relay_value']) ? 2 : 1,
			),
		);
	}

	protected function enqueueBuilding($botUserId, $elementId, array $visited = array())
	{
		$context = $this->loadBotContext($botUserId);
		if (empty($context)) {
			return array('success' => false, 'summary' => 'Bot ou planète introuvable.');
		}

		$user = $context['user'];
		$planet = $context['planet'];
		global $resource, $reslist, $pricelist;

		if (!in_array($elementId, $reslist['allow'][$planet['planet_type']])) {
			return array('success' => false, 'summary' => 'Bâtiment non disponible sur ce type d’astre.');
		}

		if (in_array((int) $elementId, $visited, true)) {
			return array('success' => false, 'summary' => 'Boucle de pré-requis détectée pour ce bâtiment.');
		}
		$visited[] = (int) $elementId;

		if (!BuildFunctions::isTechnologieAccessible($user, $planet, $elementId)) {
			return $this->resolvePrerequisiteAction($botUserId, $user, $planet, $elementId, $visited, 'bâtiment');
		}

		$currentQueue = empty($planet['b_building_id']) ? array() : unserialize($planet['b_building_id']);
		if (!is_array($currentQueue)) {
			$currentQueue = array();
		}

		$nextLevel = (int) $planet[$resource[$elementId]] + 1;
		if ($pricelist[$elementId]['max'] < $nextLevel) {
			return array('success' => false, 'summary' => 'Niveau maximum atteint.');
		}

			$cost = BuildFunctions::getElementPrice($user, $planet, $elementId, false, $nextLevel);
			if (!BuildFunctions::isElementBuyable($user, $planet, $elementId, $cost)) {
				return $this->deferForResources($user, $planet, $elementId, $cost, 'Bâtiment différé en attente des ressources.');
			}

		if (isset($cost[901])) { $planet[$resource[901]] -= $cost[901]; }
		if (isset($cost[902])) { $planet[$resource[902]] -= $cost[902]; }
		if (isset($cost[903])) { $planet[$resource[903]] -= $cost[903]; }
		if (isset($cost[921])) { $user[$resource[921]] -= $cost[921]; }

		$buildTime = BuildFunctions::getBuildingTime($user, $planet, $elementId, $cost, false, $nextLevel);
		$endTime = empty($currentQueue) ? TIMESTAMP + $buildTime : ($currentQueue[count($currentQueue) - 1][3] + $buildTime);
		$currentQueue[] = array($elementId, $nextLevel, $buildTime, $endTime, 'build');
		$planet['b_building_id'] = serialize($currentQueue);
		$planet['b_building'] = $endTime;

		$planetRess = new ResourceUpdate();
		$planetRess->setData($user, $planet);
		$planetRess->SavePlanetToDB($user, $planet);

		return array(
			'success' => true,
			'summary' => sprintf('File bâtiment mise à jour pour %s.', $resource[$elementId]),
			'cooldown' => max(300, $endTime - TIMESTAMP),
			'cooldown_until' => $endTime,
			'session_rest_until' => $endTime,
			'dynamic_delta' => array('satisfaction_economique' => 4, 'fatigue' => 2),
		);
	}

	protected function enqueueResearch($botUserId, $elementId, array $visited = array())
	{
		$context = $this->loadBotContext($botUserId);
		if (empty($context)) {
			return array('success' => false, 'summary' => 'Bot ou planète introuvable.');
		}

		$user = $context['user'];
		$planet = $context['planet'];
		global $resource, $reslist, $pricelist;

		if (!in_array($elementId, $reslist['tech'])) {
			return array('success' => false, 'summary' => 'Recherche indisponible pour ce bot.');
		}
		if (in_array((int) $elementId, $visited, true)) {
			return array('success' => false, 'summary' => 'Boucle de pré-requis détectée pour cette recherche.');
		}
		$visited[] = (int) $elementId;
		if (!BuildFunctions::isTechnologieAccessible($user, $planet, $elementId)) {
			return $this->resolvePrerequisiteAction($botUserId, $user, $planet, $elementId, $visited, 'recherche');
		}

		$currentQueue = empty($user['b_tech_queue']) ? array() : unserialize($user['b_tech_queue']);
		if (!is_array($currentQueue)) {
			$currentQueue = array();
		}

		$nextLevel = (int) $user[$resource[$elementId]] + 1;
		if ($pricelist[$elementId]['max'] < $nextLevel) {
			return array('success' => false, 'summary' => 'Niveau de recherche maximum atteint.');
		}

			$cost = BuildFunctions::getElementPrice($user, $planet, $elementId, false, $nextLevel);
			if (!BuildFunctions::isElementBuyable($user, $planet, $elementId, $cost)) {
				return $this->deferForResources($user, $planet, $elementId, $cost, 'Recherche différée en attente des ressources.');
			}

		if (isset($cost[901])) { $planet[$resource[901]] -= $cost[901]; }
		if (isset($cost[902])) { $planet[$resource[902]] -= $cost[902]; }
		if (isset($cost[903])) { $planet[$resource[903]] -= $cost[903]; }
		if (isset($cost[921])) { $user[$resource[921]] -= $cost[921]; }

		$buildTime = BuildFunctions::getBuildingTime($user, $planet, $elementId, $cost, false, $nextLevel);
		$endTime = empty($currentQueue) ? TIMESTAMP + $buildTime : ($currentQueue[count($currentQueue) - 1][3] + $buildTime);
		$currentQueue[] = array($elementId, $nextLevel, $buildTime, $endTime, $planet['id']);
		$user['b_tech_queue'] = serialize($currentQueue);
		$user['b_tech'] = $endTime;
		$user['b_tech_id'] = $elementId;
		$user['b_tech_planet'] = $planet['id'];

		$planetRess = new ResourceUpdate();
		$planetRess->setData($user, $planet);
		$planetRess->SavePlanetToDB($user, $planet);

		return array(
			'success' => true,
			'summary' => 'Recherche ajoutée à la file scientifique.',
			'cooldown' => max(300, $endTime - TIMESTAMP),
			'cooldown_until' => $endTime,
			'session_rest_until' => $endTime,
			'dynamic_delta' => array('confiance' => 3, 'fatigue' => 2),
		);
	}

	protected function enqueueShipyard($botUserId, $elementId, $amount, array $visited = array())
	{
		$context = $this->loadBotContext($botUserId);
		if (empty($context)) {
			return array('success' => false, 'summary' => 'Bot ou planète introuvable.');
		}

		$user = $context['user'];
		$planet = $context['planet'];
		global $resource, $reslist;

		if (!in_array($elementId, array_merge($reslist['fleet'], $reslist['defense'], $reslist['missile']))) {
			return array('success' => false, 'summary' => 'Élément chantier invalide.');
		}

		if (in_array((int) $elementId, $visited, true)) {
			return array('success' => false, 'summary' => 'Boucle de pré-requis détectée pour ce chantier.');
		}
		$visited[] = (int) $elementId;

		if (!BuildFunctions::isTechnologieAccessible($user, $planet, $elementId)) {
			return $this->resolvePrerequisiteAction($botUserId, $user, $planet, $elementId, $visited, 'chantier');
		}

			$requestedAmount = max(1, (int) $amount);
			$max = BuildFunctions::getMaxConstructibleElements($user, $planet, $elementId);
			if ((int) $max <= 0) {
				$requestedCost = BuildFunctions::getElementPrice($user, $planet, $elementId, false, $requestedAmount);
				return $this->deferForResources($user, $planet, $elementId, $requestedCost, 'Chantier différé en attente des ressources.');
			}
			$amount = max(1, min($requestedAmount, (int) $max));

		$buildArray = empty($planet['b_hangar_id']) ? array() : unserialize($planet['b_hangar_id']);
		if (!is_array($buildArray)) {
			$buildArray = array();
		}

		$cost = BuildFunctions::getElementPrice($user, $planet, $elementId, false, $amount);
		if (isset($cost[901])) { $planet[$resource[901]] -= $cost[901]; }
		if (isset($cost[902])) { $planet[$resource[902]] -= $cost[902]; }
		if (isset($cost[903])) { $planet[$resource[903]] -= $cost[903]; }
		if (isset($cost[921])) { $user[$resource[921]] -= $cost[921]; }

		$buildArray[] = array($elementId, $amount);
		$planet['b_hangar_id'] = serialize($buildArray);

		$planetRess = new ResourceUpdate();
		$planetRess->setData($user, $planet);
		$planetRess->SavePlanetToDB($user, $planet);

		$queueSeconds = 0;
		foreach ($buildArray as $queuedItem) {
			$queueSeconds += BuildFunctions::getBuildingTime($user, $planet, (int) $queuedItem[0]) * max(1, (int) $queuedItem[1]);
		}
		$waitUntil = TIMESTAMP + max(180, (int) $queueSeconds);

		return array(
			'success' => true,
			'summary' => 'Chantier spatial ajouté à la file.',
			'cooldown' => max(240, $waitUntil - TIMESTAMP),
			'cooldown_until' => $waitUntil,
			'session_rest_until' => $waitUntil,
			'dynamic_delta' => array('excitation_offensive' => 3, 'fatigue' => 1),
		);
	}

	protected function sendSpy($botUserId, $coordinates)
	{
		$context = $this->loadBotContext($botUserId);
		if (empty($context)) {
			return array('success' => false, 'summary' => 'Contexte bot introuvable.');
		}

		$target = $this->findPlanetByCoordinates($coordinates);
		if (empty($target)) {
			return array('success' => false, 'summary' => 'Cible d’espionnage introuvable.');
		}

		$user = $context['user'];
		$planet = $context['planet'];
		$probeCount = isset($planet['spy_sonde'])
			? (int) $planet['spy_sonde']
			: (isset($planet['espionage_probe']) ? (int) $planet['espionage_probe'] : 0);
		if ($probeCount <= 0) {
			return $this->enqueueShipyard($botUserId, 210, 2);
		}

		$fleet = array(210 => 1);
		$distance = FleetFunctions::GetTargetDistance(
			array($planet['galaxy'], $planet['system'], $planet['planet']),
			array($target['galaxy'], $target['system'], $target['planet'])
		);
		$maxSpeed = FleetFunctions::GetFleetMaxSpeed($fleet, $user);
		$duration = FleetFunctions::GetMissionDuration(10, $maxSpeed, $distance, FleetFunctions::GetGameSpeedFactor(), $user);
		$consumption = FleetFunctions::GetFleetConsumption($fleet, $duration, $distance, $user, FleetFunctions::GetGameSpeedFactor());

		if ((float) $planet['deuterium'] <= $consumption) {
			return array('success' => false, 'summary' => 'Deutérium insuffisant pour la reconnaissance.');
		}

		FleetFunctions::sendFleet(
			$fleet,
			6,
			$user['id'],
			$planet['id'],
			$planet['galaxy'],
			$planet['system'],
			$planet['planet'],
			$planet['planet_type'],
			$target['id_owner'],
			$target['id'],
			$target['galaxy'],
			$target['system'],
			$target['planet'],
			$target['planet_type'],
			array(901 => 0, 902 => 0, 903 => 0),
			TIMESTAMP + $duration,
			TIMESTAMP + $duration,
			TIMESTAMP + ($duration * 2),
			0,
			0,
			0,
			$consumption
		);

		return array(
			'success' => true,
			'summary' => 'Reconnaissance réelle envoyée vers '.$coordinates.'.',
			'cooldown' => max(420, $duration),
			'cooldown_until' => TIMESTAMP + $duration,
			'session_rest_until' => TIMESTAMP + $duration,
			'dynamic_delta' => array('vigilance' => 4, 'excitation_offensive' => 5),
		);
	}

	protected function sendRaid($botUserId, $coordinates)
	{
		$context = $this->loadBotContext($botUserId);
		if (empty($context)) {
			return array('success' => false, 'summary' => 'Contexte bot introuvable.');
		}

		$target = $this->findPlanetByCoordinates($coordinates);
		if (empty($target)) {
			return array('success' => false, 'summary' => 'Cible de raid introuvable.');
		}

		$user = $context['user'];
		$planet = $context['planet'];
		$fleet = array();
		if ((int) $planet['small_ship_cargo'] >= 4) {
			$fleet[202] = 4;
		}
		if ((int) $planet['light_hunter'] >= 6) {
			$fleet[204] = 6;
		}

		if (empty($fleet)) {
			return $this->enqueueShipyard($botUserId, 202, 4);
		}

		$distance = FleetFunctions::GetTargetDistance(
			array($planet['galaxy'], $planet['system'], $planet['planet']),
			array($target['galaxy'], $target['system'], $target['planet'])
		);
		$maxSpeed = FleetFunctions::GetFleetMaxSpeed($fleet, $user);
		$duration = FleetFunctions::GetMissionDuration(10, $maxSpeed, $distance, FleetFunctions::GetGameSpeedFactor(), $user);
		$consumption = FleetFunctions::GetFleetConsumption($fleet, $duration, $distance, $user, FleetFunctions::GetGameSpeedFactor());

		if ((float) $planet['deuterium'] <= $consumption) {
			return array('success' => false, 'summary' => 'Deutérium insuffisant pour le raid.');
		}

		FleetFunctions::sendFleet(
			$fleet,
			1,
			$user['id'],
			$planet['id'],
			$planet['galaxy'],
			$planet['system'],
			$planet['planet'],
			$planet['planet_type'],
			$target['id_owner'],
			$target['id'],
			$target['galaxy'],
			$target['system'],
			$target['planet'],
			$target['planet_type'],
			array(901 => 0, 902 => 0, 903 => 0),
			TIMESTAMP + $duration,
			TIMESTAMP + $duration,
			TIMESTAMP + ($duration * 2),
			0,
			0,
			0,
			$consumption
		);

		return array(
			'success' => true,
			'summary' => 'Raid réel lancé vers '.$coordinates.'.',
			'cooldown' => max(900, $duration * 2),
			'cooldown_until' => TIMESTAMP + ($duration * 2),
			'session_rest_until' => TIMESTAMP + ($duration * 2),
			'dynamic_delta' => array('appetit_raid' => 6, 'excitation_offensive' => 7, 'fatigue' => 4),
		);
	}

	protected function queuePrivateMessageAction($botUserId, array $payload)
	{
		if (empty($payload['target_user_id'])) {
			return array('success' => false, 'summary' => 'Cible du message privé manquante.');
		}

		$body = !empty($payload['message']) ? $payload['message'] : $this->messagingService->renderTemplate(
			isset($payload['template_key']) ? $payload['template_key'] : 'intimidation',
			$payload
		);
		$subject = !empty($payload['subject']) ? $payload['subject'] : 'Transmission Astra';
		$this->messagingService->queuePrivateMessage($botUserId, (int) $payload['target_user_id'], $subject, $body, $payload);

		return array('success' => true, 'summary' => 'Message privé mis en file.', 'cooldown' => 180);
	}

	protected function queueSocialMessageAction($botUserId, array $payload)
	{
		$text = !empty($payload['message']) ? $payload['message'] : $this->messagingService->renderTemplate(
			isset($payload['template_key']) ? $payload['template_key'] : 'presence_visible',
			$payload
		);
		if (!empty($payload['target_username']) && strpos($text, '@'.$payload['target_username']) === false && strpos($text, $payload['target_username']) === false) {
			$text = '@'.$payload['target_username'].' '.$text;
		}

		$this->messagingService->queueSocialMessage(
			$botUserId,
			isset($payload['channel_key']) ? $payload['channel_key'] : 'bots',
			$text,
			isset($payload['target_user_id']) ? (int) $payload['target_user_id'] : null,
			isset($payload['target_username']) ? $payload['target_username'] : '',
			$payload
		);

		return array('success' => true, 'summary' => 'Message social mis en file.', 'cooldown' => 180);
	}

	protected function loadBotContext($botUserId)
	{
		$db = Database::get();
		$user = $db->selectSingle('SELECT *
			FROM %%USERS%%
			WHERE id = :userId AND is_bot = 1
			LIMIT 1;', array(
				':userId' => (int) $botUserId,
			));

		if (empty($user)) {
			return array();
		}

		$planet = $db->selectSingle('SELECT *
			FROM %%PLANETS%%
			WHERE id = :planetId
			LIMIT 1;', array(
				':planetId' => (int) $user['id_planet'],
			));

		if (empty($planet)) {
			return array();
		}

		$user['factor'] = getFactors($user);
		return array(
			'user' => $user,
			'planet' => $planet,
		);
	}

	protected function findPlanetByCoordinates($coordinates)
	{
		if (!preg_match('/^(\d+):(\d+):(\d+)$/', trim((string) $coordinates), $matches)) {
			return array();
		}

		return Database::get()->selectSingle('SELECT *
			FROM %%PLANETS%%
			WHERE universe = :universe
			  AND galaxy = :galaxy
			  AND `system` = :system
			  AND planet = :planet
			  AND planet_type = 1
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':galaxy' => (int) $matches[1],
				':system' => (int) $matches[2],
				':planet' => (int) $matches[3],
			));
	}

	protected function resolvePrerequisiteAction($botUserId, array $user, array $planet, $elementId, array $visited = array(), $contextLabel = 'action')
	{
		global $requeriments, $resource, $reslist;

		if (empty($requeriments[$elementId]) || !is_array($requeriments[$elementId])) {
			return array('success' => false, 'summary' => 'Pré-requis '.$contextLabel.' non atteints.');
		}

		foreach ($requeriments[$elementId] as $requireId => $requireLevel) {
			$currentLevel = 0;
			if (isset($planet[$resource[$requireId]])) {
				$currentLevel = (int) $planet[$resource[$requireId]];
			} elseif (isset($user[$resource[$requireId]])) {
				$currentLevel = (int) $user[$resource[$requireId]];
			}

			if ($currentLevel >= (int) $requireLevel) {
				continue;
			}

			if (in_array((int) $requireId, $visited, true)) {
				return array('success' => false, 'summary' => 'Chaîne de pré-requis impossible à résoudre automatiquement.');
			}

			if (in_array($requireId, $reslist['build'])) {
				$result = $this->enqueueBuilding($botUserId, (int) $requireId, $visited);
			} elseif (in_array($requireId, $reslist['tech'])) {
				$result = $this->enqueueResearch($botUserId, (int) $requireId, $visited);
			} elseif (in_array($requireId, array_merge($reslist['fleet'], $reslist['defense'], $reslist['missile']), true)) {
				$result = $this->enqueueShipyard($botUserId, (int) $requireId, max(1, (int) $requireLevel - $currentLevel), $visited);
			} else {
				return array('success' => false, 'summary' => 'Pré-requis '.$contextLabel.' non automatisable.');
			}

			if (!empty($result['success'])) {
				$result['summary'] = sprintf('Pré-requis #%d planifié avant le %s demandé.', (int) $requireId, (string) $contextLabel);
			}

			return $result;
		}

		return array('success' => false, 'summary' => 'Pré-requis '.$contextLabel.' non atteints.');
	}

	protected function deferForResources(array $user, array $planet, $elementId, array $cost, $summaryPrefix)
	{
		$deficit = BuildFunctions::getRestPrice($user, $planet, $elementId, $cost);
		$retryDelay = $this->estimateResourceWaitSeconds($user, $planet, $deficit);
		$retryAt = TIMESTAMP + $retryDelay;

		return array(
			'success' => false,
			'defer' => true,
			'retry_at' => $retryAt,
			'cooldown' => $retryDelay,
			'cooldown_until' => $retryAt,
			'session_rest_until' => $retryAt,
			'summary' => sprintf('%s Reprise estimée dans %d min.', $summaryPrefix, (int) ceil($retryDelay / 60)),
			'dynamic_delta' => array(
				'fatigue' => -1,
				'discipline' => 1,
			),
		);
	}

	protected function estimateResourceWaitSeconds(array $user, array $planet, array $deficit)
	{
		$config = Config::get((int) $user['universe']);
		$perHour = array(
			901 => max(60.0, ((float) $config->metal_basic_income * (float) $config->resource_multiplier) + (float) $planet['metal_perhour']),
			902 => max(40.0, ((float) $config->crystal_basic_income * (float) $config->resource_multiplier) + (float) $planet['crystal_perhour']),
			903 => max(20.0, ((float) $config->deuterium_basic_income * (float) $config->resource_multiplier) + (float) $planet['deuterium_perhour']),
			921 => 0.0,
		);
		$maxWait = 0;
		foreach ($deficit as $resourceId => $missingAmount) {
			$missingAmount = (float) $missingAmount;
			if ($missingAmount <= 0) {
				continue;
			}

			if (empty($perHour[$resourceId])) {
				$maxWait = max($maxWait, 7200);
				continue;
			}

			$maxWait = max($maxWait, (int) ceil(($missingAmount * 3600) / $perHour[$resourceId]));
		}

		return max(300, min(21600, (int) ceil($maxWait * 1.15)));
	}

	protected function shouldSkipQueueInsertion($botUserId, array $action, $payloadJson, $queuedCount)
	{
		$actionType = isset($action['action_type']) ? (string) $action['action_type'] : '';
		$objectiveType = isset($action['goal']) ? (string) $action['goal'] : '';
		$payload = isset($action['payload']) && is_array($action['payload']) ? $action['payload'] : array();
		$db = Database::get();

		if ($queuedCount >= 12 && in_array($actionType, array('presence_ping', 'queue_social_message', 'queue_private_message'), true)) {
			return true;
		}

		$duplicateCount = (int) $db->selectSingle('SELECT COUNT(*) AS total
			FROM %%BOT_ACTION_QUEUE%%
			WHERE bot_user_id = :botUserId
			  AND status IN (\'queued\', \'running\')
			  AND action_type = :actionType
			  AND objective_type = :objectiveType
			  AND payload_json = :payloadJson;', array(
				':botUserId' => (int) $botUserId,
				':actionType' => $actionType,
				':objectiveType' => $objectiveType,
				':payloadJson' => $payloadJson,
			), 'total');
		if ($duplicateCount > 0) {
			return true;
		}

		$typeCount = (int) $db->selectSingle('SELECT COUNT(*) AS total
			FROM %%BOT_ACTION_QUEUE%%
			WHERE bot_user_id = :botUserId
			  AND status IN (\'queued\', \'running\')
			  AND action_type = :actionType;', array(
				':botUserId' => (int) $botUserId,
				':actionType' => $actionType,
			), 'total');

		$limits = array(
			'presence_ping' => 1,
			'queue_social_message' => 2,
			'queue_private_message' => 2,
			'send_spy' => 2,
			'send_raid' => 1,
			'enqueue_building' => 2,
			'enqueue_research' => 2,
			'enqueue_shipyard' => 3,
		);
		if (isset($limits[$actionType]) && $typeCount >= $limits[$actionType]) {
			return true;
		}

		if ($actionType === 'presence_ping') {
			$state = $this->presenceService->getState((int) $botUserId);
			$targetLogical = !empty($payload['target_logical']) ? (string) $payload['target_logical'] : 'connecte';
			$targetSocial = !empty($payload['target_social']) ? (string) $payload['target_social'] : (!empty($payload['force_discretion']) ? 'discret' : 'visible');
			if (!empty($state)
				&& $state['presence_logical'] === $targetLogical
				&& $state['presence_social'] === $targetSocial
				&& empty($payload['relay_value'])
				&& empty($payload['continuity_value'])
				&& empty($payload['manual_order_count'])) {
				return true;
			}
		}

		return false;
	}

	protected function buildQueueSignature($actionType, $objectiveType, $payloadJson)
	{
		if ($actionType === 'presence_ping') {
			return $actionType;
		}

		return sha1((string) $actionType.'|'.(string) $objectiveType.'|'.(string) $payloadJson);
	}
}
