<?php

class ShowRealtimePage extends AbstractGamePage
{
	protected $disableEcoSystem = true;

	public function __construct()
	{
		parent::__construct();
		$this->setWindow('ajax');
		$this->initTemplate();
		require_once ROOT_PATH.'includes/classes/RealtimeAuthService.class.php';
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';
	}

	public function token()
	{
		global $USER;
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';

		$scheme = HTTPS ? 'wss://' : 'ws://';
		$host = HTTP_HOST;
		$token = RealtimeAuthService::createToken($USER);

		$this->sendJSON(array(
			'status' => 'ok',
			'token' => $token,
			'wsUrl' => $scheme.$host.'/ws',
			'currentUserId' => (int) $USER['id'],
			'currentUsername' => (string) $USER['username'],
			'notifications' => NotificationService::getUnread($USER['id']),
			'unreadCount' => NotificationService::getUnreadCount($USER['id']),
			'channels' => LiveChatService::getAvailableChannelsForUser($USER),
		));
	}

	public function deleteChatMessage()
	{
		global $USER;
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';

		$config = Config::get(Universe::getEmulated());
		$messageId = HTTP::_GP('messageId', 0);
		$message = LiveChatService::getMessageById($messageId);

		if (empty($message)) {
			$this->sendJSON(array('status' => 'error', 'message' => 'Message introuvable.'));
		}

		if ((int) $config->chat_allowdelmes !== 1) {
			$this->sendJSON(array('status' => 'error', 'message' => 'La suppression des messages est désactivée.'));
		}

		if (!LiveChatService::userCanModerateChannel($USER, $message['channel_key'])) {
			$this->sendJSON(array('status' => 'error', 'message' => 'Vous ne pouvez pas modérer ce canal.'));
		}

		LiveChatService::deleteMessage($messageId);
		$this->sendJSON(array('status' => 'ok'));
	}

	public function muteChatUser()
	{
		global $USER;
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';

		$channelKey = HTTP::_GP('channelKey', '', true);
		$targetUserId = HTTP::_GP('targetUserId', 0);
		$durationMinutes = max(0, HTTP::_GP('durationMinutes', 30));
		$reason = trim(HTTP::_GP('reason', 'Modération du chat', true));

		if (!LiveChatService::userCanModerateChannel($USER, $channelKey)) {
			$this->sendJSON(array('status' => 'error', 'message' => 'Vous ne pouvez pas modérer ce canal.'));
		}

		if ($targetUserId <= 0) {
			$this->sendJSON(array('status' => 'error', 'message' => 'Utilisateur cible invalide.'));
		}

		LiveChatService::muteUser($targetUserId, $USER['id'], $durationMinutes, $reason);
		NotificationService::create(
			$targetUserId,
			'chat_mute',
			'Restriction de chat',
			$durationMinutes === 0
				? 'Votre accès au chat a été suspendu jusqu’à nouvelle décision. Motif : '.$reason
				: 'Votre accès au chat a été restreint pendant '.$durationMinutes.' minute(s). Motif : '.$reason,
			'game.php?page=chat&channel='.$channelKey,
			Universe::getEmulated(),
			array('durationMinutes' => $durationMinutes)
		);

		$this->sendJSON(array('status' => 'ok'));
	}

	public function dispatchBotCommands()
	{
		global $USER;
		require_once ROOT_PATH.'includes/classes/BotAdminService.class.php';

		if ((int) $USER['authlevel'] < AUTH_ADM) {
			$this->sendJSON(array('status' => 'error', 'message' => 'Accès refusé.'));
		}

		$service = new BotAdminService();
		$result = $service->dispatchPendingCommands(max(1, HTTP::_GP('limit', 6)));

		$this->sendJSON(array(
			'status' => 'ok',
			'processed' => (int) $result['processed'],
			'done' => (int) $result['done'],
			'rejected' => (int) $result['rejected'],
		));
	}

	public function notifications()
	{
		global $USER;

		$this->sendJSON(array(
			'status' => 'ok',
			'items' => NotificationService::getUnread($USER['id']),
			'unreadCount' => NotificationService::getUnreadCount($USER['id']),
		));
	}

	public function notificationDetail()
	{
		global $USER;

		$notificationId = HTTP::_GP('notificationId', 0);
		$item = NotificationService::getById($USER['id'], $notificationId);

		$this->sendJSON(array(
			'status' => $item ? 'ok' : 'fail',
			'item' => $item,
		));
	}

	public function markNotificationRead()
	{
		global $USER;

		$notificationId = HTTP::_GP('notificationId', 0);
		NotificationService::markRead($USER['id'], $notificationId);

		$this->sendJSON(array(
			'status' => 'ok',
			'unreadCount' => NotificationService::getUnreadCount($USER['id']),
		));
	}

	public function markNotificationsRead()
	{
		global $USER;

		NotificationService::markAllRead($USER['id']);

		$this->sendJSON(array(
			'status' => 'ok',
			'unreadCount' => 0,
		));
	}
}
