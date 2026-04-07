{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Missions en cours</span>
			<strong class="admin-kpi-card__value">{$missionSnapshot.inProgress}</strong>
			<span class="admin-kpi-card__meta">joueurs actuellement engagés</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Réclamables</span>
			<strong class="admin-kpi-card__value">{$missionSnapshot.claimable}</strong>
			<span class="admin-kpi-card__meta">prêtes à être collectées</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Réclamées</span>
			<strong class="admin-kpi-card__value">{$missionSnapshot.completed}</strong>
			<span class="admin-kpi-card__meta">progression déjà validée</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Joueurs suivis</span>
			<strong class="admin-kpi-card__value">{$missionSnapshot.assignedUsers}</strong>
			<span class="admin-kpi-card__meta">population missionnée</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Pilotage des missions</h2>
					<p class="text-white-50 mb-0">Définissez les objectifs, cadence et récompenses depuis un catalogue centralisé, puis resynchronisez la population si nécessaire.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="?page=overview">Vue d’ensemble</a>
					<a class="admin-shell-action admin-shell-action--accent" href="?page=missions&mode=refresh">Synchroniser les joueurs</a>
				</div>
			</div>
		</div>
	</section>

	<section class="admin-panel-grid">
		<div class="admin-panel-grid__side">
			<div class="admin-card h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Nouvelle mission</h2>
					<form action="?page=missions&mode=saveDefinition" method="post" class="d-flex flex-column gap-3">
						<div>
							<label class="form-label" for="title">Titre</label>
							<input id="title" class="form-control bg-dark text-white border-secondary" name="title" type="text">
						</div>
						<div>
							<label class="form-label" for="frequency">Fréquence</label>
							<select id="frequency" class="form-select bg-dark text-white border-secondary" name="frequency">
								<option value="daily">Quotidienne</option>
								<option value="weekly">Hebdomadaire</option>
								<option value="event">Événementielle</option>
							</select>
						</div>
						<div>
							<label class="form-label" for="description">Description</label>
							<textarea id="description" class="form-control bg-dark text-white border-secondary" name="description" rows="4"></textarea>
						</div>
						<div class="row g-3">
							<div class="col-md-4">
								<label class="form-label" for="objective_type">Objectif</label>
								<select id="objective_type" class="form-select bg-dark text-white border-secondary" name="objective_type">
									<option value="building_level">Niveau de bâtiment</option>
									<option value="ship_total">Total de vaisseaux</option>
									<option value="resource_total">Stock total de ressource</option>
								</select>
							</div>
							<div class="col-md-4">
								<label class="form-label" for="objective_key">Clé d’objectif</label>
								<input id="objective_key" class="form-control bg-dark text-white border-secondary" name="objective_key" type="text" value="1">
							</div>
							<div class="col-md-4">
								<label class="form-label" for="target_value">Cible</label>
								<input id="target_value" class="form-control bg-dark text-white border-secondary" name="target_value" type="number" min="1" value="5">
							</div>
						</div>
						<div class="row g-3">
							<div class="col-md-4">
								<label class="form-label" for="reward_type">Type</label>
								<select id="reward_type" class="form-select bg-dark text-white border-secondary" name="reward_type">
									<option value="resource">Ressource</option>
									<option value="darkmatter">Matière noire</option>
									<option value="ship">Vaisseau</option>
								</select>
							</div>
							<div class="col-md-4">
								<label class="form-label" for="reward_key">Clé</label>
								<input id="reward_key" class="form-control bg-dark text-white border-secondary" name="reward_key" type="text" value="metal">
							</div>
							<div class="col-md-4">
								<label class="form-label" for="reward_value">Valeur</label>
								<input id="reward_value" class="form-control bg-dark text-white border-secondary" name="reward_value" type="number" min="0" value="1000">
							</div>
						</div>
						<div class="form-check">
							<input id="is_active" class="form-check-input" type="checkbox" name="is_active" checked="checked">
							<label class="form-check-label" for="is_active">Mission active</label>
						</div>
						<div class="d-flex gap-2 flex-wrap">
							<button class="btn btn-primary" type="submit">Enregistrer la mission</button>
							<a class="btn btn-outline-light" href="?page=missions&mode=refresh">Rafraîchir les affectations</a>
						</div>
					</form>
				</div>
			</div>
		</div>

		<div class="admin-panel-grid__wide">
			<div class="admin-card h-100">
				<div class="card-body admin-stack">
					<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
						<div>
							<h2 class="h5 mb-1">Catalogue des missions</h2>
							<p class="text-white-50 mb-0">Vue condensée du catalogue actif pour contrôler le cycle, l’objectif et la récompense sans relecture technique.</p>
						</div>
						<span class="admin-pill">{$missionSnapshot.definitions|@count} définition(s)</span>
					</div>

					<div class="admin-table-shell">
						<div class="table-responsive">
							<table class="table table-dark table-striped align-middle mb-0">
								<thead>
									<tr>
										<th>Titre</th>
										<th>Cadence</th>
										<th>Objectif</th>
										<th>Récompense</th>
										<th>État</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$missionSnapshot.definitions item=mission}
										<tr>
											<td>
												<div class="fw-bold">{$mission.title}</div>
												<div class="small text-white-50">{$mission.description}</div>
											</td>
											<td>
												{if $mission.frequency == 'daily'}Quotidienne{elseif $mission.frequency == 'weekly'}Hebdomadaire{elseif $mission.frequency == 'event'}Événementielle{else}{$mission.frequency}{/if}
											</td>
											<td>
												<div>{if $mission.objective_type == 'building_level'}Niveau de bâtiment{elseif $mission.objective_type == 'ship_total'}Total de vaisseaux{elseif $mission.objective_type == 'resource_total'}Stock de ressources{else}{$mission.objective_type}{/if}</div>
												<div class="small text-white-50">Clé {$mission.objective_key} · Cible {$mission.target_value}</div>
											</td>
											<td>
												<div>{if $mission.reward_type == 'resource'}Ressource{elseif $mission.reward_type == 'darkmatter'}Matière noire{elseif $mission.reward_type == 'ship'}Vaisseau{else}{$mission.reward_type}{/if}</div>
												<div class="small text-white-50">{$mission.reward_key} · {$mission.reward_value}</div>
											</td>
											<td><span class="badge {if $mission.is_active}admin-badge-success{else}admin-badge-info{/if}">{if $mission.is_active}Activée{else}Inactive{/if}</span></td>
										</tr>
									{foreachelse}
										<tr>
											<td colspan="5"><div class="admin-empty">Aucune mission n’est encore définie.</div></td>
										</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
{/block}
