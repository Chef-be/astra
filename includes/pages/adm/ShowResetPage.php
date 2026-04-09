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

if ($USER['id'] != ROOT_USER || $_GET['sid'] != session_id()) exit;

function ShowResetPage()
{
	global $LNG, $reslist, $resource;
	require_once ROOT_PATH.'includes/classes/AdminUiService.class.php';
	$template	= new template();
	$config	= Config::get(ROOT_UNI);

	if ($_POST)
	{
		foreach($reslist['build'] as $ID)
		{
			$dbcol['build'][$ID]	= "`".$resource[$ID]."` = '0'";
		}

		foreach($reslist['tech'] as $ID)
		{
			$dbcol['tech'][$ID]		= "`".$resource[$ID]."` = '0'";
		}

		foreach($reslist['fleet'] as $ID)
		{
			$dbcol['fleet'][$ID]	= "`".$resource[$ID]."` = '0'";
		}

		foreach($reslist['defense'] as $ID)
		{
			$dbcol['defense'][$ID]	= "`".$resource[$ID]."` = '0'";
		}

		foreach($reslist['officier'] as $ID)
		{
			$dbcol['officier'][$ID]	= "`".$resource[$ID]."` = '0'";
		}

		foreach($reslist['resstype'][1] as $ID)
		{
			if(isset($config->{$resource[$ID].'_start'}))
			{
				$dbcol['resource_planet_start'][$ID]	= "`".$resource[$ID]."` = ".$config->{$resource[$ID].'_start'};
			}
		}

		foreach($reslist['resstype'][3] as $ID)
		{
			if(isset($config->{$resource[$ID].'_start'}))
			{
				$dbcol['resource_user_start'][$ID]	= "`".$resource[$ID]."` = ".$config->{$resource[$ID].'_start'};
			}
		}

		// Players and Planets

		if ($_POST['players'] == 'on'){
			$ID	= $GLOBALS['DATABASE']->getFirstCell("SELECT `id_owner` FROM ".PLANETS." WHERE `universe` = ".Universe::getEmulated()." AND `galaxy` = '1' AND `system` = '1' AND `planet` = '1';");
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".USERS." WHERE `universe` = ".Universe::getEmulated()." AND `id` != '".$ID."';DELETE FROM ".PLANETS." WHERE `universe` = ".Universe::getEmulated()." AND `id_owner` != '".$ID."';");
		}

		if ($_POST['planets'] == 'on')
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".PLANETS." WHERE `universe` = ".Universe::getEmulated()." AND `id` NOT IN (SELECT id_planet FROM ".USERS." WHERE `universe` = ".Universe::getEmulated().");UPDATE ".PLANETS." SET `id_luna` = '0' WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['moons']	== 'on'){
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".PLANETS." WHERE `planet_type` = '3' AND `universe` = ".Universe::getEmulated().";UPDATE ".PLANETS." SET `id_luna` = '0' WHERE `universe` = ".Universe::getEmulated().";");}

		// HANGARES Y DEFENSAS
		if ($_POST['defenses']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET ".implode(", ",$dbcol['defense'])." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['ships']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET ".implode(", ",$dbcol['fleet'])." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['h_d']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET `b_hangar` = '0', `b_hangar_id` = '' WHERE `universe` = ".Universe::getEmulated().";");


		// EDIFICIOS
		if ($_POST['edif_p']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET ".implode(", ",$dbcol['build']).", `field_current` = '0' WHERE `planet_type` = '1' AND `universe` = ".Universe::getEmulated().";");

		if ($_POST['edif_l']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET ".implode(", ",$dbcol['build']).", `field_current` = '0' WHERE `planet_type` = '3' AND `universe` = ".Universe::getEmulated().";");

		if ($_POST['edif']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET `b_building` = '0', `b_building_id` = '' WHERE `universe` = ".Universe::getEmulated().";");


		// INVESTIGACIONES Y OFICIALES
		if ($_POST['inves']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".USERS." SET ".implode(", ",$dbcol['tech'])." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['ofis']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".USERS." SET ".implode(", ",$dbcol['officier'])." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['inves_c']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".USERS." SET `b_tech_planet` = '0', `b_tech` = '0', `b_tech_id` = '0', `b_tech_queue` = '' WHERE `universe` = ".Universe::getEmulated().";");


		// RECURSOS
		if ($_POST['dark']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".USERS." SET ".implode(", ",$dbcol['resource_user_start'])." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['resources']	==	'on')
			$GLOBALS['DATABASE']->query("UPDATE ".PLANETS." SET ".implode(", ",$dbcol['resource_planet_start'])." WHERE `universe` = ".Universe::getEmulated().";");

		// GENERAL
		if ($_POST['notes']	==	'on')
			$GLOBALS['DATABASE']->query("DELETE FROM ".NOTES." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['rw']	==	'on')
			$GLOBALS['DATABASE']->query("DELETE FROM ".TOPKB." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['friends']	==	'on')
			$GLOBALS['DATABASE']->query("DELETE FROM ".BUDDY." WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['alliances']	==	'on')
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".ALLIANCE." WHERE `ally_universe` = '".Universe::getEmulated()."';UPDATE ".USERS." SET `ally_id` = '0', `ally_register_time` = '0', `ally_rank_id` = '0' WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['fleets']	==	'on')
			$GLOBALS['DATABASE']->query("DELETE FROM ".FLEETS." WHERE `fleet_universe` = '".Universe::getEmulated()."';");

		if ($_POST['banneds']	==	'on')
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".BANNED." WHERE `universe` = ".Universe::getEmulated().";UPDATE ".USERS." SET `bana` = '0', `banaday` = '0' WHERE `universe` = ".Universe::getEmulated().";");

		if ($_POST['messages']	==	'on')
			$GLOBALS['DATABASE']->multi_query("DELETE FROM ".MESSAGES." WHERE `message_universe` = '".Universe::getEmulated()."';");

		if ($_POST['statpoints']	==	'on')
			$GLOBALS['DATABASE']->query("DELETE FROM ".STATPOINTS." WHERE `universe` = ".Universe::getEmulated().";");

		$template->message($LNG['re_reset_excess'], '?page=reset&sid='.session_id(), 3);
		exit;
	}

	$resetGroups = array(
		array(
			'title' => $LNG['re_player_and_planets'],
			'items' => array(
				array('name' => 'players', 'label' => $LNG['re_reset_player'], 'tag' => 'Compte', 'image' => AdminUiService::getThemeAssetUrl(902)),
				array('name' => 'planets', 'label' => $LNG['re_reset_planets'], 'tag' => 'Orbites', 'image' => './styles/theme/nextgen/planeten/small/s_normaltempplanet04.jpg'),
				array('name' => 'moons', 'label' => $LNG['re_reset_moons'], 'tag' => 'Orbites', 'image' => './styles/theme/nextgen/planeten/small/s_dschjungelplanet02.jpg'),
			),
		),
		array(
			'title' => $LNG['re_defenses_and_ships'],
			'items' => array(
				array('name' => 'defenses', 'label' => $LNG['re_defenses'], 'tag' => 'Combat', 'image' => AdminUiService::getThemeAssetUrl(401)),
				array('name' => 'ships', 'label' => $LNG['re_ships'], 'tag' => 'Combat', 'image' => AdminUiService::getThemeAssetUrl(202)),
				array('name' => 'h_d', 'label' => $LNG['re_reset_hangar'], 'tag' => 'File', 'image' => AdminUiService::getThemeAssetUrl(21)),
			),
		),
		array(
			'title' => $LNG['re_buldings'],
			'items' => array(
				array('name' => 'edif_p', 'label' => $LNG['re_buildings_pl'], 'tag' => 'Planète', 'image' => AdminUiService::getThemeAssetUrl(1)),
				array('name' => 'edif_l', 'label' => $LNG['re_buildings_lu'], 'tag' => 'Lune', 'image' => AdminUiService::getThemeAssetUrl(41)),
				array('name' => 'edif', 'label' => $LNG['re_reset_buldings'], 'tag' => 'File', 'image' => AdminUiService::getThemeAssetUrl(14)),
			),
		),
		array(
			'title' => $LNG['re_inve_ofis'],
			'items' => array(
				array('name' => 'ofis', 'label' => $LNG['re_ofici'], 'tag' => 'Compte', 'image' => AdminUiService::getThemeAssetUrl(601)),
				array('name' => 'inves', 'label' => $LNG['re_investigations'], 'tag' => 'Recherche', 'image' => AdminUiService::getThemeAssetUrl(106)),
				array('name' => 'inves_c', 'label' => $LNG['re_reset_invest'], 'tag' => 'File', 'image' => AdminUiService::getThemeAssetUrl(31)),
			),
		),
		array(
			'title' => $LNG['re_resources'],
			'items' => array(
				array('name' => 'dark', 'label' => $LNG['re_resources_dark'], 'tag' => 'Compte', 'image' => AdminUiService::getThemeAssetUrl(921)),
				array('name' => 'resources', 'label' => $LNG['re_resources_met_cry'], 'tag' => 'Planète', 'image' => './styles/theme/nextgen/img/resources/metal.webp'),
			),
		),
		array(
			'title' => $LNG['re_general'],
			'items' => array(
				array('name' => 'notes', 'label' => $LNG['re_reset_notes'], 'tag' => 'Social', 'image' => AdminUiService::getThemeAssetUrl(106)),
				array('name' => 'rw', 'label' => $LNG['re_reset_rw'], 'tag' => 'Combat', 'image' => AdminUiService::getThemeAssetUrl(215)),
				array('name' => 'friends', 'label' => $LNG['re_reset_buddies'], 'tag' => 'Social', 'image' => AdminUiService::getThemeAssetUrl(604)),
				array('name' => 'alliances', 'label' => $LNG['re_reset_allys'], 'tag' => 'Alliance', 'image' => AdminUiService::getThemeAssetUrl(603)),
				array('name' => 'fleets', 'label' => $LNG['re_reset_fleets'], 'tag' => 'Vol', 'image' => AdminUiService::getThemeAssetUrl(207)),
				array('name' => 'errors', 'label' => $LNG['re_reset_errors'], 'tag' => 'Journal', 'image' => AdminUiService::getThemeAssetUrl(108)),
				array('name' => 'banneds', 'label' => $LNG['re_reset_banned'], 'tag' => 'Sanction', 'image' => AdminUiService::getThemeAssetUrl(109)),
				array('name' => 'messages', 'label' => $LNG['re_reset_messages'], 'tag' => 'Messages', 'image' => AdminUiService::getThemeAssetUrl(202)),
				array('name' => 'statpoints', 'label' => $LNG['re_reset_statpoints'], 'tag' => 'Stats', 'image' => AdminUiService::getThemeAssetUrl(113)),
			),
		),
	);

	$template->assign_vars(array(
		'button_submit'						=> $LNG['button_submit'],
		're_reset_universe_confirmation'	=> $LNG['re_reset_universe_confirmation'],
		're_reset_all'						=> $LNG['re_reset_all'],
		're_reset_all'						=> $LNG['re_reset_all'],
		're_defenses_and_ships'				=> $LNG['re_defenses_and_ships'],
		're_reset_buldings'					=> $LNG['re_reset_buldings'],
		're_buildings_lu'					=> $LNG['re_buildings_lu'],
		're_buildings_pl'					=> $LNG['re_buildings_pl'],
		're_buldings'						=> $LNG['re_buldings'],
		're_reset_hangar'					=> $LNG['re_reset_hangar'],
		're_ships'							=> $LNG['re_ships'],
		're_defenses'						=> $LNG['re_defenses'],
		're_resources_met_cry'				=> $LNG['re_resources_met_cry'],
		're_resources_dark'					=> $LNG['re_resources_dark'],
		're_resources'						=> $LNG['re_resources'],
		're_reset_invest'					=> $LNG['re_reset_invest'],
		're_investigations'					=> $LNG['re_investigations'],
		're_ofici'							=> $LNG['re_ofici'],
		're_inve_ofis'						=> $LNG['re_inve_ofis'],
		're_reset_statpoints'				=> $LNG['re_reset_statpoints'],
		're_reset_messages'					=> $LNG['re_reset_messages'],
		're_reset_banned'					=> $LNG['re_reset_banned'],
		're_reset_errors'					=> $LNG['re_reset_errors'],
		're_reset_fleets'					=> $LNG['re_reset_fleets'],
		're_reset_allys'					=> $LNG['re_reset_allys'],
		're_reset_buddies'					=> $LNG['re_reset_buddies'],
		're_reset_rw'						=> $LNG['re_reset_rw'],
		're_reset_notes'					=> $LNG['re_reset_notes'],
		're_reset_moons'					=> $LNG['re_reset_moons'],
		're_reset_planets'					=> $LNG['re_reset_planets'],
		're_reset_player'					=> $LNG['re_reset_player'],
		're_player_and_planets'				=> $LNG['re_player_and_planets'],
		're_general'						=> $LNG['re_general'],
		'resetGroups'						=> $resetGroups,
	));

	$template->show('ResetPage.tpl');
}
