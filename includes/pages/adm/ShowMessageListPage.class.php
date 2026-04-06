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
class ShowMessageListPage extends AbstractAdminPage
{

	function __construct()
	{
		parent::__construct();
	}

	function show(){

		global $LNG, $USER;
		$page		= max(1, HTTP::_GP('side', 1));
		$type		= HTTP::_GP('type', 100);
		$sender		= HTTP::_GP('sender', '', UTF8_SUPPORT);
		$receiver	= HTTP::_GP('receiver', '', UTF8_SUPPORT);
		$dateStart	= HTTP::_GP('dateStart', array());
		$dateEnd	= HTTP::_GP('dateEnd', array());
		$db			= Database::get();
		$perSide	= 50;
		$messageList = array();

		$categories	= $LNG['mg_type'];
		unset($categories[999]);

		$dateStart = array_filter($dateStart, 'is_numeric');
		$dateEnd = array_filter($dateEnd, 'is_numeric');

		$whereParts = array('m.message_universe = :universe');
		$params = array(':universe' => Universe::getEmulated());

		if ($type != 100)
		{
			$whereParts[] = 'm.message_type = :type';
			$params[':type'] = $type;
		}

		if (!empty($sender))
		{
			$whereParts[] = '(us.username = :sender OR m.message_from = :sender)';
			$params[':sender'] = $sender;
		}

		if (!empty($receiver))
		{
			$whereParts[] = 'u.username = :receiver';
			$params[':receiver'] = $receiver;
		}

		if (count($dateStart) === 3)
		{
			$whereParts[] = 'm.message_time >= :dateStart';
			$params[':dateStart'] = mktime(0, 0, 0, (int) $dateStart['month'], (int) $dateStart['day'], (int) $dateStart['year']);
		}

		if (count($dateEnd) === 3)
		{
			$whereParts[] = 'm.message_time <= :dateEnd';
			$params[':dateEnd'] = mktime(23, 59, 59, (int) $dateEnd['month'], (int) $dateEnd['day'], (int) $dateEnd['year']);
		}

		$whereSQL = implode(' AND ', $whereParts);

		$countSql = "SELECT COUNT(*) as count
		FROM %%MESSAGES%% AS m
		LEFT JOIN %%USERS%% AS u ON m.message_owner = u.id
		LEFT JOIN %%USERS%% AS us ON m.message_sender = us.id
		WHERE ".$whereSQL.";";

		$MessageCount = (int) $db->selectSingle($countSql, $params, 'count');
		$maxPage = max(1, ceil($MessageCount / $perSide));
		$page = max(1, min($page, $maxPage));
		$offset = ($page - 1) * $perSide;

		$sql = "SELECT u.username, us.username AS senderName, m.*
		FROM %%MESSAGES%% AS m
		LEFT JOIN %%USERS%% AS u ON m.message_owner = u.id
		LEFT JOIN %%USERS%% AS us ON m.message_sender = us.id
		WHERE ".$whereSQL."
		ORDER BY m.message_time DESC, m.message_id DESC
		LIMIT ".$offset.", ".$perSide.";";

		$messageRaw = $db->select($sql, $params);

		foreach($messageRaw as $messageRow)
		{
			$messageList[$messageRow['message_id']]	= array(
				'sender'	=> empty($messageRow['senderName']) ? $messageRow['message_from'] : $messageRow['senderName'].' (ID:&nbsp;'.$messageRow['message_sender'].')',
				'receiver'	=> $messageRow['username'].' (ID:&nbsp;'.$messageRow['message_owner'].')',
				'subject'	=> $messageRow['message_subject'],
				'text'		=> $messageRow['message_text'],
				'type'		=> $messageRow['message_type'],
				'deleted'	=> $messageRow['message_deleted'] != NULL,
				'time'		=> str_replace(' ', '&nbsp;', _date($LNG['php_tdformat'], $messageRow['message_time'], $USER['timezone'])),
			);
		}

		$this->assign(array(
			'categories'	=> $categories,
			'maxPage'		=> $maxPage,
			'page'			=> $page,
			'messageList'	=> $messageList,
			'type'			=> $type,
			'dateStart'		=> $dateStart,
			'dateEnd'		=> $dateEnd,
			'sender'		=> $sender,
			'receiver'		=> $receiver,
		));

		$this->display('page.messagelist.default.tpl');

	}

}
