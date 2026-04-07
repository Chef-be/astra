<?php

class BotMemoryService
{
	public function remember($botUserId, $scope, $key, array $value, $intensity = 50, $ttl = 2592000)
	{
		$expiresAt = empty($ttl) ? null : TIMESTAMP + max(60, (int) $ttl);
		$existing = Database::get()->selectSingle('SELECT id
			FROM %%BOT_MEMORY%%
			WHERE bot_user_id = :botUserId AND memory_scope = :scope AND memory_key = :memoryKey
			LIMIT 1;', array(
				':botUserId' => (int) $botUserId,
				':scope' => (string) $scope,
				':memoryKey' => (string) $key,
			));

		if (empty($existing)) {
			Database::get()->insert('INSERT INTO %%BOT_MEMORY%% SET
				bot_user_id = :botUserId,
				universe = :universe,
				memory_scope = :scope,
				memory_key = :memoryKey,
				memory_value_json = :memoryValue,
				intensity = :intensity,
				expires_at = :expiresAt,
				created_at = :timestamp,
				updated_at = :timestamp;', array(
					':botUserId' => (int) $botUserId,
					':universe' => Universe::getEmulated(),
					':scope' => (string) $scope,
					':memoryKey' => (string) $key,
					':memoryValue' => json_encode($value),
					':intensity' => max(0, min(100, (int) $intensity)),
					':expiresAt' => $expiresAt,
					':timestamp' => TIMESTAMP,
				));
			return;
		}

		Database::get()->update('UPDATE %%BOT_MEMORY%% SET
			memory_value_json = :memoryValue,
			intensity = :intensity,
			expires_at = :expiresAt,
			updated_at = :updatedAt
			WHERE id = :id;', array(
				':memoryValue' => json_encode($value),
				':intensity' => max(0, min(100, (int) $intensity)),
				':expiresAt' => $expiresAt,
				':updatedAt' => TIMESTAMP,
				':id' => (int) $existing['id'],
			));
	}

	public function getRecent($botUserId, $scope = null, $limit = 20)
	{
		$sql = 'SELECT *
			FROM %%BOT_MEMORY%%
			WHERE bot_user_id = :botUserId
			  AND (expires_at IS NULL OR expires_at >= :now)';
		$params = array(
			':botUserId' => (int) $botUserId,
			':now' => TIMESTAMP,
		);

		if ($scope !== null) {
			$sql .= ' AND memory_scope = :scope';
			$params[':scope'] = (string) $scope;
		}

		$sql .= ' ORDER BY intensity DESC, updated_at DESC LIMIT :limit;';
		$params[':limit'] = max(1, (int) $limit);

		$rows = Database::get()->select($sql, $params);
		foreach ($rows as &$row) {
			$row['memory_value'] = array();
			if (!empty($row['memory_value_json'])) {
				$decoded = json_decode($row['memory_value_json'], true);
				if (is_array($decoded)) {
					$row['memory_value'] = $decoded;
				}
			}
		}
		unset($row);

		return $rows;
	}

	public function purgeExpired()
	{
		return (int) Database::get()->delete('DELETE FROM %%BOT_MEMORY%%
			WHERE universe = :universe
			  AND expires_at IS NOT NULL
			  AND expires_at < :now;', array(
			':universe' => Universe::getEmulated(),
			':now' => TIMESTAMP,
		));
	}
}
