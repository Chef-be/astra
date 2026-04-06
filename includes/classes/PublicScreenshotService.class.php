<?php

class PublicScreenshotService
{
	const STORAGE_DIR = ROOT_PATH.'styles/resource/images/public/screens/';
	const STORAGE_URL = 'styles/resource/images/public/screens/';
	const MAX_FILE_SIZE = 10485760;

	public static function ensureStorage()
	{
		if (!is_dir(self::STORAGE_DIR) && !@mkdir(self::STORAGE_DIR, 0775, true) && !is_dir(self::STORAGE_DIR)) {
			throw new Exception('Impossible de créer le répertoire des captures publiques.');
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

	public static function normalizeStoredList($jsonValue)
	{
		$items = array();
		if (!empty($jsonValue)) {
			$decoded = json_decode($jsonValue, true);
			if (is_array($decoded)) {
				foreach ($decoded as $row) {
					if (empty($row['path'])) {
						continue;
					}
					$items[] = array(
						'path' => (string) $row['path'],
						'label' => !empty($row['label']) ? (string) $row['label'] : self::buildDefaultLabel($row['path']),
					);
				}
			}
		}

		return array_values($items);
	}

	public static function getScreenshotsFromConfig($jsonValue)
	{
		$items = self::normalizeStoredList($jsonValue);
		if (!empty($items)) {
			return $items;
		}

		return self::getLegacyScreenshots();
	}

	public static function uploadMany(array $files, array $existingItems = array())
	{
		self::ensureStorage();
		$items = $existingItems;

		if (empty($files['tmp_name']) || !is_array($files['tmp_name'])) {
			return $items;
		}

		$finfo = new finfo(FILEINFO_MIME_TYPE);
		$allowed = self::getAllowedMimeMap();

		foreach ($files['tmp_name'] as $index => $tmpName) {
			if (empty($tmpName)) {
				continue;
			}

			$error = isset($files['error'][$index]) ? (int) $files['error'][$index] : UPLOAD_ERR_NO_FILE;
			if ($error === UPLOAD_ERR_NO_FILE) {
				continue;
			}
			if ($error !== UPLOAD_ERR_OK) {
				throw new Exception('Le téléversement d’une capture a échoué.');
			}
			if (!is_uploaded_file($tmpName)) {
				throw new Exception('Une capture téléversée est invalide.');
			}

			$size = isset($files['size'][$index]) ? (int) $files['size'][$index] : 0;
			if ($size > self::MAX_FILE_SIZE) {
				throw new Exception('Une capture dépasse la taille maximale autorisée de 10 Mo.');
			}

			$mimeType = $finfo->file($tmpName);
			if (!isset($allowed[$mimeType])) {
				throw new Exception('Format non pris en charge pour les captures. Utilisez PNG, JPG, GIF ou WEBP.');
			}

			if (@getimagesize($tmpName) === false) {
				throw new Exception('Une capture téléversée n’est pas une image valide.');
			}

			$targetName = 'screen-'.date('Ymd-His').'-'.bin2hex(random_bytes(5)).'.'.$allowed[$mimeType];
			$destination = self::STORAGE_DIR.$targetName;
			if (!move_uploaded_file($tmpName, $destination)) {
				throw new Exception('Impossible d’enregistrer une capture téléversée.');
			}

			@chmod($destination, 0644);
			$items[] = array(
				'path' => self::STORAGE_URL.$targetName,
				'label' => self::buildDefaultLabel($targetName),
			);
		}

		return array_values($items);
	}

	public static function deleteSelected(array $selectedPaths, array $existingItems)
	{
		if (empty($selectedPaths)) {
			return $existingItems;
		}

		$selectedPaths = array_map('strval', $selectedPaths);
		$selectedMap = array_fill_keys($selectedPaths, true);
		$remaining = array();

		foreach ($existingItems as $item) {
			if (empty($item['path']) || empty($selectedMap[$item['path']])) {
				$remaining[] = $item;
				continue;
			}

			$localPath = ROOT_PATH.$item['path'];
			if (strpos($localPath, self::STORAGE_DIR) === 0 && file_exists($localPath)) {
				@unlink($localPath);
			}
		}

		return array_values($remaining);
	}

	public static function encodeForConfig(array $items)
	{
		return json_encode(array_values($items), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
	}

	protected static function getLegacyScreenshots()
	{
		$items = array();
		$preferredFiles = array(
			'screenshots/screenshot-nextgen-ui-dashboard-mars.png',
			'screenshots/screenshot-nextgen-ui-login.png',
			'screenshots/screenshot-gow.png',
			'screenshots/office-v1.png',
			'screenshots/screenshot-nextgen-ui-dashboard.png',
			'screenshots/screenshot-login.png',
		);

		foreach ($preferredFiles as $path) {
			if (!file_exists(ROOT_PATH.$path)) {
				continue;
			}
			$items[] = array(
				'path' => $path,
				'label' => self::buildDefaultLabel($path),
			);
		}

		if (!empty($items)) {
			return $items;
		}

		$directory = ROOT_PATH.'styles/resource/images/login/screens/';
		if (!is_dir($directory)) {
			return $items;
		}

		foreach (new DirectoryIterator($directory) as $fileInfo) {
			if (!$fileInfo->isFile()) {
				continue;
			}

			$path = 'styles/resource/images/login/screens/'.$fileInfo->getFilename();
			$items[] = array(
				'path' => $path,
				'label' => self::buildDefaultLabel($fileInfo->getFilename()),
			);
		}

		return $items;
	}

	protected static function buildDefaultLabel($path)
	{
		$name = pathinfo((string) $path, PATHINFO_FILENAME);
		$name = str_replace(array('-', '_'), ' ', $name);
		return ucfirst(trim($name));
	}
}
