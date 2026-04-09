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
class ShowOverviewPage extends AbstractAdminPage
{

	function __construct()
	{
		parent::__construct();
	}

	function show(){
		require_once ROOT_PATH.'includes/classes/AdminOverviewService.class.php';
		require_once ROOT_PATH.'includes/classes/CacheAdminService.class.php';

		$dashboardService = new AdminOverviewService();
		$dashboard = $dashboardService->getSnapshot();
		$cacheService = new CacheAdminService();
		$cacheSnapshot = $cacheService->getSnapshot();
		$commandDeck = array(
			array(
				'title' => 'Serveur',
				'subtitle' => 'Identité, sécurité, SMTP',
				'url' => 'admin.php?page=server',
				'metric' => 'PHP '.$dashboard['system']['phpVersion'],
				'icon' => 'bi-hdd-network',
			),
			array(
				'title' => 'Univers',
				'subtitle' => 'Cadence et règles',
				'url' => 'admin.php?page=universe',
				'metric' => 'U-'.$dashboard['game']['universe'],
				'icon' => 'bi-globe2',
			),
			array(
				'title' => 'Expéditions',
				'subtitle' => 'Butins et événements',
				'url' => 'admin.php?page=expedition',
				'metric' => $dashboard['game']['fleetsFlying'].' flotte(s)',
				'icon' => 'bi-compass',
			),
			array(
				'title' => 'Comptes',
				'subtitle' => 'Interventions ciblées',
				'url' => 'admin.php?page=accounts',
				'metric' => $dashboard['game']['humanUsers'].' humains',
				'icon' => 'bi-person-badge',
			),
			array(
				'title' => 'Bots',
				'subtitle' => 'Orchestration',
				'url' => 'admin.php?page=bots',
				'metric' => $dashboard['game']['activeBots'].' actif(s)',
				'icon' => 'bi-robot',
			),
			array(
				'title' => 'Support',
				'subtitle' => 'Tickets et réponses',
				'url' => 'admin.php?page=support',
				'metric' => $dashboard['game']['ticketsOpen'].' ouvert(s)',
				'icon' => 'bi-life-preserver',
			),
		);

		$overviewMetricStrip = array(
			array('label' => 'Univers', 'value' => $dashboard['game']['universe']),
			array('label' => 'Humains', 'value' => $dashboard['game']['humanUsers']),
			array('label' => 'Actifs', 'value' => $dashboard['game']['activePlayers']),
			array('label' => 'Bots', 'value' => $dashboard['game']['activeBots']),
			array('label' => 'Planètes', 'value' => $dashboard['game']['planetsTotal']),
			array('label' => 'Flottes', 'value' => $dashboard['game']['fleetsFlying']),
			array('label' => 'Tickets', 'value' => $dashboard['game']['ticketsOpen']),
		);

		$systemRail = array(
			array(
				'label' => 'Activité joueurs',
				'value' => $dashboard['game']['activePlayersPercent'].'%',
				'detail' => $dashboard['game']['activePlayers'].' / '.$dashboard['game']['humanUsers'].' connectés',
				'ratio' => $dashboard['game']['activePlayersPercent'],
			),
			array(
				'label' => 'Activité bots',
				'value' => $dashboard['game']['activeBotsPercent'].'%',
				'detail' => $dashboard['game']['activeBots'].' / '.$dashboard['game']['botsTotal'].' opérationnels',
				'ratio' => $dashboard['game']['activeBotsPercent'],
			),
			array(
				'label' => 'Mémoire',
				'value' => $dashboard['system']['memory']['percent'].'%',
				'detail' => $dashboard['system']['memory']['usedHuman'].' / '.$dashboard['system']['memory']['totalHuman'],
				'ratio' => $dashboard['system']['memory']['percent'],
			),
			array(
				'label' => 'Disque',
				'value' => $dashboard['system']['disk']['percent'].'%',
				'detail' => $dashboard['system']['disk']['usedHuman'].' / '.$dashboard['system']['disk']['totalHuman'],
				'ratio' => $dashboard['system']['disk']['percent'],
			),
		);

		$controlMatrix = array(
			array(
				'label' => 'Redis',
				'value' => $cacheSnapshot['redis']['available'] ? 'En ligne' : 'Hors ligne',
				'meta' => $cacheSnapshot['redis']['available']
					? $cacheSnapshot['redis']['dbSize'].' clé(s) • '.$cacheSnapshot['redis']['usedMemoryHuman']
					: 'Cache distribué indisponible',
			),
			array(
				'label' => 'Cache disque',
				'value' => $cacheSnapshot['filesystem']['sizeHuman'],
				'meta' => $cacheSnapshot['filesystem']['files'].' fichier(s)',
			),
			array(
				'label' => 'Docker',
				'value' => $dashboard['docker']['available'] ? 'Joignable' : 'Indisponible',
				'meta' => $dashboard['docker']['available']
					? $dashboard['docker']['servicesTotal'].' service(s) Astra'
					: 'Proxy Docker non détecté',
			),
			array(
				'label' => 'Inscriptions 24h',
				'value' => $dashboard['game']['registrations24'],
				'meta' => $dashboard['game']['newsTotal'].' actualité(s)',
			),
		);

		$this->assign(array(
			'title'		=> 'Tableau de bord',
			'dashboard'	=> $dashboard,
			'cacheSnapshot' => $cacheSnapshot,
			'commandDeck' => $commandDeck,
			'overviewMetricStrip' => $overviewMetricStrip,
			'systemRail' => $systemRail,
			'controlMatrix' => $controlMatrix,
		));

		$this->display('page.overview.default.tpl');

	}

}
