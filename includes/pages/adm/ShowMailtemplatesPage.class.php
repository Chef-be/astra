<?php

class ShowMailtemplatesPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/MailTemplateService.class.php';
	}

	public function show()
	{
		$templateName = HTTP::_GP('template', 'email_reg_done', true);
		if (!MailTemplateService::isAllowedTemplate($templateName)) {
			$templateName = 'email_reg_done';
		}

		$templates = MailTemplateService::getAvailableTemplates();
		$currentMeta = $templates[$templateName];

		$this->assign(array(
			'mailTemplateName' => $templateName,
			'mailTemplateMeta' => $currentMeta,
			'mailTemplateContent' => MailTemplateService::getTemplateContent($templateName),
			'mailTemplatePreview' => MailTemplateService::getPreview($templateName),
			'mailTemplates' => $templates,
			'mailTemplateVariables' => array(
				'{USERNAME}',
				'{GAMENAME}',
				'{PASSWORD}',
				'{VALIDURL}',
				'{VERTIFYURL}',
				'{HTTPPATH}',
				'{GAMEMAIL}',
				'{LASTDATE}',
			),
		));

		$this->display('page.mailtemplates.default.tpl');
	}

	public function save()
	{
		$templateName = HTTP::_GP('template', 'email_reg_done', true);
		$content = HTTP::_GP('content', '', true);

		if (!MailTemplateService::isAllowedTemplate($templateName)) {
			$this->printMessage('Le modèle demandé est invalide.', array(array(
				'url' => 'admin.php?page=mailtemplates',
				'label' => 'Retour aux modèles',
			)));
		}

		try {
			MailTemplateService::saveTemplateContent($templateName, $content);
		} catch (Exception $exception) {
			$this->printMessage($exception->getMessage(), array(array(
				'url' => 'admin.php?page=mailtemplates&template='.$templateName,
				'label' => 'Retour au modèle',
			)));
		}

		$this->redirectTo('admin.php?page=mailtemplates&template='.$templateName);
	}
}
