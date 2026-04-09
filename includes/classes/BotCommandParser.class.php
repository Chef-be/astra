<?php

class BotCommandParser
{
	public function parse($rawCommand)
	{
		$command = trim((string) $rawCommand);
		if ($command === '' || $command[0] !== '/') {
			return array(
				'is_valid' => false,
				'error' => 'Commande vide ou invalide.',
			);
		}

		$tokens = $this->tokenize(substr($command, 1));
		if (empty($tokens)) {
			return array(
				'is_valid' => false,
				'error' => 'Commande incomplète.',
			);
		}

		$family = $this->normalizeToken(array_shift($tokens));
		switch ($family) {
			case 'bots':
			case 'bot':
			case 'chef':
			case 'alliance-bots':
			case 'escouade':
			case 'system-bots':
			case 'galaxy-bots':
			case 'profil-bots':
				return $this->parseOperationalCommand($family, $command, $tokens);
			case 'message-prive':
				return $this->parsePrivateMessage($command, $tokens);
			case 'message-chat':
				return $this->parseSocialMessage($command, $tokens);
			case 'campagne':
			case 'harcelement':
			case 'rotation-attaque':
			case 'vague':
			case 'siege':
				return $this->parseCampaignCommand($family, $command, $tokens);
			case 'presence':
			case 'strategie':
			case 'bonus':
			case 'journal':
			case 'pause':
			case 'reprendre':
				return $this->parseOperationalCommand($family, $command, $tokens);
			default:
				return array(
					'is_valid' => false,
					'error' => 'Famille de commande inconnue : '.$family,
				);
		}
	}

	public function tokenize($input)
	{
		$input = str_replace(
			array('“', '”', '„', '«', '»', '’', '‘', '‛'),
			array('"', '"', '"', '"', '"', "'", "'", "'"),
			(string) $input
		);
		preg_match_all('/"([^"]+)"|\'([^\']+)\'|(\S+)/u', (string) $input, $matches);
		$tokens = array();
		foreach ($matches[0] as $index => $full) {
			if ($matches[1][$index] !== '') {
				$tokens[] = $matches[1][$index];
			} elseif ($matches[2][$index] !== '') {
				$tokens[] = $matches[2][$index];
			} else {
				$tokens[] = $matches[3][$index];
			}
		}

		return $tokens;
	}

