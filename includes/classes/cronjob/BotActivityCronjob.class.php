<?php

class BotActivityCronjob implements CronjobTask
{
	public function run()
	{
		require_once ROOT_PATH.'includes/classes/BotAdminService.class.php';

		foreach (Universe::availableUniverses() as $universeId) {
			Universe::setEmulated($universeId);
			$service = new BotAdminService();
			$service->ensureDefaults();
			$service->runEngine(18);
		}
	}
}
