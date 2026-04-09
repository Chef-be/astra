<?php

/**
 *
 */
class ShowExpeditionPage extends AbstractAdminPage
{

  function __construct()
  {
    parent::__construct();
  }

  function show(){
    global $config;
    require_once ROOT_PATH.'includes/classes/AdminUiService.class.php';

    $expeditionEventGroups = array(
      array(
        'title' => 'Incidents de flotte',
        'entries' => array(
          array(
            'name' => 'expedition_allow_fleet_loss',
            'title' => 'Perte de flotte',
            'tag' => 'Risque',
            'tooltip' => 'Autorise les expéditions à se solder par une perte de flotte.',
            'image' => AdminUiService::getThemeAssetUrl(215),
            'checked' => $config->expedition_allow_fleet_loss,
          ),
          array(
            'name' => 'expedition_allow_fleet_delay',
            'title' => 'Retard de flotte',
            'tag' => 'Temps',
            'tooltip' => 'Autorise les retards de retour après expédition.',
            'image' => AdminUiService::getThemeAssetUrl(207),
            'checked' => $config->expedition_allow_fleet_delay,
          ),
          array(
            'name' => 'expedition_allow_fleet_speedup',
            'title' => 'Accélération',
            'tag' => 'Temps',
            'tooltip' => 'Autorise les retours anticipés et accélérations de trajet.',
            'image' => AdminUiService::getThemeAssetUrl(211),
            'checked' => $config->expedition_allow_fleet_speedup,
          ),
          array(
            'name' => 'expedition_allow_expedition_war',
            'title' => 'Combat pirate',
            'tag' => 'Combat',
            'tooltip' => 'Autorise les rencontres hostiles pendant les expéditions.',
            'image' => AdminUiService::getThemeAssetUrl(205),
            'checked' => $config->expedition_allow_expedition_war,
          ),
        ),
      ),
      array(
        'title' => 'Butin et découvertes',
        'entries' => array(
          array(
            'name' => 'expedition_allow_darkmatter_find',
            'title' => 'Matière noire',
            'tag' => 'Butin',
            'tooltip' => 'Autorise la découverte de matière noire en expédition.',
            'image' => AdminUiService::getThemeAssetUrl(921),
            'checked' => $config->expedition_allow_darkmatter_find,
          ),
          array(
            'name' => 'expedition_allow_resources_find',
            'title' => 'Ressources',
            'tag' => 'Butin',
            'tooltip' => 'Autorise la découverte de métal, cristal et deutérium.',
            'image' => AdminUiService::getThemeAssetUrl(901),
            'checked' => $config->expedition_allow_resources_find,
          ),
          array(
            'name' => 'expedition_allow_ships_find',
            'title' => 'Vaisseaux',
            'tag' => 'Butin',
            'tooltip' => 'Autorise le gain de vaisseaux complets en retour d’expédition.',
            'image' => AdminUiService::getThemeAssetUrl(202),
            'checked' => $config->expedition_allow_ships_find,
          ),
        ),
      ),
      array(
        'title' => 'Règles de calcul',
        'entries' => array(
          array(
            'name' => 'expedition_consider_holdtime',
            'title' => 'Prendre le maintien',
            'tag' => 'Calcul',
            'tooltip' => 'Intègre le temps de maintien dans le calcul des événements.',
            'image' => AdminUiService::getThemeAssetUrl(208),
            'checked' => $config->expedition_consider_holdtime,
          ),
          array(
            'name' => 'expedition_consider_same_coordinate',
            'title' => 'Coordonnées identiques',
            'tag' => 'Calcul',
            'tooltip' => 'Prend en compte les expéditions répétées sur une même coordonnée.',
            'image' => AdminUiService::getThemeAssetUrl(210),
            'checked' => $config->expedition_consider_same_coordinate,
          ),
        ),
      ),
    );

    $expeditionFactorCards = array(
      array(
        'name' => 'expedition_factor_resources',
        'title' => 'Facteur ressources',
        'tag' => 'x',
        'tooltip' => 'Multiplicateur appliqué aux gains de ressources.',
        'image' => AdminUiService::getThemeAssetUrl(902),
        'value' => $config->expedition_factor_resources,
        'min' => 0,
        'max' => 1000,
        'step' => 0.1,
      ),
      array(
        'name' => 'expedition_factor_ships',
        'title' => 'Facteur vaisseaux',
        'tag' => 'x',
        'tooltip' => 'Multiplicateur appliqué aux gains de vaisseaux.',
        'image' => AdminUiService::getThemeAssetUrl(207),
        'value' => $config->expedition_factor_ships,
        'min' => 0,
        'max' => 1000,
        'step' => 0.1,
      ),
    );

    $expeditionChanceCards = array(
      array(
        'name' => 'expedition_chances_percent_resources',
        'title' => 'Ressources',
        'tag' => '%',
        'tooltip' => 'Probabilité de tomber sur un événement de ressources.',
        'image' => AdminUiService::getThemeAssetUrl(901),
        'value' => $config->expedition_chances_percent_resources,
        'min' => 0,
        'max' => 100,
        'step' => 0.1,
      ),
      array(
        'name' => 'expedition_chances_percent_darkmatter',
        'title' => 'Matière noire',
        'tag' => '%',
        'tooltip' => 'Probabilité de découvrir de la matière noire.',
        'image' => AdminUiService::getThemeAssetUrl(921),
        'value' => $config->expedition_chances_percent_darkmatter,
        'min' => 0,
        'max' => 100,
        'step' => 0.1,
      ),
      array(
        'name' => 'expedition_chances_percent_ships',
        'title' => 'Vaisseaux',
        'tag' => '%',
        'tooltip' => 'Probabilité de récupérer des vaisseaux en expédition.',
        'image' => AdminUiService::getThemeAssetUrl(202),
        'value' => $config->expedition_chances_percent_ships,
        'min' => 0,
        'max' => 100,
        'step' => 0.1,
      ),
      array(
        'name' => 'expedition_chances_percent_pirates',
        'title' => 'Pirates',
        'tag' => '%',
        'tooltip' => 'Probabilité de rencontrer un événement de combat pirate.',
        'image' => AdminUiService::getThemeAssetUrl(215),
        'value' => $config->expedition_chances_percent_pirates,
        'min' => 0,
        'max' => 100,
        'step' => 0.1,
      ),
    );

    $expeditionDarkmatterBands = array(
      array(
        'title' => 'Palier mineur',
        'tooltip' => 'Bornes de matière noire pour les petits événements.',
        'image' => AdminUiService::getThemeAssetUrl(921),
        'min_name' => 'expedition_min_darkmatter_small_min',
        'min_value' => $config->expedition_min_darkmatter_small_min,
        'max_name' => 'expedition_min_darkmatter_small_max',
        'max_value' => $config->expedition_min_darkmatter_small_max,
      ),
      array(
        'title' => 'Palier majeur',
        'tooltip' => 'Bornes de matière noire pour les grands événements.',
        'image' => AdminUiService::getThemeAssetUrl(603),
        'min_name' => 'expedition_min_darkmatter_large_min',
        'min_value' => $config->expedition_min_darkmatter_large_min,
        'max_name' => 'expedition_min_darkmatter_large_max',
        'max_value' => $config->expedition_min_darkmatter_large_max,
      ),
      array(
        'title' => 'Palier extrême',
        'tooltip' => 'Bornes de matière noire pour les très grands événements.',
        'image' => AdminUiService::getThemeAssetUrl(611),
        'min_name' => 'expedition_min_darkmatter_vlarge_min',
        'min_value' => $config->expedition_min_darkmatter_vlarge_min,
        'max_name' => 'expedition_min_darkmatter_vlarge_max',
        'max_value' => $config->expedition_min_darkmatter_vlarge_max,
      ),
    );

    $this->assign(array(
      'expedition_allow_fleet_loss' => $config->expedition_allow_fleet_loss,
      'expedition_allow_fleet_delay' => $config->expedition_allow_fleet_delay,
      'expedition_allow_fleet_speedup' => $config->expedition_allow_fleet_speedup,
      'expedition_allow_expedition_war' => $config->expedition_allow_expedition_war,
      'expedition_allow_darkmatter_find' => $config->expedition_allow_darkmatter_find,
      'expedition_allow_resources_find' => $config->expedition_allow_resources_find,
      'expedition_allow_ships_find' => $config->expedition_allow_ships_find,
      'expedition_consider_holdtime' => $config->expedition_consider_holdtime,
      'expedition_factor_resources' => $config->expedition_factor_resources,
      'expedition_factor_ships' => $config->expedition_factor_ships,
      'expedition_chances_percent_resources' => $config->expedition_chances_percent_resources,
      'expedition_chances_percent_darkmatter' => $config->expedition_chances_percent_darkmatter,
      'expedition_chances_percent_ships' => $config->expedition_chances_percent_ships,
      'expedition_chances_percent_pirates' => $config->expedition_chances_percent_pirates,
      'expedition_consider_same_coordinate' => $config->expedition_consider_same_coordinate,
      'expedition_min_darkmatter_small_min' => $config->expedition_min_darkmatter_small_min,
      'expedition_min_darkmatter_small_max' => $config->expedition_min_darkmatter_small_max,
      'expedition_min_darkmatter_large_min' => $config->expedition_min_darkmatter_large_min,
      'expedition_min_darkmatter_large_max' => $config->expedition_min_darkmatter_large_max,
      'expedition_min_darkmatter_vlarge_min' => $config->expedition_min_darkmatter_vlarge_min,
      'expedition_min_darkmatter_vlarge_max' => $config->expedition_min_darkmatter_vlarge_max,
      'expeditionEventGroups' => $expeditionEventGroups,
      'expeditionFactorCards' => $expeditionFactorCards,
      'expeditionChanceCards' => $expeditionChanceCards,
      'expeditionDarkmatterBands' => $expeditionDarkmatterBands,
    ));

    $this->display('page.expedition_settings.default.tpl');
  }

