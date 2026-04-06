<?php

class ShowSupervisionPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
	}

	public function show()
	{
		require_once ROOT_PATH.'includes/classes/AdminOverviewService.class.php';
		require_once ROOT_PATH.'includes/classes/CacheAdminService.class.php';

		$dashboardService = new AdminOverviewService();
		$cacheService = new CacheAdminService();

		$this->assign(array(
			'title' => 'Supervision',
			'dashboard' => $dashboardService->getSnapshot(),
			'cacheSnapshot' => $cacheService->getSnapshot(),
		));

		$this->display('page.supervision.default.tpl');
	}
}
