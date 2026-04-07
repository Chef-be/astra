INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'strategie', 'bots', 'Stratégie', 'Applique une stratégie ou doctrine opérationnelle.', '/bots strategie guerre', '["all","bot","chef","profil","alliance","escouade"]', '{"verb":"strategie","value":true}', 1, 45
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'strategie');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'cible-online', 'presence', 'Cible en ligne', 'Ajuste la cible globale de présence logique.', '/bots cible-online 120', '["all"]', '{"verb":"cible-online","value":true}', 1, 47
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'presence' AND `command_key` = 'cible-online');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'bonus', 'bots', 'Bonus', 'Attribue un bonus explicite à la cible.', '/bot "Général Orion" bonus commandement', '["all","bot","chef","profil","alliance","escouade"]', '{"verb":"bonus","value":true}', 1, 48
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'bonus');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'journal', 'bots', 'Journal', 'Affiche un résumé structuré de la cible.', '/bot "Général Orion" journal', '["all","bot","chef","profil","alliance","escouade","campagne"]', '{"verb":"journal"}', 1, 49
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'journal');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'surveillance', 'bots', 'Surveillance', 'Planifie une surveillance discrète ou répétée.', '/surveillance system-bots 2:145', '["all","bot","chef","alliance","escouade","systeme","galaxie","campagne"]', '{"verb":"surveillance","coordinates":true}', 1, 55
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'surveillance');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'defense', 'bots', 'Défense', 'Programme un renfort ou une posture défensive.', '/chef "Général Orion" defense 2:145', '["all","bot","chef","alliance","escouade","systeme","galaxie"]', '{"verb":"defense","coordinates":true}', 1, 65
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'defense');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'colonisation', 'bots', 'Colonisation', 'Force un plan de colonisation ou d''expansion.', '/profil-bots Colonisateur colonisation 3:112', '["all","bot","chef","profil","alliance","escouade","systeme","galaxie"]', '{"verb":"colonisation","coordinates":true}', 1, 75
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'bots' AND `command_key` = 'colonisation');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'harcelement', 'campagnes', 'Harcèlement', 'Ouvre une campagne de harcèlement continue.', '/harcelement system-bots 2:145 cible "NomJoueur"', '["alliance","chef","escouade","systeme","galaxie","campagne"]', '{"campaign":true,"mode":"harcelement","coordinates":true}', 1, 95
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'campagnes' AND `command_key` = 'harcelement');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'rotation-attaque', 'campagnes', 'Rotation d''attaque', 'Crée une rotation offensive cadencée.', '/rotation-attaque chef "Général Orion" cible 2:145:7 durée 6h', '["chef","alliance","escouade","campagne"]', '{"campaign":true,"mode":"rotation","coordinates":true,"duration":true}', 1, 100
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'campagnes' AND `command_key` = 'rotation-attaque');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'vague', 'campagnes', 'Vague', 'Cadence une vague offensive sur une cible.', '/vague alliance-bots ASTRA cible 2:145:7 intervalle 15m', '["alliance","chef","escouade","campagne"]', '{"campaign":true,"mode":"vague","coordinates":true,"interval":true}', 1, 110
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'campagnes' AND `command_key` = 'vague');

INSERT INTO `%PREFIX%bot_command_catalog`
(`command_key`, `family_key`, `label`, `help_text`, `syntax_example`, `target_types_json`, `payload_schema_json`, `is_active`, `sort_order`)
SELECT 'siege', 'campagnes', 'Siège', 'Déclenche une campagne de siège prolongé.', '/siege alliance-bots ASTRA zone 2:145', '["alliance","chef","escouade","systeme","galaxie","campagne"]', '{"campaign":true,"mode":"siege","coordinates":true}', 1, 120
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%bot_command_catalog` WHERE `family_key` = 'campagnes' AND `command_key` = 'siege');

INSERT INTO `%PREFIX%cronjobs`
(`name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`)
SELECT 'botmaintenance', 1, '20,50', '*', '*', '*', '*', 'BotMaintenanceCronjob', UNIX_TIMESTAMP(), NULL
WHERE NOT EXISTS (SELECT 1 FROM `%PREFIX%cronjobs` WHERE `name` = 'botmaintenance');
