<?php

class AdminUiService
{
	protected static function getSectionDefinitions()
	{
		return array(
			'pilotage' => array(
				'label' => 'Pilotage',
				'description' => 'Vue d’ensemble, supervision et suivi opérationnel.',
				'icon' => 'bi-grid-1x2-fill',
				'items' => array(
					array('page' => 'overview', 'label' => 'Tableau de bord', 'icon' => 'bi-speedometer2'),
					array('page' => 'supervision', 'label' => 'Supervision', 'icon' => 'bi-activity'),
					array('page' => 'support', 'label' => 'Support', 'icon' => 'bi-life-preserver'),
					array('page' => 'log', 'label' => 'Journaux', 'icon' => 'bi-journal-text'),
				),
			),
			'automatisation' => array(
				'label' => 'Automatisation',
				'description' => 'Bots, planification, messages et exécution récurrente.',
				'icon' => 'bi-cpu-fill',
				'items' => array(
					array('page' => 'bots', 'label' => 'Bots', 'icon' => 'bi-robot'),
					array('page' => 'cronjob', 'label' => 'Tâches planifiées', 'icon' => 'bi-clock-history'),
					array('page' => 'chat', 'label' => 'Chat temps réel', 'icon' => 'bi-chat-dots'),
					array('page' => 'sendMessages', 'label' => 'Campagnes de messages', 'icon' => 'bi-megaphone'),
				),
			),
			'joueurs' => array(
				'label' => 'Joueurs',
				'description' => 'Comptes, sanctions, recherche et exploitation du monde.',
				'icon' => 'bi-people-fill',
				'items' => array(
					array('page' => 'accounts', 'label' => 'Comptes', 'icon' => 'bi-person-badge'),
					array('page' => 'search', 'label' => 'Recherche', 'icon' => 'bi-search'),
					array('page' => 'fleets', 'label' => 'Flottes en vol', 'icon' => 'bi-rocket-takeoff'),
					array('page' => 'banned', 'label' => 'Bannissements', 'icon' => 'bi-slash-circle'),
					array('page' => 'multi', 'label' => 'Multi-comptes', 'icon' => 'bi-diagram-3'),
					array('page' => 'create', 'label' => 'Création manuelle', 'icon' => 'bi-plus-square'),
					array('page' => 'accountData', 'label' => 'Données de compte', 'icon' => 'bi-database'),
				),
			),
			'contenu' => array(
				'label' => 'Contenu',
				'description' => 'Tout ce qui est éditorial, public ou visible par les joueurs.',
				'icon' => 'bi-stars',
				'items' => array(
					array('page' => 'public', 'label' => 'Site public', 'icon' => 'bi-window'),
					array('page' => 'news', 'label' => 'Actualités', 'icon' => 'bi-newspaper'),
					array('page' => 'missions', 'label' => 'Missions', 'icon' => 'bi-list-check'),
					array('page' => 'branding', 'label' => 'Identité visuelle', 'icon' => 'bi-palette'),
					array('page' => 'mailtemplates', 'label' => 'Courriels', 'icon' => 'bi-envelope-paper'),
				),
			),
			'parametres' => array(
				'label' => 'Paramètres',
				'description' => 'Réglages du serveur, des univers et des mécaniques de jeu.',
				'icon' => 'bi-sliders2',
				'items' => array(
					array('page' => 'server', 'label' => 'Serveur et identité', 'icon' => 'bi-hdd-network'),
					array('page' => 'universe', 'label' => 'Univers', 'icon' => 'bi-globe2'),
					array('page' => 'stats', 'label' => 'Statistiques', 'icon' => 'bi-bar-chart'),
					array('page' => 'colonySettings', 'label' => 'Colonies', 'icon' => 'bi-building'),
					array('page' => 'planetFields', 'label' => 'Champs planétaires', 'icon' => 'bi-bounding-box'),
					array('page' => 'expedition', 'label' => 'Expéditions', 'icon' => 'bi-compass'),
					array('page' => 'relocate', 'label' => 'Relocalisation', 'icon' => 'bi-signpost-split'),
					array('page' => 'module', 'label' => 'Modules', 'icon' => 'bi-toggles2'),
					array('page' => 'rights', 'label' => 'Droits', 'icon' => 'bi-shield-lock'),
					array('page' => 'disclamer', 'label' => 'Mentions légales', 'icon' => 'bi-file-earmark-text'),
				),
			),
			'outils' => array(
				'label' => 'Maintenance',
				'description' => 'Nettoyage, inspection, export et contrôle technique.',
				'icon' => 'bi-tools',
				'items' => array(
					array('page' => 'active', 'label' => 'Activations en attente', 'icon' => 'bi-person-check'),
					array('page' => 'messagelist', 'label' => 'Historique des messages', 'icon' => 'bi-inboxes'),
					array('page' => 'clearCache', 'label' => 'Cache', 'icon' => 'bi-lightning-charge'),
					array('page' => 'dump', 'label' => 'Sauvegarde SQL', 'icon' => 'bi-download'),
					array('page' => 'infos', 'label' => 'Informations techniques', 'icon' => 'bi-info-circle'),
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
					'description' => isset($section['description']) ? $section['description'] : '',
					'icon' => $section['icon'],
					'count' => count($items),
					'items' => $items,
				);
			}
		}

		return $navigation;
	}

