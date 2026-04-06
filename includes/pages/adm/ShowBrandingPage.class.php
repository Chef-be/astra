<?php

class ShowBrandingPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/BrandingService.class.php';
	}

	public function show()
	{
		$this->assign(array(
			'brandLogoUrl' => BrandingService::getActiveLogoUrl(),
			'allowedExtensions' => strtoupper(implode(', ', BrandingService::getAllowedExtensions())),
		));

		$this->display('page.branding.default.tpl');
	}

	public function save()
	{
		if (!empty($_FILES['brand_logo']['name'])) {
			try {
				BrandingService::storeUploadedLogo($_FILES['brand_logo']);
			} catch (Exception $exception) {
				$this->printMessage($exception->getMessage(), array(array(
					'url' => 'admin.php?page=branding',
					'label' => 'Retour à l’identité visuelle',
				)));
			}
		}

		if (HTTP::_GP('delete_logo', 'off') === 'on') {
			BrandingService::removeExistingLogo();
		}

		$this->redirectTo('admin.php?page=branding');
	}
}
