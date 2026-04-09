<?php

class AdminUiService
{
	protected static function getThemeKey()
	{
		$theme = 'nextgen';
		if (class_exists('Config') && class_exists('Universe')) {
			$config = Config::get(Universe::getEmulated());
			if (!empty($config->server_default_theme)) {
				$theme = $config->server_default_theme;
			}
		}

		$themePath = ROOT_PATH.'styles/theme/'.$theme;
		if (!is_dir($themePath)) {
			$theme = 'nextgen';
		}

		return $theme;
	}

	public static function getActiveThemeKey()
	{
		return self::getThemeKey();
	}

	protected static function resolveThemeAsset($theme, $id)
	{
		$candidates = array(
			'styles/theme/'.$theme.'/gebaeude/'.$id.'.gif',
			'styles/theme/'.$theme.'/gebaeude/'.$id.'.jpg',
			'styles/theme/'.$theme.'/gebaeude/'.$id.'.webp',
			'styles/theme/'.$theme.'/gebaeude/'.$id.'.png',
		);

		foreach ($candidates as $candidate) {
			if (file_exists(ROOT_PATH.$candidate)) {
				return $candidate;
			}
		}

		if ($theme !== 'nextgen') {
			return self::resolveThemeAsset('nextgen', $id);
		}

		return '';
	}

	public static function getThemeAssetUrl($id, $theme = null)
	{
		if (empty($theme)) {
			$theme = self::getThemeKey();
		}

		return self::resolveThemeAsset($theme, (int) $id);
	}

	protected static function buildShowcase(array $items)
	{
		$theme = self::getThemeKey();
		$showcase = array();

		foreach ($items as $item) {
			if (empty($item['id'])) {
				continue;
			}

			$showcase[] = array(
				'id' => (int) $item['id'],
				'tag' => isset($item['tag']) ? $item['tag'] : '',
				'metric' => isset($item['metric']) ? $item['metric'] : '',
				'image' => self::resolveThemeAsset($theme, (int) $item['id']),
			);
		}

		return $showcase;
	}

