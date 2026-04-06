{block name="content"}
<div class="container-fluid py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Missions et récompenses</h1>
			<p class="text-white-50 mb-0">Préparez les objectifs journaliers, hebdomadaires et leurs récompenses.</p>
		</div>
		<div class="d-flex gap-2">
			<span class="badge bg-secondary">En cours : {$missionSnapshot.inProgress}</span>
			<span class="badge bg-warning text-dark">À réclamer : {$missionSnapshot.claimable}</span>
			<span class="badge bg-success">Réclamées : {$missionSnapshot.completed}</span>
			<span class="badge bg-info text-dark">Joueurs suivis : {$missionSnapshot.assignedUsers}</span>
			<a class="btn btn-outline-light btn-sm" href="?page=missions&mode=refresh">Synchroniser les joueurs</a>
		</div>
	</div>

	<div class="row g-3">
		<div class="col-12 col-xl-5">
			<div class="card bg-dark border-secondary h-100">
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
						<div>
							<button class="btn btn-primary" type="submit">Enregistrer la mission</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div class="col-12 col-xl-7">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Catalogue</h2>
					<div class="table-responsive">
						<table class="table table-dark table-striped align-middle mb-0">
							<thead>
								<tr>
									<th>Titre</th>
									<th>Fréquence</th>
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
											<div>{$mission.frequency}</div>
											<div class="small text-white-50">{$mission.objective_type} / {$mission.objective_key} / {$mission.target_value}</div>
										</td>
										<td>{$mission.reward_type} / {$mission.reward_key} / {$mission.reward_value}</td>
										<td><span class="badge {if $mission.is_active}bg-success{else}bg-secondary{/if}">{if $mission.is_active}Activée{else}Inactive{/if}</span></td>
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
{/block}
