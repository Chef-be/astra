<?php

class ShowMissionsPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/MissionAdminService.class.php';
	}

	public function show()
	{
		$service = new MissionAdminService();
		$service->ensureDefaults();

		$this->assign(array(
			'title' => 'Missions et récompenses',
			'missionSnapshot' => $service->getSnapshot(),
		));

		$this->display('page.missions.default.tpl');
	}

	public function refresh()
	{
		require_once ROOT_PATH.'includes/classes/UserMissionService.class.php';
		$service = new UserMissionService();
		$count = $service->refreshAllUsers();

		$this->printMessage(sprintf('Les missions ont été synchronisées pour %d compte(s) joueur.', $count), array(
			array(
				'url' => 'admin.php?page=missions',
				'label' => 'Retour aux missions',
			),
		));
	}

	public function saveDefinition()
	{
		$service = new MissionAdminService();
		$service->saveDefinition(array(
			'title' => HTTP::_GP('title', '', true),
			'frequency' => HTTP::_GP('frequency', 'daily', true),
			'description' => HTTP::_GP('description', '', true),
			'objective_type' => HTTP::_GP('objective_type', 'building_level', true),
			'objective_key' => HTTP::_GP('objective_key', '1', true),
			'target_value' => HTTP::_GP('target_value', 1),
			'is_active' => HTTP::_GP('is_active', 'off') === 'on' ? 1 : 0,
			'reward_type' => HTTP::_GP('reward_type', 'resource', true),
			'reward_key' => HTTP::_GP('reward_key', 'metal', true),
			'reward_value' => HTTP::_GP('reward_value', 0),
		));

		$this->redirectTo('admin.php?page=missions');
	}
}
