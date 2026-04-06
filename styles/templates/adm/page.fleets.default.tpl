{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Trafic en vol</span>
			<h1 class="admin-hero__title">Flottes actives</h1>
			<p class="admin-hero__subtitle">Suivez les missions en cours, les ressources transportées et l’état de verrouillage des événements de flotte.</p>
		</div>
		<div class="admin-stat-strip">
			<div class="admin-stat-card">
				<span class="admin-stat-card__label">Flottes actives</span>
				<strong class="admin-stat-card__value">{$FleetList|@count}</strong>
			</div>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div>
				<h2 class="h5 mb-1">Journal opérationnel</h2>
				<p class="text-white-50 mb-0">Les visuels des vaisseaux et des ressources facilitent la lecture sans devoir interpréter des identifiants techniques.</p>
			</div>
		</div>

		{if $FleetList|@count > 0}
			<div class="table-responsive">
				<table class="table table-dark align-middle mb-0">
					<thead>
						<tr>
							<th>#</th>
							<th>Mission</th>
							<th>Départ</th>
							<th>Charge utile</th>
							<th>Origine</th>
							<th>Arrivée</th>
							<th>Cible</th>
							<th>Retour</th>
							<th>Maintien</th>
							<th class="text-end">Verrou</th>
						</tr>
					</thead>
					<tbody>
						{foreach $FleetList as $FleetRow}
							<tr>
								<td class="fw-semibold">{$FleetRow.fleetID}</td>
								<td>
									<div class="fw-semibold">{$LNG["type_mission_{$FleetRow.missionID}"]}</div>
									{if $FleetRow.acsID != 0}
										<div class="text-white-50 small">ACS #{$FleetRow.acsID} {if $FleetRow.acsName}- {$FleetRow.acsName}{/if}</div>
									{/if}
								</td>
								<td>{$FleetRow.starttime}</td>
								<td>
									<div class="admin-media-grid">
										{foreach $FleetRow.ships as $shipID => $shipCount}
											<div class="admin-media-tile" title="{$LNG.tech.$shipID} : {$shipCount|number}">
												<img src="./styles/theme/nextgen/gebaeude/{$shipID}.gif" alt="{$LNG.tech.$shipID}">
												<strong>{$shipCount|number}</strong>
												<span>{$LNG.tech.$shipID}</span>
											</div>
										{/foreach}
									</div>
									<div class="d-flex flex-wrap gap-2 mt-3">
										{foreach $FleetRow.resource as $resourceID => $resourceCount}
											{if $resourceCount > 0}
												<span class="admin-pill">
													<img src="./styles/theme/nextgen/gebaeude/{$resourceID}.gif" alt="{$LNG.tech.$resourceID}" style="width:18px;height:18px;object-fit:contain;">
													{$resourceCount|number}
												</span>
											{/if}
										{/foreach}
									</div>
								</td>
								<td>
									<div>{$FleetRow.startUserName} <span class="text-white-50">(ID {$FleetRow.startUserID})</span></div>
									<div class="text-white-50 small">{$FleetRow.startPlanetName} [{$FleetRow.startPlanetGalaxy}:{$FleetRow.startPlanetSystem}:{$FleetRow.startPlanetPlanet}]</div>
								</td>
								<td>{if $FleetRow.state == 0}<span class="text-success fw-semibold">{$FleetRow.arrivaltime}</span>{else}{$FleetRow.arrivaltime}{/if}</td>
								<td>
									{if $FleetRow.targetUserID != 0}
										<div>{$FleetRow.targetUserName} <span class="text-white-50">(ID {$FleetRow.targetUserID})</span></div>
									{/if}
									<div class="text-white-50 small">{$FleetRow.targetPlanetName} [{$FleetRow.targetPlanetGalaxy}:{$FleetRow.targetPlanetSystem}:{$FleetRow.targetPlanetPlanet}]</div>
								</td>
								<td>{if $FleetRow.state == 1}<span class="text-success fw-semibold">{$FleetRow.endtime}</span>{else}{$FleetRow.endtime}{/if}</td>
								<td>
									{if $FleetRow.stayhour != 0}
										{if $FleetRow.state == 2}<span class="text-success fw-semibold">{$FleetRow.staytime} ({$FleetRow.stayhour}&nbsp;h)</span>{else}{$FleetRow.staytime} ({$FleetRow.stayhour}&nbsp;h){/if}
									{else}
										<span class="text-white-50">Aucun maintien</span>
									{/if}
								</td>
								<td class="text-end">
									<a class="btn btn-sm {if $FleetRow.lock}btn-outline-success{elseif $FleetRow.error}btn-outline-danger{else}btn-outline-warning{/if}" href="admin.php?page=fleets&amp;mode=lock&amp;id={$FleetRow.fleetID}&amp;lock={if $FleetRow.lock}0{elseif $FleetRow.error}2{else}1{/if}">
										{if $FleetRow.lock}{$LNG.ff_unlock}{elseif $FleetRow.error}{$LNG.ff_del}{else}{$LNG.ff_lock}{/if}
									</a>
								</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{else}
			<div class="admin-empty-state">
				Aucune flotte n’est actuellement en vol sur cet univers.
			</div>
		{/if}
	</div>
</div>
{/block}
