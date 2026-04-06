<?php

/**
*  ultimateXnova
*  based on 2moons by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package ultimateXnova
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2022 Koray Karakuş <koraykarakus@yahoo.com>
 * @copyright 2024 Pfahli (https://github.com/Pfahli)
 * @licence MIT
 * @version 1.8.x Koray Karakuş <koraykarakus@yahoo.com>
 * @link https://github.com/ultimateXnova/ultimateXnova
 */

/**
 *
 */
class ShowClearCachePage extends AbstractAdminPage
{

	function __construct()
	{
		parent::__construct();
	}

	function show(){
		require_once ROOT_PATH.'includes/classes/CacheAdminService.class.php';

		$cacheService = new CacheAdminService();
		$this->assign(array(
			'title' => 'Pilotage du cache',
			'cacheSnapshot' => $cacheService->getSnapshot(),
		));

		$this->display('page.clearcache.default.tpl');
	}

	function run()
	{
		global $LNG;
		require_once ROOT_PATH.'includes/classes/CacheAdminService.class.php';

		$scope = HTTP::_GP('scope', '', true);
		if (!in_array($scope, array('filesystem', 'redis', 'all'), true)) {
			$scope = 'all';
		}

		$cacheService = new CacheAdminService();
		$result = $cacheService->purge($scope);
		$messageParts = array();

		if ($result['filesystemPurged']) {
			$messageParts[] = 'Le cache applicatif a été purgé.';
		}

		if ($result['redisPurged']) {
			$messageParts[] = 'Redis a été vidé.';
		}

		if (empty($messageParts)) {
			$messageParts[] = $LNG['cc_cache_clear'];
		}

		$this->printMessage(
			implode(' ', $messageParts),
			array(
				array(
					'url' => '?page=clearCache',
					'label' => 'Retour au pilotage du cache',
				),
				array(
					'url' => '?page=supervision',
					'label' => 'Retour à la supervision',
				),
			)
		);
	}

}
