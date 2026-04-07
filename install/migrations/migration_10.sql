ALTER TABLE `%PREFIX%bot_profiles`
  ADD COLUMN IF NOT EXISTS `profile_code` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `doctrine` varchar(64) NOT NULL DEFAULT 'equilibre',
  ADD COLUMN IF NOT EXISTS `role_primary` varchar(64) NOT NULL DEFAULT 'economiste',
  ADD COLUMN IF NOT EXISTS `role_secondary` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `communication_style` varchar(64) NOT NULL DEFAULT 'mesure',
  ADD COLUMN IF NOT EXISTS `target_social_online` int(11) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN IF NOT EXISTS `target_presence_min` int(11) unsigned NOT NULL DEFAULT '15',
  ADD COLUMN IF NOT EXISTS `target_presence_max` int(11) unsigned NOT NULL DEFAULT '90',
  ADD COLUMN IF NOT EXISTS `always_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN IF NOT EXISTS `is_visible_socially` tinyint(1) unsigned NOT NULL DEFAULT '1',
  ADD COLUMN IF NOT EXISTS `is_commander_profile` tinyint(1) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN IF NOT EXISTS `traits_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `weights_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `hourly_schedule_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `bonus_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `doctrine_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `created_by_user_id` int(11) unsigned DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN IF NOT EXISTS `archived_at` int(11) unsigned DEFAULT NULL;

