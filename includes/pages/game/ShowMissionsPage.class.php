<?php

class ShowMissionsPage extends AbstractGamePage
{
	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/UserMissionService.class.php';
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';
	}

	public function show()
	{
		global $USER, $LNG;

		$service = new UserMissionService();
		$snapshot = $service->getPlayerSnapshot($USER['id']);

		$this->assign(array(
			'LNG' => $LNG,
			'missionsSnapshot' => $snapshot,
			'page' => 'missions',
		));

		$this->display('page.missions.default.tpl');
	}

	public function claim()
	{
		global $USER;

		$service = new UserMissionService();
		$service->claimReward($USER['id'], HTTP::_GP('id', 0));

		$this->redirectTo('game.php?page=missions');
	}
}
