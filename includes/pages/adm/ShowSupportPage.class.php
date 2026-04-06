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


class ShowSupportPage extends AbstractAdminPage
{
	private $ticketObj;
	private $statusMessages = array(
		0 => 'Ticket rouvert par l’administration.',
		1 => 'Ticket pris en charge par l’administration.',
		2 => 'Ticket clôturé par l’administration.',
	);

	function __construct()
	{
		parent::__construct();

		require_once ROOT_PATH.'includes/classes/class.SupportTickets.php';
		$this->ticketObj	= new SupportTickets;
		// Adaptateur de compatibilité historique de la classe de page.
		$ACTION = HTTP::_GP('mode', 'show');
		if(is_callable(array($this, $ACTION))) {
			$this->{$ACTION}();
		} else {
			$this->show();
    }
	}

	public function show()
	{
		global $USER, $LNG;

		list($ticketList, $ticketSummary) = $this->getTicketDataset($USER['timezone'], $LNG['php_tdformat']);

		$this->assign(array(
			'ticketList'		=> $ticketList,
			'ticketSummary'	=> $ticketSummary,
		));

		$this->display('page.ticket.default.tpl');
	}

	public function bulk()
	{
		$action = HTTP::_GP('bulkAction', '');
		$ticketIds = $this->normalizeTicketIds($_POST['ticketIds'] ?? array());

		if (empty($ticketIds)) {
			HTTP::redirectTo('admin.php?page=support');
		}

		switch ($action) {
			case 'close':
				$this->updateTicketStatus($ticketIds, 2);
				break;
			case 'answer':
				$this->updateTicketStatus($ticketIds, 1);
				break;
			case 'reopen':
				$this->updateTicketStatus($ticketIds, 0);
				break;
			case 'delete':
				$this->deleteTickets($ticketIds);
				break;
		}

		HTTP::redirectTo('admin.php?page=support');
	}

	public function quick()
	{
		$ticketId = HTTP::_GP('id', 0);
		$action = HTTP::_GP('action', '');
		$ticketIds = $ticketId > 0 ? array((int) $ticketId) : array();

		if (empty($ticketIds)) {
			HTTP::redirectTo('admin.php?page=support');
		}

		switch ($action) {
			case 'close':
				$this->updateTicketStatus($ticketIds, 2);
				break;
			case 'answer':
				$this->updateTicketStatus($ticketIds, 1);
				break;
			case 'reopen':
				$this->updateTicketStatus($ticketIds, 0);
				break;
			case 'delete':
				$this->deleteTickets($ticketIds);
				break;
		}

		HTTP::redirectTo('admin.php?page=support');
	}

	public function purgeAll()
	{
		$this->deleteAllTicketsAndResetIds();
		HTTP::redirectTo('admin.php?page=support');
	}

	function send()
	{
		global $USER, $LNG;
		require_once ROOT_PATH.'includes/classes/NotificationService.class.php';
		require_once ROOT_PATH.'includes/classes/RichTextService.class.php';

		$db = Database::get();

		$ticketID	= HTTP::_GP('id', 0);
		$message	= RichTextService::prepareForStorage((string) ($_POST['message'] ?? ''));
		$change		= HTTP::_GP('change_status', 0);

		$sql = "SELECT ownerID, subject, status FROM %%TICKETS%% WHERE ticketID = :ticketID;";

		$ticketDetail = $db->selectSingle($sql,array(
			':ticketID' => $ticketID
		));


		$status = ($change ? ($ticketDetail['status'] <= 1 ? 2 : 1) : 1);


		if(!$change && empty($message))
		{
			HTTP::redirectTo('admin.php?page=support&mode=view&id='.$ticketID);
		}

		$subject		= "RE: ".$ticketDetail['subject'];

		if($change && $status == 1) {
			$this->ticketObj->createAnswer($ticketID, $USER['id'], $USER['username'], $subject, $LNG['ti_admin_open'], $status);
		}

		if(!empty($message))
		{
			$this->ticketObj->createAnswer($ticketID, $USER['id'], $USER['username'], $subject, $message, $status);
		}

		if($change && $status == 2) {
			$this->ticketObj->createAnswer($ticketID, $USER['id'], $USER['username'], $subject, $LNG['ti_admin_close'], $status);
		}


		NotificationService::createSupportTicketNotification(
			$ticketDetail['ownerID'],
			$USER['id'],
			$ticketID,
			'Réponse du support',
			'Une réponse du support a été ajoutée à votre ticket #'.$ticketID.'.',
			'support_reply',
			Universe::getEmulated()
		);

		HTTP::redirectTo('admin.php?page=support');
	}

	function view()
	{
		global $USER, $LNG;
		require_once ROOT_PATH.'includes/classes/RichTextService.class.php';

		$db = Database::get();

		$ticketID			= HTTP::_GP('id', 0);

		$sql = "SELECT a.*, t.categoryID, t.status FROM %%TICKETS_ANSWER%% as a
		INNER JOIN %%TICKETS%% as t USING(ticketID) WHERE a.ticketID = :ticketID
		ORDER BY a.answerID;";

		$answerResult = $db->select($sql,array(
			':ticketID' => $ticketID
		));

		$answerList			= array();




		$ticket_status		= 0;
		foreach($answerResult as &$answerRow) {

			if (empty($ticket_status)){
				$ticket_status = $answerRow['status'];
			}

			$answerRow['time']	= _date($LNG['php_tdformat'], $answerRow['time'], $USER['timezone']);
			$answerRow['message']	= RichTextService::render($answerRow['message']);

			$answerList[$answerRow['answerID']]	= $answerRow;
		}
		unset($answerResult);



		$categoryList	= $this->ticketObj->getCategoryList();



		$this->assign(array(
			'ticketID'		=> $ticketID,
			'ticket_status' => $ticket_status,
			'categoryList'	=> $categoryList,
			'answerList'	=> $answerList,
		));



		$this->display('page.ticket.view.tpl');
	}

