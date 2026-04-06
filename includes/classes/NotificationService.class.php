<?php

class NotificationService
{
	public static function createSupportTicketNotification($recipientUserId, $actorUserId, $ticketId, $title, $body, $type = 'support_ticket', $universe = null)
	{
		$recipientUserId = (int) $recipientUserId;
		$actorUserId = (int) $actorUserId;
		$ticketId = (int) $ticketId;

		if ($recipientUserId <= 0 || $ticketId <= 0) {
			return false;
		}

		if ($actorUserId > 0 && $recipientUserId === $actorUserId) {
			return false;
		}

		if ($universe === null) {
			$universe = Universe::current();
		}

		return self::create(
			$recipientUserId,
			(string) $type,
			(string) $title,
			(string) $body,
			self::resolveSupportTicketLink($recipientUserId, $ticketId, $universe),
			$universe,
			array(
				'ticketId' => $ticketId,
				'actorUserId' => $actorUserId,
			)
		);
	}

	public static function create($userId, $type, $title, $body, $link = '', $universe = null, array $meta = array())
	{
		if (empty($userId)) {
			return false;
		}

		if ($universe === null) {
			$universe = Universe::current();
		}

		$sql = "INSERT INTO %%NOTIFICATIONS%% SET
			`user_id` = :userId,
			`notification_type` = :type,
			`title` = :title,
			`body` = :body,
			`link_url` = :link,
			`meta_json` = :meta,
			`is_read` = 0,
			`universe` = :universe,
			`created_at` = :createdAt;";

		Database::get()->insert($sql, array(
			':userId' => (int) $userId,
			':type' => (string) $type,
			':title' => (string) $title,
			':body' => (string) $body,
			':link' => (string) $link,
			':meta' => json_encode($meta),
			':universe' => (int) $universe,
			':createdAt' => TIMESTAMP,
		));

		return Database::get()->lastInsertId();
	}

	public static function createFromMessage($userId, $messageType, $subject, $text, $link = 'game.php?page=messages', $universe = null)
	{
		if (in_array((int) $messageType, array(1, 2), true)) {
			return false;
		}

		if (strpos((string) $link, 'game.php?page=messages') === 0) {
			$link = 'game.php?page=notifications';
		}

		$subject = trim(strip_tags((string) $subject));
		$body = trim(html_entity_decode(strip_tags((string) $text), ENT_QUOTES, 'UTF-8'));
		$body = preg_replace('/\s+/', ' ', $body);

		if ($subject === '') {
			$subject = 'Nouvelle notification';
		}

		if (mb_strlen($body) > 280) {
			$body = mb_substr($body, 0, 277).'...';
		}

		return self::create($userId, 'message_'.$messageType, $subject, $body, $link, $universe, array(
			'messageType' => (int) $messageType,
		));
	}

	public static function getUnreadCount($userId)
	{
		$sql = "SELECT COUNT(*) AS count FROM %%NOTIFICATIONS%% WHERE user_id = :userId AND is_read = 0;";
		return (int) Database::get()->selectSingle($sql, array(':userId' => (int) $userId), 'count');
	}

	public static function getRecent($userId, $limit = 20)
	{
		$sql = "SELECT id, notification_type, title, body, link_url, is_read, created_at, universe, meta_json
			FROM %%NOTIFICATIONS%%
			WHERE user_id = :userId
			ORDER BY id DESC
			LIMIT :limit;";

		$rows = Database::get()->select($sql, array(
			':userId' => (int) $userId,
			':limit' => (int) $limit,
		));

		return self::normalizeNotificationRows($rows, $userId);
	}

	public static function getUnread($userId, $limit = 20)
	{
		$sql = "SELECT id, notification_type, title, body, link_url, is_read, created_at, universe, meta_json
			FROM %%NOTIFICATIONS%%
			WHERE user_id = :userId AND is_read = 0
			ORDER BY id DESC
			LIMIT :limit;";

		$rows = Database::get()->select($sql, array(
			':userId' => (int) $userId,
			':limit' => (int) $limit,
		));

		return self::normalizeNotificationRows($rows, $userId);
	}

