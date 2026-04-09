<?php

class BotEngineService
{
	protected $configService;
	protected $traitService;
	protected $dynamicStateService;
	protected $memoryService;
	protected $presenceGovernor;
	protected $worldStateBuilder;
	protected $strategicPlanner;
	protected $actionGenerator;
	protected $actionScorer;
	protected $actionExecutor;
	protected $commandDispatcher;
	protected $journalService;
	protected $messagingService;
	protected $campaignService;
	protected $multiAccountService;
	protected $allianceService;
	protected $commanderService;
	protected $territorialMapService;
	protected $globalStrategyService;
	protected $learningService;

	public function __construct()
	{
		require_once ROOT_PATH.'includes/classes/BotEngineConfigService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTraitService.class.php';
		require_once ROOT_PATH.'includes/classes/BotDynamicStateService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMemoryService.class.php';
		require_once ROOT_PATH.'includes/classes/BotPopulationGovernor.class.php';
		require_once ROOT_PATH.'includes/classes/BotWorldStateBuilder.class.php';
		require_once ROOT_PATH.'includes/classes/BotStrategicPlanner.class.php';
		require_once ROOT_PATH.'includes/classes/BotActionGenerator.class.php';
		require_once ROOT_PATH.'includes/classes/BotActionScorer.class.php';
		require_once ROOT_PATH.'includes/classes/BotActionExecutor.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommandDispatcher.class.php';
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMessagingService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCampaignService.class.php';
		require_once ROOT_PATH.'includes/classes/BotMultiAccountService.class.php';
		require_once ROOT_PATH.'includes/classes/BotAllianceService.class.php';
		require_once ROOT_PATH.'includes/classes/BotCommanderService.class.php';
		require_once ROOT_PATH.'includes/classes/BotTerritorialMapService.class.php';
		require_once ROOT_PATH.'includes/classes/BotGlobalStrategyService.class.php';
		require_once ROOT_PATH.'includes/classes/BotLearningService.class.php';

		$this->configService = new BotEngineConfigService();
		$this->traitService = new BotTraitService();
		$this->dynamicStateService = new BotDynamicStateService();
		$this->memoryService = new BotMemoryService();
		$this->presenceGovernor = new BotPopulationGovernor();
		$this->worldStateBuilder = new BotWorldStateBuilder();
		$this->strategicPlanner = new BotStrategicPlanner();
		$this->actionGenerator = new BotActionGenerator();
		$this->actionScorer = new BotActionScorer();
		$this->actionExecutor = new BotActionExecutor();
		$this->commandDispatcher = new BotCommandDispatcher();
		$this->journalService = new BotJournalService();
		$this->messagingService = new BotMessagingService();
		$this->campaignService = new BotCampaignService();
		$this->multiAccountService = new BotMultiAccountService();
		$this->allianceService = new BotAllianceService();
		$this->commanderService = new BotCommanderService();
		$this->territorialMapService = new BotTerritorialMapService();
		$this->globalStrategyService = new BotGlobalStrategyService();
		$this->learningService = new BotLearningService();
	}

