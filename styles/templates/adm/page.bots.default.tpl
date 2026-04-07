{block name="content"}

<div class="container-fluid py-4 bots-admin-page">
  <section class="admin-hero bots-hero mb-4">
    <div class="bots-hero__content">
      <span class="admin-hero__eyebrow">Commandement bots</span>
      <h1 class="admin-hero__title">Moteur bots Astra</h1>
      <p class="admin-hero__description">
        Console d’exploitation du moteur IA, de la présence continue, des campagnes, de la messagerie et de la conformité.
        La permanence n’est plus seulement un quota : la relève et les fenêtres de session sont maintenant exposées directement ici.
      </p>
      <div class="admin-hero__meta">
        <span class="admin-hero__chip">Moteur <strong>{if $botSnapshot.config.engine_enabled}actif{else}désactivé{/if}</strong></span>
        <span class="admin-hero__chip">Cible horaire <strong>{$botSnapshot.metrics.target_online_current}</strong></span>
        <span class="admin-hero__chip">Visible socialement <strong>{$botSnapshot.metrics.target_social_current}</strong></span>
        <span class="admin-hero__chip">Ancrage <strong>{$botSnapshot.metrics.forced_online}</strong></span>
        <span class="admin-hero__chip">Relève active <strong>{$botSnapshot.metrics.rotation_online}</strong></span>
        <span class="admin-hero__chip">Repos <strong>{$botSnapshot.metrics.resting_bots}</strong></span>
      </div>
    </div>

    <div class="bots-hero__actions">
      <a class="btn btn-success btn-sm" href="?page=bots&mode=runEngine&phase=cycle&limit=18">Lancer un cycle complet</a>
      <a class="btn btn-outline-warning btn-sm" href="?page=bots&mode=runEngine&phase=campaigns&limit=12">Relancer les campagnes</a>
      <a class="btn btn-outline-info btn-sm" href="?page=bots&mode=runEngine&phase=maintenance&limit=24">Exécuter la maintenance</a>
      <a class="btn btn-outline-light btn-sm" href="?page=bots&mode=create">Créer des bots</a>
      <a class="btn btn-outline-light btn-sm" href="game.php?page=chat">Ouvrir la console bots</a>
      <a class="btn btn-outline-light btn-sm" href="#roster">Aller au roster</a>
    </div>
  </section>

  <section class="mb-4">
    <div class="bots-kpi-grid">
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Population</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.total_bots}</div>
          <div class="bots-kpi-card__meta">Actifs 15 min : {$botSnapshot.metrics.active_bots}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Présence logique</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.logical_connected}</div>
          <div class="bots-kpi-card__meta">Cible courante : {$botSnapshot.metrics.target_online_current}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Présence sociale</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.social_visible}</div>
          <div class="bots-kpi-card__meta">Cible sociale : {$botSnapshot.metrics.target_social_current}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Commandement</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.active_commanders}</div>
          <div class="bots-kpi-card__meta">Campagnes actives : {$botSnapshot.metrics.active_campaigns}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">File d’actions</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.queued_actions}</div>
          <div class="bots-kpi-card__meta">Ordres en attente : {$botSnapshot.metrics.pending_orders}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card bots-kpi-card--alert">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Anomalies</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.failed_actions + $botSnapshot.metrics.rejected_orders + $botSnapshot.metrics.compliance_issues}</div>
          <div class="bots-kpi-card__meta">Relèves dues bientôt : {$botSnapshot.metrics.relay_due_soon}</div>
        </div>
      </article>
    </div>
  </section>

  <section class="row g-4 mb-4">
    <div class="col-12 col-xxl-8">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Permanence et relève</h2>
              <p class="bots-section-text">Vue opérationnelle de la continuité réelle : noyau d’ancrage, bots en relais, bots au repos et sessions à relever.</p>
            </div>
            <span class="bots-pill">Cible courante {$botSnapshot.metrics.target_online_current}</span>
          </div>

          <div class="bots-presence-overview">
            <div class="bots-presence-stat">
              <span class="bots-presence-stat__label">En ligne</span>
              <strong class="bots-presence-stat__value">{$botSnapshot.metrics.logical_connected}</strong>
              <span class="bots-presence-stat__meta">sur {$botSnapshot.metrics.target_online_current}</span>
            </div>
            <div class="bots-presence-stat">
              <span class="bots-presence-stat__label">Ancrage permanent</span>
              <strong class="bots-presence-stat__value">{$botSnapshot.metrics.forced_online}</strong>
              <span class="bots-presence-stat__meta">chefs, campagnes, profils forcés</span>
            </div>
            <div class="bots-presence-stat">
              <span class="bots-presence-stat__label">Relève active</span>
              <strong class="bots-presence-stat__value">{$botSnapshot.metrics.rotation_online}</strong>
              <span class="bots-presence-stat__meta">bots tournants actuellement connectés</span>
            </div>
            <div class="bots-presence-stat">
              <span class="bots-presence-stat__label">Repos</span>
              <strong class="bots-presence-stat__value">{$botSnapshot.metrics.resting_bots}</strong>
              <span class="bots-presence-stat__meta">fenêtres de repos en cours</span>
            </div>
          </div>

          <div class="row g-3">
            <div class="col-12 col-xl-6">
              <div class="bots-panel">
                <div class="bots-panel__head">
                  <h3 class="bots-panel__title">Bots actuellement en ligne</h3>
                  <span class="small text-white-50">Sessions à relever en priorité en haut</span>
                </div>
                <div class="bots-mini-table">
                  {foreach from=$botSnapshot.online_roster item=bot}
                    <div class="bots-mini-table__row">
                      <div>
                        <div class="fw-bold">{$bot.username}</div>
                        <div class="small text-white-50">{$bot.profile_name|default:'Sans profil'} · {$bot.presence_logical_label|default:'En veille'}</div>
                      </div>
                      <div class="text-end">
                        <div class="bots-pill">{if $bot.is_online_forced}ancrage{else}{$bot.session_target_in_label}{/if}</div>
                        <div class="small text-white-50 mt-1">{$bot.session_target_until_formatted|default:'session ouverte'}</div>
                      </div>
                    </div>
                  {foreachelse}
                    <div class="text-white-50">Aucun bot en ligne.</div>
                  {/foreach}
                </div>
              </div>
            </div>

            <div class="col-12 col-xl-6">
              <div class="bots-panel">
                <div class="bots-panel__head">
                  <h3 class="bots-panel__title">Prochaine relève disponible</h3>
                  <span class="small text-white-50">Bots prêts ou bientôt prêts à reprendre la main</span>
                </div>
                <div class="bots-mini-table">
                  {foreach from=$botSnapshot.relay_candidates item=bot}
                    <div class="bots-mini-table__row">
                      <div>
                        <div class="fw-bold">{$bot.username}</div>
                        <div class="small text-white-50">{$bot.profile_name|default:'Sans profil'} · {$bot.presence_logical_label|default:'En veille'}</div>
                      </div>
                      <div class="text-end">
                        <div class="bots-pill">{$bot.session_rest_in_label}</div>
                        <div class="small text-white-50 mt-1">{$bot.session_rest_until_formatted|default:'immédiatement prêt'}</div>
                      </div>
                    </div>
                  {foreachelse}
                    <div class="text-white-50">Aucun relais disponible.</div>
                  {/foreach}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-12 col-xxl-4">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Pilotage rapide</h2>
              <p class="bots-section-text">Actions immédiates sur le moteur, la relève, les campagnes et la conformité.</p>
            </div>
          </div>

          <div class="bots-quick-actions bots-quick-actions--single">
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=presence&limit=24">
              <span class="bots-action-tile__title">Recalculer la présence</span>
              <span class="bots-action-tile__text">Réévalue l’ancrage, la rotation et la visibilité sociale.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=planning&limit=18">
              <span class="bots-action-tile__title">Planifier les décisions</span>
              <span class="bots-action-tile__text">Actualise besoins, objectifs et actions candidates.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=execution&limit=24">
              <span class="bots-action-tile__title">Exécuter la file</span>
              <span class="bots-action-tile__text">Traite la file d’actions dans la limite du budget.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=messaging&limit=24">
              <span class="bots-action-tile__title">Débloquer la messagerie</span>
              <span class="bots-action-tile__text">Diffuse les messages privés et sociaux en attente.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=compliance&limit=50">
              <span class="bots-action-tile__title">Resynchroniser la conformité</span>
              <span class="bots-action-tile__text">Valide emails partagés, multi-comptes et conformité bot.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=maintenance&limit=24">
              <span class="bots-action-tile__title">Maintenance et reprises</span>
              <span class="bots-action-tile__text">Nettoie mémoire, campagnes, verrous et actions bloquées.</span>
            </a>
          </div>

          <div class="bots-status-panel mt-3">
            <div class="bots-status-row">
              <span>État moteur</span>
              <strong>{if $botSnapshot.config.engine_enabled}Actif{else}Désactivé{/if}</strong>
            </div>
            <div class="bots-status-row">
              <span>Hiérarchie</span>
              <strong>{if $botSnapshot.config.enable_command_hierarchy}Active{else}Coupée{/if}</strong>
            </div>
            <div class="bots-status-row">
              <span>Campagnes</span>
              <strong>{if $botSnapshot.config.enable_campaigns}Actives{else}Coupées{/if}</strong>
            </div>
            <div class="bots-status-row">
              <span>Messagerie</span>
              <strong>{if $botSnapshot.config.enable_private_messages || $botSnapshot.config.enable_social_messages}Active{else}Coupée{/if}</strong>
            </div>
            <div class="bots-status-row">
              <span>Adresse commune</span>
              <strong>{$botSnapshot.config.shared_email|escape}</strong>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="row g-4 mb-4">
    <div class="col-12 col-xl-7">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Campagnes en cours</h2>
              <p class="bots-section-text">Campagnes offensives, de pression ou de siège maintenues avec phase, relais, visibilité et narration active.</p>
            </div>
            <span class="badge bg-secondary">{$botSnapshot.metrics.active_campaigns}</span>
          </div>
          <div class="bots-campaign-grid mb-3">
            {foreach from=$botSnapshot.campaigns item=campaign}
              <article class="bots-campaign-card">
                <div class="bots-campaign-card__top">
                  <span class="bots-pill">{$campaign.campaign_code}</span>
                  <span class="bots-pill">{$campaign.phase_label}</span>
                </div>
                <h3 class="bots-campaign-card__title">{$campaign.mode_label}</h3>
                <div class="bots-campaign-card__target">{$campaign.focused_target|default:'Sans cible précise'}</div>
                <p class="bots-campaign-card__text">{$campaign.narrative}</p>
                <div class="bots-campaign-card__meta">
                  <span>Intensité {$campaign.effective_intensity}</span>
                  <span>Membres {$campaign.member_count}</span>
                  <span>Relève {$campaign.relay_strategy_label|default:$campaign.relay_strategy}</span>
                </div>
              </article>
            {foreachelse}
              <div class="admin-empty">Aucune campagne active.</div>
            {/foreach}
          </div>
          <div class="table-responsive">
            <table class="table table-dark table-hover align-middle bots-table mb-0">
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
                    <td><span class="bots-pill">{$campaign.campaign_code}</span></td>
                    <td>{$campaign.campaign_type_label|default:$campaign.campaign_type}</td>
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

    <div class="col-12 col-xl-5">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Théâtre d’alliance</h2>
              <p class="bots-section-text">Posture des alliances bots, noyaux territoriaux et état-major courant.</p>
            </div>
          </div>
          <div class="bots-alliance-grid">
            {foreach from=$botSnapshot.alliance_summaries item=alliance}
              <article class="bots-alliance-card">
                <div class="bots-alliance-card__top">
                  <strong>{$alliance.ally_tag|default:$alliance.meta_tag}</strong>
                  <span class="bots-pill">{$alliance.diplomacy_posture_label|default:'En attente'}</span>
                </div>
                <div class="bots-alliance-card__name">{$alliance.ally_name|default:$alliance.meta_name}</div>
                <div class="bots-alliance-card__text">
                  Tension {$alliance.diplomacy.tension_level|default:0} · Commandants {$alliance.command_state.active_commanders|default:0} · Campagnes {$alliance.command_state.active_campaigns|default:0}
                </div>
                <div class="bots-alliance-card__zones">
                  {foreach from=$alliance.territorial_core item=zone}
                    <span class="bots-pill">{$zone.zone} · {$zone.total_bots}</span>
                  {/foreach}
                </div>
              </article>
            {foreachelse}
              <div class="admin-empty">Aucune alliance bots pilotée.</div>
            {/foreach}
          </div>
        </div>
      </div>
    </div>
  </section>

  <details id="pilotage" class="bots-fold" open="open">
    <summary class="bots-fold__summary">
      <div>
        <h2 class="bots-section-title mb-0">Pilotage et configuration</h2>
        <p class="bots-section-text">Réglages globaux du moteur, de la présence, des budgets et des politiques de comptes bots.</p>
      </div>
      <span class="bots-pill">Ouvert</span>
    </summary>
    <div class="bots-fold__body">
      <div class="admin-card">
        <div class="admin-card__body">
          <form action="?page=bots&mode=saveConfig" method="post" class="row g-3">
            <div class="col-md-3">
              <label class="form-label" for="target_online_total">Cible globale présence</label>
              <input id="target_online_total" class="form-control bg-dark text-white border-secondary" type="number" min="0" name="target_online_total" value="{$botSnapshot.config.target_online_total}">
            </div>
            <div class="col-md-3">
              <label class="form-label" for="target_social_total">Cible sociale</label>
              <input id="target_social_total" class="form-control bg-dark text-white border-secondary" type="number" min="0" name="target_social_total" value="{$botSnapshot.config.target_social_total}">
            </div>
            <div class="col-md-3">
              <label class="form-label" for="action_budget_per_cycle">Budget actions</label>
              <input id="action_budget_per_cycle" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="action_budget_per_cycle" value="{$botSnapshot.config.action_budget_per_cycle}">
            </div>
            <div class="col-md-3">
              <label class="form-label" for="max_bots_per_cycle">Bots par cycle</label>
              <input id="max_bots_per_cycle" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="max_bots_per_cycle" value="{$botSnapshot.config.max_bots_per_cycle}">
            </div>
            <div class="col-md-3">
              <label class="form-label" for="max_actions_per_bot">Actions max par bot</label>
              <input id="max_actions_per_bot" class="form-control bg-dark text-white border-secondary" type="number" min="1" name="max_actions_per_bot" value="{$botSnapshot.config.max_actions_per_bot}">
            </div>
            <div class="col-md-5">
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

            <div class="col-md-12">
              <div class="bots-toggle-grid">
                <label class="bots-toggle">
                  <input id="engine_enabled" class="form-check-input" type="checkbox" name="engine_enabled" {if $botSnapshot.config.engine_enabled}checked="checked"{/if}>
                  <span>Moteur actif</span>
                </label>
                <label class="bots-toggle">
                  <input id="enable_bot_alliances" class="form-check-input" type="checkbox" name="enable_bot_alliances" {if $botSnapshot.config.enable_bot_alliances}checked="checked"{/if}>
                  <span>Alliances bots</span>
                </label>
                <label class="bots-toggle">
                  <input id="enable_command_hierarchy" class="form-check-input" type="checkbox" name="enable_command_hierarchy" {if $botSnapshot.config.enable_command_hierarchy}checked="checked"{/if}>
                  <span>Hiérarchie de commandement</span>
                </label>
                <label class="bots-toggle">
                  <input id="enable_private_messages" class="form-check-input" type="checkbox" name="enable_private_messages" {if $botSnapshot.config.enable_private_messages}checked="checked"{/if}>
                  <span>Messagerie privée</span>
                </label>
                <label class="bots-toggle">
                  <input id="enable_social_messages" class="form-check-input" type="checkbox" name="enable_social_messages" {if $botSnapshot.config.enable_social_messages}checked="checked"{/if}>
                  <span>Messagerie chat</span>
                </label>
                <label class="bots-toggle">
                  <input id="enable_campaigns" class="form-check-input" type="checkbox" name="enable_campaigns" {if $botSnapshot.config.enable_campaigns}checked="checked"{/if}>
                  <span>Campagnes continues</span>
                </label>
              </div>
            </div>

            <div class="col-12 col-xl-6">
              <div class="bots-config-editor">
                <div class="bots-config-editor__title">Règles de présence</div>
                <div class="bots-config-editor__text">Réglage direct des multiplicateurs horaires et des fenêtres de session sans passer par du JSON.</div>
                <div class="row g-2 mt-1">
                  {foreach from=$botPresenceEditor.tranches item=tranche}
                    <div class="col-md-6">
                      <label class="form-label" for="presence_tranche_{$tranche.key}">{$tranche.label}</label>
                      <input id="presence_tranche_{$tranche.key}" class="form-control bg-dark text-white border-secondary" type="number" min="0.10" max="3.00" step="0.05" name="presence_tranches[{$tranche.key}]" value="{$tranche.value}">
                    </div>
                  {/foreach}
                </div>
                <div class="row g-2 mt-1">
                  {foreach from=$botPresenceEditor.sessions item=session}
                    <div class="col-md-6">
                      <label class="form-label" for="presence_session_{$session.key}">{$session.label}</label>
                      <input id="presence_session_{$session.key}" class="form-control bg-dark text-white border-secondary" type="number" min="0" step="{$session.step}" name="presence_sessions[{$session.key}]" value="{$session.value}">
                    </div>
                  {/foreach}
                </div>
                <div class="mt-2">
                  <label class="form-label" for="always_visible_roles_text">Rôles toujours visibles</label>
                  <input id="always_visible_roles_text" class="form-control bg-dark text-white border-secondary" type="text" name="always_visible_roles_text" value="{$botPresenceEditor.always_visible_roles_text|escape}">
                </div>
              </div>
            </div>
            <div class="col-12 col-xl-6">
              <div class="bots-config-editor">
                <div class="bots-config-editor__title">Pondérations décisionnelles</div>
                <div class="bots-config-editor__text">Ajustement direct des familles de décision sans édition manuelle du JSON.</div>
                {foreach from=$botDecisionEditor item=group}
                  <div class="bots-config-editor__group">
                    <div class="bots-config-editor__group-title">{$group.label}</div>
                    <div class="row g-2">
                      {foreach from=$group.fields item=field}
                        <div class="col-md-6">
                          <label class="form-label" for="decision_{$group.key}_{$field.key}">{$field.label}</label>
                          <input id="decision_{$group.key}_{$field.key}" class="form-control bg-dark text-white border-secondary" type="number" min="-1.00" max="1.00" step="0.05" name="decision_weight[{$group.key}][{$field.key}]" value="{$field.value}">
                        </div>
                      {/foreach}
                    </div>
                  </div>
                {/foreach}
              </div>
            </div>
            <div class="col-12">
              <button class="btn btn-primary" type="submit">Enregistrer la configuration</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </details>

  <details id="profils" class="bots-fold">
    <summary class="bots-fold__summary">
      <div>
        <h2 class="bots-section-title mb-0">Profils et répartition</h2>
        <p class="bots-section-text">Création de profils et distribution actuelle par doctrine, alliance et système.</p>
      </div>
      <span class="bots-pill">Rétracté</span>
    </summary>
    <div class="bots-fold__body">
      <div class="row g-4">
        <div class="col-12">
          <div class="admin-card">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Créer un nouveau profil</h3>
                  <p class="bots-section-text">Ajoute un profil réutilisable avec doctrine, intensité et style de communication.</p>
                </div>
              </div>

              <form action="?page=bots&mode=saveProfile" method="post" class="row g-3">
                <div class="col-md-3">
                  <label class="form-label" for="name">Nom du profil</label>
                  <input id="name" class="form-control bg-dark text-white border-secondary" name="name" type="text">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="profile_code">Code profil</label>
                  <input id="profile_code" class="form-control bg-dark text-white border-secondary" name="profile_code" type="text">
                </div>
                <div class="col-md-3">
                  <label class="form-label" for="doctrine">Doctrine</label>
                  <select id="doctrine" class="form-select bg-dark text-white border-secondary" name="doctrine">
                    {foreach from=$botProfileEditor.doctrines item=option}
                      <option value="{$option.value|escape}"{if $option.value == 'equilibre'} selected="selected"{/if}>{$option.label}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="role_primary">Rôle principal</label>
                  <select id="role_primary" class="form-select bg-dark text-white border-secondary" name="role_primary">
                    {foreach from=$botProfileEditor.roles item=option}
                      <option value="{$option.value|escape}"{if $option.value == 'economiste'} selected="selected"{/if}>{$option.label}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="communication_style">Style social</label>
                  <select id="communication_style" class="form-select bg-dark text-white border-secondary" name="communication_style">
                    {foreach from=$botProfileEditor.communication_styles item=option}
                      <option value="{$option.value|escape}"{if $option.value == 'mesure'} selected="selected"{/if}>{$option.label}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="col-12">
                  <label class="form-label" for="description">Description</label>
                  <textarea id="description" class="form-control bg-dark text-white border-secondary" name="description" rows="2"></textarea>
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="target_online">Présence logique</label>
                  <input id="target_online" class="form-control bg-dark text-white border-secondary" name="target_online" type="number" min="0" value="5">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="target_social_online">Présence sociale</label>
                  <input id="target_social_online" class="form-control bg-dark text-white border-secondary" name="target_social_online" type="number" min="0" value="1">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="aggression">Agressivité</label>
                  <input id="aggression" class="form-control bg-dark text-white border-secondary" name="aggression" type="number" min="0" max="100" value="35">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="economy_focus">Économie</label>
                  <input id="economy_focus" class="form-control bg-dark text-white border-secondary" name="economy_focus" type="number" min="0" max="100" value="55">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="expansion_focus">Expansion</label>
                  <input id="expansion_focus" class="form-control bg-dark text-white border-secondary" name="expansion_focus" type="number" min="0" max="100" value="40">
                </div>
                <div class="col-md-2">
                  <label class="form-label" for="is_active">Activation</label>
                  <div class="bots-toggle-grid bots-toggle-grid--compact">
                    <label class="bots-toggle">
                      <input id="is_active" class="form-check-input" type="checkbox" name="is_active" checked="checked">
                      <span>Actif</span>
                    </label>
                  </div>
                </div>
                <div class="col-12 col-xl-6">
                  <label class="form-label" for="traits_json">Traits JSON facultatifs</label>
                  <textarea id="traits_json" class="form-control bg-dark text-white border-secondary bots-codearea" name="traits_json" rows="4">{}</textarea>
                </div>
                <div class="col-12 col-xl-6">
                  <div class="bots-toggle-grid">
                    <label class="bots-toggle">
                      <input id="always_active" class="form-check-input" type="checkbox" name="always_active">
                      <span>Toujours actif</span>
                    </label>
                    <label class="bots-toggle">
                      <input id="is_visible_socially" class="form-check-input" type="checkbox" name="is_visible_socially" checked="checked">
                      <span>Visible socialement</span>
                    </label>
                    <label class="bots-toggle">
                      <input id="is_commander_profile" class="form-check-input" type="checkbox" name="is_commander_profile">
                      <span>Profil chef</span>
                    </label>
                  </div>
                </div>
                <div class="col-12">
                  <button class="btn btn-outline-primary" type="submit">Créer le profil</button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <div class="col-12 col-xl-4">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Répartition par profil</h3>
                  <p class="bots-section-text">Composition comportementale de la population bots.</p>
                </div>
              </div>
              <div class="bots-distribution-list">
                {foreach from=$botSnapshot.profile_distribution item=item}
                  <div class="bots-distribution-item">
                    <span>{$item.label}</span>
                    <strong>{$item.total}</strong>
                  </div>
                {foreachelse}
                  <div class="text-white-50">Aucune donnée de profil.</div>
                {/foreach}
              </div>
            </div>
          </div>
        </div>
        <div class="col-12 col-xl-4">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Répartition par alliance</h3>
                  <p class="bots-section-text">Concentration des bots dans les structures collectives.</p>
                </div>
              </div>
              <div class="bots-distribution-list">
                {foreach from=$botSnapshot.alliance_distribution item=item}
                  <div class="bots-distribution-item">
                    <span>{$item.label}</span>
                    <strong>{$item.total}</strong>
                  </div>
                {foreachelse}
                  <div class="text-white-50">Aucune alliance renseignée.</div>
                {/foreach}
              </div>
            </div>
          </div>
        </div>
        <div class="col-12 col-xl-4">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Répartition par système</h3>
                  <p class="bots-section-text">Noyaux territoriaux et zones de densité.</p>
                </div>
              </div>
              <div class="bots-distribution-list">
                {foreach from=$botSnapshot.galaxy_distribution item=item}
                  <div class="bots-distribution-item">
                    <span>{$item.label}</span>
                    <strong>{$item.total}</strong>
                  </div>
                {foreachelse}
                  <div class="text-white-50">Aucune présence spatiale consolidée.</div>
                {/foreach}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </details>

  <details id="supervision" class="bots-fold">
    <summary class="bots-fold__summary">
      <div>
        <h2 class="bots-section-title mb-0">Supervision avancée</h2>
        <p class="bots-section-text">Journal d’activité, runs moteur, actions planifiées et catalogue de commandes.</p>
      </div>
      <span class="bots-pill">Rétracté</span>
    </summary>
    <div class="bots-fold__body">
      <div class="admin-card mb-4">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h3 class="bots-section-title">Bots sous tension</h3>
              <p class="bots-section-text">Vue resserrée sur les bots à surveiller : chefs, campagnes, files en attente et prochaine action.</p>
            </div>
          </div>
          <div class="bots-focus-grid">
            {foreach from=$botSnapshot.bot_focus item=bot}
              <article class="bots-focus-card">
                <div class="bots-focus-card__top">
                  <strong>{$bot.username}</strong>
                  <span class="bots-pill">{$bot.presence_logical_label|default:'En veille'}</span>
                </div>
                <div class="bots-focus-card__meta">
                  <span>{$bot.profile_name|default:'Sans profil'}</span>
                  <span>{$bot.ally_tag|default:'Sans alliance'}</span>
                  <span>{$bot.hierarchy_status_label|default:'Membre'}</span>
                </div>
                <div class="bots-focus-card__campaign">
                  {if $bot.campaign_code}
                    <span class="bots-pill">{$bot.campaign_code}</span>
                    <span>{$bot.campaign_phase_label}</span>
                  {else}
                    <span class="text-white-50">Hors campagne</span>
                  {/if}
                </div>
                <div class="bots-focus-card__text">
                  {if $bot.next_action_type}
                    Prochaine action : {$bot.next_action_type_label|default:$bot.next_action_type} {if $bot.next_action_due_formatted}à {$bot.next_action_due_formatted}{/if}
                  {elseif $bot.last_activity_summary}
                    {$bot.last_activity_summary}
                  {else}
                    Aucun signal récent.
                  {/if}
                </div>
                <div class="bots-focus-card__footer">
                  <span>File {$bot.action_queue_size|default:0}</span>
                  <span>{if $bot.session_target_until}{$bot.session_target_in_label}{elseif $bot.session_rest_until}{$bot.session_rest_in_label}{else}sans fenêtre{/if}</span>
                </div>
              </article>
            {foreachelse}
              <div class="admin-empty">Aucun bot prioritaire à afficher.</div>
            {/foreach}
          </div>
        </div>
      </div>

      <div class="row g-4">
        <div class="col-12 col-xl-6">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Timeline d’activité</h3>
                  <p class="bots-section-text">Journal synthétique du raisonnement et des actions récentes du moteur.</p>
                </div>
              </div>
              <div class="table-responsive">
                <table class="table table-dark table-hover align-middle bots-table mb-0">
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
                        <td><span class="bots-pill">{$activity.activity_type_label|default:$activity.activity_type}</span></td>
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
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Runs moteur</h3>
                  <p class="bots-section-text">Dernières phases exécutées, avec charge et volume de décisions.</p>
                </div>
              </div>
              <div class="table-responsive">
                <table class="table table-dark table-hover align-middle bots-table mb-0">
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
                        <td>{$run.phase_label|default:$run.phase}</td>
                        <td><span class="bots-pill">{$run.status_label|default:$run.status}</span></td>
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

        <div class="col-12 col-xl-6">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Actions planifiées</h3>
                  <p class="bots-section-text">Actions mises en file par le moteur ou par le commandement manuel.</p>
                </div>
              </div>
              <div class="table-responsive">
                <table class="table table-dark table-hover align-middle bots-table mb-0">
                  <thead>
                    <tr>
                      <th>Bot</th>
                      <th>Action</th>
                      <th>Échéance</th>
                      <th>Prio</th>
                      <th>État</th>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach from=$botSnapshot.upcoming item=item}
                      <tr>
                        <td>{$item.username|default:'Bot système'}</td>
                        <td>{$item.action_type_label|default:$item.action_type}</td>
                        <td>{$item.due_at_formatted}</td>
                        <td>{$item.priority}</td>
                        <td><span class="bots-pill">{$item.status_label|default:$item.status}</span></td>
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
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Ordres récents</h3>
                  <p class="bots-section-text">Derniers ordres structurés remontés par la console bots.</p>
                </div>
                <a class="btn btn-outline-light btn-sm" href="game.php?page=chat">Console bots</a>
              </div>
              <div class="table-responsive">
                <table class="table table-dark table-hover align-middle bots-table mb-0">
                  <thead>
                    <tr>
                      <th>Commande</th>
                      <th>État</th>
                      <th>Date</th>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach from=$botSnapshot.orders item=order}
                      <tr>
                        <td>
                          <div><code>{$order.command_text|escape}</code></div>
                          <div class="small text-white-50 mt-1">{$order.command_name_label|default:'Commande'} · {$order.target_type_label|default:'Cible'}{if $order.response_text|default:''} · {$order.response_text}{else} · Sans réponse structurée{/if}</div>
                        </td>
                        <td><span class="bots-pill">{$order.status_label|default:$order.status}</span></td>
                        <td>{$order.created_at_formatted}</td>
                      </tr>
                    {foreachelse}
                      <tr>
                        <td colspan="3" class="text-white-50">Aucun ordre structuré enregistré.</td>
                      </tr>
                    {/foreach}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="col-12">
          <div class="admin-card h-100">
            <div class="admin-card__body">
              <div class="bots-section-heading">
                <div>
                  <h3 class="bots-section-title">Catalogue des commandes</h3>
                  <p class="bots-section-text">Aide-mémoire de la console de commandement bots.</p>
                </div>
              </div>
              <div class="table-responsive">
                <table class="table table-dark table-hover align-middle bots-table mb-0">
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
                        <td>{$item.family_label|default:$item.family_key}</td>
                        <td><span class="bots-pill">{$item.command_label|default:$item.command_key}</span></td>
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
    </div>
  </details>

  <details id="roster" class="bots-fold">
    <summary class="bots-fold__summary">
      <div>
        <h2 class="bots-section-title mb-0">Roster et actions de masse</h2>
        <p class="bots-section-text">Gestion de masse, pause, reprise, promotion chef, rotation des mots de passe et validation multi-compte.</p>
      </div>
      <span class="bots-pill">{$botSnapshot.metrics.total_bots} bots</span>
    </summary>
    <div class="bots-fold__body">
      <div class="admin-card">
        <div class="admin-card__body">
          <form action="?page=bots&mode=massAction" method="post">
            <div class="row g-3 align-items-end mb-3">
              <div class="col-md-4 col-xl-3">
                <label class="form-label" for="mass_action">Action de masse</label>
                <select id="mass_action" class="form-select bg-dark text-white border-secondary" name="mass_action">
                  <option value="pause">Pause 30 min</option>
                  <option value="resume">Reprendre</option>
                  <option value="promote">Promouvoir chef</option>
                  <option value="rotate-passwords">Régénérer mots de passe</option>
                  <option value="validate-multi">Valider multi-compte</option>
                </select>
              </div>
              <div class="col-md-4 col-xl-3">
                <label class="form-label" for="botsRosterFilter">Filtre roster</label>
                <input id="botsRosterFilter" class="form-control bg-dark text-white border-secondary" type="text" placeholder="Nom, profil, alliance, coordonnées">
              </div>
              <div class="col-md-4 col-xl-3">
                <button class="btn btn-outline-warning w-100" type="submit">Appliquer aux bots cochés</button>
              </div>
              <div class="col-xl-3">
                <div class="bots-inline-note" id="botsRosterCount">Affichage : {$botSnapshot.metrics.total_bots} bots</div>
              </div>
            </div>

            <div class="table-responsive">
              <table class="table table-dark table-hover align-middle bots-table mb-0" id="botsRosterTable">
                <thead>
                  <tr>
                    <th></th>
                    <th>Bot</th>
                    <th>Profil</th>
                    <th>Présence</th>
                    <th>Session</th>
                    <th>Alliance</th>
                    <th>Coordonnées</th>
                    <th>Chef</th>
                    <th>Conformité</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$botSnapshot.bot_roster item=bot}
                    <tr class="bots-roster-row">
                      <td><input class="form-check-input" type="checkbox" name="bot_ids[]" value="{$bot.id}"></td>
                      <td>
                        <div class="fw-bold">{$bot.username}</div>
                        <div class="small text-white-50">{$bot.email}</div>
                      </td>
                      <td>{$bot.profile_name|default:'Sans profil'}</td>
                      <td>
                        <div>{$bot.presence_logical_label|default:'En veille'}</div>
                        <div class="small text-white-50">{$bot.presence_social_label|default:'Discret'}</div>
                      </td>
                      <td>
                        <div>{if $bot.is_online_forced}<span class="bots-pill">ancrage</span>{else}{$bot.session_target_in_label}{/if}</div>
                        <div class="small text-white-50">{if $bot.session_target_until_formatted}{$bot.session_target_until_formatted}{elseif $bot.session_rest_until_formatted}{$bot.session_rest_in_label}{else}sans fenêtre{/if}</div>
                      </td>
                      <td>{$bot.ally_tag|default:'-'}</td>
                      <td>{$bot.galaxy}:{$bot.system}:{$bot.planet}</td>
                      <td>{if $bot.hierarchy_status == 'chef'}<span class="bots-pill">{$bot.hierarchy_status_label|default:'Chef'}</span>{else}<span class="text-white-50">{$bot.hierarchy_status_label|default:'Membre'}</span>{/if}</td>
                      <td>
                        <div>{$bot.compliance_status_label|default:'-'}</div>
                        <div class="small text-white-50">{$bot.validation_status_label|default:'-'}</div>
                      </td>
                    </tr>
                  {foreachelse}
                    <tr>
                      <td colspan="9" class="text-white-50">Aucun bot disponible.</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          </form>
        </div>
      </div>
    </div>
  </details>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var filterInput = document.getElementById('botsRosterFilter');
  var countNode = document.getElementById('botsRosterCount');
  var rows = Array.prototype.slice.call(document.querySelectorAll('#botsRosterTable .bots-roster-row'));

  if (!filterInput || !countNode || rows.length === 0) {
    return;
  }

  var applyFilter = function () {
    var term = filterInput.value.toLowerCase().trim();
    var visible = 0;

    rows.forEach(function (row) {
      var match = term === '' || row.textContent.toLowerCase().indexOf(term) !== -1;
      row.style.display = match ? '' : 'none';
      if (match) {
        visible += 1;
      }
    });

    countNode.textContent = 'Affichage : ' + visible + ' bot(s) visible(s)';
  };

  filterInput.addEventListener('input', applyFilter);
  applyFilter();
});
</script>

{/block}
