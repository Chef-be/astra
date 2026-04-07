<?php

class BotEngineConfigService
{
	protected $jsonColumns = array(
		'global_presence_rules_json',
		'profile_quotas_json',
		'decision_weights_json',
	);

	public function ensureDefaults($universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$db = Database::get();
		$row = $db->selectSingle('SELECT universe FROM %%BOT_ENGINE_CONFIG%% WHERE universe = :universe LIMIT 1;', array(
			':universe' => (int) $universe,
		));

		if (!empty($row)) {
			return;
		}

		$sharedEmail = $db->selectSingle('SELECT email
			FROM %%USERS%%
			WHERE universe = :universe AND is_bot = 1 AND email <> \'\'
			ORDER BY id ASC
			LIMIT 1;', array(
				':universe' => (int) $universe,
			), 'email');

		if (empty($sharedEmail)) {
			$sharedEmail = 'bots@astra.local';
		}

		$db->insert('INSERT INTO %%BOT_ENGINE_CONFIG%% SET
			universe = :universe,
			engine_enabled = 1,
			target_online_total = 24,
			target_social_total = 8,
			action_budget_per_cycle = 24,
			max_bots_per_cycle = 12,
			max_actions_per_bot = 3,
			enable_bot_alliances = 1,
			enable_command_hierarchy = 1,
			enable_bonuses = 1,
			enable_private_messages = 1,
			enable_social_messages = 1,
			enable_campaigns = 1,
			shared_email = :sharedEmail,
			password_policy = :passwordPolicy,
			multiaccount_policy = :multiPolicy,
			default_bot_alliance_tag = :tag,
			default_bot_alliance_name = :name,
			global_presence_rules_json = :presenceRules,
			profile_quotas_json = :profileQuotas,
			decision_weights_json = :decisionWeights,
			created_at = :timestamp,
			updated_at = :timestamp;', array(
				':universe' => (int) $universe,
				':sharedEmail' => $sharedEmail,
				':passwordPolicy' => 'rotation_mensuelle',
				':multiPolicy' => 'bots_valides',
				':tag' => 'ASTRA',
				':name' => 'Commandement Astra',
				':presenceRules' => json_encode($this->getDefaultPresenceRules()),
				':profileQuotas' => json_encode(array()),
				':decisionWeights' => json_encode($this->getDefaultDecisionWeights()),
				':timestamp' => TIMESTAMP,
			));
	}

	public function getConfig($universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$this->ensureDefaults($universe);

		$row = Database::get()->selectSingle('SELECT *
			FROM %%BOT_ENGINE_CONFIG%%
			WHERE universe = :universe
			LIMIT 1;', array(
				':universe' => (int) $universe,
			));

		foreach ($this->jsonColumns as $column) {
			$row[$column] = $this->decodeJsonColumn(isset($row[$column]) ? $row[$column] : null);
		}

		$row['global_presence_rules_json'] = array_replace_recursive($this->getDefaultPresenceRules(), $row['global_presence_rules_json']);
		$row['decision_weights_json'] = array_replace_recursive($this->getDefaultDecisionWeights(), $row['decision_weights_json']);
		$row['profile_quotas_json'] = is_array($row['profile_quotas_json']) ? $row['profile_quotas_json'] : array();

		return $row;
	}

	public function saveConfig(array $data, $universe = null)
	{
		if ($universe === null) {
			$universe = Universe::getEmulated();
		}

		$current = $this->getConfig($universe);
		$merged = array_merge($current, $data);

		Database::get()->update('UPDATE %%BOT_ENGINE_CONFIG%% SET
			engine_enabled = :engineEnabled,
			target_online_total = :targetOnlineTotal,
			target_social_total = :targetSocialTotal,
			action_budget_per_cycle = :actionBudget,
			max_bots_per_cycle = :maxBotsPerCycle,
			max_actions_per_bot = :maxActionsPerBot,
			enable_bot_alliances = :enableBotAlliances,
			enable_command_hierarchy = :enableCommandHierarchy,
			enable_bonuses = :enableBonuses,
			enable_private_messages = :enablePrivateMessages,
			enable_social_messages = :enableSocialMessages,
			enable_campaigns = :enableCampaigns,
			shared_email = :sharedEmail,
			password_policy = :passwordPolicy,
			multiaccount_policy = :multiaccountPolicy,
			default_bot_alliance_tag = :tag,
			default_bot_alliance_name = :name,
			global_presence_rules_json = :presenceRules,
			profile_quotas_json = :profileQuotas,
			decision_weights_json = :decisionWeights,
			updated_at = :updatedAt
			WHERE universe = :universe;', array(
				':engineEnabled' => empty($merged['engine_enabled']) ? 0 : 1,
				':targetOnlineTotal' => max(0, (int) $merged['target_online_total']),
				':targetSocialTotal' => max(0, (int) $merged['target_social_total']),
				':actionBudget' => max(1, (int) $merged['action_budget_per_cycle']),
				':maxBotsPerCycle' => max(1, (int) $merged['max_bots_per_cycle']),
				':maxActionsPerBot' => max(1, (int) $merged['max_actions_per_bot']),
				':enableBotAlliances' => empty($merged['enable_bot_alliances']) ? 0 : 1,
				':enableCommandHierarchy' => empty($merged['enable_command_hierarchy']) ? 0 : 1,
				':enableBonuses' => empty($merged['enable_bonuses']) ? 0 : 1,
				':enablePrivateMessages' => empty($merged['enable_private_messages']) ? 0 : 1,
				':enableSocialMessages' => empty($merged['enable_social_messages']) ? 0 : 1,
				':enableCampaigns' => empty($merged['enable_campaigns']) ? 0 : 1,
				':sharedEmail' => trim((string) $merged['shared_email']) !== '' ? trim((string) $merged['shared_email']) : $current['shared_email'],
				':passwordPolicy' => trim((string) $merged['password_policy']) !== '' ? trim((string) $merged['password_policy']) : 'rotation_mensuelle',
				':multiaccountPolicy' => trim((string) $merged['multiaccount_policy']) !== '' ? trim((string) $merged['multiaccount_policy']) : 'bots_valides',
				':tag' => trim((string) $merged['default_bot_alliance_tag']) !== '' ? trim((string) $merged['default_bot_alliance_tag']) : 'ASTRA',
				':name' => trim((string) $merged['default_bot_alliance_name']) !== '' ? trim((string) $merged['default_bot_alliance_name']) : 'Commandement Astra',
				':presenceRules' => json_encode(isset($merged['global_presence_rules_json']) ? $merged['global_presence_rules_json'] : $this->getDefaultPresenceRules()),
				':profileQuotas' => json_encode(isset($merged['profile_quotas_json']) ? $merged['profile_quotas_json'] : array()),
				':decisionWeights' => json_encode(isset($merged['decision_weights_json']) ? $merged['decision_weights_json'] : $this->getDefaultDecisionWeights()),
				':updatedAt' => TIMESTAMP,
				':universe' => (int) $universe,
			));
	}

	public function getDefaultPresenceRules()
	{
		return array(
			'tranches' => array(
				'00-06' => 0.45,
				'06-12' => 0.65,
				'12-18' => 0.85,
				'18-24' => 1.00,
			),
			'sessions' => array(
				'min_minutes' => 18,
				'max_minutes' => 75,
				'min_rest_minutes' => 12,
				'max_rest_minutes' => 90,
				'rest_ratio' => 0.55,
				'commander_bonus_minutes' => 40,
				'campaign_bonus_minutes' => 55,
			),
			'always_visible_roles' => array('chef', 'animateur'),
		);
	}

	public function getDefaultDecisionWeights()
	{
		return array(
			'economy' => array(
				'deficit_ressources' => 0.25,
				'retard_infrastructure' => 0.20,
				'besoin_financement_objectif' => 0.15,
				'doctrine_economique' => 0.10,
				'prudence' => 0.10,
				'fatigue' => 0.10,
				'manque_stock' => 0.10,
			),
			'aggression' => array(
				'agressivite' => 0.20,
				'opportunite_raid' => 0.15,
				'superiorite_locale' => 0.15,
				'appetit_raid' => 0.10,
				'rancune' => 0.10,
				'ordre_offensif' => 0.10,
				'intensite_campagne' => 0.10,
				'soutien_alliance' => 0.05,
				'peur' => -0.10,
				'fatigue' => -0.05,
			),
			'pression_continue' => array(
				'campagne_active' => 0.20,
				'persistance_tactique' => 0.20,
				'superiorite_locale' => 0.15,
				'objectif_alliance' => 0.15,
				'bonus_chef' => 0.10,
				'rotation_disponible' => 0.10,
				'logistique_disponible' => 0.10,
				'usure' => -0.10,
				'saturation_logistique' => -0.10,
			),
			'communication' => array(
				'sociabilite' => 0.20,
				'role_social' => 0.15,
				'opportunite_diplomatique' => 0.15,
				'pression_psychologique' => 0.15,
				'campagne_active' => 0.10,
				'ordre_chef' => 0.10,
				'discretion' => -0.15,
				'fatigue' => -0.10,
			),
		);
	}

	protected function decodeJsonColumn($value)
	{
		if (empty($value)) {
			return array();
		}

		$decoded = json_decode($value, true);
		return is_array($decoded) ? $decoded : array();
	}
}
