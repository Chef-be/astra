ALTER TABLE `%PREFIX%bot_traits`
  ADD COLUMN `patience_strategique` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `persistance_tactique`,
  ADD COLUMN `discipline_execution` tinyint(3) unsigned NOT NULL DEFAULT '60' AFTER `patience_strategique`,
  ADD COLUMN `volonte_domination` tinyint(3) unsigned NOT NULL DEFAULT '45' AFTER `discipline_execution`,
  ADD COLUMN `gout_usure` tinyint(3) unsigned NOT NULL DEFAULT '35' AFTER `volonte_domination`,
  ADD COLUMN `tendance_bluff` tinyint(3) unsigned NOT NULL DEFAULT '30' AFTER `gout_usure`,
  ADD COLUMN `sens_opportunite` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `tendance_bluff`,
  ADD COLUMN `agressivite_verbale` tinyint(3) unsigned NOT NULL DEFAULT '35' AFTER `sens_opportunite`,
  ADD COLUMN `discretion_sociale` tinyint(3) unsigned NOT NULL DEFAULT '45' AFTER `agressivite_verbale`,
  ADD COLUMN `fidelite_plan` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `discretion_sociale`,
  ADD COLUMN `capacite_relai` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `fidelite_plan`,
  ADD COLUMN `aptitude_intimidation` tinyint(3) unsigned NOT NULL DEFAULT '40' AFTER `capacite_relai`,
  ADD COLUMN `gout_chasse_ciblee` tinyint(3) unsigned NOT NULL DEFAULT '40' AFTER `aptitude_intimidation`;

ALTER TABLE `%PREFIX%bot_dynamic_state`
  ADD COLUMN `niveau_frustration` tinyint(3) unsigned NOT NULL DEFAULT '15' AFTER `excitation_offensive`,
  ADD COLUMN `pression_performance` tinyint(3) unsigned NOT NULL DEFAULT '20' AFTER `niveau_frustration`,
  ADD COLUMN `desir_revanche` tinyint(3) unsigned NOT NULL DEFAULT '10' AFTER `pression_performance`,
  ADD COLUMN `confiance_chef` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `desir_revanche`,
  ADD COLUMN `saturation_tactique` tinyint(3) unsigned NOT NULL DEFAULT '0' AFTER `confiance_chef`,
  ADD COLUMN `disponibilite_mentale` tinyint(3) unsigned NOT NULL DEFAULT '60' AFTER `saturation_tactique`,
  ADD COLUMN `stabilite_operationnelle` tinyint(3) unsigned NOT NULL DEFAULT '55' AFTER `disponibilite_mentale`,
  ADD COLUMN `intensite_engagement` tinyint(3) unsigned NOT NULL DEFAULT '25' AFTER `stabilite_operationnelle`;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_global_strategy` (
  `universe` int(11) unsigned NOT NULL,
  `strategic_state_json` mediumtext,
  `long_state_json` mediumtext,
  `strategic_cycle_at` int(11) unsigned DEFAULT NULL,
  `long_cycle_at` int(11) unsigned DEFAULT NULL,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`universe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_territorial_zones` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `zone_reference` varchar(16) NOT NULL,
  `galaxy` int(11) unsigned NOT NULL,
  `system` int(11) unsigned NOT NULL,
  `activity_density` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `richness_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `hostility_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `raid_potential` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expansion_interest` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `strategic_importance` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `bot_presence` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `campaign_count` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `coverage_need` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `pressure_need` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dissuasion_need` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tension_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `control_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `profitability_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tension_state` varchar(16) NOT NULL DEFAULT 'faible',
  `control_state` varchar(16) NOT NULL DEFAULT 'faible',
  `rentability_state` varchar(16) NOT NULL DEFAULT 'faible',
  `social_visibility_state` varchar(16) NOT NULL DEFAULT 'faible',
  `campaign_state` varchar(16) NOT NULL DEFAULT 'idle',
  `payload_json` mediumtext,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_lookup` (`universe`,`zone_reference`),
  KEY `priority_lookup` (`universe`,`strategic_importance`,`pressure_need`,`coverage_need`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `%PREFIX%bot_learning_metrics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `universe` int(11) unsigned NOT NULL,
  `scope_type` varchar(32) NOT NULL,
  `scope_reference` varchar(190) NOT NULL,
  `metric_type` varchar(32) NOT NULL,
  `sample_count` int(11) unsigned NOT NULL DEFAULT '0',
  `success_count` int(11) unsigned NOT NULL DEFAULT '0',
  `failure_count` int(11) unsigned NOT NULL DEFAULT '0',
  `score_value` decimal(8,2) NOT NULL DEFAULT '0.00',
  `payload_json` mediumtext,
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `metric_lookup` (`universe`,`scope_type`,`scope_reference`,`metric_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `%PREFIX%cronjobs` (`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botstrategic', 1, '*/30', '*', '*', '*', '*', 'BotStrategicCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botstrategic');

INSERT INTO `%PREFIX%cronjobs` (`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botlongcycle', 1, '12', '*/6', '*', '*', '*', 'BotLongCycleCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botlongcycle');

UPDATE `%PREFIX%system`
SET `dbVersion` = '14'
WHERE `dbVersion` < '14';