	public function runCycle($phase = 'cycle', $limit = null)
	{
		$config = $this->configService->getConfig();
		if (empty($config['engine_enabled'])) {
			return array(
				'phase' => $phase,
				'status' => 'disabled',
				'selectedBots' => 0,
				'executedActions' => 0,
			);
		}

		if ($this->isLocked($phase)) {
			return array(
				'phase' => $phase,
				'status' => 'locked',
				'selectedBots' => 0,
				'executedActions' => 0,
			);
		}

		$run = $this->journalService->openRun($phase, array('limit' => $limit));
		$selectedBots = 0;
		$executedActions = 0;
		$summary = array();

		try {
			$this->ensureBotFoundation($config);
			if (in_array($phase, array('cycle', 'planning', 'campaigns', 'maintenance', 'strategic', 'long'), true)) {
				$summary['alliances'] = $this->allianceService->refreshAllianceGovernance(10);
			}

			if (in_array($phase, array('cycle', 'strategic', 'long'), true)) {
				$summary['territorial_map'] = $this->territorialMapService->rebuildMap(400);
			}

			if (in_array($phase, array('cycle', 'strategic'), true)) {
				$summary['strategic_state'] = $this->globalStrategyService->refreshStrategicState($config);
			}

			if (in_array($phase, array('cycle', 'presence'), true)) {
				$summary['population'] = $this->presenceGovernor->computeAndApply($config);
			}

			if (in_array($phase, array('cycle', 'planning'), true)) {
				$summary['commands'] = $this->commandDispatcher->dispatchPending(max(4, (int) (($limit ?: $config['max_bots_per_cycle']) / 2)));
				$planning = $this->planActions($config, $limit);
				$selectedBots = $planning['selected_bots'];
				$summary['planning'] = $planning;
			}

			if (in_array($phase, array('cycle', 'execution'), true)) {
				$executedActions += $this->actionExecutor->executeQueued($limit ?: $config['action_budget_per_cycle']);
			}

			if (in_array($phase, array('cycle', 'messaging'), true)) {
				$summary['messages_sent'] = $this->messagingService->sendQueued(20);
			}

			if (in_array($phase, array('cycle', 'campaigns'), true)) {
				$summary['campaigns'] = $this->campaignService->maintainActiveCampaigns(max(1, (int) (($limit ?: $config['action_budget_per_cycle']) / 2)));
			}

			if (in_array($phase, array('cycle', 'compliance'), true)) {
				$summary['multiaccount_sync'] = $this->multiAccountService->syncAllBots();
			}

			if (in_array($phase, array('cycle', 'maintenance'), true)) {
				$summary['maintenance'] = $this->runMaintenance($config);
			}

			if (in_array($phase, array('cycle', 'long'), true)) {
				$summary['learning_metrics'] = $this->learningService->rebuildMetrics(7);
				$summary['long_state'] = $this->globalStrategyService->refreshLongState($config);
			}

			$this->journalService->closeRun((int) $run['id'], 'done', $summary, $selectedBots, $executedActions);
			return array(
				'phase' => $phase,
				'status' => 'done',
				'selectedBots' => $selectedBots,
				'executedActions' => $executedActions,
				'summary' => $summary,
			);
		} catch (Exception $exception) {
			$this->journalService->closeRun((int) $run['id'], 'failed', $summary, $selectedBots, $executedActions, $exception->getMessage());
			return array(
				'phase' => $phase,
				'status' => 'failed',
				'selectedBots' => $selectedBots,
				'executedActions' => $executedActions,
				'error' => $exception->getMessage(),
			);
		}
	}

