<?php

class BotMultiAccountService
{
	public function validateBot($botUserId, $reason = 'validation_moteur', $validatedByUserId = null)
	{
		$db = Database::get();
		$user = $db->selectSingle('SELECT id, universe FROM %%USERS%% WHERE id = :userId AND is_bot = 1 LIMIT 1;', array(
			':userId' => (int) $botUserId,
		));

		if (empty($user)) {
			return false;
		}

		$known = $db->selectSingle('SELECT multiID FROM %%MULTI%% WHERE userID = :userId LIMIT 1;', array(
			':userId' => (int) $botUserId,
		));

		if (empty($known)) {
			$db->insert('INSERT INTO %%MULTI%% SET userID = :userId;', array(
				':userId' => (int) $botUserId,
			));
		}

		$current = $db->selectSingle('SELECT id FROM %%BOT_MULTIACCOUNT_VALIDATION%% WHERE bot_user_id = :userId LIMIT 1;', array(
			':userId' => (int) $botUserId,
		));

		if (empty($current)) {
			$db->insert('INSERT INTO %%BOT_MULTIACCOUNT_VALIDATION%% SET
				universe = :universe,
				bot_user_id = :botUserId,
				validation_status = :status,
				validation_reason = :reason,
				validated_by_user_id = :validatedBy,
				validated_at = :validatedAt,
				notes_json = :notesJson;', array(
					':universe' => (int) $user['universe'],
					':botUserId' => (int) $botUserId,
					':status' => 'validated_bot',
					':reason' => (string) $reason,
					':validatedBy' => empty($validatedByUserId) ? null : (int) $validatedByUserId,
					':validatedAt' => TIMESTAMP,
					':notesJson' => json_encode(array('source' => 'BotMultiAccountService')),
				));
			return true;
		}

		$db->update('UPDATE %%BOT_MULTIACCOUNT_VALIDATION%% SET
			validation_status = :status,
			validation_reason = :reason,
			validated_by_user_id = :validatedBy,
			validated_at = :validatedAt
			WHERE id = :id;', array(
				':status' => 'validated_bot',
				':reason' => (string) $reason,
				':validatedBy' => empty($validatedByUserId) ? null : (int) $validatedByUserId,
				':validatedAt' => TIMESTAMP,
				':id' => (int) $current['id'],
			));

		return true;
	}

	public function syncAllBots()
	{
		$bots = Database::get()->select('SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 ORDER BY id ASC;', array(
			':universe' => Universe::getEmulated(),
		));

		foreach ($bots as $bot) {
			$this->validateBot($bot['id'], 'synchronisation_bots');
		}

		return count($bots);
	}
}
