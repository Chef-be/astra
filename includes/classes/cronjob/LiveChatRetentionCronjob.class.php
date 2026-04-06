<?php

class LiveChatRetentionCronjob implements CronjobTask
{
	public function run()
	{
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';

		foreach (Universe::availableUniverses() as $universeId) {
			Universe::setEmulated($universeId);
			LiveChatService::purgeExpiredMessages($universeId);
		}
	}
}
