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
class ShowColonySettingsPage extends AbstractAdminPage
{

	protected $colony_settings;

	private function getTechImage($techId)
	{
		$basePath = ROOT_PATH.'styles/theme/nextgen/gebaeude/'.$techId;
		$baseUrl = './styles/theme/nextgen/gebaeude/'.$techId;

		foreach (array('gif', 'jpg', 'png', 'webp') as $extension) {
			if (file_exists($basePath.'.'.$extension)) {
				return $baseUrl.'.'.$extension;
			}
		}

		return './styles/resource/images/admin/GO.png';
	}

	function __construct()
	{
		parent::__construct();
		$this->getColonySettings();
	}

	private function getColonySettings(){
		$db = Database::get();

		$sql = "SELECT * FROM %%COLONY_SETTINGS%%;";

		$this->colony_settings = $db->selectSingle($sql);
	}

	function show(){

		global $LNG;

		$groups = array(
			array(
				'title' => 'Ressources initiales',
				'description' => 'Dotation de départ accordée à une nouvelle colonie.',
				'fields' => array(
					array('name' => 'metal_start', 'label' => $LNG['cs_metal_start'], 'image' => $this->getTechImage(901), 'value' => $this->colony_settings['metal_start']),
					array('name' => 'crystal_start', 'label' => $LNG['cs_crystal_start'], 'image' => $this->getTechImage(902), 'value' => $this->colony_settings['crystal_start']),
					array('name' => 'deuterium_start', 'label' => $LNG['cs_deuterium_start'], 'image' => $this->getTechImage(903), 'value' => $this->colony_settings['deuterium_start']),
				),
			),
			array(
				'title' => 'Bâtiments de départ',
				'description' => 'Infrastructure accordée dès la création d’une nouvelle colonie.',
				'fields' => array(
					array('name' => 'metal_mine_start', 'label' => $LNG['cs_metal_mine_start'], 'image' => $this->getTechImage(1), 'value' => $this->colony_settings['metal_mine_start']),
					array('name' => 'crystal_mine_start', 'label' => $LNG['cs_crystal_mine_start'], 'image' => $this->getTechImage(2), 'value' => $this->colony_settings['crystal_mine_start']),
					array('name' => 'deuterium_mine_start', 'label' => $LNG['cs_deuterium_mine_start'], 'image' => $this->getTechImage(3), 'value' => $this->colony_settings['deuterium_mine_start']),
					array('name' => 'solar_plant_start', 'label' => $LNG['cs_solar_plant_start'], 'image' => $this->getTechImage(4), 'value' => $this->colony_settings['solar_plant_start']),
					array('name' => 'fusion_plant_start', 'label' => $LNG['cs_fusion_plant_start'], 'image' => $this->getTechImage(12), 'value' => $this->colony_settings['fusion_plant_start']),
					array('name' => 'robot_factory_start', 'label' => $LNG['cs_robot_factory_start'], 'image' => $this->getTechImage(14), 'value' => $this->colony_settings['robot_factory_start']),
					array('name' => 'nano_factory_start', 'label' => $LNG['cs_nano_factory_start'], 'image' => $this->getTechImage(15), 'value' => $this->colony_settings['nano_factory_start']),
					array('name' => 'hangar_start', 'label' => $LNG['cs_hangar_start'], 'image' => $this->getTechImage(21), 'value' => $this->colony_settings['hangar_start']),
					array('name' => 'metal_store_start', 'label' => $LNG['cs_metal_store_start'], 'image' => $this->getTechImage(22), 'value' => $this->colony_settings['metal_store_start']),
					array('name' => 'crystal_store_start', 'label' => $LNG['cs_crystal_store_start'], 'image' => $this->getTechImage(23), 'value' => $this->colony_settings['crystal_store_start']),
					array('name' => 'deuterium_store_start', 'label' => $LNG['cs_deuterium_store_start'], 'image' => $this->getTechImage(24), 'value' => $this->colony_settings['deuterium_store_start']),
					array('name' => 'laboratory_start', 'label' => $LNG['cs_laboratory_start'], 'image' => $this->getTechImage(31), 'value' => $this->colony_settings['laboratory_start']),
					array('name' => 'terraformer_start', 'label' => $LNG['cs_terraformer_start'], 'image' => $this->getTechImage(33), 'value' => $this->colony_settings['terraformer_start']),
					array('name' => 'university_start', 'label' => $LNG['cs_university_start'], 'image' => $this->getTechImage(44), 'value' => $this->colony_settings['university_start']),
					array('name' => 'ally_deposit_start', 'label' => $LNG['cs_ally_deposit_start'], 'image' => $this->getTechImage(34), 'value' => $this->colony_settings['ally_deposit_start']),
					array('name' => 'silo_start', 'label' => $LNG['cs_silo_start'], 'image' => $this->getTechImage(44), 'value' => $this->colony_settings['silo_start']),
				),
			),
			array(
				'title' => 'Vaisseaux de départ',
				'description' => 'Flotte initiale automatiquement accordée à la colonie.',
				'fields' => array(
					array('name' => 'small_ship_cargo_start', 'label' => $LNG['cs_small_ship_cargo_start'], 'image' => $this->getTechImage(202), 'value' => $this->colony_settings['small_ship_cargo_start']),
					array('name' => 'big_ship_cargo_start', 'label' => $LNG['cs_big_ship_cargo_start'], 'image' => $this->getTechImage(203), 'value' => $this->colony_settings['big_ship_cargo_start']),
					array('name' => 'light_hunter_start', 'label' => $LNG['cs_light_hunter_start'], 'image' => $this->getTechImage(204), 'value' => $this->colony_settings['light_hunter_start']),
					array('name' => 'heavy_hunter_start', 'label' => $LNG['cs_heavy_hunter_start'], 'image' => $this->getTechImage(205), 'value' => $this->colony_settings['heavy_hunter_start']),
					array('name' => 'crusher_start', 'label' => $LNG['cs_crusher_start'], 'image' => $this->getTechImage(206), 'value' => $this->colony_settings['crusher_start']),
					array('name' => 'battle_ship_start', 'label' => $LNG['cs_battle_ship_start'], 'image' => $this->getTechImage(207), 'value' => $this->colony_settings['battle_ship_start']),
					array('name' => 'colonizer_start', 'label' => $LNG['cs_colonizer_start'], 'image' => $this->getTechImage(208), 'value' => $this->colony_settings['colonizer_start']),
					array('name' => 'recycler_start', 'label' => $LNG['cs_recycler_start'], 'image' => $this->getTechImage(209), 'value' => $this->colony_settings['recycler_start']),
					array('name' => 'spy_sonde_start', 'label' => $LNG['cs_spy_sonde_start'], 'image' => $this->getTechImage(210), 'value' => $this->colony_settings['spy_sonde_start']),
					array('name' => 'bomber_ship_start', 'label' => $LNG['cs_bomber_ship_start'], 'image' => $this->getTechImage(211), 'value' => $this->colony_settings['bomber_ship_start']),
					array('name' => 'solar_satelit_start', 'label' => $LNG['cs_solar_satelit_start'], 'image' => $this->getTechImage(212), 'value' => $this->colony_settings['solar_satelit_start']),
					array('name' => 'destructor_start', 'label' => $LNG['cs_destructor_start'], 'image' => $this->getTechImage(213), 'value' => $this->colony_settings['destructor_start']),
					array('name' => 'dearth_star_start', 'label' => $LNG['cs_dearth_star_start'], 'image' => $this->getTechImage(214), 'value' => $this->colony_settings['dearth_star_start']),
					array('name' => 'ev_transporter_start', 'label' => $LNG['cs_ev_transporter_start'], 'image' => $this->getTechImage(215), 'value' => $this->colony_settings['ev_transporter_start']),
					array('name' => 'star_crasher_start', 'label' => $LNG['cs_star_crasher_start'], 'image' => $this->getTechImage(218), 'value' => $this->colony_settings['star_crasher_start']),
					array('name' => 'dm_ship_start', 'label' => $LNG['cs_dm_ship_start'], 'image' => $this->getTechImage(219), 'value' => $this->colony_settings['dm_ship_start']),
					array('name' => 'orbital_station_start', 'label' => $LNG['cs_orbital_station_start'], 'image' => $this->getTechImage(220), 'value' => $this->colony_settings['orbital_station_start']),
				),
			),
			array(
				'title' => 'Défenses de départ',
				'description' => 'Défenses et missiles initiaux appliqués dès la création.',
				'fields' => array(
					array('name' => 'misil_launcher_start', 'label' => $LNG['cs_misil_launcher_start'], 'image' => $this->getTechImage(401), 'value' => $this->colony_settings['misil_launcher_start']),
					array('name' => 'small_laser_start', 'label' => $LNG['cs_small_laser_start'], 'image' => $this->getTechImage(402), 'value' => $this->colony_settings['small_laser_start']),
					array('name' => 'big_laser_start', 'label' => $LNG['cs_big_laser_start'], 'image' => $this->getTechImage(403), 'value' => $this->colony_settings['big_laser_start']),
					array('name' => 'gauss_canyon_start', 'label' => $LNG['cs_gauss_canyon_start'], 'image' => $this->getTechImage(404), 'value' => $this->colony_settings['gauss_canyon_start']),
					array('name' => 'ionic_canyon_start', 'label' => $LNG['cs_ionic_canyon_start'], 'image' => $this->getTechImage(405), 'value' => $this->colony_settings['ionic_canyon_start']),
					array('name' => 'buster_canyon_start', 'label' => $LNG['cs_buster_canyon_start'], 'image' => $this->getTechImage(406), 'value' => $this->colony_settings['buster_canyon_start']),
					array('name' => 'small_protection_shield_start', 'label' => $LNG['cs_small_protection_shield_start'], 'image' => $this->getTechImage(407), 'value' => $this->colony_settings['small_protection_shield_start']),
					array('name' => 'planet_protector_start', 'label' => $LNG['cs_planet_protector_start'], 'image' => $this->getTechImage(408), 'value' => $this->colony_settings['planet_protector_start']),
					array('name' => 'big_protection_shield_start', 'label' => $LNG['cs_big_protection_shield_start'], 'image' => $this->getTechImage(409), 'value' => $this->colony_settings['big_protection_shield_start']),
					array('name' => 'graviton_canyon_start', 'label' => $LNG['cs_graviton_canyon_start'], 'image' => $this->getTechImage(410), 'value' => $this->colony_settings['graviton_canyon_start']),
					array('name' => 'interceptor_misil_start', 'label' => $LNG['cs_interceptor_misil_start'], 'image' => $this->getTechImage(502), 'value' => $this->colony_settings['interceptor_misil_start']),
					array('name' => 'interplanetary_misil_start', 'label' => $LNG['cs_interplanetary_misil_start'], 'image' => $this->getTechImage(503), 'value' => $this->colony_settings['interplanetary_misil_start']),
				),
			),
		);

		$this->assign(array(
			'metal_start'						=> $this->colony_settings['metal_start'],
			'crystal_start'						=> $this->colony_settings['crystal_start'],
			'deuterium_start'					=> $this->colony_settings['deuterium_start'],
			'metal_mine_start'						=> $this->colony_settings['metal_mine_start'],
			'crystal_mine_start'						=> $this->colony_settings['crystal_mine_start'],
			'deuterium_mine_start'						=> $this->colony_settings['deuterium_mine_start'],
			'solar_plant_start'						=> $this->colony_settings['solar_plant_start'],
			'fusion_plant_start'						=> $this->colony_settings['fusion_plant_start'],
			'robot_factory_start'						=> $this->colony_settings['robot_factory_start'],
			'nano_factory_start'						=> $this->colony_settings['nano_factory_start'],
			'hangar_start'						=> $this->colony_settings['hangar_start'],
			'metal_store_start'						=> $this->colony_settings['metal_store_start'],
			'crystal_store_start'						=> $this->colony_settings['crystal_store_start'],
			'deuterium_store_start'						=> $this->colony_settings['deuterium_store_start'],
			'laboratory_start'						=> $this->colony_settings['laboratory_start'],
			'terraformer_start'						=> $this->colony_settings['terraformer_start'],
			'university_start'						=> $this->colony_settings['university_start'],
			'ally_deposit_start'						=> $this->colony_settings['ally_deposit_start'],
			'silo_start'						=> $this->colony_settings['silo_start'],
			'small_ship_cargo_start'						=> $this->colony_settings['small_ship_cargo_start'],
			'big_ship_cargo_start'						=> $this->colony_settings['big_ship_cargo_start'],
			'light_hunter_start'						=> $this->colony_settings['light_hunter_start'],
			'heavy_hunter_start'						=> $this->colony_settings['heavy_hunter_start'],
			'crusher_start'						=> $this->colony_settings['crusher_start'],
			'battle_ship_start'						=> $this->colony_settings['battle_ship_start'],
			'colonizer_start'						=> $this->colony_settings['colonizer_start'],
			'recycler_start'						=> $this->colony_settings['recycler_start'],
			'spy_sonde_start'						=> $this->colony_settings['spy_sonde_start'],
			'bomber_ship_start'						=> $this->colony_settings['bomber_ship_start'],
			'solar_satelit_start'						=> $this->colony_settings['solar_satelit_start'],
			'destructor_start'						=> $this->colony_settings['destructor_start'],
			'dearth_star_start'						=> $this->colony_settings['dearth_star_start'],
			'ev_transporter_start'						=> $this->colony_settings['ev_transporter_start'],
			'star_crasher_start'						=> $this->colony_settings['star_crasher_start'],
			'dm_ship_start'						=> $this->colony_settings['dm_ship_start'],
			'orbital_station_start'						=> $this->colony_settings['orbital_station_start'],
			'misil_launcher_start'						=> $this->colony_settings['misil_launcher_start'],
			'small_laser_start'						=> $this->colony_settings['small_laser_start'],
			'big_laser_start'						=> $this->colony_settings['big_laser_start'],
			'gauss_canyon_start'						=> $this->colony_settings['gauss_canyon_start'],
			'ionic_canyon_start'						=> $this->colony_settings['ionic_canyon_start'],
			'buster_canyon_start'						=> $this->colony_settings['buster_canyon_start'],
			'small_protection_shield_start'						=> $this->colony_settings['small_protection_shield_start'],
			'planet_protector_start'						=> $this->colony_settings['planet_protector_start'],
			'big_protection_shield_start'						=> $this->colony_settings['big_protection_shield_start'],
			'graviton_canyon_start'						=> $this->colony_settings['graviton_canyon_start'],
			'interceptor_misil_start'						=> $this->colony_settings['interceptor_misil_start'],
			'interplanetary_misil_start'						=> $this->colony_settings['interplanetary_misil_start'],
			'colonySettingGroups' => $groups,
		));

		$this->display('page.colony.default.tpl');

	}

