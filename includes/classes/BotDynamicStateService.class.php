<?php

class BotDynamicStateService
{
	public function ensureDefaults($botUserId)
	{
		$row = Database::get()->selectSingle('SELECT bot_user_id FROM %%BOT_DYNAMIC_STATE%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));

		if (!empty($row)) {
			return;
		}

		Database::get()->insert('INSERT INTO %%BOT_DYNAMIC_STATE%% SET
			bot_user_id = :botUserId,
			stress = 20,
			confiance = 55,
			moral = 55,
			fatigue = 15,
			peur = 10,
			pression_ennemie = 0,
			appetit_raid = 45,
			vigilance = 50,
			satisfaction_economique = 45,
			saturation_logistique = 0,
			tension_diplomatique = 0,
			superiorite_locale = 50,
			intensite_campagne = 0,
			envie_vengeance = 0,
			disponibilite_sociale = 40,
			excitation_offensive = 25,
			niveau_frustration = 15,
			pression_performance = 20,
			desir_revanche = 10,
			confiance_chef = 55,
			saturation_tactique = 0,
			disponibilite_mentale = 60,
			stabilite_operationnelle = 55,
			intensite_engagement = 25,
			updated_at = :updatedAt;', array(
				':botUserId' => (int) $botUserId,
				':updatedAt' => TIMESTAMP,
			));
	}

	public function load($botUserId)
	{
		return Database::get()->selectSingle('SELECT * FROM %%BOT_DYNAMIC_STATE%% WHERE bot_user_id = :botUserId LIMIT 1;', array(
			':botUserId' => (int) $botUserId,
		));
	}

	public function applyDelta($botUserId, array $delta)
	{
		$current = $this->load($botUserId);
		if (empty($current)) {
			$this->ensureDefaults($botUserId);
			$current = $this->load($botUserId);
		}

		$params = array(':botUserId' => (int) $botUserId, ':updatedAt' => TIMESTAMP);
		$set = array('updated_at = :updatedAt');
		foreach ($delta as $column => $value) {
			if (!array_key_exists($column, $current)) {
				continue;
			}

			$newValue = max(0, min(100, (int) $current[$column] + (int) $value));
			$set[] = $column.' = :'.$column;
			$params[':'.$column] = $newValue;
		}

		if (count($set) === 1) {
			return;
		}

		Database::get()->update('UPDATE %%BOT_DYNAMIC_STATE%% SET '.implode(', ', $set).' WHERE bot_user_id = :botUserId;', $params);
	}
}
