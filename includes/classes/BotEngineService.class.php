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
			if (in_array($phase, array('cycle', 'planning', 'campaigns', 'maintenance'), true)) {
				$summary['alliances'] = $this->allianceService->refreshAllianceGovernance(10);
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
		$bots = $db->select('SELECT u.id, u.username
			FROM %%USERS%% u
			INNER JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
			WHERE u.universe = :universe
			  AND u.is_bot = 1
			  AND bs.presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\')
			  AND (bs.paused_until IS NULL OR bs.paused_until <= :now)
			  AND (bs.cooldown_until IS NULL OR bs.cooldown_until <= :now)
			ORDER BY COALESCE(bs.current_campaign_id, 0) DESC, COALESCE(bs.last_action_at, 0) ASC, u.id ASC
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

			if (!empty($selected)) {
				$this->actionExecutor->enqueueActions((int) $bot['id'], $selected, 'engine', 'cycle');
			}

			$bestAction = !empty($selected[0]) ? $selected[0] : array('action_type' => 'veille', 'confidence' => 0, 'estimated_risk' => 0, 'justification' => 'Aucune action suffisante.');
			$this->journalService->logDecision((int) $bot['id'], array(
				'bot_name' => $bot['username'],
				'role' => isset($snapshot['state']['hierarchy_status']) ? $snapshot['state']['hierarchy_status'] : 'membre',
				'etat' => isset($snapshot['state']['presence_logical']) ? $snapshot['state']['presence_logical'] : 'latent',
				'besoin_dominant' => isset($decision['primary_need']) ? $decision['primary_need'] : 'besoin_economique',
				'opportunite_dominante' => !empty($snapshot['best_target']['username']) ? $snapshot['best_target']['username'] : 'aucune cible évidente',
				'ordre_hierarchique' => !empty($hierarchy['state']['current_target_json']) ? $hierarchy['state']['current_target_json'] : 'aucun',
				'action' => $bestAction['action_type'],
				'confidence' => isset($bestAction['confidence']) ? (int) $bestAction['confidence'] : 0,
				'risk' => isset($bestAction['estimated_risk']) ? (int) round($bestAction['estimated_risk']) : 0,
				'next_step' => isset($bestAction['next_step']) ? $bestAction['next_step'] : (isset($bestAction['justification']) ? $bestAction['justification'] : 'veille'),
			));

			$this->memoryService->remember((int) $bot['id'], 'decision', 'dernier_objectif', array(
				'goal' => $decision['strategic_goal'],
				'action' => $bestAction['action_type'],
			), 55, 86400);

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

	protected function runMaintenance(array $config)
	{
		$maintenance = array();
		$maintenance['hierarchy'] = $this->commanderService->synchronizeHierarchy(8);
		$maintenance['stale_actions'] = $this->actionExecutor->recoverStaleActions(1800);
		$maintenance['completed_campaigns'] = $this->campaignService->recoverCampaigns();
		$maintenance['expired_memory'] = $this->memoryService->purgeExpired();
		$maintenance['multiaccount_sync'] = $this->multiAccountService->syncAllBots();

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
