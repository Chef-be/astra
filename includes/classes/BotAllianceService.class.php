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

	public function refreshAllianceGovernance($limit = 12)
	{
		$db = Database::get();
		$metas = $db->select('SELECT *
			FROM %%BOT_ALLIANCE_META%%
			WHERE universe = :universe
			ORDER BY id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':limit' => max(1, (int) $limit),
			));

		$updated = 0;
		foreach ($metas as $meta) {
			$memberStats = $db->selectSingle('SELECT
					COUNT(*) AS total_bots,
					SUM(CASE WHEN bs.hierarchy_status = \'chef\' THEN 1 ELSE 0 END) AS commanders,
					SUM(CASE WHEN bs.presence_logical IN (\'connecte\', \'engage\', \'alerte\', \'coordination\', \'campagne\', \'harcelement\') THEN 1 ELSE 0 END) AS active_bots,
					SUM(CASE WHEN bs.is_socially_visible = 1 THEN 1 ELSE 0 END) AS visible_bots
				FROM %%USERS%% u
				LEFT JOIN %%BOT_STATE%% bs ON bs.bot_user_id = u.id
				WHERE u.universe = :universe
				  AND u.is_bot = 1
				  AND u.ally_id = :allianceId;', array(
					':universe' => Universe::getEmulated(),
					':allianceId' => (int) $meta['alliance_id'],
				));

			$territories = $db->select('SELECT pl.galaxy, pl.`system`, COUNT(*) AS total
				FROM %%USERS%% u
				INNER JOIN %%PLANETS%% pl ON pl.id = u.id_planet
				WHERE u.universe = :universe
				  AND u.is_bot = 1
				  AND u.ally_id = :allianceId
				GROUP BY pl.galaxy, pl.`system`
				ORDER BY total DESC, pl.galaxy ASC, pl.`system` ASC
				LIMIT 6;', array(
					':universe' => Universe::getEmulated(),
					':allianceId' => (int) $meta['alliance_id'],
				));

			$activeCampaigns = $db->select('SELECT id, campaign_code, campaign_type, target_reference, zone_reference, intensity, updated_at, payload_json
				FROM %%BOT_CAMPAIGNS%%
				WHERE universe = :universe
				  AND status = \'active\'
				  AND (
					responsible_alliance_meta_id = :metaId
					OR responsible_bot_user_id IN (
						SELECT id FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND ally_id = :allianceId
					)
				  )
				ORDER BY updated_at DESC
				LIMIT 8;', array(
					':universe' => Universe::getEmulated(),
					':metaId' => (int) $meta['id'],
					':allianceId' => (int) $meta['alliance_id'],
				));

			$currentDiplomacy = $this->decodeJson(isset($meta['diplomacy_json']) ? $meta['diplomacy_json'] : null);
			$currentObjectives = $this->decodeJson(isset($meta['objective_json']) ? $meta['objective_json'] : null);
			$currentCommandState = $this->decodeJson(isset($meta['command_state_json']) ? $meta['command_state_json'] : null);

			$territorialCore = array();
			foreach ($territories as $territory) {
				$territorialCore[] = array(
					'zone' => sprintf('%d:%d', $territory['galaxy'], $territory['system']),
					'total_bots' => (int) $territory['total'],
				);
			}

			$campaignTypes = array();
			$focusTargets = array();
			$activeIntensity = 0;
			foreach ($activeCampaigns as $campaign) {
				$campaignTypes[] = $campaign['campaign_type'];
				$focusTargets[] = $campaign['target_reference'] !== '' ? $campaign['target_reference'] : $campaign['zone_reference'];
				$activeIntensity += (int) $campaign['intensity'];
			}

			$campaignCount = count($activeCampaigns);
			$averageIntensity = $campaignCount > 0 ? (int) round($activeIntensity / $campaignCount) : 0;
			$tensionLevel = min(100,
				($campaignCount * 18)
				+ ((int) $memberStats['commanders'] * 6)
				+ min(25, (int) round(((int) $memberStats['active_bots']) / 2))
				+ min(20, (int) round($averageIntensity / 5))
			);

			$diplomacy = array(
				'posture' => $campaignCount > 0 ? 'offensive' : (!empty($territorialCore) ? 'territoriale' : 'attente'),
				'tension_level' => $tensionLevel,
				'focused_targets' => array_values(array_unique(array_filter($focusTargets))),
				'dominant_modes' => array_values(array_unique(array_filter($campaignTypes))),
				'visible_pressure' => min(100, ($campaignCount * 15) + ((int) $memberStats['visible_bots'] * 2)),
				'last_refresh_at' => TIMESTAMP,
			);

			if (!empty($currentDiplomacy) && is_array($currentDiplomacy)) {
				$diplomacy = array_merge($currentDiplomacy, $diplomacy);
			}

			$objectives = array(
				'goals' => array_values(array_unique(array_filter(array_merge(
					isset($currentObjectives['goals']) && is_array($currentObjectives['goals']) ? $currentObjectives['goals'] : array(),
					$campaignTypes,
					empty($territorialCore) ? array('croissance') : array('domination_zone')
				)))),
				'territorial_focus' => !empty($territorialCore[0]) ? $territorialCore[0]['zone'] : '',
				'focus_targets' => array_slice(array_values(array_unique(array_filter($focusTargets))), 0, 4),
				'updated_at' => TIMESTAMP,
			);

			$commandState = array(
				'active_campaigns' => $campaignCount,
				'active_commanders' => (int) $memberStats['commanders'],
				'active_bots' => (int) $memberStats['active_bots'],
				'visible_bots' => (int) $memberStats['visible_bots'],
				'average_intensity' => $averageIntensity,
				'dominant_zone' => !empty($territorialCore[0]) ? $territorialCore[0]['zone'] : '',
				'last_refresh_at' => TIMESTAMP,
			);

			if (!empty($currentCommandState) && is_array($currentCommandState)) {
				$commandState = array_merge($currentCommandState, $commandState);
			}

			$db->update('UPDATE %%BOT_ALLIANCE_META%% SET
				territorial_core_json = :territory,
				diplomacy_json = :diplomacy,
				objective_json = :objectives,
				command_state_json = :commandState,
				updated_at = :updatedAt
				WHERE id = :id;', array(
					':territory' => json_encode($territorialCore),
					':diplomacy' => json_encode($diplomacy),
					':objectives' => json_encode($objectives),
					':commandState' => json_encode($commandState),
					':updatedAt' => TIMESTAMP,
					':id' => (int) $meta['id'],
				));
			$updated++;
		}

		return array(
			'alliances' => count($metas),
			'updated' => $updated,
		);
	}

	public function getAllianceSummaries($limit = 8)
	{
		$rows = Database::get()->select('SELECT bam.*, a.ally_tag, a.ally_name
			FROM %%BOT_ALLIANCE_META%% bam
			LEFT JOIN %%ALLIANCE%% a ON a.id = bam.alliance_id
			WHERE bam.universe = :universe
			ORDER BY bam.updated_at DESC, bam.id ASC
			LIMIT :limit;', array(
				':universe' => Universe::getEmulated(),
				':limit' => max(1, (int) $limit),
			));

		foreach ($rows as &$row) {
			$row['territorial_core'] = $this->decodeJson(isset($row['territorial_core_json']) ? $row['territorial_core_json'] : null);
			$row['diplomacy'] = $this->decodeJson(isset($row['diplomacy_json']) ? $row['diplomacy_json'] : null);
			$row['objectives'] = $this->decodeJson(isset($row['objective_json']) ? $row['objective_json'] : null);
			$row['command_state'] = $this->decodeJson(isset($row['command_state_json']) ? $row['command_state_json'] : null);
		}
		unset($row);

		return $rows;
	}

	protected function decodeJson($json)
	{
		if (empty($json)) {
			return array();
		}

		$decoded = json_decode($json, true);
		return is_array($decoded) ? $decoded : array();
	}
}