ALTER TABLE `%PREFIX%bot_commands`
  ADD COLUMN IF NOT EXISTS `command_family` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `command_name` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `target_type` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `target_reference` varchar(190) NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS `scope_mode` varchar(32) NOT NULL DEFAULT 'direct',
  ADD COLUMN IF NOT EXISTS `priority` tinyint(3) unsigned NOT NULL DEFAULT '50',
  ADD COLUMN IF NOT EXISTS `scheduled_at` int(11) unsigned DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `locked_at` int(11) unsigned DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `lock_token` varchar(64) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `payload_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `parsed_command_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `result_json` mediumtext,
  ADD COLUMN IF NOT EXISTS `engine_run_id` int(11) unsigned DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `failure_reason` varchar(255) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_engine_config` (
  `universe` int(11) unsigned NOT NULL,
  `engine_enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `target_online_total` int(11) unsigned NOT NULL DEFAULT '24',
  `target_social_total` int(11) unsigned NOT NULL DEFAULT '8',
  `action_budget_per_cycle` int(11) unsigned NOT NULL DEFAULT '24',
  `max_bots_per_cycle` int(11) unsigned NOT NULL DEFAULT '12',
  `max_actions_per_bot` tinyint(3) unsigned NOT NULL DEFAULT '3',
  `enable_bot_alliances` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_command_hierarchy` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_bonuses` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_private_messages` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_social_messages` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_campaigns` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `shared_email` varchar(190) NOT NULL DEFAULT 'bots@astra.local',
  `password_policy` varchar(64) NOT NULL DEFAULT 'rotation_mensuelle',
  `multiaccount_policy` varchar(64) NOT NULL DEFAULT 'bots_valides',
  `default_bot_alliance_tag` varchar(12) NOT NULL DEFAULT 'ASTRA',
  `default_bot_alliance_name` varchar(80) NOT NULL DEFAULT 'Commandement Astra',
  `global_presence_rules_json` mediumtext,
  `profile_quotas_json` mediumtext,
  `decision_weights_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`universe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_state` (
  `bot_user_id` int(11) unsigned NOT NULL,
  `universe` int(11) unsigned NOT NULL,
  `role_primary` varchar(64) NOT NULL DEFAULT 'economiste',
  `role_secondary` varchar(64) NOT NULL DEFAULT '',
  `hierarchy_status` varchar(32) NOT NULL DEFAULT 'membre',
  `doctrine_active` varchar(64) NOT NULL DEFAULT 'equilibre',
  `presence_logical` varchar(32) NOT NULL DEFAULT 'latent',
  `presence_social` varchar(32) NOT NULL DEFAULT 'discret',
  `commander_bot_user_id` int(11) unsigned DEFAULT NULL,
  `squad_id` int(11) unsigned DEFAULT NULL,
  `alliance_id` int(11) unsigned DEFAULT NULL,
  `prestige` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `obedience_modifier` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `bonus_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `cooldown_until` int(11) unsigned DEFAULT NULL,
  `paused_until` int(11) unsigned DEFAULT NULL,
  `next_intention_at` int(11) unsigned DEFAULT NULL,
  `last_decision_at` int(11) unsigned DEFAULT NULL,
  `last_action_at` int(11) unsigned DEFAULT NULL,
  `action_queue_size` int(11) unsigned NOT NULL DEFAULT '0',
  `is_online_forced` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_socially_visible` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `current_campaign_id` int(11) unsigned DEFAULT NULL,
  `current_target_json` mediumtext,
  `structural_state_json` mediumtext,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bot_user_id`),
  KEY `universe` (`universe`,`presence_logical`,`presence_social`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_traits` (
  `bot_user_id` int(11) unsigned NOT NULL,
  `aggressivite` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `prudence` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `ambition` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `loyaute` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `discipline` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `sociabilite` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `opportunisme` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `expansion` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `technologie` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `economie` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `defense` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `espionnage` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `tolerance_risque` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `aptitude_commandement` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `obeissance` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `rancune` tinyint(3) unsigned NOT NULL DEFAULT '20',
  `stabilite_emotionnelle` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `coordination` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `intensite_offensive` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `aptitude_communication` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `gout_harcelement` tinyint(3) unsigned NOT NULL DEFAULT '30',
  `persistance_tactique` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bot_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_dynamic_state` (
  `bot_user_id` int(11) unsigned NOT NULL,
  `stress` tinyint(3) unsigned NOT NULL DEFAULT '20',
  `confiance` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `moral` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `fatigue` tinyint(3) unsigned NOT NULL DEFAULT '15',
  `peur` tinyint(3) unsigned NOT NULL DEFAULT '10',
  `pression_ennemie` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `appetit_raid` tinyint(3) unsigned NOT NULL DEFAULT '40',
  `vigilance` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `satisfaction_economique` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `saturation_logistique` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tension_diplomatique` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `superiorite_locale` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `intensite_campagne` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `envie_vengeance` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `disponibilite_sociale` tinyint(3) unsigned NOT NULL DEFAULT '40',
  `excitation_offensive` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bot_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_memory` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_user_id` int(11) unsigned NOT NULL,
  `universe` int(11) unsigned NOT NULL,
  `memory_scope` varchar(64) NOT NULL,
  `memory_key` varchar(190) NOT NULL,
  `memory_value_json` mediumtext,
  `intensity` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `expires_at` int(11) unsigned DEFAULT NULL,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bot_scope` (`bot_user_id`,`memory_scope`,`memory_key`),
  KEY `universe` (`universe`,`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_relationships` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_user_id` int(11) unsigned NOT NULL,
  `target_type` varchar(32) NOT NULL,
  `target_reference` varchar(190) NOT NULL,
  `stance` varchar(32) NOT NULL DEFAULT 'neutre',
  `affinity` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `fear` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `resentment` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `trust` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `notes_json` mediumtext,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bot_target` (`bot_user_id`,`target_type`,`target_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_squads` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `squad_code` varchar(64) NOT NULL,
  `squad_name` varchar(120) NOT NULL,
  `doctrine` varchar(64) NOT NULL DEFAULT 'equilibre',
  `commander_bot_user_id` int(11) unsigned DEFAULT NULL,
  `target_scope` varchar(190) NOT NULL DEFAULT '',
  `is_temporary` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `settings_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_squad_members` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `squad_id` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `role_name` varchar(64) NOT NULL DEFAULT 'membre',
  `joined_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `squad_id` (`squad_id`,`bot_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_alliance_meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `alliance_id` int(11) unsigned DEFAULT NULL,
  `meta_tag` varchar(20) NOT NULL,
  `meta_name` varchar(120) NOT NULL,
  `doctrine` varchar(64) NOT NULL DEFAULT 'equilibre',
  `territorial_core_json` mediumtext,
  `diplomacy_json` mediumtext,
  `objective_json` mediumtext,
  `recruitment_policy` varchar(64) NOT NULL DEFAULT 'ouvert',
  `communication_policy` varchar(64) NOT NULL DEFAULT 'visible',
  `command_state_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`,`meta_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_bonus_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `rule_code` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `bonus_type` varchar(64) NOT NULL,
  `scope_type` varchar(32) NOT NULL DEFAULT 'bot',
  `score_modifier` decimal(8,2) NOT NULL DEFAULT '0.00',
  `payload_json` mediumtext,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`,`rule_code`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_bonus_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `rule_id` int(11) unsigned DEFAULT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `source_type` varchar(32) NOT NULL DEFAULT 'manuel',
  `source_reference` varchar(190) NOT NULL DEFAULT '',
  `active_until` int(11) unsigned DEFAULT NULL,
  `payload_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bot_rule` (`bot_user_id`,`rule_id`,`active_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_action_queue` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `source_type` varchar(32) NOT NULL DEFAULT 'engine',
  `source_reference` varchar(190) NOT NULL DEFAULT '',
  `action_type` varchar(64) NOT NULL,
  `objective_type` varchar(64) NOT NULL DEFAULT '',
  `priority` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `planned_at` int(11) unsigned NOT NULL DEFAULT '0',
  `due_at` int(11) unsigned DEFAULT NULL,
  `locked_at` int(11) unsigned DEFAULT NULL,
  `started_at` int(11) unsigned DEFAULT NULL,
  `finished_at` int(11) unsigned DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'queued',
  `estimated_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `estimated_risk` decimal(12,2) NOT NULL DEFAULT '0.00',
  `confidence` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `payload_json` mediumtext,
  `justification` varchar(255) NOT NULL DEFAULT '',
  `result_summary` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `queue_lookup` (`universe`,`status`,`priority`,`planned_at`),
  KEY `bot_lookup` (`bot_user_id`,`status`,`due_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_action_results` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `action_queue_id` bigint(20) unsigned NOT NULL,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'done',
  `result_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `action_queue_id` (`action_queue_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_engine_runs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `phase` varchar(32) NOT NULL DEFAULT 'cycle',
  `status` varchar(16) NOT NULL DEFAULT 'running',
  `lock_name` varchar(120) NOT NULL DEFAULT '',
  `lock_token` varchar(64) NOT NULL DEFAULT '',
  `started_at` int(11) unsigned NOT NULL DEFAULT '0',
  `finished_at` int(11) unsigned DEFAULT NULL,
  `selected_bots` int(11) unsigned NOT NULL DEFAULT '0',
  `executed_actions` int(11) unsigned NOT NULL DEFAULT '0',
  `summary_json` mediumtext,
  `error_summary` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `run_lookup` (`universe`,`phase`,`status`,`started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_presence_snapshots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `logical_presence` varchar(32) NOT NULL,
  `social_presence` varchar(32) NOT NULL,
  `snapshot_reason` varchar(120) NOT NULL DEFAULT '',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `snapshot_lookup` (`universe`,`bot_user_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_campaigns` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `campaign_code` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `campaign_type` varchar(64) NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'active',
  `target_type` varchar(32) NOT NULL DEFAULT '',
  `target_reference` varchar(190) NOT NULL DEFAULT '',
  `zone_reference` varchar(190) NOT NULL DEFAULT '',
  `responsible_alliance_meta_id` int(11) unsigned DEFAULT NULL,
  `responsible_bot_user_id` int(11) unsigned DEFAULT NULL,
  `rhythm_minutes` int(11) unsigned NOT NULL DEFAULT '30',
  `interval_minutes` int(11) unsigned NOT NULL DEFAULT '15',
  `duration_minutes` int(11) unsigned NOT NULL DEFAULT '360',
  `budget_actions` int(11) unsigned NOT NULL DEFAULT '24',
  `intensity` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `objective_exit` varchar(120) NOT NULL DEFAULT '',
  `payload_json` mediumtext,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `campaign_lookup` (`universe`,`status`,`campaign_type`,`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_campaign_members` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned DEFAULT NULL,
  `squad_id` int(11) unsigned DEFAULT NULL,
  `role_name` varchar(64) NOT NULL DEFAULT 'membre',
  `rotation_weight` tinyint(3) unsigned NOT NULL DEFAULT '50',
  `joined_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `campaign_id` (`campaign_id`,`bot_user_id`,`squad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_private_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `target_user_id` int(11) unsigned NOT NULL,
  `subject` varchar(180) NOT NULL DEFAULT '',
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'queued',
  `cooldown_until` int(11) unsigned DEFAULT NULL,
  `sent_at` int(11) unsigned DEFAULT NULL,
  `payload_json` mediumtext,
  PRIMARY KEY (`id`),
  KEY `message_lookup` (`universe`,`status`,`bot_user_id`,`target_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_social_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `channel_key` varchar(32) NOT NULL DEFAULT 'bots',
  `target_user_id` int(11) unsigned DEFAULT NULL,
  `target_username` varchar(64) NOT NULL DEFAULT '',
  `message_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'queued',
  `cooldown_until` int(11) unsigned DEFAULT NULL,
  `sent_at` int(11) unsigned DEFAULT NULL,
  `payload_json` mediumtext,
  PRIMARY KEY (`id`),
  KEY `social_lookup` (`universe`,`status`,`channel_key`,`bot_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_multiaccount_validation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `validation_status` varchar(32) NOT NULL DEFAULT 'validated_bot',
  `validation_reason` varchar(190) NOT NULL DEFAULT '',
  `validated_by_user_id` int(11) unsigned DEFAULT NULL,
  `validated_at` int(11) unsigned DEFAULT NULL,
  `notes_json` mediumtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bot_user_id` (`bot_user_id`),
  KEY `universe` (`universe`,`validation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_account_compliance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `bot_user_id` int(11) unsigned NOT NULL,
  `shared_email` varchar(190) NOT NULL DEFAULT '',
  `password_rotated_at` int(11) unsigned DEFAULT NULL,
  `password_policy` varchar(64) NOT NULL DEFAULT 'rotation_mensuelle',
  `multiaccount_sync_at` int(11) unsigned DEFAULT NULL,
  `compliance_status` varchar(32) NOT NULL DEFAULT 'pending',
  `details_json` mediumtext,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bot_user_id` (`bot_user_id`),
  KEY `universe` (`universe`,`compliance_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_command_catalog` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `command_key` varchar(64) NOT NULL,
  `family_key` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `help_text` varchar(255) NOT NULL DEFAULT '',
  `syntax_example` varchar(255) NOT NULL DEFAULT '',
  `target_types_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload_schema_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `command_lookup` (`family_key`,`command_key`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `%PREFIX%bot_engine_config`
(`universe`, `engine_enabled`, `target_online_total`, `target_social_total`, `action_budget_per_cycle`, `max_bots_per_cycle`, `max_actions_per_bot`, `enable_bot_alliances`, `enable_command_hierarchy`, `enable_bonuses`, `enable_private_messages`, `enable_social_messages`, `enable_campaigns`, `shared_email`, `password_policy`, `multiaccount_policy`, `default_bot_alliance_tag`, `default_bot_alliance_name`, `global_presence_rules_json`, `profile_quotas_json`, `decision_weights_json`, `created_at`, `updated_at`)
SELECT c.uni, 1, 24, 8, 24, 12, 3, 1, 1, 1, 1, 1, 1,
       CASE
         WHEN EXISTS(SELECT 1 FROM `%PREFIX%users` u WHERE u.universe = c.uni AND u.is_bot = 1 AND u.email <> '' LIMIT 1)
           THEN (SELECT u.email FROM `%PREFIX%users` u WHERE u.universe = c.uni AND u.is_bot = 1 AND u.email <> '' ORDER BY u.id ASC LIMIT 1)
         ELSE 'bots@astra.local'
       END,
       'rotation_mensuelle',
       'bots_valides',
       'ASTRA',
       'Commandement Astra',
       '{"tranches":{"00-06":0.45,"06-12":0.65,"12-18":0.85,"18-24":1.00},"always_visible_roles":["chef","animateur"]}',
       '{}',
       '{"economy":{"deficit_ressources":0.25,"retard_infrastructure":0.20,"besoin_financement_objectif":0.15,"doctrine_economique":0.10,"prudence":0.10,"fatigue":0.10,"manque_stock":0.10},"aggression":{"agressivite":0.20,"opportunite_raid":0.15,"superiorite_locale":0.15,"appetit_raid":0.10,"rancune":0.10,"ordre_offensif":0.10,"intensite_campagne":0.10,"soutien_alliance":0.05,"peur":-0.10,"fatigue":-0.05},"pression_continue":{"campagne_active":0.20,"persistance_tactique":0.20,"superiorite_locale":0.15,"objectif_alliance":0.15,"bonus_chef":0.10,"rotation_disponible":0.10,"logistique_disponible":0.10,"usure":-0.10,"saturation_logistique":-0.10},"communication":{"sociabilite":0.20,"role_social":0.15,"opportunite_diplomatique":0.15,"pression_psychologique":0.15,"campagne_active":0.10,"ordre_chef":0.10,"discretion":-0.15,"fatigue":-0.10}}',
       UNIX_TIMESTAMP(),
       UNIX_TIMESTAMP()
FROM `%PREFIX%config` c
WHERE NOT EXISTS (
  SELECT 1
  FROM `%PREFIX%bot_engine_config` bec
  WHERE bec.universe = c.uni
);

UPDATE `%PREFIX%users` u
INNER JOIN `%PREFIX%bot_engine_config` bec ON bec.universe = u.universe
SET u.email = bec.shared_email,
    u.email_2 = bec.shared_email
WHERE u.is_bot = 1;

INSERT INTO `%PREFIX%multi` (`userID`)
SELECT u.id
FROM `%PREFIX%users` u
LEFT JOIN `%PREFIX%multi` m ON m.userID = u.id
WHERE u.is_bot = 1
  AND m.userID IS NULL;

INSERT INTO `%PREFIX%bot_state`
(`bot_user_id`, `universe`, `role_primary`, `role_secondary`, `hierarchy_status`, `doctrine_active`, `presence_logical`, `presence_social`, `prestige`, `obedience_modifier`, `bonus_score`, `action_queue_size`, `is_online_forced`, `is_socially_visible`, `updated_at`)
SELECT u.id,
       u.universe,
       COALESCE(NULLIF(bp.role_primary, ''), 'economiste'),
       COALESCE(bp.role_secondary, ''),
       CASE
         WHEN u.username LIKE 'Général %' THEN 'chef'
         WHEN COALESCE(bp.is_commander_profile, 0) = 1 THEN 'chef'
         ELSE 'membre'
       END,
       COALESCE(NULLIF(bp.doctrine, ''), 'equilibre'),
       'latent',
       'discret',
       CASE
         WHEN u.username LIKE 'Général %' THEN 75
         ELSE 50
       END,
       50,
       0,
       0,
       0,
       0,
       UNIX_TIMESTAMP()
FROM `%PREFIX%users` u
LEFT JOIN `%PREFIX%bot_profiles` bp ON bp.id = u.bot_profile_id
LEFT JOIN `%PREFIX%bot_state` bs ON bs.bot_user_id = u.id
WHERE u.is_bot = 1
  AND bs.bot_user_id IS NULL;

INSERT INTO `%PREFIX%bot_traits`
(`bot_user_id`, `aggressivite`, `prudence`, `ambition`, `loyaute`, `discipline`, `sociabilite`, `opportunisme`, `expansion`, `technologie`, `economie`, `defense`, `espionnage`, `tolerance_risque`, `aptitude_commandement`, `obeissance`, `rancune`, `stabilite_emotionnelle`, `coordination`, `intensite_offensive`, `aptitude_communication`, `gout_harcelement`, `persistance_tactique`, `updated_at`)
SELECT u.id,
       COALESCE(bp.aggression, 35),
       60,
       55,
       70,
       65,
       40,
       50,
       COALESCE(bp.expansion_focus, 40),
       45,
       COALESCE(bp.economy_focus, 50),
       50,
       55,
       45,
       CASE
         WHEN u.username LIKE 'Général %' THEN 80
         ELSE 45
       END,
       65,
       20,
       60,
       55,
       COALESCE(bp.aggression, 35),
       45,
       30,
       55,
       UNIX_TIMESTAMP()
FROM `%PREFIX%users` u
LEFT JOIN `%PREFIX%bot_profiles` bp ON bp.id = u.bot_profile_id
LEFT JOIN `%PREFIX%bot_traits` bt ON bt.bot_user_id = u.id
WHERE u.is_bot = 1
  AND bt.bot_user_id IS NULL;

INSERT INTO `%PREFIX%bot_dynamic_state`
(`bot_user_id`, `stress`, `confiance`, `moral`, `fatigue`, `peur`, `pression_ennemie`, `appetit_raid`, `vigilance`, `satisfaction_economique`, `saturation_logistique`, `tension_diplomatique`, `superiorite_locale`, `intensite_campagne`, `envie_vengeance`, `disponibilite_sociale`, `excitation_offensive`, `updated_at`)
SELECT u.id, 20, 55, 55, 15, 10, 0, 45, 50, 45, 0, 0, 50, 0, 0, 40, 25, UNIX_TIMESTAMP()
FROM `%PREFIX%users` u
LEFT JOIN `%PREFIX%bot_dynamic_state` bds ON bds.bot_user_id = u.id
WHERE u.is_bot = 1
  AND bds.bot_user_id IS NULL;

INSERT INTO `%PREFIX%bot_multiaccount_validation`
(`universe`, `bot_user_id`, `validation_status`, `validation_reason`, `validated_at`, `notes_json`)
SELECT u.universe, u.id, 'validated_bot', 'migration_initiale', UNIX_TIMESTAMP(), '{"source":"migration_10"}'
FROM `%PREFIX%users` u
LEFT JOIN `%PREFIX%bot_multiaccount_validation` bmv ON bmv.bot_user_id = u.id
WHERE u.is_bot = 1
  AND bmv.bot_user_id IS NULL;

INSERT INTO `%PREFIX%bot_account_compliance`
(`universe`, `bot_user_id`, `shared_email`, `password_rotated_at`, `password_policy`, `multiaccount_sync_at`, `compliance_status`, `details_json`, `updated_at`)
SELECT u.universe,
       u.id,
       bec.shared_email,
       UNIX_TIMESTAMP(),
       bec.password_policy,
       UNIX_TIMESTAMP(),
       'ok',
       '{"source":"migration_10","migrated":true}',
       UNIX_TIMESTAMP()
FROM `%PREFIX%users` u
INNER JOIN `%PREFIX%bot_engine_config` bec ON bec.universe = u.universe
LEFT JOIN `%PREFIX%bot_account_compliance` bac ON bac.bot_user_id = u.id
WHERE u.is_bot = 1
  AND bac.bot_user_id IS NULL;

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'statut', 'bots', 'Statut', 'Affiche un état synthétique de la cible.', '/bots statut', '["all","bot","profil","alliance","escouade","systeme","galaxie","chef","campagne"]', '{"verb":"statut"}', 1, 10
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'statut');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'pause', 'bots', 'Pause', 'Met la cible en pause pour une durée donnée.', '/bot "Général Orion" pause 30m', '["all","bot","chef","profil","alliance","escouade"]', '{"verb":"pause","duration":true}', 1, 20
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'pause');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'reprendre', 'bots', 'Reprendre', 'Relance la cible après pause.', '/bots reprendre', '["all","bot","chef","profil","alliance","escouade"]', '{"verb":"reprendre"}', 1, 30
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'reprendre');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'doctrine', 'bots', 'Doctrine', 'Applique une doctrine à la cible.', '/bots doctrine opportuniste', '["all","bot","chef","profil","alliance","escouade"]', '{"verb":"doctrine","value":true}', 1, 40
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'doctrine');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'recon', 'bots', 'Reconnaissance', 'Programme une reconnaissance ciblée.', '/chef "Général Orion" lancer reconnaissance 2:145:7', '["all","bot","chef","alliance","escouade","systeme","galaxie","campagne"]', '{"verb":"recon","coordinates":true}', 1, 50
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'recon');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'raid', 'bots', 'Raid', 'Programme un raid ciblé ou opportuniste.', '/system-bots 2:145 raid opportuniste', '["all","bot","chef","alliance","escouade","systeme","galaxie","campagne"]', '{"verb":"raid","coordinates":true}', 1, 60
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'raid');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'message-prive', 'communication', 'Message privé', 'Programme un message privé bot vers joueur.', '/message-prive bot "Général Orion" vers "NomJoueur" message "Nous surveillons votre système."', '["bot","chef"]', '{"target_player":true,"message":true}', 1, 70
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'communication' AND `command_key` = 'message-prive');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'message-chat', 'communication', 'Message chat', 'Programme un message de chat avec mention.', '/message-chat bot "Général Orion" mention "@NomJoueur" message "Nous reviendrons."', '["bot","chef"]', '{"target_player":true,"message":true,"channel":true}', 1, 80
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'communication' AND `command_key` = 'message-chat');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'campagne', 'campagnes', 'Campagne', 'Crée ou ajuste une campagne continue.', '/campagne alliance-bots ASTRA cible 2:145 mode pression', '["alliance","chef","campagne"]', '{"campaign":true,"coordinates":true,"mode":true}', 1, 90
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'campagnes' AND `command_key` = 'campagne');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botpresence', 1, '*/5', '*', '*', '*', '*', 'BotPresenceCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botpresence');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botplanning', 1, '*/5', '*', '*', '*', '*', 'BotPlanningCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botplanning');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botexecution', 1, '*/5', '*', '*', '*', '*', 'BotExecutionCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botexecution');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botmessaging', 1, '*/5', '*', '*', '*', '*', 'BotMessagingCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botmessaging');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botcampaigns', 1, '*/10', '*', '*', '*', '*', 'BotCampaignCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botcampaigns');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botcompliance', 1, '15', '*/2', '*', '*', '*', 'BotComplianceCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botcompliance');

