<?php

class EditorMediaService
{
	const STORAGE_DIR = ROOT_PATH.'cache/editor-media/';
	const STORAGE_URL = 'cache/editor-media/';
	const MAX_FILE_SIZE = 8388608;

	public static function ensureStorage()
	{
		if (!is_dir(self::STORAGE_DIR) && !@mkdir(self::STORAGE_DIR, 0775, true) && !is_dir(self::STORAGE_DIR)) {
			throw new Exception('Impossible de créer le répertoire des médias de l’éditeur.');
		}
	}

	public static function getAllowedMimeMap()
	{
		return array(
			'image/png' => 'png',
			'image/jpeg' => 'jpg',
			'image/gif' => 'gif',
			'image/webp' => 'webp',
		);
	}

	public static function storeUploadedImage(array $file)
	{
		self::ensureStorage();

		if (empty($file['tmp_name']) || (int) $file['error'] !== UPLOAD_ERR_OK) {
			throw new Exception('Le téléversement de l’image a échoué.');
		}

		if (!is_uploaded_file($file['tmp_name'])) {
			throw new Exception('Le fichier téléversé est invalide.');
		}

		if (!empty($file['size']) && (int) $file['size'] > self::MAX_FILE_SIZE) {
			throw new Exception('L’image dépasse la taille maximale autorisée de 8 Mo.');
		}

		$finfo = new finfo(FILEINFO_MIME_TYPE);
		$mimeType = $finfo->file($file['tmp_name']);
		$allowedMimeMap = self::getAllowedMimeMap();

		if (!isset($allowedMimeMap[$mimeType])) {
			throw new Exception('Format d’image non pris en charge. Utilisez PNG, JPG, GIF ou WEBP.');
		}

		if (@getimagesize($file['tmp_name']) === false) {
			throw new Exception('Le fichier envoyé n’est pas une image valide.');
		}

		$fileName = 'editor-'.date('Ymd-His').'-'.bin2hex(random_bytes(6)).'.'.$allowedMimeMap[$mimeType];
		$destination = self::STORAGE_DIR.$fileName;

		if (!move_uploaded_file($file['tmp_name'], $destination)) {
			throw new Exception('Impossible d’enregistrer l’image téléversée.');
		}

		@chmod($destination, 0644);

		return self::STORAGE_URL.$fileName.'?v='.filemtime($destination);
	}
}
