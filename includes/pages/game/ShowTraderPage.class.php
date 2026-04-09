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


class ShowTraderPage extends AbstractGamePage
{
	public static $requireModule = MODULE_TRADER;
	const ACTIVITY_WINDOW = 604800;
	const PLAYER_HALF_LIFE = 172800;
	const BOT_HALF_LIFE = 86400;
	const BOT_ACTIVITY_LIMIT = 240;

	function __construct()
	{
		parent::__construct();
	}

	public static $Charge = array(
		901	=> array(901 => 1, 902 => 2, 903 => 4),
		902	=> array(901 => 0.5, 902 => 1, 903 => 2),
		903	=> array(901 => 0.25, 902 => 0.5, 903 => 1),
	);

	protected function ensureTraderActivityTable()
	{
		static $schemaReady = false;

		if ($schemaReady) {
			return;
		}

		Database::get()->query('CREATE TABLE IF NOT EXISTS '.DB_PREFIX.'trader_activity (
			id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
			universe int(11) unsigned NOT NULL DEFAULT 0,
			actor_user_id int(11) unsigned DEFAULT NULL,
			is_bot tinyint(1) unsigned NOT NULL DEFAULT 0,
			resource_from smallint(5) unsigned NOT NULL DEFAULT 0,
			resource_to smallint(5) unsigned NOT NULL DEFAULT 0,
			source_amount bigint(20) unsigned NOT NULL DEFAULT 0,
			target_amount bigint(20) unsigned NOT NULL DEFAULT 0,
			effective_rate decimal(12,4) unsigned NOT NULL DEFAULT 0,
			created_at int(11) unsigned NOT NULL DEFAULT 0,
			PRIMARY KEY (id),
			KEY universe_time (universe, created_at),
			KEY actor_time (actor_user_id, created_at)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;');

		$schemaReady = true;
	}

	protected function getResourcePressureSeed()
	{
		return array(
			901 => array('net' => 0.0, 'gross' => 0.0, 'incoming' => 0.0, 'outgoing' => 0.0),
			902 => array('net' => 0.0, 'gross' => 0.0, 'incoming' => 0.0, 'outgoing' => 0.0),
			903 => array('net' => 0.0, 'gross' => 0.0, 'incoming' => 0.0, 'outgoing' => 0.0),
		);
	}

	protected function accumulatePressure(array &$pressure, $resourceFrom, $resourceTo, $sourceAmount, $targetAmount, $weight)
	{
		if (empty($pressure[$resourceFrom]) || empty($pressure[$resourceTo]) || $weight <= 0) {
			return;
		}

		$weightedSource = max(0, (float) $sourceAmount) * $weight;
		$weightedTarget = max(0, (float) $targetAmount) * $weight;

		$pressure[$resourceFrom]['incoming'] += $weightedSource;
		$pressure[$resourceFrom]['gross'] += $weightedSource;
		$pressure[$resourceFrom]['net'] += $weightedSource;

		$pressure[$resourceTo]['outgoing'] += $weightedTarget;
		$pressure[$resourceTo]['gross'] += $weightedTarget;
		$pressure[$resourceTo]['net'] -= $weightedTarget;
	}

	protected function getPlayerActivityPressure()
	{
		$this->ensureTraderActivityTable();

		$db = Database::get();
		$since = TIMESTAMP - self::ACTIVITY_WINDOW;
		$pressure = $this->getResourcePressureSeed();
		$rows = $db->select('SELECT resource_from, resource_to, source_amount, target_amount, created_at
			FROM %%TRADER_ACTIVITY%%
			WHERE universe = :universe
			  AND created_at >= :since
			ORDER BY created_at DESC;', array(
				':universe' => Universe::getEmulated(),
				':since' => $since,
			));

		foreach ($rows as $row) {
			$age = max(0, TIMESTAMP - (int) $row['created_at']);
			$weight = exp(-$age / self::PLAYER_HALF_LIFE);
			$this->accumulatePressure(
				$pressure,
				(int) $row['resource_from'],
				(int) $row['resource_to'],
				(float) $row['source_amount'],
				(float) $row['target_amount'],
				$weight
			);
		}

		return $pressure;
	}

