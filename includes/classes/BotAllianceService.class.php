<?php

class BotAllianceService
{
	public function ensureDefaultAlliance(array $config)
	{
		if (empty($config['enable_bot_alliances'])) {
			return null;
		}

		$db = Database::get();
		$meta = $db->selectSingle('SELECT *
			FROM %%BOT_ALLIANCE_META%%
			WHERE universe = :universe AND meta_tag = :tag
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':tag' => $config['default_bot_alliance_tag'],
			));

		if (!empty($meta)) {
			return $meta;
		}

		$alliance = $db->selectSingle('SELECT id
			FROM %%ALLIANCE%%
			WHERE ally_universe = :universe AND ally_tag = :tag
			LIMIT 1;', array(
				':universe' => Universe::getEmulated(),
				':tag' => $config['default_bot_alliance_tag'],
			));

		$allianceId = null;
		if (empty($alliance)) {
			$db->insert('INSERT INTO %%ALLIANCE%% SET
				ally_name = :name,
				ally_tag = :tag,
				ally_owner = 0,
				ally_owner_range = :ownerRange,
				ally_members = 0,
				ally_register_time = :registerTime,
				ally_universe = :universe,
				ally_description = :description,
				ally_text = :text,
				ally_request = :request,
				ally_events = :events;', array(
					':name' => $config['default_bot_alliance_name'],
					':tag' => $config['default_bot_alliance_tag'],
					':ownerRange' => 'État-major bots',
					':registerTime' => TIMESTAMP,
					':universe' => Universe::getEmulated(),
					':description' => 'Alliance gérée par le moteur bots Astra.',
					':text' => 'Alliance automatisée dédiée aux campagnes et à la coordination.',
					':request' => 'Recrutement géré automatiquement.',
					':events' => '1,3,4,5,6,7,8,9,10,15',
				));
			$allianceId = (int) $db->lastInsertId();
		} else {
			$allianceId = (int) $alliance['id'];
		}

		$db->insert('INSERT INTO %%BOT_ALLIANCE_META%% SET
			universe = :universe,
			alliance_id = :allianceId,
			meta_tag = :tag,
			meta_name = :name,
			doctrine = :doctrine,
			territorial_core_json = :territory,
			diplomacy_json = :diplomacy,
			objective_json = :objectives,
			recruitment_policy = :recruitmentPolicy,
			communication_policy = :communicationPolicy,
			command_state_json = :commandState,
			created_at = :createdAt,
			updated_at = :updatedAt;', array(
				':universe' => Universe::getEmulated(),
				':allianceId' => $allianceId,
				':tag' => $config['default_bot_alliance_tag'],
				':name' => $config['default_bot_alliance_name'],
				':doctrine' => 'pression_continue',
				':territory' => json_encode(array()),
				':diplomacy' => json_encode(array()),
				':objectives' => json_encode(array('croissance', 'pression_locale')),
				':recruitmentPolicy' => 'automatique',
				':communicationPolicy' => 'visible',
				':commandState' => json_encode(array()),
				':createdAt' => TIMESTAMP,
				':updatedAt' => TIMESTAMP,
			));

		return $db->selectSingle('SELECT * FROM %%BOT_ALLIANCE_META%% WHERE universe = :universe AND meta_tag = :tag LIMIT 1;', array(
			':universe' => Universe::getEmulated(),
			':tag' => $config['default_bot_alliance_tag'],
		));
	}

	public function assignBotToAlliance($botUserId, $allianceId)
	{
		Database::get()->update('UPDATE %%USERS%% SET ally_id = :allianceId, ally_rank_id = 0, ally_register_time = :registerTime WHERE id = :botUserId AND is_bot = 1;', array(
			':allianceId' => empty($allianceId) ? 0 : (int) $allianceId,
			':registerTime' => TIMESTAMP,
			':botUserId' => (int) $botUserId,
		));

		Database::get()->update('UPDATE %%BOT_STATE%% SET alliance_id = :allianceId, updated_at = :updatedAt WHERE bot_user_id = :botUserId;', array(
			':allianceId' => empty($allianceId) ? null : (int) $allianceId,
			':updatedAt' => TIMESTAMP,
			':botUserId' => (int) $botUserId,
		));
	}
}