	function saveSettings(){
		global $LNG;

			$config_before = array(
				'metal_start'						=> $this->colony_settings['metal_start'],
				'crystal_start'						=> $this->colony_settings['crystal_start'],
				'deuterium_start'					=> $this->colony_settings['deuterium_start'],
				'metal_mine_start'						=> $this->colony_settings['metal_mine_start'],
				'crystal_mine_start'						=> $this->colony_settings['crystal_mine_start'],
				'deuterium_mine_start'						=> $this->colony_settings['deuterium_mine_start'],
				'solar_plant_start'						=> $this->colony_settings['solar_plant_start'],
				'fusion_plant_start'						=> $this->colony_settings['fusion_plant_start'],
				'robot_factory_start'						=> $this->colony_settings['robot_factory_start'],
				'nano_factory_start'						=> $this->colony_settings['nano_factory_start'],
				'hangar_start'						=> $this->colony_settings['hangar_start'],
				'metal_store_start'						=> $this->colony_settings['metal_store_start'],
				'crystal_store_start'						=> $this->colony_settings['crystal_store_start'],
				'deuterium_store_start'						=> $this->colony_settings['deuterium_store_start'],
				'laboratory_start'						=> $this->colony_settings['laboratory_start'],
				'terraformer_start'						=> $this->colony_settings['terraformer_start'],
				'university_start'						=> $this->colony_settings['university_start'],
				'ally_deposit_start'						=> $this->colony_settings['ally_deposit_start'],
				'silo_start'						=> $this->colony_settings['silo_start'],
				'small_ship_cargo_start'						=> $this->colony_settings['small_ship_cargo_start'],
				'big_ship_cargo_start'						=> $this->colony_settings['big_ship_cargo_start'],
				'light_hunter_start'						=> $this->colony_settings['light_hunter_start'],
				'heavy_hunter_start'						=> $this->colony_settings['heavy_hunter_start'],
				'crusher_start'						=> $this->colony_settings['crusher_start'],
				'battle_ship_start'						=> $this->colony_settings['battle_ship_start'],
				'colonizer_start'						=> $this->colony_settings['colonizer_start'],
				'recycler_start'						=> $this->colony_settings['recycler_start'],
				'spy_sonde_start'						=> $this->colony_settings['spy_sonde_start'],
				'bomber_ship_start'						=> $this->colony_settings['bomber_ship_start'],
				'solar_satelit_start'						=> $this->colony_settings['solar_satelit_start'],
				'destructor_start'						=> $this->colony_settings['destructor_start'],
				'dearth_star_start'						=> $this->colony_settings['dearth_star_start'],
				'ev_transporter_start'						=> $this->colony_settings['ev_transporter_start'],
				'star_crasher_start'						=> $this->colony_settings['star_crasher_start'],
				'dm_ship_start'						=> $this->colony_settings['dm_ship_start'],
				'orbital_station_start'						=> $this->colony_settings['orbital_station_start'],
				'misil_launcher_start'						=> $this->colony_settings['misil_launcher_start'],
				'small_laser_start'						=> $this->colony_settings['small_laser_start'],
				'big_laser_start'						=> $this->colony_settings['big_laser_start'],
				'gauss_canyon_start'						=> $this->colony_settings['gauss_canyon_start'],
				'ionic_canyon_start'						=> $this->colony_settings['ionic_canyon_start'],
				'buster_canyon_start'						=> $this->colony_settings['buster_canyon_start'],
				'small_protection_shield_start'						=> $this->colony_settings['small_protection_shield_start'],
				'planet_protector_start'						=> $this->colony_settings['planet_protector_start'],
				'big_protection_shield_start'						=> $this->colony_settings['big_protection_shield_start'],
				'graviton_canyon_start'						=> $this->colony_settings['graviton_canyon_start'],
				'interceptor_misil_start'						=> $this->colony_settings['interceptor_misil_start'],
				'interplanetary_misil_start'						=> $this->colony_settings['interplanetary_misil_start'],
			);

			$metal_start = HTTP::_GP('metal_start',500);
			$crystal_start = HTTP::_GP('crystal_start',500);
			$deuterium_start = HTTP::_GP('deuterium_start',0);
			$metal_mine_start = HTTP::_GP('metal_mine_start',0);
			$crystal_mine_start = HTTP::_GP('crystal_mine_start',0);
			$deuterium_mine_start = HTTP::_GP('deuterium_mine_start',0);
			$solar_plant_start = HTTP::_GP('solar_plant_start',0);
			$fusion_plant_start = HTTP::_GP('fusion_plant_start',0);
			$robot_factory_start = HTTP::_GP('robot_factory_start',0);
			$nano_factory_start = HTTP::_GP('nano_factory_start',0);
			$hangar_start = HTTP::_GP('hangar_start',0);
			$metal_store_start = HTTP::_GP('metal_store_start',0);
			$crystal_store_start = HTTP::_GP('crystal_store_start',0);
			$deuterium_store_start = HTTP::_GP('deuterium_store_start',0);
			$laboratory_start = HTTP::_GP('laboratory_start',0);
			$terraformer_start = HTTP::_GP('terraformer_start',0);
			$university_start = HTTP::_GP('university_start',0);
			$ally_deposit_start = HTTP::_GP('ally_deposit_start',0);
			$silo_start = HTTP::_GP('silo_start',0);
			$small_ship_cargo_start = HTTP::_GP('small_ship_cargo_start',0);
			$big_ship_cargo_start = HTTP::_GP('big_ship_cargo_start',0);
			$light_hunter_start = HTTP::_GP('light_hunter_start',0);
			$heavy_hunter_start = HTTP::_GP('heavy_hunter_start',0);
			$crusher_start = HTTP::_GP('crusher_start',0);
			$battle_ship_start = HTTP::_GP('battle_ship_start',0);
			$colonizer_start = HTTP::_GP('colonizer_start',0);
			$recycler_start = HTTP::_GP('recycler_start',0);
			$spy_sonde_start = HTTP::_GP('spy_sonde_start',0);
			$bomber_ship_start = HTTP::_GP('bomber_ship_start',0);
			$solar_satelit_start = HTTP::_GP('solar_satelit_start',0);
			$destructor_start = HTTP::_GP('destructor_start',0);
			$dearth_star_start = HTTP::_GP('dearth_star_start',0);
			$battleship_start = HTTP::_GP('battleship_start',0);
			$ev_transporter_start = HTTP::_GP('ev_transporter_start',0);
			$star_crasher_start = HTTP::_GP('star_crasher_start',0);
			$giga_recykler_start = HTTP::_GP('giga_recykler_start',0);
			$dm_ship_start = HTTP::_GP('dm_ship_start',0);
			$orbital_station_start = HTTP::_GP('orbital_station_start',0);
			$misil_launcher_start = HTTP::_GP('misil_launcher_start',0);
			$small_laser_start = HTTP::_GP('small_laser_start',0);
			$big_laser_start = HTTP::_GP('big_laser_start',0);
			$gauss_canyon_start = HTTP::_GP('gauss_canyon_start',0);
			$ionic_canyon_start = HTTP::_GP('ionic_canyon_start',0);
			$buster_canyon_start = HTTP::_GP('buster_canyon_start',0);
			$small_protection_shield_start = HTTP::_GP('small_protection_shield_start',0);
			$planet_protector_start = HTTP::_GP('planet_protector_start',0);
			$big_protection_shield_start = HTTP::_GP('big_protection_shield_start',0);
			$graviton_canyon_start = HTTP::_GP('graviton_canyon_start',0);
			$interceptor_misil_start = HTTP::_GP('interceptor_misil_start',0);
			$interplanetary_misil_start = HTTP::_GP('interplanetary_misil_start',0);

			$sql = "UPDATE %%COLONY_SETTINGS%% SET
			`metal_start` = :metal_start,
			`crystal_start` = :crystal_start,
			`deuterium_start` = :deuterium_start,
			`metal_mine_start` = :metal_mine_start,
			`crystal_mine_start` = :crystal_mine_start,
			`deuterium_mine_start` = :deuterium_mine_start,
			`solar_plant_start` = :solar_plant_start,
			`fusion_plant_start` = :fusion_plant_start,
			`robot_factory_start` = :robot_factory_start,
			`nano_factory_start` = :nano_factory_start,
			`hangar_start` = :hangar_start,
			`metal_store_start` = :metal_store_start,
			`crystal_store_start` = :crystal_store_start,
			`deuterium_store_start` = :deuterium_store_start,
			`laboratory_start` = :laboratory_start,
			`terraformer_start` = :terraformer_start,
			`university_start` = :university_start,
			`ally_deposit_start` = :ally_deposit_start,
			`silo_start` = :silo_start,
			`small_ship_cargo_start` = :small_ship_cargo_start,
			`big_ship_cargo_start` = :big_ship_cargo_start,
			`light_hunter_start` = :light_hunter_start,
			`heavy_hunter_start` = :heavy_hunter_start,
			`crusher_start` = :crusher_start,
			`battle_ship_start` = :battle_ship_start,
			`colonizer_start` = :colonizer_start,
			`recycler_start` = :recycler_start,
			`spy_sonde_start` = :spy_sonde_start,
			`bomber_ship_start` = :bomber_ship_start,
			`solar_satelit_start` = :solar_satelit_start,
			`destructor_start` = :destructor_start,
			`dearth_star_start` = :dearth_star_start,
			`battleship_start` = :battleship_start,
			`ev_transporter_start` = :ev_transporter_start,
			`star_crasher_start` = :star_crasher_start,
			`giga_recykler_start` = :giga_recykler_start,
			`dm_ship_start` = :dm_ship_start,
			`orbital_station_start` = :orbital_station_start,
			`misil_launcher_start` = :misil_launcher_start,
			`small_laser_start` = :small_laser_start,
			`big_laser_start` = :big_laser_start,
			`gauss_canyon_start` = :gauss_canyon_start,
			`ionic_canyon_start` = :ionic_canyon_start,
			`buster_canyon_start` = :buster_canyon_start,
			`small_protection_shield_start` = :small_protection_shield_start,
			`planet_protector_start` = :planet_protector_start,
			`big_protection_shield_start` = :big_protection_shield_start,
			`graviton_canyon_start` = :graviton_canyon_start,
			`interceptor_misil_start` = :interceptor_misil_start,
			`interplanetary_misil_start` = :interplanetary_misil_start;";

			Database::get()->update($sql,array(
				':metal_start' => $metal_start,
				':crystal_start' => $crystal_start,
				':deuterium_start' => $deuterium_start,
				':metal_mine_start' => $metal_mine_start,
				':crystal_mine_start' => $crystal_mine_start,
				':deuterium_mine_start' => $deuterium_mine_start,
				':solar_plant_start' => $solar_plant_start,
				':fusion_plant_start' => $fusion_plant_start,
				':robot_factory_start' => $robot_factory_start,
				':nano_factory_start' => $nano_factory_start,
				':hangar_start' => $hangar_start,
				':metal_store_start' => $metal_store_start,
				':crystal_store_start' => $crystal_store_start,
				':deuterium_store_start' => $deuterium_store_start,
				':laboratory_start' => $laboratory_start,
				':terraformer_start' => $terraformer_start,
				':university_start' => $university_start,
				':ally_deposit_start' => $ally_deposit_start,
				':silo_start' => $silo_start,
				':small_ship_cargo_start' => $small_ship_cargo_start,
				':big_ship_cargo_start' => $big_ship_cargo_start,
				':light_hunter_start' => $light_hunter_start,
				':heavy_hunter_start' => $heavy_hunter_start,
				':crusher_start' => $crusher_start,
				':battle_ship_start' => $battle_ship_start,
				':colonizer_start' => $colonizer_start,
				':recycler_start' => $recycler_start,
				':spy_sonde_start' => $spy_sonde_start,
				':bomber_ship_start' => $bomber_ship_start,
				':solar_satelit_start' => $solar_satelit_start,
				':destructor_start' => $destructor_start,
				':dearth_star_start' => $dearth_star_start,
				':battleship_start' => $battleship_start,
				':ev_transporter_start' => $ev_transporter_start,
				':star_crasher_start' => $star_crasher_start,
				':giga_recykler_start' => $giga_recykler_start,
				':dm_ship_start' => $dm_ship_start,
				':orbital_station_start' => $orbital_station_start,
				':misil_launcher_start' => $misil_launcher_start,
				':small_laser_start' => $small_laser_start,
				':big_laser_start' => $big_laser_start,
				':gauss_canyon_start' => $gauss_canyon_start,
				':ionic_canyon_start' => $ionic_canyon_start,
				':buster_canyon_start' => $buster_canyon_start,
				':small_protection_shield_start' => $small_protection_shield_start,
				':planet_protector_start' => $planet_protector_start,
				':big_protection_shield_start' => $big_protection_shield_start,
				':graviton_canyon_start' => $graviton_canyon_start,
				':interceptor_misil_start' => $interceptor_misil_start,
				':interplanetary_misil_start' => $interplanetary_misil_start,
			));


			$config_after = array(
				'metal_start'						=> $metal_start,
				'crystal_start'						=> $crystal_start,
				'deuterium_start'					=> $deuterium_start,
				'metal_mine_start'						=> $metal_mine_start,
				'crystal_mine_start'						=> $crystal_mine_start,
				'deuterium_mine_start'						=> $deuterium_mine_start,
				'solar_plant_start'						=> $solar_plant_start,
				'fusion_plant_start'						=> $fusion_plant_start,
				'robot_factory_start'						=> $robot_factory_start,
				'nano_factory_start'						=> $nano_factory_start,
				'hangar_start'						=> $hangar_start,
				'metal_store_start'						=> $metal_store_start,
				'crystal_store_start'						=> $crystal_store_start,
				'deuterium_store_start'						=> $deuterium_store_start,
				'laboratory_start'						=> $laboratory_start,
				'terraformer_start'						=> $terraformer_start,
				'university_start'						=> $university_start,
				'ally_deposit_start'						=> $ally_deposit_start,
				'silo_start'						=> $silo_start,
				'small_ship_cargo_start'						=> $small_ship_cargo_start,
				'big_ship_cargo_start'						=> $big_ship_cargo_start,
				'light_hunter_start'						=> $light_hunter_start,
				'heavy_hunter_start'						=> $heavy_hunter_start,
				'crusher_start'						=> $crusher_start,
				'battle_ship_start'						=> $battle_ship_start,
				'colonizer_start'						=> $colonizer_start,
				'recycler_start'						=> $recycler_start,
				'spy_sonde_start'						=> $spy_sonde_start,
				'bomber_ship_start'						=> $bomber_ship_start,
				'solar_satelit_start'						=> $solar_satelit_start,
				'destructor_start'						=> $destructor_start,
				'dearth_star_start'						=> $dearth_star_start,
				'ev_transporter_start'						=> $ev_transporter_start,
				'star_crasher_start'						=> $star_crasher_start,
				'dm_ship_start'						=> $dm_ship_start,
				'orbital_station_start'						=> $orbital_station_start,
				'misil_launcher_start'						=> $misil_launcher_start,
				'small_laser_start'						=> $small_laser_start,
				'big_laser_start'						=> $big_laser_start,
				'gauss_canyon_start'						=> $gauss_canyon_start,
				'ionic_canyon_start'						=> $ionic_canyon_start,
				'buster_canyon_start'						=> $buster_canyon_start,
				'small_protection_shield_start'						=> $small_protection_shield_start,
				'planet_protector_start'						=> $planet_protector_start,
				'big_protection_shield_start'						=> $big_protection_shield_start,
				'graviton_canyon_start'						=> $graviton_canyon_start,
				'interceptor_misil_start'						=> $interceptor_misil_start,
				'interplanetary_misil_start'						=> $interplanetary_misil_start,
					);




			$LOG = new Log(3);
			$LOG->target = 1;
			$LOG->old = $config_before;
			$LOG->new = $config_after;
			$LOG->save();




			$redirectButton = array();
      $redirectButton[] = array(
        'url' => 'admin.php?page=colonySettings&mode=show',
				'label' => $LNG['uvs_back']
      );

      $this->printMessage($LNG['settings_successful'],$redirectButton);

	}

}
