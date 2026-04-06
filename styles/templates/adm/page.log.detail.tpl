{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-split mb-4">
		<div class="admin-mini-hero">
			<h2 class="h3">Entrée de journal #{$id}</h2>
			<p>Détail complet de la modification, avec comparaison entre l’état précédent et le nouvel état.</p>
		</div>
		<div class="admin-card">
			<div class="admin-card__body">
				<div class="admin-stat-strip">
					<div class="admin-stat-pill">{$log_admin} : {$admin}</div>
					<div class="admin-stat-pill">{$log_target} : {$target}</div>
					<div class="admin-stat-pill">{$log_time} : {$time}</div>
				</div>
			</div>
		</div>
	</div>

	<div class="admin-table-shell">
		<div class="table-responsive">
			<table class="table table-dark table-striped align-middle mb-0">
				<thead>
					<tr>
						<th>{$log_element}</th>
						<th>{$log_old}</th>
						<th>{$log_new}</th>
					</tr>
				</thead>
				<tbody>
					{foreach item=LogInfo from=$LogArray}
						{if ($LogInfo.old <> $LogInfo.new)}
							<tr>
								<td>{$LogInfo.Element}</td>
								<td>{$LogInfo.old}</td>
								<td>{$LogInfo.new}</td>
							</tr>
						{/if}
					{foreachelse}
						<tr>
							<td colspan="3">
								<div class="admin-empty">Aucune différence exploitable n’a été trouvée pour cette entrée.</div>
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
</div>
{/block}
