<?php

class BotTraitService
{
	public function ensureDefaults($botUserId, array $profile = array())
	{
		$row = Database::get()->selectSingle('SELECT bot_user_id FROM %%BOT_TRAITS%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));

		if (!empty($row)) {
			return;
		}

		$defaults = array(
			'aggressivite' => isset($profile['aggression']) ? (int) $profile['aggression'] : 35,
			'prudence' => 60,
			'ambition' => 55,
			'loyaute' => 70,
			'discipline' => 65,
			'sociabilite' => 40,
			'opportunisme' => 50,
			'expansion' => isset($profile['expansion_focus']) ? (int) $profile['expansion_focus'] : 40,
			'technologie' => 45,
			'economie' => isset($profile['economy_focus']) ? (int) $profile['economy_focus'] : 50,
			'defense' => 50,
			'espionnage' => 55,
			'tolerance_risque' => 45,
			'aptitude_commandement' => !empty($profile['is_commander_profile']) ? 80 : 45,
			'obeissance' => 65,
			'rancune' => 20,
			'stabilite_emotionnelle' => 60,
			'coordination' => 55,
			'intensite_offensive' => isset($profile['aggression']) ? (int) $profile['aggression'] : 35,
			'aptitude_communication' => 45,
			'gout_harcelement' => 30,
			'persistance_tactique' => 55,
		);

		if (!empty($profile['traits_json'])) {
			$decoded = json_decode($profile['traits_json'], true);
			if (is_array($decoded)) {
				$defaults = array_merge($defaults, $decoded);
			}
		}

		$params = array(':botUserId' => (int) $botUserId, ':updatedAt' => TIMESTAMP);
		$sqlParts = array('bot_user_id = :botUserId');
		foreach ($defaults as $column => $value) {
			$sqlParts[] = $column.' = :'.$column;
			$params[':'.$column] = max(0, min(100, (int) $value));
		}
		$sqlParts[] = 'updated_at = :updatedAt';

		Database::get()->insert('INSERT INTO %%BOT_TRAITS%% SET '.implode(', ', $sqlParts).';', $params);
	}

	public function load($botUserId)
	{
		return Database::get()->selectSingle('SELECT * FROM %%BOT_TRAITS%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));
	}
}
