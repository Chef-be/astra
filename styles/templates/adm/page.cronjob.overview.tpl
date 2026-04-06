{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h2 class="h3">Tâches planifiées</h2>
			<p>Pilotez les cronjobs du jeu, leur état, leur verrouillage et leur prochaine exécution.</p>
		</div>
		<div class="admin-actions">
			<a class="btn btn-primary" href="admin.php?page=cronjob&mode=showCronjobCreate">{$LNG.cronjob_new}</a>
		</div>
	</div>

	<div class="admin-table-shell">
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
	</div>
</div>
{/block}
