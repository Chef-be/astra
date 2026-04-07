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

define('DB_VERSION_REQUIRED', 12);
define('DB_NAME'			, $database['databasename']);
define('DB_PREFIX'			, $database['tableprefix']);

// Data Tabells
$dbTableNames	= array(
	'AKS'				=> DB_PREFIX.'aks',
	'ALLIANCE'			=> DB_PREFIX.'alliance',
	'ALLIANCE_RANK'		=> DB_PREFIX.'alliance_ranks',
	'ALLIANCE_REQUEST'	=> DB_PREFIX.'alliance_request',
	'BANNED'			=> DB_PREFIX.'banned',
	'BOT_ACTIVITY'		=> DB_PREFIX.'bot_activity',
	'BOT_ACCOUNT_COMPLIANCE' => DB_PREFIX.'bot_account_compliance',
	'BOT_ACTION_QUEUE'	=> DB_PREFIX.'bot_action_queue',
	'BOT_ACTION_RESULTS' => DB_PREFIX.'bot_action_results',
	'BOT_ALLIANCE_META' => DB_PREFIX.'bot_alliance_meta',
	'BOT_BONUS_ASSIGNMENTS' => DB_PREFIX.'bot_bonus_assignments',
	'BOT_BONUS_RULES'	=> DB_PREFIX.'bot_bonus_rules',
	'BOT_CAMPAIGNS'		=> DB_PREFIX.'bot_campaigns',
	'BOT_CAMPAIGN_MEMBERS' => DB_PREFIX.'bot_campaign_members',
	'BOT_COMMAND_CATALOG' => DB_PREFIX.'bot_command_catalog',
	'BOT_COMMANDS'		=> DB_PREFIX.'bot_commands',
	'BOT_DYNAMIC_STATE' => DB_PREFIX.'bot_dynamic_state',
	'BOT_ENGINE_CONFIG' => DB_PREFIX.'bot_engine_config',
	'BOT_ENGINE_RUNS'	=> DB_PREFIX.'bot_engine_runs',
	'BOT_MEMORY'		=> DB_PREFIX.'bot_memory',
	'BOT_MULTIACCOUNT_VALIDATION' => DB_PREFIX.'bot_multiaccount_validation',
	'BOT_PRESENCE_SNAPSHOTS' => DB_PREFIX.'bot_presence_snapshots',
	'BOT_PROFILES'		=> DB_PREFIX.'bot_profiles',
	'BOT_PRIVATE_MESSAGES' => DB_PREFIX.'bot_private_messages',
	'BOT_RELATIONSHIPS' => DB_PREFIX.'bot_relationships',
	'BOT_SOCIAL_MESSAGES' => DB_PREFIX.'bot_social_messages',
	'BOT_SQUADS'		=> DB_PREFIX.'bot_squads',
	'BOT_SQUAD_MEMBERS' => DB_PREFIX.'bot_squad_members',
	'BOT_STATE'			=> DB_PREFIX.'bot_state',
	'BOT_TRAITS'		=> DB_PREFIX.'bot_traits',
	'BUDDY'				=> DB_PREFIX.'buddy',
	'BUDDY_REQUEST'		=> DB_PREFIX.'buddy_request',
	'CHAT_BAN'			=> DB_PREFIX.'chat_bans',
	'CHAT_INV'			=> DB_PREFIX.'chat_invitations',
	'CHAT_MES'			=> DB_PREFIX.'chat_messages',
	'CHAT_ON'			=> DB_PREFIX.'chat_online',
	'CONFIG'			=> DB_PREFIX.'config',
	'CRONJOBS'			=> DB_PREFIX.'cronjobs',
	'CRONJOBS_LOG'		=> DB_PREFIX.'cronjobs_log',
	'DIPLO'				=> DB_PREFIX.'diplo',
	'TRADES'			=> DB_PREFIX.'trades',
	'FLEETS'			=> DB_PREFIX.'fleets',
	'FLEETS_EVENT'		=> DB_PREFIX.'fleet_event',
	'LOG'				=> DB_PREFIX.'log',
	'LOG_FLEETS'		=> DB_PREFIX.'log_fleets',
	'LOSTPASSWORD'		=> DB_PREFIX.'lostpassword',
	'LIVE_CHAT_MESSAGES' => DB_PREFIX.'live_chat_messages',
	'LIVE_CHAT_MUTES'	=> DB_PREFIX.'live_chat_mutes',
	'LIVE_CHAT_CHANNELS'	=> DB_PREFIX.'live_chat_channels',
	'NEWS'				=> DB_PREFIX.'news',
	'NOTES'				=> DB_PREFIX.'notes',
	'NOTIFICATIONS'		=> DB_PREFIX.'notifications',
	'MESSAGES'			=> DB_PREFIX.'messages',
	'MISSION_DEFINITIONS'	=> DB_PREFIX.'mission_definitions',
	'MISSION_REWARDS'	=> DB_PREFIX.'mission_rewards',
	'MULTI'				=> DB_PREFIX.'multi',
	'PLANETS'			=> DB_PREFIX.'planets',
	'RW'				=> DB_PREFIX.'raports',
	'RECORDS'			=> DB_PREFIX.'records',
	'SESSION'			=> DB_PREFIX.'session',
	'SHORTCUTS'			=> DB_PREFIX.'shortcuts',
	'SYSTEM'		    => DB_PREFIX.'system',
	'TICKETS'			=> DB_PREFIX.'ticket',
	'TICKETS_ANSWER'	=> DB_PREFIX.'ticket_answer',
	'TICKETS_CATEGORY'	=> DB_PREFIX.'ticket_category',
	'TOPKB'				=> DB_PREFIX.'topkb',
	'TOPKB_USERS'		=> DB_PREFIX.'users_to_topkb',
	'USERS'				=> DB_PREFIX.'users',
	'USER_MISSIONS'		=> DB_PREFIX.'user_missions',
	'USERS_ACS'			=> DB_PREFIX.'users_to_acs',
	'USERS_AUTH'		=> DB_PREFIX.'users_to_extauth',
	'USERS_VALID'	 	=> DB_PREFIX.'users_valid',
	'USER_POINTS' => DB_PREFIX.'user_points',
	'ALLIANCE_POINTS' => DB_PREFIX.'alliance_points',
	'VARS'	 			=> DB_PREFIX.'vars',
	'VARS_RAPIDFIRE'	=> DB_PREFIX.'vars_rapidfire',
	'VARS_REQUIRE'	 	=> DB_PREFIX.'vars_requriements',
	'REMEMBER_ME' => DB_PREFIX.'remember_me',
	'COLONY_SETTINGS' => DB_PREFIX.'colony_settings',
);
// MOD-TABLES