	protected function ensureBotFoundation(array $config)
	{
		$db = Database::get();
		$bots = $db->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1;', array(
			':universe' => Universe::getEmulated(),
		));

		foreach ($bots as $bot) {
			$this->traitService->ensureDefaults((int) $bot['id']);
			$this->dynamicStateService->ensureDefaults((int) $bot['id']);
		}

		$this->allianceService->ensureDefaultAlliance($config);
		$this->commanderService->synchronizeHierarchy(8);
	}

	protected function planActions(array $config, $limit)
	{
		require_once ROOT_PATH.'includes/classes/BotCommanderService.class.php';
		$commanderService = new BotCommanderService();
		$db = Database::get();
		$bots = $db->select('SELECT u.id, u.username, COALESCE(hf.hostile_count, 0) AS hostile_count
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			LEFT JOIN (
				SELECT fleet_target_owner AS bot_user_id, COUNT(*) AS hostile_count
				FROM %%FLEETS%%
				WHERE fleet_universe = :universe
				  AND fleet_mess = 0
				  AND hasCanceled = 0
				  AND fleet_end_time >= :now
				  AND fleet_mission IN (1, 6, 9, 10)
				GROUP BY fleet_target_owner
			) hf ON hf.bot_user_id = u.id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND bs.presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\')
			  AND (bs.paused_until IS NULL OR bs.paused_until <= :now)
			  AND (bs.cooldown_until IS NULL OR bs.cooldown_until <= :now OR COALESCE(hf.hostile_count, 0) > 0)
			ORDER BY COALESCE(hf.hostile_count, 0) DESC, COALESCE(bs.current_campaign_id, 0) DESC, COALESCE(bs.last_action_at, 0) ASC, u.id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
				':limit' => (int) ($limit ?: $config['max_bots_per_cycle']),
			));

		$planned = 0;
		$botSummaries = array();
		foreach ($bots as $bot) {
			$snapshot = $this->worldStateBuilder->build((int) $bot['id']);
			if (empty($snapshot)) {
				continue;
			}

			$hierarchy = $commanderService->getHierarchyContext((int) $bot['id']);
			$decision = $this->strategicPlanner->buildDecision($snapshot, $config, $hierarchy);
			$candidates = $this->actionGenerator->generate($snapshot, $decision);
			$scored = $this->actionScorer->score($candidates, $snapshot, $decision);
			$selected = array_slice(array_filter($scored, function ($action) {
				return isset($action['utility']) && $action['utility'] >= 35;
			}), 0, max(1, (int) $config['max_actions_per_bot']));
			$focusTarget = $this->resolveFocusTarget($snapshot, $selected, $decision);

			if (!empty($selected)) {
				$this->actionExecutor->enqueueActions((int) $bot['id'], $selected, 'engine', 'cycle');
			}

			if (!empty($focusTarget)) {
				$commanderService->assignCurrentTarget((int) $bot['id'], $focusTarget);
			} else {
				$commanderService->clearCurrentTarget((int) $bot['id']);
			}

			$bestAction = !empty($selected[0]) ? $selected[0] : array('action_type' => 'veille', 'confidence' => 0, 'estimated_risk' => 0, 'justification' => 'Aucune action suffisante.');
			$this->journalService->logDecision((int) $bot['id'], array(
				'bot_name' => $bot['username'],
				'role' => isset($snapshot['state']['hierarchy_status']) ? $snapshot['state']['hierarchy_status'] : 'membre',
				'etat' => isset($snapshot['state']['presence_logical']) ? $snapshot['state']['presence_logical'] : 'latent',
				'besoin_dominant' => isset($decision['primary_need']) ? $decision['primary_need'] : 'besoin_economique',
				'opportunite_dominante' => !empty($snapshot['best_target']['username']) ? $snapshot['best_target']['username'] : 'aucune cible évidente',
				'ordre_hierarchique' => !empty($snapshot['commander_target_focus']['target_coordinates'])
					? $snapshot['commander_target_focus']['target_coordinates']
					: (!empty($snapshot['current_target_focus']['target_coordinates']) ? $snapshot['current_target_focus']['target_coordinates'] : 'aucun'),
				'action' => $bestAction['action_type'],
				'confidence' => isset($bestAction['confidence']) ? (int) $bestAction['confidence'] : 0,
				'risk' => isset($bestAction['estimated_risk']) ? (int) round($bestAction['estimated_risk']) : 0,
				'next_step' => isset($bestAction['next_step']) ? $bestAction['next_step'] : (isset($bestAction['justification']) ? $bestAction['justification'] : 'veille'),
				'intention' => isset($decision['intention']) ? $decision['intention'] : 'observer',
				'posture_globale' => isset($decision['global_posture']) ? $decision['global_posture'] : 'equilibree',
			));

			$this->memoryService->remember((int) $bot['id'], 'decision', 'dernier_objectif', array(
				'goal' => $decision['strategic_goal'],
				'action' => $bestAction['action_type'],
			), 55, 86400);
			if (!empty($focusTarget)) {
				$this->memoryService->remember((int) $bot['id'], 'targeting', 'focus_courant', array(
					'target_user_id' => !empty($focusTarget['target_user_id']) ? (int) $focusTarget['target_user_id'] : 0,
					'target_username' => !empty($focusTarget['target_username']) ? $focusTarget['target_username'] : '',
					'target_coordinates' => !empty($focusTarget['target_coordinates']) ? $focusTarget['target_coordinates'] : '',
					'hostility' => !empty($snapshot['hostile_context']['pressure_score']) ? min(100, (int) $snapshot['hostile_context']['pressure_score']) : 0,
					'revenge' => !empty($snapshot['hostile_context']['retaliation_target']) ? 70 : 30,
				), 72, 86400);
			}

			$db->update('UPDATE %%BOT_STATE%% SET next_intention_at = :nextIntentionAt, last_decision_at = :lastDecisionAt, updated_at = :updatedAt WHERE bot_user_id = :botUserId;', array(
				':nextIntentionAt' => TIMESTAMP + 300,
				':lastDecisionAt' => TIMESTAMP,
				':updatedAt' => TIMESTAMP,
				':botUserId' => (int) $bot['id'],
			));

			$planned++;
			$botSummaries[] = array(
				'id' => (int) $bot['id'],
				'username' => $bot['username'],
				'goal' => $decision['strategic_goal'],
				'action' => $bestAction['action_type'],
			);
		}

		return array(
			'selected_bots' => $planned,
			'items' => $botSummaries,
		);
	}

	protected function resolveFocusTarget(array $snapshot, array $selected, array $decision)
	{
		$candidates = array(
			isset($snapshot['hostile_context']['retaliation_target']) ? $snapshot['hostile_context']['retaliation_target'] : array(),
			isset($snapshot['current_target_focus']) ? $snapshot['current_target_focus'] : array(),
			isset($snapshot['commander_target_focus']) ? $snapshot['commander_target_focus'] : array(),
		);

		foreach ($selected as $action) {
			if (!empty($action['payload']['target_coordinates'])) {
				$candidates[] = array(
					'type' => 'coordonnees',
					'reference' => (string) $action['payload']['target_coordinates'],
					'target_coordinates' => (string) $action['payload']['target_coordinates'],
					'target_planet_id' => !empty($action['payload']['target_planet_id']) ? (int) $action['payload']['target_planet_id'] : 0,
					'target_user_id' => !empty($action['payload']['target_user_id']) ? (int) $action['payload']['target_user_id'] : 0,
					'target_username' => !empty($action['payload']['target_username']) ? $action['payload']['target_username'] : '',
					'goal' => isset($decision['strategic_goal']) ? $decision['strategic_goal'] : '',
					'updated_at' => TIMESTAMP,
				);
			}
		}

		foreach ($candidates as $candidate) {
			if (!empty($candidate['target_coordinates']) || !empty($candidate['reference'])) {
				if (empty($candidate['type'])) {
					$candidate['type'] = !empty($candidate['target_coordinates']) ? 'coordonnees' : 'zone';
				}
				if (empty($candidate['reference']) && !empty($candidate['target_coordinates'])) {
					$candidate['reference'] = $candidate['target_coordinates'];
				}
				$candidate['updated_at'] = TIMESTAMP;
				return $candidate;
			}
		}

		return array();
	}

	protected function runMaintenance(array $config)
	{
		$maintenance = array();
		$maintenance['hierarchy'] = $this->commanderService->synchronizeHierarchy(8);
		$maintenance['stale_targets'] = $this->commanderService->clearStaleTargets(21600);
		$maintenance['stale_actions'] = $this->actionExecutor->recoverStaleActions(1800);
		$maintenance['queue_compaction'] = $this->actionExecutor->compactQueue(12);
		$maintenance['historical_failures'] = $this->actionExecutor->purgeHistoricalFailures(21600, 1);
		$maintenance['completed_campaigns'] = $this->campaignService->recoverCampaigns();
		$maintenance['expired_memory'] = $this->memoryService->purgeExpired();
		$maintenance['multiaccount_sync'] = $this->multiAccountService->syncAllBots();
		$maintenance['territorial_map'] = $this->territorialMapService->rebuildMap(240);

		return $maintenance;
	}

	protected function isLocked($phase)
	{
		$running = Database::get()->selectSingle('SELECT id
			FROM %%BOT_ENGINE_RUNS%%
			WHERE universe = :universe
			  AND phase = :phase
			  AND status = \'running\'
			  AND started_at >= :startedAt
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':phase' => (string) $phase,
				':startedAt' => TIMESTAMP - 1800,
			));

		return !empty($running);
	}
}
