<?php

class BotCommandDispatcher
{
	protected $parser;
	protected $actionExecutor;
	protected $campaignService;
	protected $messagingService;
	protected $journalService;
	protected $commanderService;
	protected $configService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotCommandParser.class.php';
		require_once ROOT_PATH.'includes/classes/BotActionExecutor.class.php';
		require_once ROOT_PATH.'includes/classes/BotCampaignService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMessagingService.class.php';
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommanderService.class.php';
		require_once ROOT_PATH.'includes/classes/BotEngineConfigService.class.php';

		$this->parser = new BotCommandParser();
		$this->actionExecutor = new BotActionExecutor();
		$this->campaignService = new BotCampaignService();
		$this->messagingService = new BotMessagingService();
		$this->journalService = new BotJournalService();
		$this->commanderService = new BotCommanderService();
		$this->configService = new BotEngineConfigService();
	}

	public function createStructuredCommand($rawCommand, $issuedByUserId)
	{
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';

		$parsed = $this->parser->parse($rawCommand);
		if (empty($parsed['is_valid'])) {
			return array(
				'status' => 'error',
				'message' => isset($parsed['error']) ? $parsed['error'] : 'Commande invalide.',
			);
		}

		$db = Database::get();
		$db->insert('INSERT INTO %%BOT_COMMANDS%% SET
			universe = :universe,
			issued_by_user_id = :issuedByUserId,
			target_bot_user_id = :targetBotUserId,
			target_selector = :targetSelector,
			command_text = :commandText,
			command_family = :commandFamily,
			command_name = :commandName,
			target_type = :targetType,
			target_reference = :targetReference,
			scope_mode = :scopeMode,
			priority = :priority,
			payload_json = :payloadJson,
			parsed_command_json = :parsedCommandJson,
			status = :status,
			created_at = :createdAt;', array(
				':universe' => Universe::getEmulated(),
				':issuedByUserId' => (int) $issuedByUserId,
				':targetBotUserId' => $this->resolvePrimaryBotId($parsed),
				':targetSelector' => $parsed['target_type'].':'.$parsed['target_reference'],
				':commandText' => trim((string) $rawCommand),
				':commandFamily' => $parsed['command_family'],
				':commandName' => $parsed['command_name'],
				':targetType' => $parsed['target_type'],
				':targetReference' => $parsed['target_reference'],
				':scopeMode' => 'direct',
				':priority' => $this->computePriority($parsed),
				':payloadJson' => json_encode($parsed['payload']),
				':parsedCommandJson' => json_encode($parsed),
				':status' => 'parsed',
				':createdAt' => TIMESTAMP,
			));

		$commandId = (int) $db->lastInsertId();
		LiveChatService::createBotFeedEntry('Orchestrateur Astra Bots', 'Commande structurée enregistrée : '.$rawCommand, 0, Universe::getEmulated());

		return array(
			'status' => 'ok',
			'commandId' => $commandId,
			'parsed' => $parsed,
		);
	}

	public function getCatalog()
	{
		return $this->parser->getCatalog();
	}

	public function dispatchPending($limit = 12)
	{
		$db = Database::get();
		$commands = $db->select('SELECT *
			FROM %%BOT_COMMANDS%%
			WHERE universe = :universe
			  AND status IN (\'pending\', \'parsed\')
			ORDER BY priority DESC, id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':limit' => (int) $limit,
			));

		$result = array(
			'processed' => 0,
			'done' => 0,
			'rejected' => 0,
		);

		foreach ($commands as $command) {
			$outcome = $this->dispatchOne($command);
			$db->update('UPDATE %%BOT_COMMANDS%% SET
				status = :status,
				response_text = :responseText,
				result_json = :resultJson,
				executed_at = :executedAt,
				failure_reason = :failureReason
				WHERE id = :id;', array(
					':status' => $outcome['status'],
					':responseText' => $outcome['responseText'],
					':resultJson' => json_encode($outcome),
					':executedAt' => TIMESTAMP,
					':failureReason' => $outcome['status'] === 'done' ? null : $outcome['responseText'],
					':id' => (int) $command['id'],
				));

			$result['processed']++;
			if ($outcome['status'] === 'done') {
				$result['done']++;
			} else {
				$result['rejected']++;
			}
		}

		return $result;
	}

	protected function dispatchOne(array $command)
	{
		$payload = !empty($command['payload_json']) ? json_decode($command['payload_json'], true) : array();
		if (!is_array($payload)) {
			$payload = array();
		}

		$targetBotIds = $this->resolveBotTargets($command['target_type'], $command['target_reference']);
		$commandName = trim((string) $command['command_name']);
		if (in_array($commandName, array('coordonner', 'lancer'), true) && $command['target_type'] === 'chef') {
			$targetBotIds = $this->expandCommanderScope($targetBotIds);
		}

		switch ($commandName) {
			case 'statut':
				return $this->buildStatusResponse($targetBotIds, $command);
			case 'pause':
				return $this->applyPause($targetBotIds, isset($payload['duration']) ? $payload['duration'] : '30m');
			case 'reprendre':
				return $this->applyResume($targetBotIds);
			case 'doctrine':
			case 'priorite':
			case 'intensifier':
			case 'strategie':
				return $this->applyDoctrine($targetBotIds, isset($payload['doctrine']) ? $payload['doctrine'] : (isset($payload['arguments'][0]) ? $payload['arguments'][0] : 'equilibre'));
			case 'bonus':
				return $this->applyBonus($targetBotIds, isset($payload['arguments'][0]) ? $payload['arguments'][0] : '10');
			case 'cible-online':
				return $this->applyGlobalPresenceTarget(isset($payload['arguments'][0]) ? $payload['arguments'][0] : 0);
			case 'coordonner':
				return $this->applyCommanderTarget($targetBotIds, $payload);
			case 'lancer':
				return $this->dispatchLaunchedAction($targetBotIds, $payload);
			case 'recon':
			case 'reconnaissance':
			case 'surveillance':
				return $this->queueTargetedAction($targetBotIds, 'send_spy', $payload);
			case 'raid':
				return $this->queueTargetedAction($targetBotIds, 'send_raid', $payload);
			case 'defense':
				return $this->queueDefensiveAction($targetBotIds, $payload);
			case 'colonisation':
				return $this->queueColonizationAction($targetBotIds, $payload);
			case 'message-prive':
				return $this->queuePrivateMessage($targetBotIds, $payload);
			case 'message-chat':
				return $this->queueSocialMessage($targetBotIds, $payload);
			case 'campagne':
			case 'harcelement':
			case 'rotation-attaque':
			case 'vague':
			case 'siege':
				return $this->createCampaign($command, $payload, $targetBotIds);
			default:
				if (!empty($targetBotIds)) {
					return $this->queueTargetedAction($targetBotIds, 'presence_ping', $payload);
				}

				return array(
					'status' => 'rejected',
					'responseText' => 'Commande non prise en charge par le dispatcher.',
				);
		}
	}

	protected function applyPause(array $botIds, $durationToken)
	{
		$seconds = $this->parseDuration($durationToken);
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot correspondant à mettre en pause.');
		}

		Database::get()->update('UPDATE %%BOT_STATE%% SET paused_until = :pausedUntil, updated_at = :updatedAt WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
			':pausedUntil' => TIMESTAMP + $seconds,
			':updatedAt' => TIMESTAMP,
		));

		return array('status' => 'done', 'responseText' => sprintf('%d bot(s) mis en pause pour %s.', count($botIds), $durationToken));
	}

	protected function applyResume(array $botIds)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot correspondant à relancer.');
		}

		Database::get()->update('UPDATE %%BOT_STATE%% SET paused_until = NULL, updated_at = :updatedAt WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
			':updatedAt' => TIMESTAMP,
		));

		return array('status' => 'done', 'responseText' => sprintf('%d bot(s) relancé(s).', count($botIds)));
	}

	protected function applyDoctrine(array $botIds, $doctrine)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot correspondant à reconfigurer.');
		}

		Database::get()->update('UPDATE %%BOT_STATE%% SET doctrine_active = :doctrine, updated_at = :updatedAt WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
			':doctrine' => trim((string) $doctrine) !== '' ? trim((string) $doctrine) : 'equilibre',
			':updatedAt' => TIMESTAMP,
		));

		return array('status' => 'done', 'responseText' => sprintf('Doctrine « %s » appliquée à %d bot(s).', $doctrine, count($botIds)));
	}

	protected function applyBonus(array $botIds, $bonusValue)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot correspondant à bonifier.');
		}

		$resolvedBonus = max(0, min(100, (int) $bonusValue));
		Database::get()->update('UPDATE %%BOT_STATE%% SET
			bonus_score = :bonusScore,
			updated_at = :updatedAt
			WHERE bot_user_id IN ('.implode(',', array_map('intval', $botIds)).');', array(
			':bonusScore' => $resolvedBonus,
			':updatedAt' => TIMESTAMP,
		));

		return array('status' => 'done', 'responseText' => sprintf('Bonus de %d appliqué à %d bot(s).', $resolvedBonus, count($botIds)));
	}

	protected function applyGlobalPresenceTarget($targetValue)
	{
		$targetValue = max(0, (int) $targetValue);
		if ($targetValue <= 0) {
			return array('status' => 'rejected', 'responseText' => 'Valeur cible de présence invalide.');
		}

		$this->configService->saveConfig(array(
			'target_online_total' => $targetValue,
		));

		return array('status' => 'done', 'responseText' => sprintf('Nouvelle cible globale de présence enregistrée : %d.', $targetValue));
	}

	protected function applyCommanderTarget(array $botIds, array $payload)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun chef ou subordonné résolu pour la coordination.');
		}

		$target = array(
			'type' => !empty($payload['system_reference']) ? 'systeme' : (!empty($payload['target_coordinates']) ? 'coordonnees' : 'zone'),
			'reference' => !empty($payload['system_reference']) ? $payload['system_reference'] : (!empty($payload['target_coordinates']) ? $payload['target_coordinates'] : (isset($payload['zone_reference']) ? $payload['zone_reference'] : '')),
			'updated_at' => TIMESTAMP,
		);

		foreach ($botIds as $botId) {
			$this->commanderService->assignCurrentTarget((int) $botId, $target);
		}

		return array('status' => 'done', 'responseText' => sprintf('Priorité hiérarchique appliquée à %d bot(s) sur %s.', count($botIds), $target['reference']));
	}

	protected function dispatchLaunchedAction(array $botIds, array $payload)
	{
		$verb = !empty($payload['verb']) ? trim((string) $payload['verb']) : '';
		if (in_array($verb, array('reconnaissance', 'recon', 'surveillance'), true)) {
			return $this->queueTargetedAction($botIds, 'send_spy', $payload);
		}

		if ($verb === 'raid') {
			return $this->queueTargetedAction($botIds, 'send_raid', $payload);
		}

		return array('status' => 'rejected', 'responseText' => 'Verbe de lancement non pris en charge.');
	}

	protected function queueTargetedAction(array $botIds, $actionType, array $payload)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot cible résolu pour cette action.');
		}

		$queued = 0;
		foreach ($botIds as $botId) {
			$this->actionExecutor->enqueueActions((int) $botId, array(array(
				'action_type' => $actionType,
				'goal' => $actionType,
				'utility' => 80,
				'confidence' => 85,
				'estimated_cost' => 10,
				'estimated_risk' => 18,
				'payload' => $payload,
				'justification' => 'Ordre manuel prioritaire.',
			)), 'commande', 'ordre_manuel');
			$queued++;
		}

		return array('status' => 'done', 'responseText' => sprintf('%d action(s) %s placée(s) en file.', $queued, $actionType));
	}

	protected function queueDefensiveAction(array $botIds, array $payload)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot cible résolu pour la défense.');
		}

		$queued = 0;
		foreach ($botIds as $botId) {
			$this->actionExecutor->enqueueActions((int) $botId, array(
				array(
					'action_type' => 'enqueue_shipyard',
					'goal' => 'defense_zone',
					'utility' => 78,
					'confidence' => 82,
					'estimated_cost' => 14,
					'estimated_risk' => 12,
					'payload' => array('element_id' => 401, 'amount' => 8),
					'justification' => 'Ordre manuel de renforcement défensif.',
				),
			), 'commande', 'ordre_manuel_defense');
			$queued++;
		}

		return array('status' => 'done', 'responseText' => sprintf('%d renfort(s) défensif(s) placé(s) en file.', $queued));
	}

	protected function queueColonizationAction(array $botIds, array $payload)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot cible résolu pour la colonisation.');
		}

		$queued = 0;
		foreach ($botIds as $botId) {
			$this->actionExecutor->enqueueActions((int) $botId, array(
				array(
					'action_type' => 'enqueue_shipyard',
					'goal' => 'expansion_coloniale',
					'utility' => 74,
					'confidence' => 80,
					'estimated_cost' => 18,
					'estimated_risk' => 16,
					'payload' => array('element_id' => 208, 'amount' => 1),
					'justification' => 'Ordre manuel de préparation à la colonisation.',
				),
			), 'commande', 'ordre_manuel_colonisation');
			$queued++;
		}

		return array('status' => 'done', 'responseText' => sprintf('%d préparation(s) à la colonisation placée(s) en file.', $queued));
	}

	protected function queuePrivateMessage(array $botIds, array $payload)
	{
		if (empty($botIds) || empty($payload['target_username'])) {
			return array('status' => 'rejected', 'responseText' => 'Bot source ou joueur cible manquant pour le message privé.');
		}

		$targetUser = Database::get()->selectSingle('SELECT id, username FROM %%USERS%% WHERE username = :username LIMIT 1;', array(
			':username' => $payload['target_username'],
		));
		if (empty($targetUser)) {
			return array('status' => 'rejected', 'responseText' => 'Joueur cible introuvable pour le message privé.');
		}

		foreach ($botIds as $botId) {
			$this->messagingService->queuePrivateMessage((int) $botId, (int) $targetUser['id'], 'Transmission Astra', isset($payload['message']) ? $payload['message'] : '', $payload);
		}

		return array('status' => 'done', 'responseText' => sprintf('Message privé mis en file pour %d bot(s).', count($botIds)));
	}

	protected function queueSocialMessage(array $botIds, array $payload)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Bot source manquant pour le message social.');
		}

		foreach ($botIds as $botId) {
			$this->messagingService->queueSocialMessage((int) $botId, 'bots', isset($payload['message']) ? $payload['message'] : '', null, isset($payload['target_username']) ? $payload['target_username'] : '', $payload);
		}

		return array('status' => 'done', 'responseText' => sprintf('Message social mis en file pour %d bot(s).', count($botIds)));
	}

	protected function createCampaign(array $command, array $payload, array $targetBotIds)
	{
		if ($command['target_type'] === 'chef') {
			$targetBotIds = $this->expandCommanderScope($targetBotIds);
		}

		if (empty($targetBotIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot résolu pour lancer la campagne.');
		}

		$responsibleAllianceMetaId = null;
		if (!empty($command['target_type']) && $command['target_type'] === 'alliance') {
			$allianceMeta = Database::get()->selectSingle('SELECT id
				FROM %%BOT_ALLIANCE_META%%
				WHERE universe = :universe
				  AND (meta_tag = :reference OR meta_name = :reference)
				LIMIT 1;', array(
					':universe' => Universe::getEmulated(),
					':reference' => $command['target_reference'],
				));
			if (!empty($allianceMeta['id'])) {
				$responsibleAllianceMetaId = (int) $allianceMeta['id'];
			}
		}

		$campaign = $this->campaignService->createCampaign(array(
			'campaign_code' => 'campagne-'.substr(md5($command['command_text'].'-'.TIMESTAMP), 0, 12),
			'label' => 'Campagne '.$command['command_name'],
			'campaign_type' => $command['command_name'],
			'target_type' => !empty($payload['target_coordinates']) ? 'coordonnees' : 'zone',
			'target_reference' => !empty($payload['target_coordinates']) ? $payload['target_coordinates'] : (isset($payload['target_player']) ? $payload['target_player'] : $command['target_reference']),
			'zone_reference' => !empty($payload['coordinates']) ? $payload['coordinates'] : $command['target_reference'],
			'responsible_alliance_meta_id' => $responsibleAllianceMetaId,
			'responsible_bot_user_id' => !empty($targetBotIds) ? (int) $targetBotIds[0] : null,
			'member_bot_user_ids' => $targetBotIds,
			'rhythm_minutes' => !empty($payload['interval']) ? $this->parseDurationToMinutes($payload['interval']) : 15,
			'interval_minutes' => !empty($payload['interval']) ? $this->parseDurationToMinutes($payload['interval']) : 15,
			'duration_minutes' => !empty($payload['duration']) ? $this->parseDurationToMinutes($payload['duration']) : 360,
			'intensity' => 70,
			'payload' => $payload,
		));

		if (empty($campaign)) {
			return array('status' => 'rejected', 'responseText' => 'Impossible de créer la campagne demandée.');
		}

		return array('status' => 'done', 'responseText' => sprintf('Campagne enregistrée : %s (%d membre(s)).', $campaign['campaign_code'], count($targetBotIds)), 'campaign_id' => $campaign['id']);
	}

	protected function resolveBotTargets($targetType, $targetReference)
	{
		$db = Database::get();
		$type = trim((string) $targetType);
		$reference = trim((string) $targetReference);

		if ($type === 'all' || $reference === 'all') {
			return array_map('intval', array_column($db->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 ORDER BY id ASC;', array(
				':universe' => Universe::getEmulated(),
			)), 'id'));
		}

		if ($type === 'bot') {
			return $this->idsFromRows($db->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND username = :username;', array(
				':universe' => Universe::getEmulated(),
				':username' => $reference,
			)));
		}

		if ($type === 'chef') {
			if ($reference !== '') {
				return $this->idsFromRows($db->select('SELECT u.id
					FROM %%USERS%% u
					INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
					WHERE u.universe = :universe AND u.is_bot = 1 AND bs.hierarchy_status = \'chef\' AND u.username = :username;', array(
						':universe' => Universe::getEmulated(),
						':username' => $reference,
					)));
			}

			return $this->idsFromRows($db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
				WHERE u.universe = :universe AND u.is_bot = 1 AND bs.hierarchy_status = \'chef\';', array(
					':universe' => Universe::getEmulated(),
				)));
		}

		if ($type === 'alliance') {
			return $this->idsFromRows($db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%ALLIANCE%% a ON a.id = u.ally_id
				WHERE u.universe = :universe AND u.is_bot = 1 AND (a.ally_tag = :reference OR a.ally_name = :reference);', array(
					':universe' => Universe::getEmulated(),
					':reference' => $reference,
				)));
			}

			if ($type === 'profil') {
			return $this->idsFromRows($db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%BOT_PROFILES%% bp ON bp.id = u.bot_profile_id
				WHERE u.universe = :universe AND u.is_bot = 1 AND bp.name = :reference;', array(
					':universe' => Universe::getEmulated(),
					':reference' => $reference,
				)));
			}

			if ($type === 'escouade') {
				return $this->idsFromRows($db->select('SELECT m.bot_user_id AS id
					FROM %%BOT_SQUAD_MEMBERS%% m
					INNER JOIN %%BOT_SQUADS%% s ON s.id = m.squad_id
					WHERE s.universe = :universe
					  AND (s.squad_code = :reference OR s.squad_name = :reference);', array(
						':universe' => Universe::getEmulated(),
						':reference' => $reference,
					)));
			}

		if ($type === 'systeme' && preg_match('/^(\d+):(\d+)$/', $reference, $match)) {
			return $this->idsFromRows($db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
				WHERE u.universe = :universe AND u.is_bot = 1 AND p.galaxy = :galaxy AND p.`system` = :system;', array(
					':universe' => Universe::getEmulated(),
					':galaxy' => (int) $match[1],
					':system' => (int) $match[2],
				)));
		}

		if ($type === 'galaxie' && ctype_digit($reference)) {
			return $this->idsFromRows($db->select('SELECT u.id
				FROM %%USERS%% u
				INNER JOIN %%PLANETS%% p ON p.id = u.id_planet
				WHERE u.universe = :universe AND u.is_bot = 1 AND p.galaxy = :galaxy;', array(
					':universe' => Universe::getEmulated(),
					':galaxy' => (int) $reference,
				)));
		}

		if ($type === 'campagne') {
			return $this->idsFromRows($db->select('SELECT DISTINCT bot_user_id AS id
				FROM %%BOT_CAMPAIGN_MEMBERS%% m
				INNER JOIN %%BOT_CAMPAIGNS%% c ON c.id = m.campaign_id
				WHERE c.universe = :universe AND c.campaign_code = :reference;', array(
					':universe' => Universe::getEmulated(),
					':reference' => $reference,
				)));
		}

		return array();
	}

	protected function resolvePrimaryBotId(array $parsed)
	{
		$targets = $this->resolveBotTargets($parsed['target_type'], $parsed['target_reference']);
		return empty($targets) ? null : (int) $targets[0];
	}

	protected function computePriority(array $parsed)
	{
		$high = array('raid', 'recon', 'campagne', 'siege', 'harcelement', 'rotation-attaque', 'vague');
		return in_array($parsed['command_name'], $high, true) ? 85 : 60;
	}

	protected function parseDuration($token)
	{
		$token = trim((string) $token);
		if (preg_match('/^(\d+)h$/', $token, $match)) {
			return (int) $match[1] * 3600;
		}
		if (preg_match('/^(\d+)m$/', $token, $match)) {
			return (int) $match[1] * 60;
		}
		return 1800;
	}

	protected function parseDurationToMinutes($token)
	{
		return max(5, (int) round($this->parseDuration($token) / 60));
	}

	protected function idsFromRows(array $rows)
	{
		return array_map('intval', array_column($rows, 'id'));
	}

	protected function expandCommanderScope(array $commanderIds)
	{
		$resolved = array();
		foreach ($commanderIds as $commanderId) {
			$resolved[] = (int) $commanderId;
			$resolved = array_merge($resolved, $this->commanderService->getSubordinateIds((int) $commanderId));
		}

		return array_values(array_unique(array_map('intval', $resolved)));
	}

	protected function buildStatusResponse(array $botIds, array $command)
	{
		if (empty($botIds)) {
			return array('status' => 'rejected', 'responseText' => 'Aucun bot correspondant au statut demandé.');
		}

		$rows = Database::get()->select('SELECT u.id, u.username, bs.presence_logical, bs.presence_social, bs.hierarchy_status, bs.current_campaign_id
			FROM %%USERS%% u
			LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.id IN ('.implode(',', array_map('intval', $botIds)).')
			ORDER BY u.username ASC
			LIMIT 25;');

		$logical = array();
		$campaigns = 0;
		foreach ($rows as $row) {
			$key = !empty($row['presence_logical']) ? $row['presence_logical'] : 'inconnu';
			$logical[$key] = isset($logical[$key]) ? $logical[$key] + 1 : 1;
			if (!empty($row['current_campaign_id'])) {
				$campaigns++;
			}
		}

		$parts = array();
		foreach ($logical as $state => $count) {
			$parts[] = $state.'='.$count;
		}

		return array(
			'status' => 'done',
			'responseText' => sprintf('Statut %s : %d bot(s), %d en campagne, répartition logique [%s].', $command['target_reference'] !== '' ? $command['target_reference'] : 'global', count($botIds), $campaigns, implode(', ', $parts)),
			'targets' => $botIds,
		);
	}
}
