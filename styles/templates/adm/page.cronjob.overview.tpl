{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Planification</span>
			<h2>Tâches planifiées</h2>
		</div>
		<div class="admin-headerline__actions">
			<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=cronjob&mode=showCronjobCreate">{$LNG.cronjob_new}</a>
			<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=supervision">Supervision</a>
		</div>
	</section>

	<section class="admin-kpi-grid admin-kpi-grid--cron">
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Cronjobs</span>
			<strong class="admin-kpi-card__value">{$cronTotal}</strong>
			<span class="admin-kpi-card__meta">ensemble configuré</span>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Actifs</span>
			<strong class="admin-kpi-card__value">{$cronActive}</strong>
			<span class="admin-kpi-card__meta">désactivés : {$cronTotal-$cronActive}</span>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Verrous</span>
			<strong class="admin-kpi-card__value">{$cronLocked}</strong>
			<span class="admin-kpi-card__meta">libres : {$cronTotal-$cronLocked}</span>
		</article>
	</section>

	<details class="admin-fold admin-fold--compact">
		<summary class="admin-fold__summary">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div><h2 class="h5 mb-1">Catalogue des cronjobs</h2></div>
				<span class="admin-pill">{$cronTotal} tâche(s)</span>
			</div>
		</summary>
		<div class="admin-fold__body">
			<section class="admin-table-shell">
				<div class="table-responsive admin-scroll-region">
					<table class="table table-dark table-striped align-middle mb-0">
						<thead>
							<tr>
								<th>{$LNG.cronjob_id}</th>
								<th>{$LNG.cronjob_name}</th>
								<th>Planification</th>
								<th>{$LNG.cronjob_class}</th>
								<th>{$LNG.cronjob_nextTime}</th>
								<th>État</th>
								<th>Verrou</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							{foreach item=CronjobInfo from=$CronjobArray}
								<tr>
									<td>#{$CronjobInfo.id}</td>
									<td>{$CronjobInfo.name_label|default:$CronjobInfo.name}</td>
									<td><code>{$CronjobInfo.min} {$CronjobInfo.hours} {$CronjobInfo.dom} {if $CronjobInfo.month == '*'}*{else}{foreach item=month from=$CronjobInfo.month}{$month}{if !$month@last},{/if}{/foreach}{/if} {if $CronjobInfo.dow == '*'}*{else}{foreach item=d from=$CronjobInfo.dow}{$d}{if !$d@last},{/if}{/foreach}{/if}</code></td>
									<td>{$CronjobInfo.class}</td>
									<td>{if $CronjobInfo.isActive}{date($LNG.php_tdformat, $CronjobInfo.nextTime)}{else}-{/if}</td>
									<td>
										{if $CronjobInfo.isActive}
											<span class="badge admin-badge-success">Actif</span>
										{else}
											<span class="badge admin-badge-danger">Inactif</span>
										{/if}
									</td>
									<td>
										{if $CronjobInfo.lock}
											<span class="badge admin-badge-warning">Verrouillé</span>
										{else}
											<span class="badge admin-badge-info">Libre</span>
										{/if}
									</td>
									<td>
										<div class="admin-actions">
											<a class="btn btn-outline-info btn-sm" href="admin.php?page=cronjob&mode=showCronjobDetail&id={$CronjobInfo.id}">Éditer</a>
											<a class="btn btn-outline-light btn-sm" href="admin.php?page=cronjob&mode=enable&id={$CronjobInfo.id}&enable={if $CronjobInfo.isActive}0{else}1{/if}">{if $CronjobInfo.isActive}{$LNG.cronjob_inactive}{else}{$LNG.cronjob_active}{/if}</a>
											<a class="btn btn-outline-warning btn-sm" href="admin.php?page=cronjob&id={$CronjobInfo.id}&mode={if $CronjobInfo.lock}unlock{else}lock{/if}">{if $CronjobInfo.lock}{$LNG.cronjob_is_lock}{else}{$LNG.cronjob_is_unlock}{/if}</a>
											<a class="btn btn-outline-danger btn-sm" href="admin.php?page=cronjob&mode=delete&id={$CronjobInfo.id}" onclick="return confirm('Supprimer ce cronjob ?');">Supprimer</a>
										</div>
									</td>
								</tr>
							{foreachelse}
								<tr>
									<td colspan="8">
										<div class="admin-empty">Aucune tâche planifiée n’est disponible.</div>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</section>
		</div>
	</details>
</div>
{/block}
