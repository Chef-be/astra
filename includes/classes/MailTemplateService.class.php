<?php

class MailTemplateService
{
	protected static $templates = array(
		'email_reg_done' => array(
			'label' => 'Bienvenue après inscription',
			'description' => 'Message envoyé après la création du compte.',
		),
		'email_vaild_reg' => array(
			'label' => 'Validation de compte',
			'description' => 'Message de validation d’adresse ou d’activation.',
		),
		'email_lost_password_validation' => array(
			'label' => 'Réinitialisation de mot de passe',
			'description' => 'Message contenant le lien de réinitialisation.',
		),
		'email_lost_password_changed' => array(
			'label' => 'Nouveau mot de passe',
			'description' => 'Message envoyé après génération du nouveau mot de passe.',
		),
		'email_inactive' => array(
			'label' => 'Relance d’inactivité',
			'description' => 'Message de relance envoyé aux comptes inactifs.',
		),
	);

	public static function getAvailableTemplates()
	{
		return self::$templates;
	}

	public static function isAllowedTemplate($templateName)
	{
		return isset(self::$templates[$templateName]);
	}

	public static function getTemplatePath($templateName, $language = 'fr')
	{
		if (!self::isAllowedTemplate($templateName)) {
			throw new Exception('Modèle de courriel inconnu.');
		}

		return ROOT_PATH.'language/'.$language.'/templates/'.$templateName.'.txt';
	}

	public static function getTemplateContent($templateName, $language = 'fr')
	{
		$path = self::getTemplatePath($templateName, $language);
		if (!file_exists($path)) {
			return '';
		}

		return file_get_contents($path);
	}

	public static function saveTemplateContent($templateName, $content, $language = 'fr')
	{
		$path = self::getTemplatePath($templateName, $language);
		if (file_put_contents($path, str_replace("\r\n", "\n", (string) $content)) === false) {
			throw new Exception('Impossible d’enregistrer le modèle de courriel.');
		}
	}

	public static function getPreview($templateName, $language = 'fr')
	{
		$content = self::getTemplateContent($templateName, $language);
		$placeholders = array(
			'{USERNAME}' => 'Commandant Astra',
			'{GAMENAME}' => Config::get()->game_name,
			'{PASSWORD}' => 'MotDePasseExemple42',
			'{VALIDURL}' => PROTOCOL.HTTP_HOST.HTTP_BASE.'index.php?page=vertify&mode=validate&token=demo',
			'{VERTIFYURL}' => PROTOCOL.HTTP_HOST.HTTP_BASE.'index.php?page=vertify&mode=validate&token=demo',
			'{HTTPPATH}' => PROTOCOL.HTTP_HOST.HTTP_BASE,
			'{GAMEMAIL}' => Config::get()->smtp_sendmail,
			'{LASTDATE}' => _date('d/m/Y H:i'),
		);

		return strtr($content, $placeholders);
	}
}
