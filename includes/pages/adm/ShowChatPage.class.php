<?php

/**
*  ultimateXnova
*  based on 2moons by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package ultimateXnova
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2022 Koray Karakuş <koraykarakus@yahoo.com>
 * @copyright 2024 Pfahli (https://github.com/Pfahli)
 * @licence MIT
 * @version 1.8.x Koray Karakuş <koraykarakus@yahoo.com>
 * @link https://github.com/ultimateXnova/ultimateXnova
 */

/**
 *
 */
class ShowChatPage extends AbstractAdminPage
{
	protected $liveChatService;

	function __construct()
	{
		parent::__construct();
		require_once ROOT_PATH.'includes/classes/LiveChatService.class.php';
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';
		$this->liveChatService = new LiveChatService();
	}

	function show(){

		global $LNG, $USER;

		$config = Config::get(Universe::getEmulated());
		LiveChatService::ensureChannelDefaults();

		$recentMessages = LiveChatService::getRecentAdminMessages(120);
		$channelMap = array();
		foreach (LiveChatService::getChannels() as $channelRow) {
			$channelMap[$channelRow['channel_key']] = $channelRow;
		}

		foreach ($recentMessages as &$messageRow) {
			$messageRow['created_at_formatted'] = _date($LNG['php_tdformat'], $messageRow['created_at'], $USER['timezone']);
			$messageRow['channel_label'] = isset($channelMap[$messageRow['channel_key']]['label']) ? $channelMap[$messageRow['channel_key']]['label'] : $this->getChannelLabel($messageRow['channel_key']);
			$messageRow['status_label'] = ((int) $messageRow['is_deleted'] === 1) ? 'Supprimé' : 'Visible';
		}
		unset($messageRow);

		$activeMutes = LiveChatService::getActiveMutes();
		foreach ($activeMutes as &$muteRow) {
			$muteRow['created_at_formatted'] = _date($LNG['php_tdformat'], $muteRow['created_at'], $USER['timezone']);
			$muteRow['expires_at_formatted'] = ((int) $muteRow['expires_at'] >= 4102444800)
				? 'Permanent'
				: _date($LNG['php_tdformat'], $muteRow['expires_at'], $USER['timezone']);
		}
		unset($muteRow);

		$this->assign(array(
			'chat_closed'			=> $config->chat_closed,
			'chat_allowchan'		=> $config->chat_allowchan,
			'chat_allowmes'			=> $config->chat_allowmes,
			'chat_allowdelmes'		=> $config->chat_allowdelmes,
			'chat_logmessage'		=> $config->chat_logmessage,
			'chat_nickchange'		=> $config->chat_nickchange,
			'chat_botname'			=> $config->chat_botname,
			'chat_channelname'		=> $config->chat_channelname,
			'chat_retention_days'	=> $config->chat_retention_days,
			'chat_history_limit'	=> $config->chat_history_limit,
			'se_server_parameters'	=> $LNG['se_server_parameters'],
			'se_save_parameters'	=> $LNG['se_save_parameters'],
			'ch_closed'				=> $LNG['ch_closed'],
			'ch_allowchan'			=> $LNG['ch_allowchan'],
			'ch_allowmes'			=> $LNG['ch_allowmes'],
			'ch_allowdelmes'		=> $LNG['ch_allowdelmes'],
			'ch_logmessage'			=> $LNG['ch_logmessage'],
			'ch_nickchange'			=> $LNG['ch_nickchange'],
			'ch_botname'			=> $LNG['ch_botname'],
			'ch_channelname'		=> $LNG['ch_channelname'],
			'recentMessages'		=> $recentMessages,
			'activeMutes'			=> $activeMutes,
			'channelSettings'		=> array_values($channelMap),
			'realtimeStatus'		=> $this->getRealtimeStatus(),
		));

		$this->display('page.chat.default.tpl');

	}


