<?php

class PublicContentService
{
	protected $config;

	protected $pageConfigMap = array(
		'register'   => 'public_menu_register',
		'news'       => 'public_menu_news',
		'rules'      => 'public_menu_rules',
		'screens'    => 'public_menu_screens',
		'banList'    => 'public_menu_banlist',
		'battleHall' => 'public_menu_battlehall',
		'disclamer'  => 'public_menu_disclamer',
	);

	public function __construct($config = null)
	{
		if ($config === null) {
			$config = Config::get();
		}

		$this->config = $config;
	}

	public function getHomepageIntroHtml()
	{
		$content = trim((string) $this->config->homepage_intro_html);

		if ($content === '') {
			$gameName = htmlspecialchars($this->config->game_name, ENT_QUOTES, 'UTF-8');
			return '<p><strong>'.$gameName.'</strong> est un jeu de stratégie spatiale en temps réel où des milliers de joueurs peuvent évoluer au sein du même univers.</p><p>Développez votre empire, bâtissez vos flottes, défendez vos colonies et imposez votre domination galactique depuis un simple navigateur web.</p>';
		}

		if (strpos($content, '&lt;') !== false && strpos($content, '<') === false) {
			$content = html_entity_decode($content, ENT_QUOTES, 'UTF-8');
		}

		return $content;
	}

	public function getSecretQuestions()
	{
		$questions = array();
		$rawValue = trim((string) $this->config->secret_question_options);

		if ($rawValue === '') {
			$questions = self::getDefaultSecretQuestions();
		} else {
			foreach (preg_split('/\r\n|\r|\n/', $rawValue) as $question) {
				$question = trim($question);

				if ($question === '') {
					continue;
				}

				$questions[] = $question;
			}
		}

		if (empty($questions)) {
			$questions = self::getDefaultSecretQuestions();
		}

		return array_values($questions);
	}

	public function getSecretQuestionTextareaValue()
	{
		return implode("\n", $this->getSecretQuestions());
	}

	public function getPageFlags()
	{
		$flags = array();

		foreach ($this->pageConfigMap as $page => $configKey) {
			$flags[$page] = !empty($this->config->$configKey);
		}

		$flags['index'] = true;
		$flags['login'] = true;
		$flags['lostPassword'] = true;
		$flags['vertify'] = true;
		$flags['externalAuth'] = true;

		return $flags;
	}

	public function isPageEnabled($page)
	{
		$page = (string) $page;

		if ($page === '' || $page === 'index') {
			return true;
		}

		if ($page === 'register' && (int) $this->config->reg_closed === 1) {
			return false;
		}

		if (!isset($this->pageConfigMap[$page])) {
			return true;
		}

		$configKey = $this->pageConfigMap[$page];
		return !empty($this->config->$configKey);
	}

	public function getNavigationItems($LNG)
	{
		$items = array(
			array(
				'id'    => 'index',
				'title' => $LNG['siteTitleIndex'],
				'url'   => 'index.php?page=index',
			),
		);

		$definitions = array(
			'register' => $LNG['siteTitleRegister'],
			'news' => $LNG['siteTitleNews'],
			'rules' => $LNG['siteTitleRules'],
			'screens' => $LNG['siteTitleScreens'],
			'banList' => $LNG['siteTitleBanList'],
			'battleHall' => $LNG['siteTitleBattleHall'],
			'disclamer' => $LNG['siteTitleDisclamer'],
		);

		foreach ($definitions as $page => $title) {
			if (!$this->isPageEnabled($page)) {
				continue;
			}

			$items[] = array(
				'id'    => $page,
				'title' => $title,
				'url'   => 'index.php?page='.$page,
			);
		}

		return $items;
	}

	public static function getDefaultSecretQuestions()
	{
		return array(
			'Dans quelle ville êtes-vous né ?',
			'Quel est le nom de votre animal favori ?',
			'Quel est le nom de naissance de votre mère ?',
			'Quel lycée avez-vous fréquenté ?',
			'Quel était le nom de votre école primaire ?',
			'Quelle était la marque de votre première voiture ?',
			'Quel était votre plat préféré durant votre enfance ?',
		);
	}
}
