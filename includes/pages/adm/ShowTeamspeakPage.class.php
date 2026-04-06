<?php

class ShowTeamspeakPage extends AbstractAdminPage
{
	public function __construct()
	{
		parent::__construct();
	}

	public function show()
	{
		$this->printMessage('Le module TeamSpeak a été retiré de la plateforme.', array(
			array(
				'url' => 'admin.php?page=server',
				'label' => 'Retour à la configuration',
			),
		));
	}

	public function saveSettings()
	{
		$this->show();
	}
}
