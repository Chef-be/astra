ALTER TABLE `%PREFIX%users`
  ADD COLUMN `noob_protection_disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' AFTER `is_bot`,
  ADD COLUMN `noob_protection_disabled_at` int(11) unsigned NOT NULL DEFAULT '0' AFTER `noob_protection_disabled`;

UPDATE `%PREFIX%users`
SET `noob_protection_disabled` = 1,
    `noob_protection_disabled_at` = UNIX_TIMESTAMP()
WHERE `is_bot` = 1;

UPDATE `%PREFIX%system`
SET `dbVersion` = '13'
WHERE `dbVersion` < '13';