	protected function getBotActivityPressure()
	{
		$db = Database::get();
		$since = TIMESTAMP - self::ACTIVITY_WINDOW;
		$pressure = $this->getResourcePressureSeed();
		$rows = $db->select('SELECT a.bot_user_id, a.activity_type, a.created_at,
			a.activity_payload
			FROM %%BOT_ACTIVITY%% a
			INNER JOIN %%USERS%% u ON u.id = a.bot_user_id
			WHERE a.universe = :universe
			  AND a.created_at >= :since
			  AND u.is_bot = 1
			ORDER BY a.created_at DESC
			LIMIT '.self::BOT_ACTIVITY_LIMIT.';', array(
				':universe' => Universe::getEmulated(),
				':since' => $since,
			));

		$resources = array(901, 902, 903);
		foreach ($rows as $row) {
			$payload = array();
			if (!empty($row['activity_payload'])) {
				$decodedPayload = json_decode($row['activity_payload'], true);
				if (is_array($decodedPayload)) {
					$payload = $decodedPayload;
				}
			}

			$signature = implode('|', array(
				(int) $row['bot_user_id'],
				(string) $row['activity_type'],
				isset($payload['goal']) ? (string) $payload['goal'] : '',
				isset($payload['next_step']) ? (string) $payload['next_step'] : '',
				isset($payload['opportunite_dominante']) ? (string) $payload['opportunite_dominante'] : '',
				(int) $row['created_at'],
			));
			$hash = (int) sprintf('%u', crc32($signature));
			$fromIndex = (int) ($hash % 3);
			$offset = 1 + (int) (intdiv($hash, 7) % 2);
			$toIndex = ($fromIndex + $offset) % 3;
			$resourceFrom = $resources[$fromIndex];
			$resourceTo = $resources[$toIndex];
			$baseRate = self::$Charge[$resourceFrom][$resourceTo];
			$activityBias = 1 + ((intdiv($hash, 29) % 60) / 100);
			$targetAmount = max(800, (int) round((2200 + (intdiv($hash, 131) % 6400)) * $activityBias));
			$sourceAmount = (int) ceil($targetAmount * $baseRate);
			$age = max(0, TIMESTAMP - (int) $row['created_at']);
			$weight = 0.32 * exp(-$age / self::BOT_HALF_LIFE);

			$this->accumulatePressure($pressure, $resourceFrom, $resourceTo, $sourceAmount, $targetAmount, $weight);
		}