	protected static function getSectionDefinitions()
	{
		return array(
			'pilotage' => array(
				'label' => 'Pilotage',
				'description' => 'Vue d’ensemble, supervision et suivi opérationnel.',
				'icon' => 'bi-grid-1x2-fill',
				'artwork' => 'styles/theme/nextgen/img/space.avif',
				'thumbnail' => 'styles/theme/nextgen/img/background.jpg',
				'accent' => 'cyan',
				'showcase' => array(
					array('id' => 210, 'tag' => 'Recon'),
					array('id' => 207, 'tag' => 'Escadre'),
					array('id' => 108, 'tag' => 'Tech'),
					array('id' => 601, 'tag' => 'Officier'),
				),
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
				'artwork' => 'styles/theme/nextgen/images/research.webp',
				'thumbnail' => 'styles/theme/nextgen/images/facilities.webp',
				'accent' => 'emerald',
				'showcase' => array(
					array('id' => 211, 'tag' => 'Strike'),
					array('id' => 215, 'tag' => 'Cycle'),
					array('id' => 113, 'tag' => 'IA'),
					array('id' => 611, 'tag' => 'Agent'),
				),
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
				'artwork' => 'styles/theme/nextgen/images/hangar.webp',
				'thumbnail' => 'styles/theme/nextgen/images/buildings.webp',
				'accent' => 'amber',
				'showcase' => array(
					array('id' => 202, 'tag' => 'Cargo'),
					array('id' => 204, 'tag' => 'Léger'),
					array('id' => 205, 'tag' => 'Lourd'),
					array('id' => 215, 'tag' => 'BC'),
				),
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
				'artwork' => 'styles/theme/gow/img/space.avif',
				'thumbnail' => 'styles/theme/nova/img/bkd_page.jpg',
				'accent' => 'violet',
				'showcase' => array(
					array('id' => 601, 'tag' => 'Staff'),
					array('id' => 602, 'tag' => 'Audit'),
					array('id' => 603, 'tag' => 'Ops'),
					array('id' => 604, 'tag' => 'Com'),
				),
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
				'artwork' => 'styles/theme/nextgen/images/facilities.webp',
				'thumbnail' => 'styles/theme/nextgen/images/research.webp',
				'accent' => 'blue',
				'showcase' => array(
					array('id' => 1, 'tag' => 'Mine'),
					array('id' => 14, 'tag' => 'Usine'),
					array('id' => 108, 'tag' => 'Computing'),
					array('id' => 109, 'tag' => 'Armement'),
				),
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
				'artwork' => 'styles/theme/nextgen/images/defense.webp',
				'thumbnail' => 'styles/theme/nextgen/img/bkd_page.jpg',
				'accent' => 'rose',
				'showcase' => array(
					array('id' => 401, 'tag' => 'Laser'),
					array('id' => 402, 'tag' => 'Laser lourd'),
					array('id' => 406, 'tag' => 'Gauss'),
					array('id' => 502, 'tag' => 'ABM'),
				),
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
					'artwork' => isset($section['artwork']) ? $section['artwork'] : '',
					'thumbnail' => isset($section['thumbnail']) ? $section['thumbnail'] : '',
					'accent' => isset($section['accent']) ? $section['accent'] : 'cyan',
					'showcase' => isset($section['showcase']) ? self::buildShowcase($section['showcase']) : array(),
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
			'login' => array('section' => 'pilotage', 'icon' => 'bi-shield-lock', 'title' => 'Accès administration', 'description' => 'Connexion sécurisée au poste de commande.', 'illustration' => 'styles/theme/nextgen/img/space.avif', 'thumbnail' => 'styles/theme/nextgen/img/background.jpg', 'showcase' => array(
				array('id' => 202, 'tag' => 'Cargo'),
				array('id' => 207, 'tag' => 'Ligne'),
				array('id' => 108, 'tag' => 'Recherche'),
				array('id' => 601, 'tag' => 'Officier'),
			)),
			'overview' => array('section' => 'pilotage', 'icon' => 'bi-speedometer2', 'title' => 'Tableau de bord', 'description' => 'Synthèse d’exploitation, signaux système et raccourcis directs.', 'illustration' => 'styles/theme/nextgen/img/space.avif', 'thumbnail' => 'styles/theme/nextgen/img/background.jpg', 'showcase' => array(
				array('id' => 202, 'tag' => 'Cargo'),
				array('id' => 207, 'tag' => 'Flotte'),
				array('id' => 210, 'tag' => 'Scan'),
				array('id' => 601, 'tag' => 'Command'),
			), 'actions' => array(
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
				array('label' => 'Bots', 'url' => 'admin.php?page=bots', 'tone' => 'accent'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'supervision' => array('section' => 'pilotage', 'icon' => 'bi-activity', 'title' => 'Supervision', 'description' => 'Serveur, conteneurs et services critiques.', 'illustration' => 'styles/theme/nextgen/img/background.jpg', 'thumbnail' => 'styles/theme/nextgen/img/bkd_page.jpg', 'showcase' => array(
				array('id' => 108, 'tag' => 'Core'),
				array('id' => 113, 'tag' => 'Grid'),
				array('id' => 114, 'tag' => 'Sensors'),
				array('id' => 601, 'tag' => 'Ops'),
			), 'actions' => array(
				array('label' => 'Retour tableau de bord', 'url' => 'admin.php?page=overview', 'tone' => 'light'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'support' => array('section' => 'pilotage', 'icon' => 'bi-life-preserver', 'title' => 'Support', 'description' => 'Tickets, réponses et suivi des demandes.', 'illustration' => 'styles/theme/nextgen/img/background.jpg'),
			'log' => array('section' => 'pilotage', 'icon' => 'bi-journal-text', 'title' => 'Journaux', 'description' => 'Audit, incidents et historique opérationnel.'),
			'public' => array('section' => 'contenu', 'title' => 'Site public', 'description' => 'Accueil, navigation et contenus publics.'),
			'news' => array('section' => 'contenu', 'title' => 'Actualités', 'description' => 'Rédaction et publication des nouvelles.', 'illustration' => 'styles/theme/gow/img/space.avif'),
			'bots' => array('section' => 'automatisation', 'icon' => 'bi-robot', 'title' => 'Bots', 'description' => 'Profils, consignes, activité en direct et pilotage des bots du jeu.', 'showcase' => array(
				array('id' => 211, 'tag' => 'Strike'),
				array('id' => 215, 'tag' => 'BC'),
				array('id' => 603, 'tag' => 'Brain'),
				array('id' => 611, 'tag' => 'Agent'),
			), 'actions' => array(
				array('label' => 'Cycle complet', 'url' => 'admin.php?page=bots&mode=runEngine&phase=cycle&limit=18', 'tone' => 'accent'),
				array('label' => 'Créer des bots', 'url' => 'admin.php?page=bots&mode=create', 'tone' => 'light'),
				array('label' => 'Console bots', 'url' => 'game.php?page=chat', 'tone' => 'light'),
			)),
			'missions' => array('section' => 'contenu', 'title' => 'Missions', 'description' => 'Catalogue et récompenses distribuées aux joueurs.'),
			'chat' => array('section' => 'automatisation', 'icon' => 'bi-chat-dots', 'title' => 'Chat temps réel', 'description' => 'Canaux, modération et relais temps réel.', 'actions' => array(
				array('label' => 'Ouvrir le chat', 'url' => 'game.php?page=chat', 'tone' => 'light'),
				array('label' => 'Campagnes de messages', 'url' => 'admin.php?page=sendMessages', 'tone' => 'light'),
			)),
			'sendMessages' => array('section' => 'automatisation', 'icon' => 'bi-megaphone', 'title' => 'Campagnes de messages', 'description' => 'Communication globale vers les joueurs.'),
			'accounts' => array('section' => 'joueurs', 'icon' => 'bi-person-badge', 'title' => 'Comptes', 'description' => 'Administration des comptes, planètes et ressources.', 'showcase' => array(
				array('id' => 202, 'tag' => 'Cargo'),
				array('id' => 204, 'tag' => 'Chasseur'),
				array('id' => 205, 'tag' => 'Lourd'),
				array('id' => 215, 'tag' => 'BC'),
			), 'actions' => array(
				array('label' => 'Recherche', 'url' => 'admin.php?page=search', 'tone' => 'light'),
				array('label' => 'Créer un compte', 'url' => 'admin.php?page=create', 'tone' => 'accent'),
			)),
			'create' => array('section' => 'joueurs', 'title' => 'Création manuelle', 'description' => 'Création assistée de comptes et actifs.'),
			'banned' => array('section' => 'joueurs', 'title' => 'Bannissements', 'description' => 'Sanctions, motifs et durées d’exclusion.'),
			'fleets' => array('section' => 'joueurs', 'title' => 'Flottes en vol', 'description' => 'Lecture directe des flottes actives.'),
			'search' => array('section' => 'joueurs', 'title' => 'Recherche', 'description' => 'Recherche transversale sur les données joueurs.'),
			'active' => array('section' => 'outils', 'title' => 'Activations en attente', 'description' => 'Validation manuelle des comptes en file.'),
			'messagelist' => array('section' => 'outils', 'title' => 'Historique des messages', 'description' => 'Journal des messages pour audit et support.'),
			'multi' => array('section' => 'joueurs', 'title' => 'Multi-comptes et IP', 'description' => 'Recouvrements techniques entre comptes.'),
			'accountData' => array('section' => 'joueurs', 'title' => 'Données de compte', 'description' => 'Lecture consolidée des actifs d’un joueur.'),
			'server' => array('section' => 'parametres', 'icon' => 'bi-hdd-network', 'title' => 'Serveur et identité', 'description' => 'Réglages globaux, sécurité, SMTP et thème.', 'illustration' => 'styles/theme/nextgen/images/facilities.webp', 'thumbnail' => 'styles/theme/nextgen/images/research.webp', 'showcase' => array(
				array('id' => 1, 'tag' => 'Mine'),
				array('id' => 14, 'tag' => 'Factory'),
				array('id' => 108, 'tag' => 'Tech'),
				array('id' => 109, 'tag' => 'Weapon'),
			), 'actions' => array(
				array('label' => 'Univers', 'url' => 'admin.php?page=universe', 'tone' => 'light'),
				array('label' => 'Modules', 'url' => 'admin.php?page=module', 'tone' => 'light'),
				array('label' => 'Cache', 'url' => 'admin.php?page=clearCache', 'tone' => 'warning'),
			)),
			'branding' => array('section' => 'contenu', 'title' => 'Identité visuelle', 'description' => 'Logo global et diffusion visuelle.', 'illustration' => 'styles/theme/nova/img/logo.png', 'showcase' => array(
				array('id' => 601, 'tag' => 'Staff'),
				array('id' => 602, 'tag' => 'Intel'),
				array('id' => 603, 'tag' => 'Ops'),
				array('id' => 604, 'tag' => 'Com'),
			)),
			'mailtemplates' => array('section' => 'contenu', 'title' => 'Modèles de courriels', 'description' => 'Courriels transactionnels et variables.'),
			'universe' => array('section' => 'parametres', 'title' => 'Univers', 'description' => 'Cadence et règles par univers.', 'illustration' => 'styles/theme/nextgen/images/buildings.webp', 'thumbnail' => 'styles/theme/nextgen/images/hangar.webp', 'showcase' => array(
				array('id' => 1, 'tag' => 'Eco'),
				array('id' => 2, 'tag' => 'Crystal'),
				array('id' => 14, 'tag' => 'Factory'),
				array('id' => 31, 'tag' => 'Lab'),
			)),
			'colonySettings' => array('section' => 'parametres', 'title' => 'Colonies', 'description' => 'Réglages de colonisation.'),
			'planetFields' => array('section' => 'parametres', 'title' => 'Champs planétaires', 'description' => 'Barèmes et limites planétaires.'),
			'expedition' => array('section' => 'parametres', 'title' => 'Expéditions', 'description' => 'Événements et paramètres d’expédition.'),
			'relocate' => array('section' => 'parametres', 'title' => 'Relocalisation', 'description' => 'Déplacements encadrés des planètes.'),
			'module' => array('section' => 'parametres', 'title' => 'Modules', 'description' => 'Pilotage des fonctionnalités applicatives.'),
			'disclamer' => array('section' => 'parametres', 'title' => 'Mentions légales', 'description' => 'Coordonnées et conformité.'),
			'stats' => array('section' => 'parametres', 'title' => 'Statistiques', 'description' => 'Réglages et fréquence de calcul.'),
			'cronjob' => array('section' => 'automatisation', 'icon' => 'bi-clock-history', 'title' => 'Tâches planifiées', 'description' => 'Planification, inspection et exécution des tâches récurrentes.', 'actions' => array(
				array('label' => 'Nouveau cronjob', 'url' => 'admin.php?page=cronjob&mode=showCronjobCreate', 'tone' => 'accent'),
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
			)),
			'clearCache' => array('section' => 'outils', 'icon' => 'bi-lightning-charge', 'title' => 'Cache', 'description' => 'Purge et pilotage du cache applicatif.', 'actions' => array(
				array('label' => 'Supervision', 'url' => 'admin.php?page=supervision', 'tone' => 'light'),
				array('label' => 'Tableau de bord', 'url' => 'admin.php?page=overview', 'tone' => 'light'),
			)),
			'dump' => array('section' => 'outils', 'title' => 'Sauvegarde SQL', 'description' => 'Export technique de la base.'),
			'rights' => array('section' => 'parametres', 'title' => 'Droits', 'description' => 'Niveaux d’accès et permissions.'),
			'infos' => array('section' => 'outils', 'title' => 'Informations techniques', 'description' => 'Versions et environnement d’exécution.'),
		);

		$meta = isset($map[$page]) ? $map[$page] : array(
			'section' => 'pilotage',
			'icon' => 'bi-grid-1x2-fill',
			'title' => 'Administration',
			'description' => 'Pilotage et maintenance de la plateforme.',
			'actions' => array(),
		);

		$sections = self::getSectionDefinitions();
		if (isset($sections[$meta['section']])) {
			$meta['sectionLabel'] = $sections[$meta['section']]['label'];
			$meta['accent'] = isset($meta['accent']) ? $meta['accent'] : $sections[$meta['section']]['accent'];
			$meta['illustration'] = isset($meta['illustration']) ? $meta['illustration'] : $sections[$meta['section']]['artwork'];
			$meta['thumbnail'] = isset($meta['thumbnail']) ? $meta['thumbnail'] : $sections[$meta['section']]['thumbnail'];
			$meta['showcase'] = isset($meta['showcase']) ? self::buildShowcase($meta['showcase']) : self::buildShowcase($sections[$meta['section']]['showcase']);
		}

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

	public static function getSectionUrl($sectionKey)
	{
		foreach (self::getNavigation() as $section) {
			if ($section['key'] !== $sectionKey) {
				continue;
			}

			if (!empty($section['items'][0]['url'])) {
				return $section['items'][0]['url'];
			}
		}

		return 'admin.php?page=overview';
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
