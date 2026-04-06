<?php

class ShowPublicPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
	}

	public function show()
	{
		require_once ROOT_PATH.'includes/classes/PublicContentService.class.php';
		require_once ROOT_PATH.'includes/classes/PublicScreenshotService.class.php';

		$config = Config::get(Universe::getEmulated());
		$publicContentService = new PublicContentService($config);

		$this->assign(array(
			'title' => 'Site public',
			'homepage_intro_html' => $publicContentService->getHomepageIntroHtml(),
			'public_rules_html' => $config->public_rules_html,
			'secret_question_options' => $publicContentService->getSecretQuestionTextareaValue(),
			'public_screenshots' => PublicScreenshotService::getScreenshotsFromConfig((string) $config->public_screens_json),
			'public_menu_register' => $config->public_menu_register,
			'public_menu_news' => $config->public_menu_news,
			'public_menu_rules' => $config->public_menu_rules,
			'public_menu_screens' => $config->public_menu_screens,
			'public_menu_banlist' => $config->public_menu_banlist,
			'public_menu_battlehall' => $config->public_menu_battlehall,
			'public_menu_disclamer' => $config->public_menu_disclamer,
			'discord_active' => $config->discord_active,
			'discord_url' => $config->discord_url,
			'seo_meta_title' => $config->seo_meta_title,
			'seo_meta_description' => $config->seo_meta_description,
			'seo_meta_keywords' => $config->seo_meta_keywords,
			'seo_og_image_url' => $config->seo_og_image_url,
		));

		$this->display('page.public.default.tpl');
	}

	public function saveSettings()
	{
		global $LNG;
		require_once ROOT_PATH.'includes/classes/RichTextService.class.php';
		require_once ROOT_PATH.'includes/classes/PublicScreenshotService.class.php';

		$config = Config::get(Universe::getEmulated());

		$configBefore = array(
			'homepage_intro_html' => $config->homepage_intro_html,
			'public_rules_html' => $config->public_rules_html,
			'public_screens_json' => $config->public_screens_json,
			'secret_question_options' => $config->secret_question_options,
			'public_menu_register' => $config->public_menu_register,
			'public_menu_news' => $config->public_menu_news,
			'public_menu_rules' => $config->public_menu_rules,
			'public_menu_screens' => $config->public_menu_screens,
			'public_menu_banlist' => $config->public_menu_banlist,
			'public_menu_battlehall' => $config->public_menu_battlehall,
			'public_menu_disclamer' => $config->public_menu_disclamer,
			'discord_active' => $config->discord_active,
			'discord_url' => $config->discord_url,
			'seo_meta_title' => $config->seo_meta_title,
			'seo_meta_description' => $config->seo_meta_description,
			'seo_meta_keywords' => $config->seo_meta_keywords,
			'seo_og_image_url' => $config->seo_og_image_url,
		);

		$homepageIntroHtml = '';
		if (isset($_POST['homepage_intro_html'])) {
			$homepageIntroHtml = RichTextService::prepareForStorage((string) $_POST['homepage_intro_html']);
		}
		$publicRulesHtml = '';
		if (isset($_POST['public_rules_html'])) {
			$publicRulesHtml = RichTextService::prepareForStorage((string) $_POST['public_rules_html']);
		}
		$existingScreenshots = PublicScreenshotService::normalizeStoredList((string) $config->public_screens_json);
		$existingScreenshots = PublicScreenshotService::deleteSelected((array) HTTP::_GP('delete_public_screens', array()), $existingScreenshots);
		if (!empty($_FILES['public_screens_upload'])) {
			$existingScreenshots = PublicScreenshotService::uploadMany($_FILES['public_screens_upload'], $existingScreenshots);
		}

		$configAfter = array(
			'homepage_intro_html' => $homepageIntroHtml,
			'public_rules_html' => $publicRulesHtml,
			'public_screens_json' => PublicScreenshotService::encodeForConfig($existingScreenshots),
			'secret_question_options' => HTTP::_GP('secret_question_options', '', true),
			'public_menu_register' => (HTTP::_GP('public_menu_register', 'off') == 'on') ? 1 : 0,
			'public_menu_news' => (HTTP::_GP('public_menu_news', 'off') == 'on') ? 1 : 0,
			'public_menu_rules' => (HTTP::_GP('public_menu_rules', 'off') == 'on') ? 1 : 0,
			'public_menu_screens' => (HTTP::_GP('public_menu_screens', 'off') == 'on') ? 1 : 0,
			'public_menu_banlist' => (HTTP::_GP('public_menu_banlist', 'off') == 'on') ? 1 : 0,
			'public_menu_battlehall' => (HTTP::_GP('public_menu_battlehall', 'off') == 'on') ? 1 : 0,
			'public_menu_disclamer' => (HTTP::_GP('public_menu_disclamer', 'off') == 'on') ? 1 : 0,
			'discord_active' => (HTTP::_GP('discord_active', 'off') == 'on') ? 1 : 0,
			'discord_url' => HTTP::_GP('discord_url', '', true),
			'seo_meta_title' => HTTP::_GP('seo_meta_title', '', true),
			'seo_meta_description' => HTTP::_GP('seo_meta_description', '', true),
			'seo_meta_keywords' => HTTP::_GP('seo_meta_keywords', '', true),
			'seo_og_image_url' => HTTP::_GP('seo_og_image_url', '', true),
		);

		foreach ($configAfter as $key => $value) {
			$config->$key = $value;
		}

		$config->save();

		$LOG = new Log(3);
		$LOG->target = 0;
		$LOG->old = $configBefore;
		$LOG->new = $configAfter;
		$LOG->save();

		$this->printMessage($LNG['settings_successful'], array(
			array(
				'url' => 'admin.php?page=public&mode=show',
				'label' => $LNG['uvs_back'],
			),
		));
	}
}
