<?php

class BotCampaignCronjob implements CronjobTask
{
	public function run()
	{
		require_once ROOT_PATH.'includes/classes/BotEngineService.class.php';

		foreach (Universe::availableUniverses() as $universeId) {
			Universe::setEmulated($universeId);
			$service = new BotEngineService();
			$service->runCycle('campaigns', 12);
		}
	}
}
