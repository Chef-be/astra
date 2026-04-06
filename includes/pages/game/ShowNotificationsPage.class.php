<?php

class ShowNotificationsPage extends AbstractGamePage
{
	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';
	}

	public function show()
	{
		global $USER;

		$this->assign(array(
			'notificationItems' => NotificationService::getAll($USER['id'], 150),
			'page' => 'notifications',
		));

		$this->display('page.notifications.default.tpl');
	}

	public function markRead()
	{
		global $USER;

		$notificationId = HTTP::_GP('id', 0);
		if ($notificationId > 0) {
			NotificationService::markRead($USER['id'], $notificationId);
		}

		$this->redirectTo('game.php?page=notifications');
	}

	public function markAllRead()
	{
		global $USER;

		NotificationService::markAllRead($USER['id']);
		$this->redirectTo('game.php?page=notifications');
	}
}
