{block name="content"}

<div class="container-fluid py-4 text-white">
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
    <div>
      <h1 class="h3 mb-1">Moteur bots Astra</h1>
      <p class="text-white-50 mb-0">Pilotage de la présence, campagnes offensives, commandes structurées et conformité des comptes bots.</p>
    </div>
    <div class="d-flex gap-2 flex-wrap">
      <a class="btn btn-outline-success btn-sm" href="?page=bots&mode=runEngine&phase=cycle&limit=18">Cycle complet</a>
      <a class="btn btn-outline-warning btn-sm" href="?page=bots&mode=runEngine&phase=campaigns&limit=12">Campagnes</a>
      <a class="btn btn-outline-info btn-sm" href="?page=bots&mode=runEngine&phase=maintenance&limit=24">Maintenance</a>
      <a class="btn btn-outline-light btn-sm" href="?page=bots&mode=create">Création de bots</a>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-6 col-lg-3">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="small text-white-50">Bots totaux</div>
          <div class="fs-3 fw-bold">{$botSnapshot.metrics.total_bots}</div>
          <div class="small text-white-50 mt-2">Actifs 15 min : {$botSnapshot.metrics.active_bots}</div>
        </div>
      </div>
    </div>
    <div class="col-6 col-lg-3">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="small text-white-50">Présence</div>
          <div class="fs-3 fw-bold">{$botSnapshot.metrics.logical_connected}</div>
          <div class="small text-white-50 mt-2">Visibles socialement : {$botSnapshot.metrics.social_visible}</div>
        </div>
      </div>
    </div>
    <div class="col-6 col-lg-3">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="small text-white-50">Commandement</div>
          <div class="fs-3 fw-bold">{$botSnapshot.metrics.active_commanders}</div>
          <div class="small text-white-50 mt-2">Campagnes actives : {$botSnapshot.metrics.active_campaigns}</div>
        </div>
      </div>
    </div>
    <div class="col-6 col-lg-3">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="small text-white-50">Anomalies</div>
          <div class="fs-3 fw-bold">{$botSnapshot.metrics.failed_actions + $botSnapshot.metrics.rejected_orders + $botSnapshot.metrics.compliance_issues}</div>
          <div class="small text-white-50 mt-2">Actions en file : {$botSnapshot.metrics.queued_actions}</div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-xl-7">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Paramètres globaux</h2>
          <form action="?page=bots&mode=saveConfig" method="post" class="row g-3">
            <div class="col-md-4">
              <label class="form-label" for="target_online_total">Cible globale présence</label>
              <input id="target_online_total" class="form-control bg-dark text-white border-secondary" type="number" min="0" name="target_online_total" value="{$botSnapshot.config.target_online_total}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="target_social_total">Cible sociale</label>
              <input id="target_social_total" class="form-control bg-dark text-white border-secondary" type="number" min="0" name="target_social_total" value="{$botSnapshot.config.target_social_total}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="action_budget_per_cycle">Budget actions par cycle</label>
              <input id="action_budget_per_cycle" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="action_budget_per_cycle" value="{$botSnapshot.config.action_budget_per_cycle}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="max_bots_per_cycle">Bots par cycle</label>
              <input id="max_bots_per_cycle" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="max_bots_per_cycle" value="{$botSnapshot.config.max_bots_per_cycle}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="max_actions_per_bot">Actions max par bot</label>
              <input id="max_actions_per_bot" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="max_actions_per_bot" value="{$botSnapshot.config.max_actions_per_bot}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="shared_email">Adresse mail commune</label>
              <input id="shared_email" class="form-control bg-dark text-white border-secondary" type="email" name="shared_email" value="{$botSnapshot.config.shared_email|escape}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="password_policy">Politique mots de passe</label>
              <input id="password_policy" class="form-control bg-dark text-white border-secondary" type="text" name="password_policy" value="{$botSnapshot.config.password_policy|escape}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="multiaccount_policy">Politique multi-comptes</label>
              <input id="multiaccount_policy" class="form-control bg-dark text-white border-secondary" type="text" name="multiaccount_policy" value="{$botSnapshot.config.multiaccount_policy|escape}">
            </div>
            <div class="col-md-2">
              <label class="form-label" for="default_bot_alliance_tag">Tag alliance</label>
              <input id="default_bot_alliance_tag" class="form-control bg-dark text-white border-secondary" type="text" name="default_bot_alliance_tag" value="{$botSnapshot.config.default_bot_alliance_tag|escape}">
            </div>
            <div class="col-md-6">
              <label class="form-label" for="default_bot_alliance_name">Nom alliance</label>
              <input id="default_bot_alliance_name" class="form-control bg-dark text-white border-secondary" type="text" name="default_bot_alliance_name" value="{$botSnapshot.config.default_bot_alliance_name|escape}">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="engine_enabled">Activation moteur</label>
              <div class="form-check mt-2">
                <input id="engine_enabled" class="form-check-input" type="checkbox" name="engine_enabled" {if $botSnapshot.config.engine_enabled}checked="checked"{/if}>
                <label class="form-check-label" for="engine_enabled">Moteur actif</label>
              </div>
            </div>
            <div class="col-md-4">
              <div class="form-check mt-4 pt-2">
                <input id="enable_bot_alliances" class="form-check-input" type="checkbox" name="enable_bot_alliances" {if $botSnapshot.config.enable_bot_alliances}checked="checked"{/if}>
                <label class="form-check-label" for="enable_bot_alliances">Alliances bots actives</label>
              </div>
              <div class="form-check mt-2">
                <input id="enable_command_hierarchy" class="form-check-input" type="checkbox" name="enable_command_hierarchy" {if $botSnapshot.config.enable_command_hierarchy}checked="checked"{/if}>
                <label class="form-check-label" for="enable_command_hierarchy">Commandement actif</label>
              </div>
            </div>
            <div class="col-md-4">
              <div class="form-check mt-4 pt-2">
                <input id="enable_private_messages" class="form-check-input" type="checkbox" name="enable_private_messages" {if $botSnapshot.config.enable_private_messages}checked="checked"{/if}>
                <label class="form-check-label" for="enable_private_messages">Messagerie privée</label>
              </div>
              <div class="form-check mt-2">
                <input id="enable_social_messages" class="form-check-input" type="checkbox" name="enable_social_messages" {if $botSnapshot.config.enable_social_messages}checked="checked"{/if}>
                <label class="form-check-label" for="enable_social_messages">Messagerie chat</label>
              </div>
              <div class="form-check mt-2">
                <input id="enable_campaigns" class="form-check-input" type="checkbox" name="enable_campaigns" {if $botSnapshot.config.enable_campaigns}checked="checked"{/if}>
                <label class="form-check-label" for="enable_campaigns">Campagnes continues</label>
              </div>
            </div>
            <div class="col-12">
              <label class="form-label" for="global_presence_rules_json">Règles de présence JSON</label>
              <textarea id="global_presence_rules_json" class="form-control bg-dark text-white border-secondary" rows="4" name="global_presence_rules_json">{$botSnapshot.config.global_presence_rules_json|@json_encode}</textarea>
            </div>
            <div class="col-12">
              <label class="form-label" for="decision_weights_json">Pondérations décisionnelles JSON</label>
              <textarea id="decision_weights_json" class="form-control bg-dark text-white border-secondary" rows="6" name="decision_weights_json">{$botSnapshot.config.decision_weights_json|@json_encode}</textarea>
            </div>
            <div class="col-12">
              <button class="btn btn-primary" type="submit">Enregistrer la configuration</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="col-12 col-xl-5">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Nouveau profil</h2>
          <form action="?page=bots&mode=saveProfile" method="post" class="row g-3">
            <div class="col-md-6">
              <label class="form-label" for="name">Nom du profil</label>
              <input id="name" class="form-control bg-dark text-white border-secondary" name="name" type="text">
            </div>
            <div class="col-md-6">
              <label class="form-label" for="profile_code">Code profil</label>
              <input id="profile_code" class="form-control bg-dark text-white border-secondary" name="profile_code" type="text">
            </div>
            <div class="col-md-6">
              <label class="form-label" for="doctrine">Doctrine</label>
              <input id="doctrine" class="form-control bg-dark text-white border-secondary" name="doctrine" type="text" value="equilibre">
            </div>
            <div class="col-md-6">
              <label class="form-label" for="role_primary">Rôle principal</label>
              <input id="role_primary" class="form-control bg-dark text-white border-secondary" name="role_primary" type="text" value="economiste">
            </div>
            <div class="col-12">
              <label class="form-label" for="description">Description</label>
              <textarea id="description" class="form-control bg-dark text-white border-secondary" name="description" rows="2"></textarea>
            </div>
            <div class="col-md-4">
              <label class="form-label" for="target_online">Présence logique</label>
              <input id="target_online" class="form-control bg-dark text-white border-secondary" name="target_online" type="number" min="0" value="5">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="target_social_online">Présence sociale</label>
              <input id="target_social_online" class="form-control bg-dark text-white border-secondary" name="target_social_online" type="number" min="0" value="1">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="communication_style">Style de communication</label>
              <input id="communication_style" class="form-control bg-dark text-white border-secondary" name="communication_style" type="text" value="mesure">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="aggression">Agressivité</label>
              <input id="aggression" class="form-control bg-dark text-white border-secondary" name="aggression" type="number" min="0" max="100" value="35">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="economy_focus">Économie</label>
              <input id="economy_focus" class="form-control bg-dark text-white border-secondary" name="economy_focus" type="number" min="0" max="100" value="55">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="expansion_focus">Expansion</label>
              <input id="expansion_focus" class="form-control bg-dark text-white border-secondary" name="expansion_focus" type="number" min="0" max="100" value="40">
            </div>
            <div class="col-12">
              <label class="form-label" for="traits_json">Traits JSON facultatifs</label>
              <textarea id="traits_json" class="form-control bg-dark text-white border-secondary" name="traits_json" rows="3">{}</textarea>
            </div>
            <div class="col-12 d-flex flex-wrap gap-3">
              <div class="form-check">
                <input id="always_active" class="form-check-input" type="checkbox" name="always_active">
                <label class="form-check-label" for="always_active">Toujours actif</label>
              </div>
              <div class="form-check">
                <input id="is_visible_socially" class="form-check-input" type="checkbox" name="is_visible_socially" checked="checked">
                <label class="form-check-label" for="is_visible_socially">Visible socialement</label>
              </div>
              <div class="form-check">
                <input id="is_commander_profile" class="form-check-input" type="checkbox" name="is_commander_profile">
                <label class="form-check-label" for="is_commander_profile">Profil chef</label>
              </div>
              <div class="form-check">
                <input id="is_active" class="form-check-input" type="checkbox" name="is_active" checked="checked">
                <label class="form-check-label" for="is_active">Actif</label>
              </div>
            </div>
            <div class="col-12">
              <button class="btn btn-outline-primary" type="submit">Créer le profil</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-lg-4">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Répartition par profil</h2>
          <div class="table-responsive">
            <table class="table table-dark table-sm align-middle mb-0">
              <tbody>
                {foreach from=$botSnapshot.profile_distribution item=item}
                  <tr>
                    <td>{$item.label}</td>
                    <td class="text-end">{$item.total}</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-lg-4">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Répartition par alliance</h2>
          <div class="table-responsive">
            <table class="table table-dark table-sm align-middle mb-0">
              <tbody>
                {foreach from=$botSnapshot.alliance_distribution item=item}
                  <tr>
                    <td>{$item.label}</td>
                    <td class="text-end">{$item.total}</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-lg-4">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Répartition par système</h2>
          <div class="table-responsive">
            <table class="table table-dark table-sm align-middle mb-0">
              <tbody>
                {foreach from=$botSnapshot.galaxy_distribution item=item}
                  <tr>
                    <td>{$item.label}</td>
                    <td class="text-end">{$item.total}</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 mb-0">Campagnes en cours</h2>
            <span class="badge bg-secondary">{$botSnapshot.metrics.active_campaigns}</span>
          </div>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Code</th>
                  <th>Type</th>
                  <th>Cible</th>
                  <th>Intensité</th>
                  <th>Mise à jour</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.campaigns item=campaign}
                  <tr>
                    <td>{$campaign.campaign_code}</td>
                    <td>{$campaign.campaign_type}</td>
                    <td>{$campaign.target_reference|default:$campaign.zone_reference}</td>
                    <td>{$campaign.intensity}</td>
                    <td>{$campaign.updated_at_formatted}</td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="5" class="text-white-50">Aucune campagne active.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 mb-0">Ordres récents</h2>
            <a class="btn btn-outline-light btn-sm" href="game.php?page=chat">Console bots</a>
          </div>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Commande</th>
                  <th>État</th>
                  <th>Réponse</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.orders item=order}
                  <tr>
                    <td><code>{$order.command_text|escape}</code></td>
                    <td>{$order.status}</td>
                    <td>{$order.response_text|default:'-'}</td>
                    <td>{$order.created_at_formatted}</td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="4" class="text-white-50">Aucun ordre structuré enregistré.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Activité récente</h2>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Type</th>
                  <th>Résumé</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.activity item=activity}
                  <tr>
                    <td>{$activity.created_at_formatted}</td>
                    <td>{$activity.activity_type}</td>
                    <td>{$activity.activity_summary}</td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="3" class="text-white-50">Aucune activité journalisée.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Runs moteur</h2>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Phase</th>
                  <th>État</th>
                  <th>Bots</th>
                  <th>Actions</th>
                  <th>Début</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.metrics.latest_runs item=run}
                  <tr>
                    <td>{$run.phase}</td>
                    <td>{$run.status}</td>
                    <td>{$run.selected_bots}</td>
                    <td>{$run.executed_actions}</td>
                    <td>{$run.started_at_formatted}</td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="5" class="text-white-50">Aucun run enregistré.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Actions planifiées</h2>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Bot</th>
                  <th>Action</th>
                  <th>Échéance</th>
                  <th>Priorité</th>
                  <th>État</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.upcoming item=item}
                  <tr>
                    <td>{$item.username|default:'Bot système'}</td>
                    <td>{$item.action_type}</td>
                    <td>{$item.due_at_formatted}</td>
                    <td>{$item.priority}</td>
                    <td>{$item.status}</td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="5" class="text-white-50">Aucune action planifiée.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Catalogue des commandes</h2>
          <div class="table-responsive">
            <table class="table table-dark table-sm align-middle mb-0">
              <thead>
                <tr>
                  <th>Famille</th>
                  <th>Commande</th>
                  <th>Exemple</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.command_catalog item=item}
                  <tr>
                    <td>{$item.family_key}</td>
                    <td>{$item.command_key}</td>
                    <td><code>{$item.syntax_example|escape}</code></td>
                  </tr>
                {foreachelse}
                  <tr>
                    <td colspan="3" class="text-white-50">Catalogue indisponible.</td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3">
    <div class="col-12">
      <div class="card bg-dark border-secondary">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 mb-0">Roster bots</h2>
            <div class="small text-white-50">Mass actions: pause, reprise, promotion chef, régénération de mots de passe, validation multi-compte.</div>
          </div>

          <form action="?page=bots&mode=massAction" method="post">
            <div class="row g-2 align-items-end mb-3">
              <div class="col-md-4">
                <label class="form-label" for="mass_action">Action de masse</label>
                <select id="mass_action" class="form-select bg-dark text-white border-secondary" name="mass_action">
                  <option value="pause">Pause 30 min</option>
                  <option value="resume">Reprendre</option>
                  <option value="promote">Promouvoir chef</option>
                  <option value="rotate-passwords">Régénérer mots de passe</option>
                  <option value="validate-multi">Valider multi-compte</option>
                </select>
              </div>
              <div class="col-md-3">
                <button class="btn btn-outline-warning" type="submit">Appliquer aux bots cochés</button>
              </div>
            </div>

            <div class="table-responsive">
              <table class="table table-dark table-striped align-middle mb-0">
                <thead>
                  <tr>
                    <th></th>
                    <th>Bot</th>
                    <th>Profil</th>
                    <th>Présence</th>
                    <th>Alliance</th>
                    <th>Coordonnées</th>
                    <th>Chef</th>
                    <th>Conformité</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$botSnapshot.bot_roster item=bot}
                    <tr>
                      <td><input class="form-check-input" type="checkbox" name="bot_ids[]" value="{$bot.id}"></td>
                      <td>
                        <div class="fw-bold">{$bot.username}</div>
                        <div class="small text-white-50">{$bot.email}</div>
                      </td>
                      <td>{$bot.profile_name|default:'Sans profil'}</td>
                      <td>
                        <div>{$bot.presence_logical|default:'latent'}</div>
                        <div class="small text-white-50">{$bot.presence_social|default:'discret'}</div>
                      </td>
                      <td>{$bot.ally_tag|default:'-'}</td>
                      <td>{$bot.galaxy}:{$bot.system}:{$bot.planet}</td>
                      <td>{if $bot.hierarchy_status == 'chef'}Oui{else}Non{/if}</td>
                      <td>
                        <div>{$bot.compliance_status|default:'-'}</div>
                        <div class="small text-white-50">{$bot.validation_status|default:'-'}</div>
                      </td>
                    </tr>
                  {foreachelse}
                    <tr>
                      <td colspan="8" class="text-white-50">Aucun bot disponible.</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

{/block}
