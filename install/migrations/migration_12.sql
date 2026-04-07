ALTER TABLE `%PREFIX%bot_state`
  ADD COLUMN IF NOT EXISTS `session_started_at` int(11) unsigned DEFAULT NULL AFTER `last_action_at`,
  ADD COLUMN IF NOT EXISTS `session_target_until` int(11) unsigned DEFAULT NULL AFTER `session_started_at`,
  ADD COLUMN IF NOT EXISTS `session_rest_until` int(11) unsigned DEFAULT NULL AFTER `session_target_until`,
  ADD COLUMN IF NOT EXISTS `last_presence_change_at` int(11) unsigned DEFAULT NULL AFTER `structural_state_json`;

UPDATE `%PREFIX%bot_state`
SET `last_presence_change_at` = `updated_at`
WHERE `last_presence_change_at` IS NULL OR `last_presence_change_at` = 0;

UPDATE `%PREFIX%system`
SET `dbVersion` = '12'
WHERE `dbVersion` < '12';
