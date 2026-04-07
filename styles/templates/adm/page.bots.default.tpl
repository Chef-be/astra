{block name="content"}

<div class="container-fluid py-4 bots-admin-page">
  <section class="admin-hero bots-hero mb-4">
    <div class="bots-hero__content">
      <span class="admin-hero__eyebrow">Commandement bots</span>
      <h1 class="admin-hero__title">Moteur bots Astra</h1>
      <p class="admin-hero__description">
        Pilotage de la présence, des campagnes, de la hiérarchie, des messages et de la conformité des comptes bots.
        Cette page sert de console d’exploitation pour le moteur IA et sa couche sociale.
      </p>
      <div class="admin-hero__meta">
        <span class="admin-hero__chip">Moteur {if $botSnapshot.config.engine_enabled}<strong>actif</strong>{else}<strong>désactivé</strong>{/if}</span>
        <span class="admin-hero__chip">Cible logique <strong>{$botSnapshot.config.target_online_total}</strong></span>
        <span class="admin-hero__chip">Cible sociale <strong>{$botSnapshot.config.target_social_total}</strong></span>
        <span class="admin-hero__chip">Budget cycle <strong>{$botSnapshot.config.action_budget_per_cycle}</strong></span>
      </div>
    </div>

    <div class="bots-hero__actions">
      <a class="btn btn-success btn-sm" href="?page=bots&mode=runEngine&phase=cycle&limit=18">Lancer un cycle complet</a>
      <a class="btn btn-outline-warning btn-sm" href="?page=bots&mode=runEngine&phase=campaigns&limit=12">Relancer les campagnes</a>
      <a class="btn btn-outline-info btn-sm" href="?page=bots&mode=runEngine&phase=maintenance&limit=24">Exécuter la maintenance</a>
      <a class="btn btn-outline-light btn-sm" href="?page=bots&mode=create">Créer des bots</a>
      <a class="btn btn-outline-light btn-sm" href="game.php?page=chat">Ouvrir la console bots</a>
    </div>
  </section>

  <nav class="admin-tabs mb-4">
    <a class="admin-tab is-active" href="#synthese">Synthèse</a>
    <a class="admin-tab" href="#pilotage">Pilotage</a>
    <a class="admin-tab" href="#repartition">Répartition</a>
    <a class="admin-tab" href="#operations">Opérations</a>
    <a class="admin-tab" href="#supervision">Supervision</a>
    <a class="admin-tab" href="#roster">Roster</a>
  </nav>

  <section id="synthese" class="mb-4">
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
          <div class="bots-kpi-card__meta">Visible socialement : {$botSnapshot.metrics.social_visible}</div>
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
          <div class="bots-kpi-card__meta">Messages privés : {$botSnapshot.metrics.private_messages_sent}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Canal social</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.social_messages_sent}</div>
          <div class="bots-kpi-card__meta">Ordres rejetés : {$botSnapshot.metrics.rejected_orders}</div>
        </div>
      </article>
      <article class="admin-card bots-kpi-card bots-kpi-card--alert">
        <div class="admin-card__body">
          <div class="bots-kpi-card__label">Anomalies</div>
          <div class="bots-kpi-card__value">{$botSnapshot.metrics.failed_actions + $botSnapshot.metrics.rejected_orders + $botSnapshot.metrics.compliance_issues}</div>
          <div class="bots-kpi-card__meta">Conformité en écart : {$botSnapshot.metrics.compliance_issues}</div>
        </div>
      </article>
    </div>
  </section>

  <section id="pilotage" class="row g-4 mb-4">
    <div class="col-12 col-xxl-4">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Pilotage rapide</h2>
              <p class="bots-section-text">Actions d’exploitation immédiates sur le moteur.</p>
            </div>
          </div>

          <div class="bots-quick-actions">
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=presence&limit=24">
              <span class="bots-action-tile__title">Gouvernance de présence</span>
              <span class="bots-action-tile__text">Recalcule la présence logique et sociale.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=planning&limit=18">
              <span class="bots-action-tile__title">Planification</span>
              <span class="bots-action-tile__text">Choisit objectifs, besoins et actions candidates.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=execution&limit=24">
              <span class="bots-action-tile__title">Exécution réelle</span>
              <span class="bots-action-tile__text">Vide la file d’actions dans la limite du budget.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=messaging&limit=24">
              <span class="bots-action-tile__title">Messagerie</span>
              <span class="bots-action-tile__text">Diffuse messages privés et messages chat.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=compliance&limit=50">
              <span class="bots-action-tile__title">Conformité</span>
              <span class="bots-action-tile__text">Resynchronise email partagé, validation multi et conformité.</span>
            </a>
            <a class="bots-action-tile" href="?page=bots&mode=runEngine&phase=maintenance&limit=24">
              <span class="bots-action-tile__title">Reprise et verrous</span>
              <span class="bots-action-tile__text">Récupère actions bloquées, mémoire expirée et campagnes.</span>
            </a>
          </div>

          <div class="bots-status-panel">
            <div class="bots-status-row">
              <span>État moteur</span>
              <strong>{if $botSnapshot.config.engine_enabled}Actif{else}Désactivé{/if}</strong>
            </div>
            <div class="bots-status-row">
              <span>Commandement</span>
              <strong>{if $botSnapshot.config.enable_command_hierarchy}Actif{else}Coupé{/if}</strong>
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
              <span>Email partagé</span>
              <strong>{$botSnapshot.config.shared_email|escape}</strong>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-12 col-xxl-8">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Paramètres globaux</h2>
              <p class="bots-section-text">Réglage des cibles de présence, des budgets, des politiques de comptes et des coefficients de décision.</p>
            </div>
          </div>

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
              <label class="form-label" for="global_presence_rules_json">Règles de présence JSON</label>
              <textarea id="global_presence_rules_json" class="form-control bg-dark text-white border-secondary bots-codearea" rows="7" name="global_presence_rules_json">{$botSnapshot.config.global_presence_rules_json|@json_encode}</textarea>
            </div>
            <div class="col-12 col-xl-6">
              <label class="form-label" for="decision_weights_json">Pondérations décisionnelles JSON</label>
              <textarea id="decision_weights_json" class="form-control bg-dark text-white border-secondary bots-codearea" rows="7" name="decision_weights_json">{$botSnapshot.config.decision_weights_json|@json_encode}</textarea>
            </div>
            <div class="col-12">
              <button class="btn btn-primary" type="submit">Enregistrer la configuration</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </section>

  <section class="row g-4 mb-4">
    <div class="col-12">
      <div class="admin-card">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Créer un nouveau profil</h2>
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
              <input id="doctrine" class="form-control bg-dark text-white border-secondary" name="doctrine" type="text" value="equilibre">
            </div>
            <div class="col-md-2">
              <label class="form-label" for="role_primary">Rôle principal</label>
              <input id="role_primary" class="form-control bg-dark text-white border-secondary" name="role_primary" type="text" value="economiste">
            </div>
            <div class="col-md-2">
              <label class="form-label" for="communication_style">Style social</label>
              <input id="communication_style" class="form-control bg-dark text-white border-secondary" name="communication_style" type="text" value="mesure">
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
  </section>

  <section id="repartition" class="row g-4 mb-4">
    <div class="col-12 col-xl-4">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Répartition par profil</h2>
              <p class="bots-section-text">Vue rapide de la composition comportementale de la population bots.</p>
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
              <h2 class="bots-section-title">Répartition par alliance</h2>
              <p class="bots-section-text">Mesure la concentration des bots dans les structures collectives.</p>
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
              <h2 class="bots-section-title">Répartition par système</h2>
              <p class="bots-section-text">Repère les noyaux territoriaux et les zones de densité.</p>
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
  </section>

  <section id="operations" class="row g-4 mb-4">
    <div class="col-12 col-xl-7">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Campagnes en cours</h2>
              <p class="bots-section-text">Campagnes offensives, de pression ou de siège maintenues par le moteur.</p>
            </div>
            <span class="badge bg-secondary">{$botSnapshot.metrics.active_campaigns}</span>
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

    <div class="col-12 col-xl-5">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Ordres récents</h2>
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
                      <div class="small text-white-50 mt-1">{$order.response_text|default:'Sans réponse structurée'}</div>
                    </td>
                    <td><span class="bots-pill">{$order.status}</span></td>
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
  </section>

  <section id="supervision" class="row g-4 mb-4">
    <div class="col-12 col-xl-6">
      <div class="admin-card h-100">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Timeline d’activité</h2>
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
                    <td><span class="bots-pill">{$activity.activity_type}</span></td>
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
              <h2 class="bots-section-title">Runs moteur</h2>
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
                    <td>{$run.phase}</td>
                    <td><span class="bots-pill">{$run.status}</span></td>
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
              <h2 class="bots-section-title">Actions planifiées</h2>
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
                    <td>{$item.action_type}</td>
                    <td>{$item.due_at_formatted}</td>
                    <td>{$item.priority}</td>
                    <td><span class="bots-pill">{$item.status}</span></td>
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
              <h2 class="bots-section-title">Catalogue des commandes</h2>
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
                    <td>{$item.family_key}</td>
                    <td><span class="bots-pill">{$item.command_key}</span></td>
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
  </section>

  <section id="roster" class="row g-4">
    <div class="col-12">
      <div class="admin-card">
        <div class="admin-card__body">
          <div class="bots-section-heading">
            <div>
              <h2 class="bots-section-title">Roster bots</h2>
              <p class="bots-section-text">Vue de masse pour pause, reprise, promotion chef, rotation des mots de passe et validation multi-compte.</p>
            </div>
          </div>

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
                <button class="btn btn-outline-warning w-100" type="submit">Appliquer aux bots cochés</button>
              </div>
            </div>

            <div class="table-responsive">
              <table class="table table-dark table-hover align-middle bots-table mb-0">
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
                      <td>{if $bot.hierarchy_status == 'chef'}<span class="bots-pill">Oui</span>{else}<span class="text-white-50">Non</span>{/if}</td>
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
  </section>
</div>

{/block}
