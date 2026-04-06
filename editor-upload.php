<?php

define('MODE', 'INGAME');
define('ROOT_PATH', str_replace('\\', '/', __DIR__).'/');
set_include_path(ROOT_PATH);
chdir(ROOT_PATH);

require ROOT_PATH.'includes/common.php';
require_once ROOT_PATH.'includes/classes/EditorMediaService.class.php';

header('Content-Type: application/json; charset=UTF-8');

try {
	if (empty($USER['id'])) {
		throw new Exception('Authentification requise.');
	}

	if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
		throw new Exception('Méthode non autorisée.');
	}

	if (empty($_FILES['file'])) {
		throw new Exception('Aucun fichier image reçu.');
	}

	echo json_encode(array(
		'location' => EditorMediaService::storeUploadedImage($_FILES['file']),
	));
} catch (Exception $exception) {
	http_response_code(400);
	echo json_encode(array(
		'message' => $exception->getMessage(),
	));
}
