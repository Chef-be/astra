{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	{assign var="cronTotal" value=$CronjobArray|@count}
	{assign var="cronActive" value=0}
	{assign var="cronLocked" value=0}
	{foreach item=CronjobInfo from=$CronjobArray}
		{if $CronjobInfo.isActive}{assign var="cronActive" value=$cronActive+1}{/if}
		{if $CronjobInfo.lock}{assign var="cronLocked" value=$cronLocked+1}{/if}
	{/foreach}

	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Cronjobs</span>
			<strong class="admin-kpi-card__value">{$cronTotal}</strong>
			<span class="admin-kpi-card__meta">ensemble configuré</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Actifs</span>
			<strong class="admin-kpi-card__value">{$cronActive}</strong>
			<span class="admin-kpi-card__meta">désactivés : {$cronTotal-$cronActive}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Verrous</span>
			<strong class="admin-kpi-card__value">{$cronLocked}</strong>
			<span class="admin-kpi-card__meta">libres : {$cronTotal-$cronLocked}</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Tâches planifiées</h2>
					<p class="text-white-50 mb-0">Le pilotage distingue l’état métier, le verrou technique et la prochaine exécution pour éviter les ambiguïtés.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=cronjob&mode=showCronjobCreate">{$LNG.cronjob_new}</a>
					<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=supervision">Supervision</a>
				</div>
			</div>
		</div>
	</section>

	<section class="admin-table-shell">
		<div class="table-responsive">
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
							<td>{$LNG["cronName_{$CronjobInfo.name}"]}</td>
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
{/block}
