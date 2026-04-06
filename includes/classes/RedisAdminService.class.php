<?php

class RedisAdminService
{
	private $host;
	private $port;
	private $timeout;
	private $socket;

	public function __construct($host = 'astra-cache', $port = 6379, $timeout = 2.0)
	{
		$this->host = $host;
		$this->port = (int) $port;
		$this->timeout = (float) $timeout;
	}

	public function getSnapshot()
	{
		try {
			$this->connect();
			$info = $this->command('INFO');
			$dbSize = (int) $this->command('DBSIZE');
			$this->disconnect();

			$parsed = $this->parseInfo($info);
			$usedMemory = isset($parsed['used_memory']) ? (int) $parsed['used_memory'] : 0;
			$maxMemory = isset($parsed['maxmemory']) ? (int) $parsed['maxmemory'] : 0;
			$uptime = isset($parsed['uptime_in_seconds']) ? (int) $parsed['uptime_in_seconds'] : 0;
			$clients = isset($parsed['connected_clients']) ? (int) $parsed['connected_clients'] : 0;

			return array(
				'available' => true,
				'host' => $this->host,
				'port' => $this->port,
				'dbSize' => $dbSize,
				'version' => isset($parsed['redis_version']) ? $parsed['redis_version'] : 'inconnue',
				'usedMemory' => $usedMemory,
				'usedMemoryHuman' => $this->formatBytes($usedMemory),
				'maxMemory' => $maxMemory,
				'maxMemoryHuman' => $maxMemory > 0 ? $this->formatBytes($maxMemory) : 'non limité',
				'memoryPercent' => $maxMemory > 0 ? min(100, round(($usedMemory / $maxMemory) * 100)) : 0,
				'clients' => $clients,
				'uptime' => $uptime,
				'uptimeHuman' => $this->formatDuration($uptime),
				'evictedKeys' => isset($parsed['evicted_keys']) ? (int) $parsed['evicted_keys'] : 0,
				'hits' => isset($parsed['keyspace_hits']) ? (int) $parsed['keyspace_hits'] : 0,
				'misses' => isset($parsed['keyspace_misses']) ? (int) $parsed['keyspace_misses'] : 0,
			);
		} catch (Exception $exception) {
			$this->disconnect();

			return array(
				'available' => false,
				'host' => $this->host,
				'port' => $this->port,
				'error' => $exception->getMessage(),
				'dbSize' => 0,
				'usedMemory' => 0,
				'usedMemoryHuman' => '0 B',
				'maxMemory' => 0,
				'maxMemoryHuman' => 'non disponible',
				'memoryPercent' => 0,
				'clients' => 0,
				'uptime' => 0,
				'uptimeHuman' => '0 s',
				'evictedKeys' => 0,
				'hits' => 0,
				'misses' => 0,
				'version' => 'indisponible',
			);
		}
	}

	public function flushAll()
	{
		$this->connect();
		$result = $this->command('FLUSHALL');
		$this->disconnect();

		return $result === 'OK';
	}

	private function connect()
	{
		if (is_resource($this->socket)) {
			return;
		}

		$this->socket = @fsockopen($this->host, $this->port, $errorNumber, $errorMessage, $this->timeout);
		if (!is_resource($this->socket)) {
			throw new Exception('Redis indisponible : '.$errorMessage.' ('.$errorNumber.').');
		}

		stream_set_timeout($this->socket, (int) $this->timeout);
	}

	private function disconnect()
	{
		if (is_resource($this->socket)) {
			fclose($this->socket);
		}

		$this->socket = null;
	}

	private function command($command)
	{
		$parts = explode(' ', $command);
		$payload = '*'.count($parts)."\r\n";
		foreach ($parts as $part) {
			$payload .= '$'.strlen($part)."\r\n".$part."\r\n";
		}

		fwrite($this->socket, $payload);

		return $this->readResponse();
	}

	private function readResponse()
	{
		$line = fgets($this->socket);
		if ($line === false) {
			throw new Exception('Aucune réponse reçue depuis Redis.');
		}

		$type = substr($line, 0, 1);
		$data = substr($line, 1, -2);

		switch ($type) {
			case '+':
				return $data;
			case '-':
				throw new Exception('Erreur Redis : '.$data);
			case ':':
				return (int) $data;
			case '$':
				$length = (int) $data;
				if ($length < 0) {
					return null;
				}

				$buffer = '';
				while (strlen($buffer) < $length) {
					$chunk = fread($this->socket, $length - strlen($buffer));
					if ($chunk === false || $chunk === '') {
						break;
					}
					$buffer .= $chunk;
				}
				fread($this->socket, 2);
				return $buffer;
			case '*':
				$count = (int) $data;
				$result = array();
				for ($index = 0; $index < $count; $index++) {
					$result[] = $this->readResponse();
				}
				return $result;
		}

		throw new Exception('Type de réponse Redis inconnu.');
	}

	private function parseInfo($payload)
	{
		$data = array();
		foreach (preg_split('/\r\n|\n|\r/', (string) $payload) as $line) {
			if ($line === '' || $line[0] === '#') {
				continue;
			}

			$parts = explode(':', $line, 2);
			if (count($parts) !== 2) {
				continue;
			}

			$data[$parts[0]] = $parts[1];
		}

		return $data;
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

	private function formatDuration($seconds)
	{
		$seconds = max(0, (int) $seconds);
		$days = floor($seconds / 86400);
		$hours = floor(($seconds % 86400) / 3600);
		$minutes = floor(($seconds % 3600) / 60);

		if ($days > 0) {
			return $days.' j '.$hours.' h';
		}

		if ($hours > 0) {
			return $hours.' h '.$minutes.' min';
		}

		if ($minutes > 0) {
			return $minutes.' min';
		}

		return $seconds.' s';
	}
}
