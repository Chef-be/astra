{block name="content"}

<div class="container-fluid py-4 text-white">
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
    <div>
      <h1 class="h3 mb-1">Gestion des bots</h1>
      <p class="text-white-50 mb-0">Profils d’activité, cible de présence connectée et suivi des actions.</p>
    </div>
    <div class="d-flex gap-2 flex-wrap">
      <a class="btn btn-outline-success btn-sm" href="?page=bots&mode=runEngine&limit=12">Exécuter le moteur</a>
      <a class="btn btn-outline-light btn-sm" href="?page=bots&mode=create">Créer des bots legacy</a>
    </div>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-12 col-lg-4">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <div class="text-white-50 small">Bots totaux</div>
          <div class="fs-3 fw-bold">{$botSnapshot.totalBots}</div>
          <div class="small text-white-50 mt-2">Bots actifs sur 15 min : {$botSnapshot.activeBots}</div>
        </div>
      </div>
    </div>
    <div class="col-12 col-lg-8">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Nouveau profil</h2>
          <form action="?page=bots&mode=saveProfile" method="post" class="row g-3">
            <div class="col-md-6">
              <label class="form-label" for="name">Nom du profil</label>
              <input id="name" class="form-control bg-dark text-white border-secondary" name="name" type="text">
            </div>
            <div class="col-md-6">
              <label class="form-label" for="target_online">Bots connectés ciblés</label>
              <input id="target_online" class="form-control bg-dark text-white border-secondary" name="target_online" type="number" min="0" value="10">
            </div>
            <div class="col-12">
              <label class="form-label" for="description">Description</label>
              <textarea id="description" class="form-control bg-dark text-white border-secondary" name="description" rows="3"></textarea>
            </div>
            <div class="col-md-4">
              <label class="form-label" for="aggression">Agressivité</label>
              <input id="aggression" class="form-control bg-dark text-white border-secondary" name="aggression" type="number" min="0" max="100" value="30">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="economy_focus">Économie</label>
              <input id="economy_focus" class="form-control bg-dark text-white border-secondary" name="economy_focus" type="number" min="0" max="100" value="50">
            </div>
            <div class="col-md-4">
              <label class="form-label" for="expansion_focus">Expansion</label>
              <input id="expansion_focus" class="form-control bg-dark text-white border-secondary" name="expansion_focus" type="number" min="0" max="100" value="40">
            </div>
            <div class="col-12">
              <div class="form-check">
                <input id="is_active" class="form-check-input" type="checkbox" name="is_active" checked="checked">
                <label class="form-check-label" for="is_active">Profil actif</label>
              </div>
            </div>
            <div class="col-12">
              <button class="btn btn-primary" type="submit">Enregistrer le profil</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3">
    <div class="col-12 col-xl-6">
      <div class="card bg-dark border-secondary h-100">
        <div class="card-body">
          <h2 class="h5 mb-3">Profils disponibles</h2>
          <div class="table-responsive">
            <table class="table table-dark table-striped align-middle mb-0">
              <thead>
                <tr>
                  <th>Profil</th>
                  <th>Connexion</th>
                  <th>Axes</th>
                  <th>État</th>
                </tr>
              </thead>
              <tbody>
                {foreach from=$botSnapshot.profiles item=profile}
                  <tr>
                    <td>
                      <div class="fw-bold">{$profile.name}</div>
                      <div class="small text-white-50">{$profile.description}</div>
                    </td>
                    <td>{$profile.target_online}<div class="small text-white-50">Assignés : {$profile.assigned_bots}</div></td>
                    <td>A {$profile.aggression} / É {$profile.economy_focus} / X {$profile.expansion_focus}</td>
                    <td><span class="badge {if $profile.is_active}bg-success{else}bg-secondary{/if}">{if $profile.is_active}Actif{else}Inactif{/if}</span></td>
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
          <h2 class="h5 mb-3">Journal d’activité</h2>
          {if $botSnapshot.activity|@count > 0}
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
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="alert alert-secondary mb-0">Aucune activité bot journalisée pour le moment.</div>
          {/if}
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mt-1">
    <div class="col-12">
      <div class="card bg-dark border-secondary">
        <div class="card-body">
          <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
            <div>
              <h2 class="h5 mb-1">Actions à venir</h2>
              <div class="small text-white-50">Le canal bots accepte aussi des consignes directes, par exemple <code>/bot NomDuBot lancer reconnaissance</code>.</div>
            </div>
            <a class="btn btn-outline-light btn-sm" href="?page=chat">Ouvrir le canal bots</a>
          </div>
          {if $botSnapshot.upcoming|@count > 0}
            <div class="table-responsive">
              <table class="table table-dark table-striped align-middle mb-0">
                <thead>
                  <tr>
                    <th>Bot</th>
                    <th>Type</th>
                    <th>Prévision</th>
                    <th>Échéance</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$botSnapshot.upcoming item=upcoming}
                    <tr>
                      <td>{$upcoming.username|default:'Bot système'}</td>
                      <td>{$upcoming.activity_type}</td>
                      <td>{$upcoming.activity_summary}</td>
                      <td>{$upcoming.next_action_at_formatted}</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="alert alert-secondary mb-0">Aucune action à venir n’a encore été planifiée.</div>
          {/if}
        </div>
      </div>
    </div>
  </div>

  <div class="row g-3 mt-1">
    <div class="col-12">
      <div class="card bg-dark border-secondary">
        <div class="card-body">
          <h2 class="h5 mb-3">Bots surveillés</h2>
          {if $botSnapshot.botRoster|@count > 0}
            <div class="table-responsive">
              <table class="table table-dark table-striped align-middle mb-0">
                <thead>
                  <tr>
                    <th>Bot</th>
                    <th>Profil</th>
                    <th>Coordonnées</th>
                    <th>Dernière présence</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$botSnapshot.botRoster item=bot}
                    <tr>
                      <td>
                        <div class="fw-bold">{$bot.username}</div>
                        <div class="small text-white-50">ID {$bot.id}</div>
                      </td>
                      <td>{$bot.profile_name|default:'Non affecté'}</td>
                      <td>{$bot.galaxy}:{$bot.system}:{$bot.planet}</td>
                      <td>{$bot.onlinetime_formatted}</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="alert alert-secondary mb-0">Aucun bot n’est actuellement enregistré dans ce suivi.</div>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>

{/block}
