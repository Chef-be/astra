<?php

class CacheAdminService
{
	public function getSnapshot()
	{
		require_once ROOT_PATH.'includes/classes/RedisAdminService.class.php';

		$filesystem = $this->getFilesystemSnapshot();
		$redisService = new RedisAdminService();

		return array(
			'filesystem' => $filesystem,
			'redis' => $redisService->getSnapshot(),
		);
	}

	public function purge($scope)
	{
		require_once ROOT_PATH.'includes/classes/RedisAdminService.class.php';

		$scope = (string) $scope;
		$result = array(
			'scope' => $scope,
			'filesystemPurged' => false,
			'redisPurged' => false,
		);

		if (in_array($scope, array('filesystem', 'all'), true)) {
			ClearCache();
			$result['filesystemPurged'] = true;
		}

		if (in_array($scope, array('redis', 'all'), true)) {
			$redisService = new RedisAdminService();
			$result['redisPurged'] = $redisService->flushAll();
		}

		return $result;
	}

	private function getFilesystemSnapshot()
	{
		$paths = array(
			ROOT_PATH.'cache',
			ROOT_PATH.'cache/templates',
		);

		$files = 0;
		$bytes = 0;

		foreach ($paths as $path) {
			if (!is_dir($path)) {
				continue;
			}

			$iterator = new RecursiveIteratorIterator(
				new RecursiveDirectoryIterator($path, FilesystemIterator::SKIP_DOTS)
			);

			foreach ($iterator as $item) {
				if (!$item->isFile()) {
					continue;
				}

				$files++;
				$bytes += $item->getSize();
			}
		}

		return array(
			'files' => $files,
			'bytes' => $bytes,
			'sizeHuman' => $this->formatBytes($bytes),
			'cacheWritable' => is_writable(ROOT_PATH.'cache'),
		);
	}

	private function formatBytes($bytes)
	{
		$bytes = (float) $bytes;
		$units = array('B', 'KB', 'MB', 'GB', 'TB');
		$power = 0;

		while ($bytes >= 1024 && $power < count($units) - 1) {
			$bytes /= 1024;
			$power++;
		}

		return number_format($bytes, $power === 0 ? 0 : 2, '.', ' ').' '.$units[$power];
	}
}
