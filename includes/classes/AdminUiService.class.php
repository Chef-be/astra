<?php

class AdminUiService
{
	protected static function getSectionDefinitions()
	{
		return array(
			'pilotage' => array(
				'label' => 'Pilotage',
				'icon' => 'bi-speedometer2',
				'items' => array(
					array('page' => 'overview', 'label' => 'Tableau de bord'),
					array('page' => 'supervision', 'label' => 'Supervision'),
					array('page' => 'support', 'label' => 'Support'),
					array('page' => 'chat', 'label' => 'Chat temps réel'),
					array('page' => 'log', 'label' => 'Journaux'),
				),
			),
			'contenu' => array(
				'label' => 'Contenu',
				'icon' => 'bi-stars',
				'items' => array(
					array('page' => 'public', 'label' => 'Site public'),
					array('page' => 'news', 'label' => 'Actualités'),
					array('page' => 'missions', 'label' => 'Missions'),
					array('page' => 'bots', 'label' => 'Bots'),
					array('page' => 'sendMessages', 'label' => 'Campagnes de messages'),
				),
			),
			'joueurs' => array(
				'label' => 'Joueurs',
				'icon' => 'bi-people',
				'items' => array(
					array('page' => 'accounts', 'label' => 'Comptes'),
					array('page' => 'search', 'label' => 'Recherche'),
					array('page' => 'fleets', 'label' => 'Flottes en vol'),
					array('page' => 'banned', 'label' => 'Bannissements'),
					array('page' => 'create', 'label' => 'Création manuelle'),
				),
			),
			'parametres' => array(
				'label' => 'Paramètres',
				'icon' => 'bi-sliders',
				'items' => array(
					array('page' => 'server', 'label' => 'Serveur et identité'),
					array('page' => 'universe', 'label' => 'Univers'),
					array('page' => 'branding', 'label' => 'Identité visuelle'),
					array('page' => 'mailtemplates', 'label' => 'Courriels'),
					array('page' => 'stats', 'label' => 'Statistiques'),
					array('page' => 'colonySettings', 'label' => 'Colonies'),
					array('page' => 'planetFields', 'label' => 'Champs planétaires'),
					array('page' => 'expedition', 'label' => 'Expéditions'),
					array('page' => 'relocate', 'label' => 'Relocalisation'),
					array('page' => 'module', 'label' => 'Modules'),
					array('page' => 'disclamer', 'label' => 'Mentions légales'),
					array('page' => 'clearCache', 'label' => 'Cache'),
				),
			),
			'outils' => array(
				'label' => 'Outils avancés',
				'icon' => 'bi-tools',
				'items' => array(
					array('page' => 'active', 'label' => 'Activations en attente'),
					array('page' => 'messagelist', 'label' => 'Historique des messages'),
					array('page' => 'multi', 'label' => 'Multi-comptes et IP'),
					array('page' => 'accountData', 'label' => 'Données de compte'),
					array('page' => 'rights', 'label' => 'Droits'),
					array('page' => 'cronjob', 'label' => 'Tâches planifiées'),
					array('page' => 'dump', 'label' => 'Sauvegarde SQL'),
					array('page' => 'infos', 'label' => 'Informations techniques'),
				),
			),
		);
	}

	public static function getNavigation()
	{
		$navigation = array();
		foreach (self::getSectionDefinitions() as $sectionKey => $section) {
			$items = array();
			foreach ($section['items'] as $item) {
				$pageClass = 'Show'.ucfirst($item['page']).'Page';
				if (!class_exists($pageClass) && !file_exists(ROOT_PATH.'includes/pages/adm/'.$pageClass.'.class.php')) {
					continue;
				}
				if (function_exists('allowedTo') && !allowedTo($pageClass)) {
					continue;
				}

				$item['url'] = 'admin.php?page='.$item['page'];
				$items[] = $item;
			}

			if (!empty($items)) {
				$navigation[] = array(
					'key' => $sectionKey,
					'label' => $section['label'],
					'icon' => $section['icon'],
					'items' => $items,
				);
			}
		}

		return $navigation;
	}

