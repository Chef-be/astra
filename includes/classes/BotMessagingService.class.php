<?php

class BotMessagingService
{
	public function queuePrivateMessage($botUserId, $targetUserId, $subject, $body, array $payload = array())
	{
		Database::get()->insert('INSERT INTO %%BOT_PRIVATE_MESSAGES%% SET
			universe = :universe,
			bot_user_id = :botUserId,
			target_user_id = :targetUserId,
			subject = :subject,
			body = :body,
			status = :status,
			cooldown_until = :cooldownUntil,
			payload_json = :payloadJson;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':targetUserId' => (int) $targetUserId,
				':subject' => trim((string) $subject),
				':body' => trim((string) $body),
				':status' => 'queued',
				':cooldownUntil' => TIMESTAMP + 900,
				':payloadJson' => empty($payload) ? null : json_encode($payload),
			));
	}

	public function queueSocialMessage($botUserId, $channelKey, $messageText, $targetUserId = null, $targetUsername = '', array $payload = array())
	{
		Database::get()->insert('INSERT INTO %%BOT_SOCIAL_MESSAGES%% SET
			universe = :universe,
			bot_user_id = :botUserId,
			channel_key = :channelKey,
			target_user_id = :targetUserId,
			target_username = :targetUsername,
			message_text = :messageText,
			status = :status,
			cooldown_until = :cooldownUntil,
			payload_json = :payloadJson;', array(
				':universe' => Universe::getEmulated(),
				':botUserId' => (int) $botUserId,
				':channelKey' => trim((string) $channelKey) !== '' ? trim((string) $channelKey) : 'bots',
				':targetUserId' => empty($targetUserId) ? null : (int) $targetUserId,
				':targetUsername' => trim((string) $targetUsername),
				':messageText' => trim((string) $messageText),
				':status' => 'queued',
				':cooldownUntil' => TIMESTAMP + 300,
				':payloadJson' => empty($payload) ? null : json_encode($payload),
			));
	}

	public function sendQueued($limit = 20)
	{
		require_once ROOT_PATH.'includes/classes/PlayerUtil.class.php';
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';
		require_once ROOT_PATH.'includes/classes/BotJournalService.class.php';

		$db = Database::get();
		$journal = new BotJournalService();
		$sent = 0;

		$privateMessages = $db->select('SELECT pm.*, u.username AS bot_name
			FROM %%BOT_PRIVATE_MESSAGES%% pm
			INNER JOIN %%USERS%% u ON u.id = pm.bot_user_id
			WHERE pm.universe = :universe
			  AND pm.status = \'queued\'
			  AND (pm.cooldown_until IS NULL OR pm.cooldown_until <= :now)
			ORDER BY pm.id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
				':limit' => (int) $limit,
			));

		foreach ($privateMessages as $row) {
			PlayerUtil::sendMessage(
				(int) $row['target_user_id'],
				(int) $row['bot_user_id'],
				(string) $row['bot_name'],
				4,
				(string) $row['subject'],
				(string) $row['body'],
				TIMESTAMP
			);

			$db->update('UPDATE %%BOT_PRIVATE_MESSAGES%% SET status = :status, sent_at = :sentAt WHERE id = :id;', array(
				':status' => 'sent',
				':sentAt' => TIMESTAMP,
				':id' => (int) $row['id'],
			));

			$journal->logActivity((int) $row['bot_user_id'], 'message_prive', sprintf('%s envoie un message privé au joueur #%d.', $row['bot_name'], $row['target_user_id']), array(
				'subject' => $row['subject'],
			));
			$sent++;
		}

		$socialMessages = $db->select('SELECT sm.*, u.username AS bot_name, u.ally_id
			FROM %%BOT_SOCIAL_MESSAGES%% sm
			INNER JOIN %%USERS%% u ON u.id = sm.bot_user_id
			WHERE sm.universe = :universe
			  AND sm.status = \'queued\'
			  AND (sm.cooldown_until IS NULL OR sm.cooldown_until <= :now)
			ORDER BY sm.id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':now' => TIMESTAMP,
				':limit' => (int) $limit,
			));

		foreach ($socialMessages as $row) {
			LiveChatService::createChannelMessage(
				$row['channel_key'],
				$row['bot_name'],
				$row['message_text'],
				(int) $row['bot_user_id'],
				Universe::getEmulated(),
				(int) $row['ally_id']
			);

			$db->update('UPDATE %%BOT_SOCIAL_MESSAGES%% SET status = :status, sent_at = :sentAt WHERE id = :id;', array(
				':status' => 'sent',
				':sentAt' => TIMESTAMP,
				':id' => (int) $row['id'],
			));

			$journal->logActivity((int) $row['bot_user_id'], 'message_chat', sprintf('%s publie un message social sur %s.', $row['bot_name'], $row['channel_key']), array(
				'message' => $row['message_text'],
			));
			$sent++;
		}

		return $sent;
	}

	public function renderTemplate($templateKey, array $context = array())
	{
		$target = !empty($context['target_username']) ? '@'.$context['target_username'] : '';
		$coordinates = !empty($context['target_coordinates']) ? $context['target_coordinates'] : '';
		$templates = array(
			'intimidation' => $target.' Nous surveillons votre secteur '.$coordinates.'.',
			'pression_locale' => 'Pression maintenue sur '.$coordinates.'. Rotation offensive en cours.',
			'defense_zone' => 'Renforcement défensif engagé. La zone reste sous contrôle.',
			'presence_visible' => 'Commandement Astra actif. Ordres et supervision en cours.',
		);

		return isset($templates[$templateKey]) ? trim($templates[$templateKey]) : 'Transmission tactique en cours.';
	}
}