	function saveSettings(){

		global $LNG;

		$config = Config::get(Universe::getEmulated());

		$config_before = array(
			'chat_closed'			=> $config->chat_closed,
			'chat_allowchan'		=> $config->chat_allowchan,
			'chat_allowmes'			=> $config->chat_allowmes,
			'chat_allowdelmes'		=> $config->chat_allowdelmes,
			'chat_logmessage'		=> $config->chat_logmessage,
			'chat_nickchange'		=> $config->chat_nickchange,
			'chat_botname'			=> $config->chat_botname,
			'chat_channelname'		=> $config->chat_channelname,
		);

		$chat_allowchan			= isset($_POST['chat_allowchan']) && $_POST['chat_allowchan'] == 'on' ? 1 : 0;
		$chat_allowmes			= isset($_POST['chat_allowmes']) && $_POST['chat_allowmes'] == 'on' ? 1 : 0;
		$chat_allowdelmes		= isset($_POST['chat_allowdelmes']) && $_POST['chat_allowdelmes'] == 'on' ? 1 : 0;
		$chat_logmessage		= isset($_POST['chat_logmessage']) && $_POST['chat_logmessage'] == 'on' ? 1 : 0;
		$chat_nickchange		= isset($_POST['chat_nickchange']) && $_POST['chat_nickchange'] == 'on' ? 1 : 0;
		$chat_closed			= isset($_POST['chat_closed']) && $_POST['chat_closed'] == 'on' ? 1 : 0;

		$chat_channelname		= HTTP::_GP('chat_channelname', '', true);
		$chat_botname			= HTTP::_GP('chat_botname', '', true);
		$chat_retention_days	= max(1, HTTP::_GP('chat_retention_days', 30));
		$chat_history_limit		= max(20, min(300, HTTP::_GP('chat_history_limit', 120)));

		$config_after = array(
			'chat_closed'			=> $chat_closed,
			'chat_allowchan'		=> $chat_allowchan,
			'chat_allowmes'			=> $chat_allowmes,
			'chat_allowdelmes'		=> $chat_allowdelmes,
			'chat_logmessage'		=> $chat_logmessage,
			'chat_nickchange'		=> $chat_nickchange,
			'chat_botname'			=> $chat_botname,
			'chat_channelname'		=> $chat_channelname,
			'chat_retention_days'	=> $chat_retention_days,
			'chat_history_limit'	=> $chat_history_limit,
		);

		foreach($config_after as $key => $value)
		{
			$config->$key	= $value;
		}
		try {
			$config->save();
			Config::reload();
		} catch (Exception $exception) {
			$this->printMessage('La sauvegarde du chat a échoué : '.$exception->getMessage(), array(array(
				'url' => 'admin.php?page=chat',
				'label' => 'Retour au chat',
			)));
		}

		$LOG = new Log(3);
		$LOG->target = 3;
		$LOG->old = $config_before;
		$LOG->new = $config_after;
		$LOG->save();

		$redirectButton = array();
		$redirectButton[] = array(
			'url' => 'admin.php?page=chat&mode=show',
			'label' => $LNG['uvs_back']
		);

		$this->printMessage($LNG['settings_successful'],$redirectButton);

	}

	function mute()
	{
		global $USER;

		$targetUser = $this->resolveUser(HTTP::_GP('target_user', '', true));
		$durationMinutes = max(0, HTTP::_GP('duration_minutes', 30));
		$reason = trim(HTTP::_GP('reason', '', true));

		if (empty($targetUser)) {
			$this->printMessage('Utilisateur introuvable. Utilisez un identifiant, un pseudo ou une adresse e-mail valides.', array(array(
				'label' => 'Retour au chat',
				'url' => 'admin.php?page=chat',
			)));
		}

		if ($reason === '') {
			$reason = 'Modération du chat en direct';
		}

		LiveChatService::muteUser($targetUser['id'], $USER['id'], $durationMinutes, $reason);
		NotificationService::create(
			$targetUser['id'],
			'chat_mute',
			'Restriction de chat',
			$durationMinutes === 0
				? 'Votre accès au chat a été suspendu jusqu’à nouvelle décision. Motif : '.$reason
				: 'Votre accès au chat a été restreint pendant '.$durationMinutes.' minute(s). Motif : '.$reason,
			'game.php?page=chat',
			Universe::getEmulated(),
			array('durationMinutes' => $durationMinutes)
		);

		$this->redirectTo('admin.php?page=chat');
	}