	public static function getPageMeta($page, $search = '')
	{
		$map = array(
			'overview' => array('section' => 'pilotage', 'title' => 'Tableau de bord', 'description' => 'Synthèse d’exploitation, signaux système et raccourcis de supervision.'),
			'supervision' => array('section' => 'pilotage', 'title' => 'Supervision', 'description' => 'Suivi du serveur, des conteneurs Astra et des services techniques.'),
			'support' => array('section' => 'pilotage', 'title' => 'Support', 'description' => 'Traitement des tickets, échanges et suivi des demandes en cours.'),
			'log' => array('section' => 'pilotage', 'title' => 'Journaux', 'description' => 'Traçabilité des opérations, audits et incidents.'),
			'public' => array('section' => 'contenu', 'title' => 'Site public', 'description' => 'Accueil, navigation publique, contenus éditoriaux et réglages visibles hors jeu.'),
			'news' => array('section' => 'contenu', 'title' => 'Actualités', 'description' => 'Rédaction et publication des nouvelles visibles sur le site public.'),
			'bots' => array('section' => 'contenu', 'title' => 'Bots', 'description' => 'Profils, consignes, activité en direct et pilotage des bots du jeu.'),
			'missions' => array('section' => 'contenu', 'title' => 'Missions', 'description' => 'Catalogue, récompenses et suivi des missions distribuées aux joueurs.'),
			'chat' => array('section' => 'contenu', 'title' => 'Chat temps réel', 'description' => 'Canaux, modération, rétention, restrictions et paramètres du relais WebSocket.'),
			'sendMessages' => array('section' => 'contenu', 'title' => 'Campagnes de messages', 'description' => 'Communication globale auprès des joueurs selon les besoins d’exploitation.'),
			'accounts' => array('section' => 'joueurs', 'title' => 'Comptes', 'description' => 'Administration détaillée des comptes, planètes, ressources et profils.'),
			'create' => array('section' => 'joueurs', 'title' => 'Création manuelle', 'description' => 'Création assistée de comptes, planètes, lunes et entrées techniques.'),
			'banned' => array('section' => 'joueurs', 'title' => 'Bannissements', 'description' => 'Gestion des sanctions, motifs et durées d’exclusion.'),
			'fleets' => array('section' => 'joueurs', 'title' => 'Flottes en vol', 'description' => 'Vision d’ensemble des flottes actives et de leurs missions.'),
			'search' => array('section' => 'joueurs', 'title' => 'Recherche', 'description' => 'Recherche transversale sur les joueurs, planètes, lunes et connexions.'),
			'active' => array('section' => 'outils', 'title' => 'Activations en attente', 'description' => 'Validation manuelle des comptes en attente d’activation.'),
			'messagelist' => array('section' => 'outils', 'title' => 'Historique des messages', 'description' => 'Consultation du journal des messages pour audit et support.'),
			'multi' => array('section' => 'outils', 'title' => 'Multi-comptes et IP', 'description' => 'Détection et suivi des recouvrements techniques entre comptes.'),
			'accountData' => array('section' => 'outils', 'title' => 'Données de compte', 'description' => 'Lecture consolidée des données d’un joueur et de ses actifs.'),
			'server' => array('section' => 'parametres', 'title' => 'Serveur et identité', 'description' => 'Réglages globaux du jeu, sécurité, SMTP, thèmes et identité du serveur.'),
			'branding' => array('section' => 'parametres', 'title' => 'Identité visuelle', 'description' => 'Logo global, aperçu de marque et diffusion visuelle sur toute la plateforme.'),
			'mailtemplates' => array('section' => 'parametres', 'title' => 'Modèles de courriels', 'description' => 'Édition des courriels transactionnels et aperçu des variables disponibles.'),
			'universe' => array('section' => 'parametres', 'title' => 'Univers', 'description' => 'Paramètres par univers et réglages structurels du gameplay.'),
			'colonySettings' => array('section' => 'parametres', 'title' => 'Colonies', 'description' => 'Réglages des colonies et équilibre d’occupation planétaire.'),
			'planetFields' => array('section' => 'parametres', 'title' => 'Champs planétaires', 'description' => 'Barèmes, limites et contrôles liés aux champs des planètes.'),
			'expedition' => array('section' => 'parametres', 'title' => 'Expéditions', 'description' => 'Configuration des événements et paramètres d’expédition.'),
			'relocate' => array('section' => 'parametres', 'title' => 'Relocalisation', 'description' => 'Déplacements encadrés des planètes et outils d’assistance.'),
			'module' => array('section' => 'parametres', 'title' => 'Modules', 'description' => 'Activation, désactivation et pilotage des fonctionnalités applicatives.'),
			'disclamer' => array('section' => 'parametres', 'title' => 'Mentions légales', 'description' => 'Coordonnées légales, notice de contact et informations de conformité.'),
			'stats' => array('section' => 'parametres', 'title' => 'Statistiques', 'description' => 'Réglages et fréquence de calcul des statistiques du jeu.'),
			'cronjob' => array('section' => 'outils', 'title' => 'Tâches planifiées', 'description' => 'Planification, inspection et exécution des tâches récurrentes.'),
			'clearCache' => array('section' => 'parametres', 'title' => 'Cache', 'description' => 'Purge et pilotage du cache de l’application et des couches associées.'),
			'dump' => array('section' => 'outils', 'title' => 'Sauvegarde SQL', 'description' => 'Export technique de la base et opérations de sauvegarde.'),
			'rights' => array('section' => 'outils', 'title' => 'Droits', 'description' => 'Gestion des droits d’administration et des niveaux d’accès.'),
			'infos' => array('section' => 'outils', 'title' => 'Informations techniques', 'description' => 'Versions, environnement d’exécution et points de diagnostic pour le support.'),
		);

		$meta = isset($map[$page]) ? $map[$page] : array(
			'section' => 'pilotage',
			'title' => 'Administration',
			'description' => 'Pilotage et maintenance de la plateforme.',
		);

		if ($page === 'search' && $search !== '') {
			$meta['description'] = 'Recherche ciblée sur le périmètre : '.$search.'.';
		}

		return $meta;
	}

	public static function getSectionLabel($sectionKey)
	{
		$sections = self::getSectionDefinitions();
		return isset($sections[$sectionKey]['label']) ? $sections[$sectionKey]['label'] : 'Administration';
	}

	public static function getTabs($page)
	{
		$meta = self::getPageMeta($page);
		$sectionKey = $meta['section'];
		$sections = self::getSectionDefinitions();
		$tabs = array();

		if (empty($sections[$sectionKey])) {
			return $tabs;
		}

		foreach ($sections[$sectionKey]['items'] as $item) {
			$pageClass = 'Show'.ucfirst($item['page']).'Page';
			if (!class_exists($pageClass) && !file_exists(ROOT_PATH.'includes/pages/adm/'.$pageClass.'.class.php')) {
				continue;
			}
			if (function_exists('allowedTo') && !allowedTo($pageClass)) {
				continue;
			}

			$tabs[] = array(
				'page' => $item['page'],
				'label' => $item['label'],
				'url' => 'admin.php?page='.$item['page'],
				'active' => $item['page'] === $page,
			);
		}

		return $tabs;
	}
}