	private function getTicketDataset($timezone, $dateFormat)
	{
		$db = Database::get();

		$sql = "SELECT t.*, u.username, COUNT(a.ticketID) as answer FROM
		%%TICKETS%% as t INNER JOIN %%TICKETS_ANSWER%% as a USING (ticketID)
		INNER JOIN %%USERS%% as u ON u.id = t.ownerID WHERE t.universe = :universe
		GROUP BY a.ticketID ORDER BY t.ticketID DESC;";

		$ticketResult = $db->select($sql, array(
			':universe' => Universe::getEmulated()
		));

		$ticketList = array();
		$ticketSummary = array(
			'total'		=> 0,
			'open'		=> 0,
			'answer'	=> 0,
			'closed'	=> 0,
		);

		foreach ($ticketResult as $ticketRow) {
			$ticketRow['time'] = _date($dateFormat, $ticketRow['time'], $timezone);
			$ticketRow['replyCount'] = max(0, (int) $ticketRow['answer'] - 1);
			$ticketList[$ticketRow['ticketID']] = $ticketRow;
			$ticketSummary['total']++;

			if ((int) $ticketRow['status'] === 0) {
				$ticketSummary['open']++;
			} elseif ((int) $ticketRow['status'] === 1) {
				$ticketSummary['answer']++;
			} else {
				$ticketSummary['closed']++;
			}
		}

		return array($ticketList, $ticketSummary);
	}

	private function normalizeTicketIds($ticketIds)
	{
		if (!is_array($ticketIds)) {
			return array();
		}

		$ticketIds = array_map('intval', $ticketIds);
		$ticketIds = array_filter($ticketIds, function ($value) {
			return $value > 0;
		});

		return array_values(array_unique($ticketIds));
	}

	private function updateTicketStatus(array $ticketIds, $newStatus)
	{
		global $USER;

		if (empty($ticketIds)) {
			return;
		}

		$db = Database::get();
		$targets = $db->select('SELECT ticketID, subject FROM %%TICKETS%% WHERE ticketID IN ('.implode(',', $ticketIds).') AND universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		));

		foreach ($targets as $target) {
			$db->update('UPDATE %%TICKETS%% SET status = :status WHERE ticketID = :ticketId;', array(
				':status' => (int) $newStatus,
				':ticketId' => (int) $target['ticketID'],
			));

			$message = $this->statusMessages[(int) $newStatus] ?? 'Statut du ticket mis à jour.';
			$this->ticketObj->createAnswer(
				(int) $target['ticketID'],
				(int) $USER['id'],
				(string) $USER['username'],
				'RE: '.$target['subject'],
				$message,
				(int) $newStatus
			);
		}
	}

	private function deleteTickets(array $ticketIds)
	{
		if (empty($ticketIds)) {
			return;
		}

		$db = Database::get();
		$idList = implode(',', $ticketIds);

		$db->delete('DELETE FROM %%TICKETS_ANSWER%% WHERE ticketID IN ('.$idList.');');
		$db->delete('DELETE FROM %%TICKETS%% WHERE ticketID IN ('.$idList.') AND universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		));
		$db->delete("DELETE FROM %%NOTIFICATIONS%% WHERE universe = :universe AND notification_type IN ('support_ticket', 'support_reply') AND meta_json REGEXP :ticketPattern;", array(
			':universe' => Universe::getEmulated(),
			':ticketPattern' => '\"ticketId\":(' . implode('|', $ticketIds) . ')',
		));

		$this->resetTicketSequencesIfEmpty();
	}

	private function deleteAllTicketsAndResetIds()
	{
		$db = Database::get();

		$db->delete('DELETE FROM %%TICKETS_ANSWER%%;');
		$db->delete('DELETE FROM %%TICKETS%% WHERE universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		));
		$db->delete("DELETE FROM %%NOTIFICATIONS%% WHERE universe = :universe AND notification_type IN ('support_ticket', 'support_reply');", array(
			':universe' => Universe::getEmulated(),
		));

		$db->query('ALTER TABLE '.TICKETS_ANSWER.' AUTO_INCREMENT = 1;');
		$db->query('ALTER TABLE '.TICKETS.' AUTO_INCREMENT = 1;');
	}

	private function resetTicketSequencesIfEmpty()
	{
		$db = Database::get();
		$count = (int) $db->selectSingle('SELECT COUNT(*) AS count FROM %%TICKETS%% WHERE universe = :universe;', array(
			':universe' => Universe::getEmulated(),
		), 'count');

		if ($count === 0) {
			$db->query('ALTER TABLE '.TICKETS_ANSWER.' AUTO_INCREMENT = 1;');
			$db->query('ALTER TABLE '.TICKETS.' AUTO_INCREMENT = 1;');
		}
	}
}