  function send(){
    global $LNG, $config;

    $config_before = array(
      'expedition_allow_fleet_loss' => $config->expedition_allow_fleet_loss,
      'expedition_allow_fleet_delay' => $config->expedition_allow_fleet_delay,
      'expedition_allow_fleet_speedup' => $config->expedition_allow_fleet_speedup,
      'expedition_allow_expedition_war' => $config->expedition_allow_expedition_war,
      'expedition_allow_darkmatter_find' => $config->expedition_allow_darkmatter_find,
      'expedition_allow_resources_find' => $config->expedition_allow_resources_find,
      'expedition_allow_ships_find' => $config->expedition_allow_ships_find,
      'expedition_consider_holdtime' => $config->expedition_consider_holdtime,
      'expedition_consider_same_coordinate' => $config->expedition_consider_same_coordinate,
      'expedition_chances_percent_resources' => $config->expedition_chances_percent_resources,
      'expedition_chances_percent_darkmatter' => $config->expedition_chances_percent_darkmatter,
      'expedition_chances_percent_ships' => $config->expedition_chances_percent_ships,
      'expedition_chances_percent_pirates' => $config->expedition_chances_percent_pirates,
      'expedition_min_darkmatter_small_min' => $config->expedition_min_darkmatter_small_min,
      'expedition_min_darkmatter_small_max' => $config->expedition_min_darkmatter_small_max,
      'expedition_min_darkmatter_large_min' => $config->expedition_min_darkmatter_large_min,
      'expedition_min_darkmatter_large_max' => $config->expedition_min_darkmatter_large_max,
      'expedition_min_darkmatter_vlarge_min' => $config->expedition_min_darkmatter_vlarge_min,
      'expedition_min_darkmatter_vlarge_max' => $config->expedition_min_darkmatter_vlarge_max,
    );

    $expedition_allow_fleet_loss = (HTTP::_GP('expedition_allow_fleet_loss', 'off') == 'on') ? 1 : 0;
    $expedition_allow_fleet_delay = (HTTP::_GP('expedition_allow_fleet_delay', 'off') == 'on') ? 1 : 0;
    $expedition_allow_fleet_speedup = (HTTP::_GP('expedition_allow_fleet_speedup', 'off') == 'on') ? 1 : 0;
    $expedition_allow_expedition_war = (HTTP::_GP('expedition_allow_expedition_war', 'off') == 'on') ? 1 : 0;
    $expedition_allow_darkmatter_find = (HTTP::_GP('expedition_allow_darkmatter_find', 'off') == 'on') ? 1 : 0;
    $expedition_allow_resources_find = (HTTP::_GP('expedition_allow_resources_find', 'off') == 'on') ? 1 : 0;
    $expedition_allow_ships_find = (HTTP::_GP('expedition_allow_ships_find', 'off') == 'on') ? 1 : 0;
    $expedition_consider_holdtime = (HTTP::_GP('expedition_consider_holdtime', 'off') == 'on') ? 1 : 0;
    $expedition_consider_same_coordinate = (HTTP::_GP('expedition_consider_same_coordinate', 'off') == 'on') ? 1 : 0;

    $expedition_factor_resources = HTTP::_GP('expedition_factor_resources',1);
    $expedition_factor_ships = HTTP::_GP('expedition_factor_ships',1);
    $chances_percent_resources = HTTP::_GP('expedition_chances_percent_resources',32.5);
    $chances_percent_darkmatter = HTTP::_GP('expedition_chances_percent_darkmatter',9);
    $chances_percent_ships = HTTP::_GP('expedition_chances_percent_ships',22);
    $chances_percent_pirates = HTTP::_GP('expedition_chances_percent_pirates',8.4);
    

    $expedition_min_darkmatter_small_min = HTTP::_GP('expedition_min_darkmatter_small_min',100);
    $expedition_min_darkmatter_small_max = HTTP::_GP('expedition_min_darkmatter_small_max',300);
    $expedition_min_darkmatter_large_min = HTTP::_GP('expedition_min_darkmatter_large_min',301);
    $expedition_min_darkmatter_large_max = HTTP::_GP('expedition_min_darkmatter_large_max',600);
    $expedition_min_darkmatter_vlarge_min = HTTP::_GP('expedition_min_darkmatter_vlarge_min',601);
    $expedition_min_darkmatter_vlarge_max = HTTP::_GP('expedition_min_darkmatter_vlarge_max',3000);

    $config_after = array(
      'expedition_allow_fleet_loss' => $expedition_allow_fleet_loss,
      'expedition_allow_fleet_delay' => $expedition_allow_fleet_delay,
      'expedition_allow_fleet_speedup' => $expedition_allow_fleet_speedup,
      'expedition_allow_expedition_war' => $expedition_allow_expedition_war,
      'expedition_allow_darkmatter_find' => $expedition_allow_darkmatter_find,
      'expedition_allow_resources_find' => $expedition_allow_resources_find,
      'expedition_allow_ships_find' => $expedition_allow_ships_find,
      'expedition_consider_holdtime' => $expedition_consider_holdtime,
      'expedition_consider_same_coordinate' => $expedition_consider_same_coordinate,
      'expedition_factor_resources' => $expedition_factor_resources,
      'expedition_factor_ships' => $expedition_factor_ships,
      'expedition_chances_percent_resources' => $chances_percent_resources,
      'expedition_chances_percent_darkmatter' => $chances_percent_darkmatter,
      'expedition_chances_percent_ships' => $chances_percent_ships,
      'expedition_chances_percent_pirates' => $chances_percent_pirates,
      'expedition_min_darkmatter_small_min' => $expedition_min_darkmatter_small_min,
      'expedition_min_darkmatter_small_max' => $expedition_min_darkmatter_small_max,
      'expedition_min_darkmatter_large_min' => $expedition_min_darkmatter_large_min,
      'expedition_min_darkmatter_large_max' => $expedition_min_darkmatter_large_max,
      'expedition_min_darkmatter_vlarge_min' => $expedition_min_darkmatter_vlarge_min,
      'expedition_min_darkmatter_vlarge_max' => $expedition_min_darkmatter_vlarge_max,
    );

    foreach($config_after as $key => $value)
    {
      $config->$key	= $value;
    }
    $config->save();

    $LOG = new Log(3);
    $LOG->target = 1;
    $LOG->old = $config_before;
    $LOG->new = $config_after;
    $LOG->save();


    $redirectButton = array();
    $redirectButton[] = array(
      'url' => 'admin.php?page=expedition&mode=show',
      'label' => $LNG['uvs_back']
    );

    $this->printMessage($LNG['settings_successful'],$redirectButton);

  }

