{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h2 class="h3">Liste des journaux</h2>
			<p>Chaque ligne permet d’ouvrir le détail complet d’une modification enregistrée.</p>
		</div>
		<div class="admin-actions">
			<a class="btn btn-outline-light" href="?page=log">Retour aux catégories</a>
		</div>
	</div>

	<div class="admin-table-shell">
		<div class="table-responsive">
			<table class="table table-dark table-striped align-middle mb-0">
				<thead>
					<tr>
						<th>{$log_id}</th>
						<th>{$log_admin}</th>
						<th>{$log_uni}</th>
						<th>{$log_target}</th>
						<th>{$log_time}</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					{foreach item=LogInfo from=$LogArray}
						<tr>
							<td>#{$LogInfo.id}</td>
							<td>{$LogInfo.admin}</td>
							<td>{$LogInfo.target_uni}</td>
							<td>{$LogInfo.target}</td>
							<td>{$LogInfo.time}</td>
							<td><a class="btn btn-outline-info btn-sm" href="?page=log&mode=detail&id={$LogInfo.id}">{$log_view}</a></td>
						</tr>
					{foreachelse}
						<tr>
							<td colspan="6">
								<div class="admin-empty">Aucune entrée de journal n’est disponible pour ce périmètre.</div>
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
</div>
{/block}