	public static function getAll($userId, $limit = 100)
	{
		$sql = "SELECT id, notification_type, title, body, link_url, is_read, created_at, read_at, universe, meta_json
			FROM %%NOTIFICATIONS%%
			WHERE user_id = :userId
			ORDER BY id DESC
			LIMIT :limit;";

		$rows = Database::get()->select($sql, array(
			':userId' => (int) $userId,
			':limit' => (int) $limit,
		));

		return self::normalizeNotificationRows($rows, $userId);
	}

	public static function getById($userId, $notificationId)
	{
		$sql = "SELECT id, notification_type, title, body, link_url, is_read, created_at, universe, meta_json
			FROM %%NOTIFICATIONS%%
			WHERE id = :notificationId AND user_id = :userId
			LIMIT 1;";

		$row = Database::get()->selectSingle($sql, array(
			':notificationId' => (int) $notificationId,
			':userId' => (int) $userId,
		));

		if (empty($row)) {
			return false;
		}

		return self::normalizeNotificationRow($row, $userId);
	}

	public static function markRead($userId, $notificationId)
	{
		$sql = "UPDATE %%NOTIFICATIONS%% SET is_read = 1, read_at = :readAt
			WHERE id = :notificationId AND user_id = :userId;";

		return Database::get()->update($sql, array(
			':readAt' => TIMESTAMP,
			':notificationId' => (int) $notificationId,
			':userId' => (int) $userId,
		));
	}

	public static function markAllRead($userId)
	{
		$sql = "UPDATE %%NOTIFICATIONS%% SET is_read = 1, read_at = :readAt
			WHERE user_id = :userId AND is_read = 0;";

		return Database::get()->update($sql, array(
			':readAt' => TIMESTAMP,
			':userId' => (int) $userId,
		));
	}

	private static function resolveSupportTicketLink($recipientUserId, $ticketId, $universe)
	{
		$db = Database::get();

		$ticket = $db->selectSingle('SELECT ticketID, ownerID, universe
			FROM %%TICKETS%%
			WHERE ticketID = :ticketId
			LIMIT 1;', array(
			':ticketId' => (int) $ticketId,
		));

		if (empty($ticket)) {
			return 'game.php?page=ticket';
		}

		$recipient = $db->selectSingle('SELECT id, authlevel
			FROM %%USERS%%
			WHERE id = :userId AND universe = :universe
			LIMIT 1;', array(
			':userId' => (int) $recipientUserId,
			':universe' => (int) $universe,
		));

		$isTicketOwner = (int) $ticket['ownerID'] === (int) $recipientUserId;
		$isAdmin = !empty($recipient) && (int) $recipient['authlevel'] > AUTH_USR;

		if ($isTicketOwner || !$isAdmin) {
			return 'game.php?page=ticket&mode=view&id='.(int) $ticketId;
		}

		return 'admin.php?page=support&mode=view&id='.(int) $ticketId;
	}

	private static function normalizeNotificationRows(array $rows, $userId)
	{
		foreach ($rows as $key => $row) {
			$rows[$key] = self::normalizeNotificationRow($row, $userId);
		}

		return $rows;
	}

	private static function normalizeNotificationRow(array $row, $userId)
	{
		$meta = array();

		if (!empty($row['meta_json'])) {
			$decoded = json_decode($row['meta_json'], true);
			if (is_array($decoded)) {
				$meta = $decoded;
			}
		}

		if (in_array((string) $row['notification_type'], array('support_ticket', 'support_reply'), true) && !empty($meta['ticketId'])) {
			$row['link_url'] = self::resolveSupportTicketLink((int) $userId, (int) $meta['ticketId'], !empty($row['universe']) ? (int) $row['universe'] : Universe::current());
		}

		unset($row['meta_json']);

		return $row;
	}
}
