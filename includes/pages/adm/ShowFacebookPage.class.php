<?php

class ShowFacebookPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
	}

	public function show()
	{
		$this->printMessage('Le module Facebook a été retiré de la plateforme.', array(
			array(
				'url' => 'admin.php?page=public',
				'label' => 'Retour au site public',
			),
		));
	}

	public function saveSettings()
	{
		$this->show();
	}
}