	public function getCatalog()
	{
		$rows = Database::get()->select('SELECT *
			FROM %%BOT_COMMAND_CATALOG%%
			WHERE is_active = 1
			ORDER BY sort_order ASC, family_key ASC, command_key ASC;');

		foreach ($rows as &$row) {
			$row['target_types'] = !empty($row['target_types_json']) ? json_decode($row['target_types_json'], true) : array();
			$row['payload_schema'] = !empty($row['payload_schema_json']) ? json_decode($row['payload_schema_json'], true) : array();
		}
		unset($row);

		return $rows;
	}

	protected function parseOperationalCommand($family, $command, array $tokens)
	{
		$parsed = array(
			'is_valid' => true,
			'raw_command' => $command,
			'command_family' => 'bots',
			'command_name' => 'statut',
			'target_type' => 'all',
			'target_reference' => 'all',
			'payload' => array(),
		);

		if ($family === 'bots') {
			$parsed['target_type'] = 'all';
			$parsed['target_reference'] = 'all';
			$parsed['command_name'] = !empty($tokens[0]) ? $this->normalizeToken($tokens[0]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 1));
			return $parsed;
		}

		if (in_array($family, array('bot', 'chef'), true)) {
			$parsed['target_type'] = $family === 'chef' ? 'chef' : 'bot';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		if ($family === 'alliance-bots') {
			$parsed['target_type'] = 'alliance';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		if ($family === 'escouade') {
			$parsed['target_type'] = 'escouade';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		if ($family === 'system-bots') {
			$parsed['target_type'] = 'systeme';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		if ($family === 'galaxy-bots') {
			$parsed['target_type'] = 'galaxie';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		if ($family === 'profil-bots') {
			$parsed['target_type'] = 'profil';
			$parsed['target_reference'] = !empty($tokens[0]) ? $tokens[0] : '';
			$parsed['command_name'] = !empty($tokens[1]) ? $this->normalizeToken($tokens[1]) : 'statut';
			$parsed['payload'] = $this->extractPayload(array_slice($tokens, 2));
			return $parsed;
		}

		$parsed['command_name'] = $family;
		$parsed['payload'] = $this->extractPayload($tokens);
		return $parsed;
	}

	protected function parsePrivateMessage($command, array $tokens)
	{
		$payload = $this->extractPayload(array_slice($tokens, 2));
		return array(
			'is_valid' => true,
			'raw_command' => $command,
			'command_family' => 'communication',
			'command_name' => 'message-prive',
			'target_type' => !empty($tokens[0]) ? $this->normalizeTargetType($tokens[0]) : 'bot',
			'target_reference' => !empty($tokens[1]) ? $tokens[1] : '',
			'payload' => $payload,
		);
	}

	protected function parseSocialMessage($command, array $tokens)
	{
		$payload = $this->extractPayload(array_slice($tokens, 2));
		if (empty($payload['channel_key'])) {
			$payload['channel_key'] = 'bots';
		}
		return array(
			'is_valid' => true,
			'raw_command' => $command,
			'command_family' => 'communication',
			'command_name' => 'message-chat',
			'target_type' => !empty($tokens[0]) ? $this->normalizeTargetType($tokens[0]) : 'bot',
			'target_reference' => !empty($tokens[1]) ? $tokens[1] : '',
			'payload' => $payload,
		);
	}

	protected function parseCampaignCommand($family, $command, array $tokens)
	{
		$targetType = !empty($tokens[0]) ? $this->normalizeTargetType($tokens[0]) : 'alliance';
		$targetReference = !empty($tokens[1]) ? $tokens[1] : '';
		return array(
			'is_valid' => true,
			'raw_command' => $command,
			'command_family' => 'campagnes',
			'command_name' => $family,
			'target_type' => $targetType,
			'target_reference' => $targetReference,
			'payload' => $this->extractPayload(array_slice($tokens, 2)),
		);
	}

	protected function extractPayload(array $tokens)
	{
		$payload = array(
			'arguments' => $tokens,
		);

		foreach ($tokens as $index => $token) {
			$normalized = $this->normalizeToken($token);
			if (preg_match('/^\d+:\d+(?::\d+)?$/', $token)) {
				$payload['coordinates'] = $token;
				$payload['target_coordinates'] = $token;
				if (substr_count($token, ':') === 1) {
					$payload['zone_reference'] = $token;
				}
			}
			if (preg_match('/^\d+[mh]$/', $token)) {
				$payload['duration'] = $token;
			}
			if ($normalized === 'doctrine' && isset($tokens[$index + 1])) {
				$payload['doctrine'] = $tokens[$index + 1];
			}
			if ($normalized === 'mode' && isset($tokens[$index + 1])) {
				$payload['mode'] = $tokens[$index + 1];
			}
			if ($normalized === 'message' && isset($tokens[$index + 1])) {
				$payload['message'] = implode(' ', array_slice($tokens, $index + 1));
				break;
			}
			if (($normalized === 'vers' || $normalized === 'cible') && isset($tokens[$index + 1])) {
				$payload['target_player'] = $tokens[$index + 1];
				$payload['target_username'] = ltrim($tokens[$index + 1], '@');
			}
			if ($normalized === 'mention' && isset($tokens[$index + 1])) {
				$payload['target_username'] = ltrim($tokens[$index + 1], '@');
			}
			if ($normalized === 'intervalle' && isset($tokens[$index + 1])) {
				$payload['interval'] = $tokens[$index + 1];
			}
			if (($normalized === 'canal' || $normalized === 'channel') && isset($tokens[$index + 1])) {
				$payload['channel_key'] = $this->normalizeToken($tokens[$index + 1]);
			}
			if ($normalized === 'duree' && isset($tokens[$index + 1])) {
				$payload['duration'] = $tokens[$index + 1];
			}
			if ($normalized === 'systeme' && isset($tokens[$index + 1])) {
				$payload['system_reference'] = $tokens[$index + 1];
				$payload['zone_reference'] = $tokens[$index + 1];
			}
			if ($normalized === 'galaxie' && isset($tokens[$index + 1])) {
				$payload['galaxy_reference'] = $tokens[$index + 1];
			}
			if ($normalized === 'zone' && isset($tokens[$index + 1])) {
				$payload['zone_reference'] = $tokens[$index + 1];
			}
			if ($normalized === 'priorite' && isset($tokens[$index + 1])) {
				$payload['priority_value'] = $tokens[$index + 1];
			}
			if ($normalized === 'doctrine' && isset($tokens[$index + 1])) {
				$payload['doctrine'] = $tokens[$index + 1];
			}
		}

		if (!isset($payload['verb']) && !empty($tokens[0])) {
			$payload['verb'] = $this->normalizeToken($tokens[0]);
		}

		return $payload;
	}

	protected function normalizeToken($value)
	{
		$value = mb_strtolower(trim((string) $value), 'UTF-8');
		$value = strtr($value, array(
			'à' => 'a',
			'â' => 'a',
			'ä' => 'a',
			'á' => 'a',
			'è' => 'e',
			'é' => 'e',
			'ê' => 'e',
			'ë' => 'e',
			'ì' => 'i',
			'î' => 'i',
			'ï' => 'i',
			'í' => 'i',
			'ò' => 'o',
			'ô' => 'o',
			'ö' => 'o',
			'ó' => 'o',
			'ù' => 'u',
			'û' => 'u',
			'ü' => 'u',
			'ú' => 'u',
			'ÿ' => 'y',
			'ç' => 'c',
			'œ' => 'oe',
			'æ' => 'ae',
			'–' => '-',
			'—' => '-',
		));

		return $value;
	}

	protected function normalizeTargetType($value)
	{
		$normalized = $this->normalizeToken($value);
		$map = array(
			'bots' => 'all',
			'bot' => 'bot',
			'chef' => 'chef',
			'alliance-bots' => 'alliance',
			'alliance' => 'alliance',
			'escouade' => 'escouade',
			'system-bots' => 'systeme',
			'systeme' => 'systeme',
			'galaxy-bots' => 'galaxie',
			'galaxie' => 'galaxie',
			'profil-bots' => 'profil',
			'profil' => 'profil',
			'campagne' => 'campagne',
		);

		return isset($map[$normalized]) ? $map[$normalized] : $normalized;
	}
}
