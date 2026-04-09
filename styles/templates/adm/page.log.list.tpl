{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Audit</span>
			<h2>Liste des journaux</h2>
		</div>
		<div class="admin-headerline__actions">
			<a class="admin-shell-action admin-shell-action--light" href="?page=log">Retour aux catégories</a>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Historique filtré</span>
				<span class="admin-pill">Détail disponible</span>
			</div>
		</div>
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
							<td class="fw-semibold">#{$LogInfo.id}</td>
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