	public static function getFlatNavigation()
	{
		$flat = array();
		foreach (self::getNavigation() as $section) {
			foreach ($section['items'] as $item) {
				$item['section'] = $section['label'];
				$item['section_key'] = $section['key'];
				$flat[] = $item;
			}
		}

		return $flat;
	}

	public static function getPageMeta($page, $search = '')
	{
		$map = array(
			'overview' => array('section' => 'pilotage', 'icon' => 'bi-speedometer2', 'title' => 'Tableau de bord', 'description' => 'Synthèse d’exploitation, signaux système et raccourcis de supervision.', 'actions' => array(
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
				array('label' => 'Bots', 'url' => 'admin.php?page=bots', 'tone' => 'accent'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'supervision' => array('section' => 'pilotage', 'icon' => 'bi-activity', 'title' => 'Supervision', 'description' => 'Suivi du serveur, des conteneurs Astra et des services techniques.', 'actions' => array(
				array('label' => 'Retour tableau de bord', 'url' => 'admin.php?page=overview', 'tone' => 'light'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'support' => array('section' => 'pilotage', 'icon' => 'bi-life-preserver', 'title' => 'Support', 'description' => 'Traitement des tickets, échanges et suivi des demandes en cours.'),
			'log' => array('section' => 'pilotage', 'icon' => 'bi-journal-text', 'title' => 'Journaux', 'description' => 'Traçabilité des opérations, audits et incidents.'),
			'public' => array('section' => 'contenu', 'title' => 'Site public', 'description' => 'Accueil, navigation publique, contenus éditoriaux et réglages visibles hors jeu.'),
			'news' => array('section' => 'contenu', 'title' => 'Actualités', 'description' => 'Rédaction et publication des nouvelles visibles sur le site public.'),
			'bots' => array('section' => 'automatisation', 'icon' => 'bi-robot', 'title' => 'Bots', 'description' => 'Profils, consignes, activité en direct et pilotage des bots du jeu.', 'actions' => array(
				array('label' => 'Cycle complet', 'url' => 'admin.php?page=bots&mode=runEngine&phase=cycle&limit=18', 'tone' => 'accent'),
				array('label' => 'Créer des bots', 'url' => 'admin.php?page=bots&mode=create', 'tone' => 'light'),
				array('label' => 'Console bots', 'url' => 'game.php?page=chat', 'tone' => 'light'),
			)),
			'missions' => array('section' => 'contenu', 'title' => 'Missions', 'description' => 'Catalogue, récompenses et suivi des missions distribuées aux joueurs.'),
			'chat' => array('section' => 'automatisation', 'icon' => 'bi-chat-dots', 'title' => 'Chat temps réel', 'description' => 'Canaux, modération, rétention, restrictions et paramètres du relais WebSocket.', 'actions' => array(
				array('label' => 'Ouvrir le chat', 'url' => 'game.php?page=chat', 'tone' => 'light'),
				array('label' => 'Campagnes de messages', 'url' => 'admin.php?page=sendMessages', 'tone' => 'light'),
			)),
			'sendMessages' => array('section' => 'automatisation', 'icon' => 'bi-megaphone', 'title' => 'Campagnes de messages', 'description' => 'Communication globale auprès des joueurs selon les besoins d’exploitation.'),
			'accounts' => array('section' => 'joueurs', 'icon' => 'bi-person-badge', 'title' => 'Comptes', 'description' => 'Administration détaillée des comptes, planètes, ressources et profils.', 'actions' => array(
				array('label' => 'Recherche', 'url' => 'admin.php?page=search', 'tone' => 'light'),
				array('label' => 'Créer un compte', 'url' => 'admin.php?page=create', 'tone' => 'accent'),
			)),
			'create' => array('section' => 'joueurs', 'title' => 'Création manuelle', 'description' => 'Création assistée de comptes, planètes, lunes et entrées techniques.'),
			'banned' => array('section' => 'joueurs', 'title' => 'Bannissements', 'description' => 'Gestion des sanctions, motifs et durées d’exclusion.'),
			'fleets' => array('section' => 'joueurs', 'title' => 'Flottes en vol', 'description' => 'Vision d’ensemble des flottes actives et de leurs missions.'),
			'search' => array('section' => 'joueurs', 'title' => 'Recherche', 'description' => 'Recherche transversale sur les joueurs, planètes, lunes et connexions.'),
			'active' => array('section' => 'outils', 'title' => 'Activations en attente', 'description' => 'Validation manuelle des comptes en attente d’activation.'),
			'messagelist' => array('section' => 'outils', 'title' => 'Historique des messages', 'description' => 'Consultation du journal des messages pour audit et support.'),
			'multi' => array('section' => 'joueurs', 'title' => 'Multi-comptes et IP', 'description' => 'Détection et suivi des recouvrements techniques entre comptes.'),
			'accountData' => array('section' => 'joueurs', 'title' => 'Données de compte', 'description' => 'Lecture consolidée des données d’un joueur et de ses actifs.'),
			'server' => array('section' => 'parametres', 'icon' => 'bi-hdd-network', 'title' => 'Serveur et identité', 'description' => 'Réglages globaux du jeu, sécurité, SMTP, thèmes et identité du serveur.', 'actions' => array(
				array('label' => 'Univers', 'url' => 'admin.php?page=universe', 'tone' => 'light'),
				array('label' => 'Modules', 'url' => 'admin.php?page=module', 'tone' => 'light'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'branding' => array('section' => 'contenu', 'title' => 'Identité visuelle', 'description' => 'Logo global, aperçu de marque et diffusion visuelle sur toute la plateforme.'),
			'mailtemplates' => array('section' => 'contenu', 'title' => 'Modèles de courriels', 'description' => 'Édition des courriels transactionnels et aperçu des variables disponibles.'),
			'universe' => array('section' => 'parametres', 'title' => 'Univers', 'description' => 'Paramètres par univers et réglages structurels du gameplay.'),
			'colonySettings' => array('section' => 'parametres', 'title' => 'Colonies', 'description' => 'Réglages des colonies et équilibre d’occupation planétaire.'),
			'planetFields' => array('section' => 'parametres', 'title' => 'Champs planétaires', 'description' => 'Barèmes, limites et contrôles liés aux champs des planètes.'),
			'expedition' => array('section' => 'parametres', 'title' => 'Expéditions', 'description' => 'Configuration des événements et paramètres d’expédition.'),
			'relocate' => array('section' => 'parametres', 'title' => 'Relocalisation', 'description' => 'Déplacements encadrés des planètes et outils d’assistance.'),
			'module' => array('section' => 'parametres', 'title' => 'Modules', 'description' => 'Activation, désactivation et pilotage des fonctionnalités applicatives.'),
			'disclamer' => array('section' => 'parametres', 'title' => 'Mentions légales', 'description' => 'Coordonnées légales, notice de contact et informations de conformité.'),
			'stats' => array('section' => 'parametres', 'title' => 'Statistiques', 'description' => 'Réglages et fréquence de calcul des statistiques du jeu.'),
			'cronjob' => array('section' => 'automatisation', 'icon' => 'bi-clock-history', 'title' => 'Tâches planifiées', 'description' => 'Planification, inspection et exécution des tâches récurrentes.', 'actions' => array(
				array('label' => 'Nouveau cronjob', 'url' => 'admin.php?page=cronjob&mode=showCronjobCreate', 'tone' => 'accent'),
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
			)),
			'clearCache' => array('section' => 'outils', 'icon' => 'bi-lightning-charge', 'title' => 'Cache', 'description' => 'Purge et pilotage du cache de l’application et des couches associées.', 'actions' => array(
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
				array('label' => 'Tableau de bord', 'url' => 'admin.php?page=overview', 'tone' => 'light'),
			)),
			'dump' => array('section' => 'outils', 'title' => 'Sauvegarde SQL', 'description' => 'Export technique de la base et opérations de sauvegarde.'),
			'rights' => array('section' => 'parametres', 'title' => 'Droits', 'description' => 'Gestion des droits d’administration et des niveaux d’accès.'),
			'infos' => array('section' => 'outils', 'title' => 'Informations techniques', 'description' => 'Versions, environnement d’exécution et points de diagnostic pour le support.'),
		);

		$meta = isset($map[$page]) ? $map[$page] : array(
			'section' => 'pilotage',
			'icon' => 'bi-grid-1x2-fill',
			'title' => 'Administration',
			'description' => 'Pilotage et maintenance de la plateforme.',
			'actions' => array(),
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
				'icon' => isset($item['icon']) ? $item['icon'] : 'bi-dot',
				'url' => 'admin.php?page='.$item['page'],
				'active' => $item['page'] === $page,
			);
		}

		return $tabs;
	}
}
