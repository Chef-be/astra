<?php

class BotRelationshipService
{
	public function upsert($botUserId, $targetType, $targetReference, array $data)
	{
		$db = Database::get();
		$row = $db->selectSingle('SELECT id
			FROM %%BOT_RELATIONSHIPS%%
			WHERE bot_user_id = :botUserId AND target_type = :targetType AND target_reference = :targetReference
			LIMIT 1;', array(
				':botUserId' => (int) $botUserId,
				':targetType' => (string) $targetType,
				':targetReference' => (string) $targetReference,
			));

		$payload = array(
			':stance' => isset($data['stance']) ? (string) $data['stance'] : 'neutre',
			':affinity' => isset($data['affinity']) ? max(0, min(100, (int) $data['affinity'])) : 50,
			':fear' => isset($data['fear']) ? max(0, min(100, (int) $data['fear'])) : 0,
			':resentment' => isset($data['resentment']) ? max(0, min(100, (int) $data['resentment'])) : 0,
			':trust' => isset($data['trust']) ? max(0, min(100, (int) $data['trust'])) : 50,
			':notesJson' => json_encode(isset($data['notes']) && is_array($data['notes']) ? $data['notes'] : array()),
			':updatedAt' => TIMESTAMP,
		);

		if (empty($row)) {
			$db->insert('INSERT INTO %%BOT_RELATIONSHIPS%% SET
				bot_user_id = :botUserId,
				target_type = :targetType,
				target_reference = :targetReference,
				stance = :stance,
				affinity = :affinity,
				fear = :fear,
				resentment = :resentment,
				trust = :trust,
				notes_json = :notesJson,
				updated_at = :updatedAt;', array_merge($payload, array(
					':botUserId' => (int) $botUserId,
					':targetType' => (string) $targetType,
					':targetReference' => (string) $targetReference,
				)));
			return;
		}

		$db->update('UPDATE %%BOT_RELATIONSHIPS%% SET
			stance = :stance,
			affinity = :affinity,
			fear = :fear,
			resentment = :resentment,
			trust = :trust,
			notes_json = :notesJson,
			updated_at = :updatedAt
			WHERE id = :id;', array_merge($payload, array(
				':id' => (int) $row['id'],
			)));
	}

	public function getForBot($botUserId)
	{
		return Database::get()->select('SELECT *
			FROM %%BOT_RELATIONSHIPS%%
			WHERE bot_user_id = :botUserId
			ORDER BY updated_at DESC
			LIMIT 50;', array(
				':botUserId' => (int) $botUserId,
			));
	}
}