	function unmute()
	{
		$muteId = HTTP::_GP('mute_id', 0);
		if ($muteId > 0) {
			LiveChatService::unmute($muteId);
		}

		$this->redirectTo('admin.php?page=chat');
	}

	function deleteMessage()
	{
		$messageId = HTTP::_GP('message_id', 0);
		if ($messageId > 0) {
			LiveChatService::deleteMessage($messageId);
		}

		$this->redirectTo('admin.php?page=chat');
	}

	function saveChannel()
	{
		$channelKey = HTTP::_GP('channel_key', '', true);
		$label = HTTP::_GP('label', '', true);
		$description = HTTP::_GP('description', '', true);
		$isActive = HTTP::_GP('is_active', 'off') === 'on' ? 1 : 0;
		$requiresAdmin = HTTP::_GP('requires_admin', 'off') === 'on' ? 1 : 0;
		$moderatorTarget = HTTP::_GP('moderator_user', '', true);
		$moderatorUserId = null;

		if ($moderatorTarget !== '') {
			$targetUser = $this->resolveUser($moderatorTarget);
			if (!empty($targetUser)) {
				$moderatorUserId = (int) $targetUser['id'];
			}
		}

		LiveChatService::saveChannelSettings($channelKey, $label, $description, $isActive, $moderatorUserId, $requiresAdmin);
		$this->redirectTo('admin.php?page=chat');
	}

	function createChannel()
	{
		$key = HTTP::_GP('channel_key_new', '', true);
		$label = HTTP::_GP('label_new', '', true);
		$description = HTTP::_GP('description_new', '', true);
		$requiresAdmin = HTTP::_GP('requires_admin_new', 'off') === 'on' ? 1 : 0;
		$moderatorTarget = HTTP::_GP('moderator_user_new', '', true);
		$moderatorUserId = null;

		if ($moderatorTarget !== '') {
			$targetUser = $this->resolveUser($moderatorTarget);
			if (!empty($targetUser)) {
				$moderatorUserId = (int) $targetUser['id'];
			}
		}

		LiveChatService::createChannel($key, $label, $description, $requiresAdmin, $moderatorUserId);
		$this->redirectTo('admin.php?page=chat');
	}

	function deleteChannel()
	{
		$channelKey = HTTP::_GP('channel_key', '', true);
		LiveChatService::deleteChannel($channelKey);
		$this->redirectTo('admin.php?page=chat');
	}

	function runRetention()
	{
		LiveChatService::purgeExpiredMessages(Universe::getEmulated());
		$this->redirectTo('admin.php?page=chat');
	}

	private function resolveUser($target)
	{
		$target = trim((string) $target);
		if ($target === '') {
			return null;
		}

		$db = Database::get();
		$universe = Universe::getEmulated();
		$params = array(':universe' => $universe);

		if (ctype_digit($target)) {
			$sql = "SELECT id, username, email
				FROM %%USERS%%
				WHERE universe = :universe AND id = :target
				LIMIT 1;";
			$params[':target'] = (int) $target;
			return $db->selectSingle($sql, $params);
		}

		$sql = "SELECT id, username, email
			FROM %%USERS%%
			WHERE universe = :universe
			AND (username = :target OR email = :target)
			LIMIT 1;";
		$params[':target'] = $target;

		return $db->selectSingle($sql, $params);
	}

	private function getChannelLabel($channelKey)
	{
		if ($channelKey === 'global') {
			return 'Général';
		}

		if (strpos($channelKey, 'alliance:') === 0) {
			return 'Alliance';
		}

		return $channelKey;
	}

	private function getRealtimeStatus()
	{
		$context = stream_context_create(array(
			'http' => array(
				'method' => 'GET',
				'timeout' => 2,
			),
		));

		$payload = @file_get_contents('http://astra-realtime:8080/health', false, $context);
		$isAvailable = is_string($payload) && strpos($payload, '"status":"ok"') !== false;

		return array(
			'available' => $isAvailable,
			'endpoint' => (HTTPS ? 'wss://' : 'ws://').HTTP_HOST.'/ws',
			'healthUrl' => (HTTPS ? 'https://' : 'http://').HTTP_HOST.'/realtime-health',
		);
	}

}
