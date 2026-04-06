<?php

class BrandingService
{
	const STORAGE_DIR = ROOT_PATH.'cache/branding/';
	const FILE_STEM = 'brand-logo';

	public static function ensureStorage()
	{
		if (!is_dir(self::STORAGE_DIR)) {
			mkdir(self::STORAGE_DIR, 0775, true);
		}
	}

	public static function getAllowedExtensions()
	{
		return array('svg', 'png', 'jpg', 'jpeg');
	}

	public static function getActiveLogoPath()
	{
		self::ensureStorage();

		foreach (self::getAllowedExtensions() as $extension) {
			$path = self::STORAGE_DIR.self::FILE_STEM.'.'.$extension;
			if (file_exists($path)) {
				return $path;
			}
		}

		return null;
	}

	public static function getActiveLogoUrl()
	{
		$path = self::getActiveLogoPath();
		if (empty($path)) {
			return false;
		}

		return 'cache/branding/'.basename($path).'?v='.filemtime($path);
	}

	public static function removeExistingLogo()
	{
		foreach (self::getAllowedExtensions() as $extension) {
			$path = self::STORAGE_DIR.self::FILE_STEM.'.'.$extension;
			if (file_exists($path)) {
				unlink($path);
			}
		}
	}

	public static function storeUploadedLogo(array $file)
	{
		self::ensureStorage();

		if (empty($file['tmp_name']) || (int) $file['error'] !== UPLOAD_ERR_OK) {
			throw new Exception('Le téléversement du logo a échoué.');
		}

		$extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
		if (!in_array($extension, self::getAllowedExtensions(), true)) {
			throw new Exception('Format de logo non pris en charge. Utilisez PNG, JPG ou SVG.');
		}

		self::removeExistingLogo();
		$destination = self::STORAGE_DIR.self::FILE_STEM.'.'.$extension;

		if (!move_uploaded_file($file['tmp_name'], $destination)) {
			throw new Exception('Impossible d’enregistrer le logo téléversé.');
		}

		chmod($destination, 0644);

		return $destination;
	}
}