		return $pressure;
	}

	protected function formatTraderRatio($value)
	{
		$value = (float) $value;
		if (abs($value - round($value)) < 0.001) {
			return number_format($value, 0, ',', ' ');
		}

		return number_format($value, 2, ',', ' ');
	}

	protected function buildTraderMarketData()
	{
		global $LNG;

		$pressure = $this->getResourcePressureSeed();
		$playerPressure = $this->getPlayerActivityPressure();
		$botPressure = $this->getBotActivityPressure();

		foreach ($pressure as $resourceId => &$resourcePressure) {
			foreach (array('incoming', 'outgoing', 'gross', 'net') as $key) {
				$resourcePressure[$key] = $playerPressure[$resourceId][$key] + $botPressure[$resourceId][$key];
			}
		}
		unset($resourcePressure);

		$premium = array();
		$marketOverview = array();
		foreach ($pressure as $resourceId => $resourcePressure) {
			$baseline = max(60000, $resourcePressure['gross'] * 1.55);
			$bias = $resourcePressure['net'] / $baseline;
			$bias = max(-0.18, min(0.18, $bias));
			$premium[$resourceId] = max(0.78, min(1.22, 1 - $bias));

			if ($bias <= -0.09) {
				$state = 'shortage';
				$label = 'Sous tension';
			} elseif ($bias >= 0.09) {
				$state = 'surplus';
				$label = 'Surplus';
			} else {
				$state = 'stable';
				$label = 'Stable';
			}

			$marketOverview[$resourceId] = array(
				'label' => $LNG['tech'][$resourceId],
				'state' => $state,
				'stateLabel' => $label,
				'incoming' => pretty_number((int) round($resourcePressure['incoming'])),
				'outgoing' => pretty_number((int) round($resourcePressure['outgoing'])),
				'biasPercent' => (int) round(abs($bias) * 100),
				'premium' => $premium[$resourceId],
			);
		}

		$charge = self::$Charge;
		$chargeDisplay = array();
		foreach (self::$Charge as $sourceId => $targets) {
			foreach ($targets as $targetId => $ratio) {
				if ($sourceId === $targetId) {
					$dynamicRatio = 1;
				} else {
					$dynamicRatio = $ratio * ($premium[$targetId] / max(0.78, $premium[$sourceId]));
					$dynamicRatio = max($ratio * 0.72, min($ratio * 1.38, $dynamicRatio));
				}

				$dynamicRatio = round($dynamicRatio, 2);
				$charge[$sourceId][$targetId] = $dynamicRatio;
				$chargeDisplay[$sourceId][$targetId] = $this->formatTraderRatio($dynamicRatio);
			}
		}

		return array(
			'charge' => $charge,
			'chargeDisplay' => $chargeDisplay,
			'marketOverview' => $marketOverview,
		);
	}

	protected function recordTraderActivity($userId, $resourceFrom, $resourceTo, $sourceAmount, $targetAmount, $effectiveRate)
	{
		$this->ensureTraderActivityTable();

		Database::get()->insert('INSERT INTO %%TRADER_ACTIVITY%% SET
			universe = :universe,
			actor_user_id = :actorUserId,
			is_bot = :isBot,
			resource_from = :resourceFrom,
			resource_to = :resourceTo,
			source_amount = :sourceAmount,
			target_amount = :targetAmount,
			effective_rate = :effectiveRate,
			created_at = :createdAt;', array(
				':universe' => Universe::getEmulated(),
				':actorUserId' => (int) $userId,
				':isBot' => 0,
				':resourceFrom' => (int) $resourceFrom,
				':resourceTo' => (int) $resourceTo,
				':sourceAmount' => (int) $sourceAmount,
				':targetAmount' => (int) $targetAmount,
				':effectiveRate' => number_format((float) $effectiveRate, 4, '.', ''),
				':createdAt' => TIMESTAMP,
			));
	}

	public function show()
	{
		global $LNG, $USER, $resource;

		$darkmatter_cost_trader	= Config::get()->darkmatter_cost_trader;
		$marketData = $this->buildTraderMarketData();

		$this->assign(array(
			'tr_cost_dm_trader'		=> sprintf($LNG['tr_cost_dm_trader'], pretty_number($darkmatter_cost_trader), $LNG['tech'][921]),
			'charge'				=> $marketData['charge'],
			'chargeDisplay'		=> $marketData['chargeDisplay'],
			'marketOverview'		=> $marketData['marketOverview'],
			'resource'				=> $resource,
			'requiredDarkMatter'	=> $USER['darkmatter'] < $darkmatter_cost_trader ? sprintf($LNG['tr_not_enought'], $LNG['tech'][921]) : false,
		));

		$this->display("page.trader.default.tpl");
	}

	function trade()
	{
		global $USER, $LNG, $resource;

		if ($USER['darkmatter'] < Config::get()->darkmatter_cost_trader) {
			$this->redirectTo('game.php?page=trader');
		}

		$resourceID	= HTTP::_GP('resource', 0);

		if(!in_array($resourceID, array_keys(self::$Charge))) {
			$this->printMessage($LNG['invalid_action'], array(array(
				'label'	=> $LNG['sys_back'],
				'url'	=> 'game.php?page=trader'
			)));
		}

		$marketData = $this->buildTraderMarketData();
		$tradeResources	= array_values(array_diff(array_keys(self::$Charge[$resourceID]), array($resourceID)));
		$this->tplObj->loadscript("trader.js");
		$this->assign(array(
			'tradeResourceID'	=> $resourceID,
			'tradeResources'	=> $tradeResources,
			'charge' 			=> $marketData['charge'][$resourceID],
			'chargeDisplay'		=> $marketData['chargeDisplay'][$resourceID],
			'marketOverview'		=> $marketData['marketOverview'],
			'resource'			=> $resource,
		));

		$this->display('page.trader.trade.tpl');
	}

	function send()
	{
		global $USER, $PLANET, $LNG, $resource;

		if ($USER['darkmatter'] < Config::get()->darkmatter_cost_trader) {
			$this->redirectTo('game.php?page=trader');
		}

		$resourceID	= HTTP::_GP('resource', 0);

		if(!in_array($resourceID, array_keys(self::$Charge))) {
			$this->printMessage($LNG['invalid_action'], array(array(
				'label'	=> $LNG['sys_back'],
				'url'	=> 'game.php?page=trader'
			)));
		}

		$marketData = $this->buildTraderMarketData();
		$chargeMatrix = $marketData['charge'];
		$getTradeResources	= HTTP::_GP('trade', array());
		$tradeResources		= array_values(array_diff(array_keys(self::$Charge[$resourceID]), array($resourceID)));
		$tradeRows			= array();
		$totalSourceAmount = 0;

		foreach($tradeResources as $tradeRessID)
		{
			if(!isset($getTradeResources[$tradeRessID]))
			{
				continue;
			}
			$tradeAmount	= max(0, round((float) $getTradeResources[$tradeRessID]));

			if(empty($tradeAmount) || !isset($chargeMatrix[$resourceID][$tradeRessID]))
			{
				continue;
			}

			$usedResources = (int) ceil($tradeAmount * $chargeMatrix[$resourceID][$tradeRessID]);
			$tradeRows[] = array(
				'resource_to' => $tradeRessID,
				'target_amount' => (int) $tradeAmount,
				'source_amount' => $usedResources,
				'effective_rate' => (float) $chargeMatrix[$resourceID][$tradeRessID],
			);
			$totalSourceAmount += $usedResources;
		}

		if (empty($tradeRows)) {
			$this->printMessage($LNG['invalid_action'], array(array(
				'label'	=> $LNG['sys_back'],
				'url'	=> 'game.php?page=trader'
			)));
		}

		if(isset($PLANET[$resource[$resourceID]]))
		{
			if($totalSourceAmount > $PLANET[$resource[$resourceID]])
			{
				$this->printMessage(sprintf($LNG['tr_not_enought'], $LNG['tech'][$resourceID]), array(array(
					'label'	=> $LNG['sys_back'],
					'url'	=> 'game.php?page=trader'
				)));
			}

			$PLANET[$resource[$resourceID]] -= $totalSourceAmount;
		}
		elseif(isset($USER[$resource[$resourceID]]))
		{
			if($totalSourceAmount > $USER[$resource[$resourceID]])
			{
				$this->printMessage(sprintf($LNG['tr_not_enought'], $LNG['tech'][$resourceID]), array(array(
					'label'	=> $LNG['sys_back'],
					'url'	=> 'game.php?page=trader'
				)));
			}

			$USER[$resource[$resourceID]] -= $totalSourceAmount;
		}
		else
		{
			throw new Exception('Unknown resource ID #'.$resourceID);
		}

		foreach ($tradeRows as $tradeRow)
		{
			$tradeRessID = $tradeRow['resource_to'];
			if(isset($PLANET[$resource[$tradeRessID]]))
			{
				$PLANET[$resource[$tradeRessID]] += $tradeRow['target_amount'];
			}
			elseif(isset($USER[$resource[$tradeRessID]]))
			{
				$USER[$resource[$tradeRessID]] += $tradeRow['target_amount'];
			}
			else
			{
				throw new Exception('Unknown resource ID #'.$tradeRessID);
			}

			$this->recordTraderActivity(
				$USER['id'],
				$resourceID,
				$tradeRessID,
				$tradeRow['source_amount'],
				$tradeRow['target_amount'],
				$tradeRow['effective_rate']
			);
		}

		$USER[$resource[921]] -= Config::get()->darkmatter_cost_trader;

		$this->printMessage($LNG['tr_exchange_done'], array(array(
			'label'	=> $LNG['sys_forward'],
			'url'	=> 'game.php?page=trader'
		)));
	}
}
