<?php

class MissionProgressCronjob implements CronjobTask
{
	public function run()
	{
		require_once ROOT_PATH.'includes/classes/UserMissionService.class.php';
		require_once ROOT_PATH.'includes/classes/MissionAdminService.class.php';

		foreach (Universe::availableUniverses() as $universeId) {
			Universe::setEmulated($universeId);
			$adminService = new MissionAdminService();
			$adminService->ensureDefaults();

			$service = new UserMissionService();
			$service->refreshAllUsers();
		}
	}
}