  function default(){

    global $config, $LNG;

    $expedition_allow_fleet_loss = 1;
    $expedition_allow_fleet_delay = 1;
    $expedition_allow_fleet_speedup = 1;
    $expedition_allow_expedition_war = 1;
    $expedition_allow_darkmatter_find = 1;
    $expedition_allow_resources_find = 1;
    $expedition_allow_ships_find = 1;
    $expedition_consider_holdtime = 1;
    $expedition_consider_same_coordinate = 1;

    $expedition_factor_resources = 1;
    $expedition_factor_ships = 1;
    $chances_percent_resources = 32.5;
		$chances_percent_darkmatter = 9;
		$chances_percent_ships = 22;
		$chances_percent_pirates = 8.4;

    $expedition_min_darkmatter_small_min = 100;
    $expedition_min_darkmatter_small_max = 300;
    $expedition_min_darkmatter_large_min = 301;
    $expedition_min_darkmatter_large_max = 600;
    $expedition_min_darkmatter_vlarge_min = 601;
    $expedition_min_darkmatter_vlarge_max = 3000;

    $config_after = array(
      'expedition_allow_fleet_loss' => $expedition_allow_fleet_loss,
      'expedition_allow_fleet_delay' => $expedition_allow_fleet_delay,
      'expedition_allow_fleet_speedup' => $expedition_allow_fleet_speedup,
      'expedition_allow_expedition_war' => $expedition_allow_expedition_war,
      'expedition_allow_darkmatter_find' => $expedition_allow_darkmatter_find,
      'expedition_allow_resources_find' => $expedition_allow_resources_find,
      'expedition_allow_ships_find' => $expedition_allow_ships_find,
      'expedition_consider_holdtime' => $expedition_consider_holdtime,
      'expedition_consider_same_coordinate' => $expedition_consider_same_coordinate,
      'expedition_factor_resources' => $expedition_factor_resources,
      'expedition_factor_ships' => $expedition_factor_ships,
      'expedition_chances_percent_resources' => $chances_percent_resources,
      'expedition_chances_percent_darkmatter' => $chances_percent_darkmatter,
      'expedition_chances_percent_ships' => $chances_percent_ships,
      'expedition_chances_percent_pirates' => $chances_percent_pirates,
      'expedition_min_darkmatter_small_min' => $expedition_min_darkmatter_small_min,
      'expedition_min_darkmatter_small_max' => $expedition_min_darkmatter_small_max,
      'expedition_min_darkmatter_large_min' => $expedition_min_darkmatter_large_min,
      'expedition_min_darkmatter_large_max' => $expedition_min_darkmatter_large_max,
      'expedition_min_darkmatter_vlarge_min' => $expedition_min_darkmatter_vlarge_min,
      'expedition_min_darkmatter_vlarge_max' => $expedition_min_darkmatter_vlarge_max,
    );

    foreach($config_after as $key => $value)
    {
      $config->$key	= $value;
    }
    $config->save();

    $redirectButton = array();
    $redirectButton[] = array(
      'url' => 'admin.php?page=expedition&mode=show',
      'label' => $LNG['uvs_back']
    );

    $this->printMessage($LNG['settings_successful'],$redirectButton);


  }


}










 ?>
