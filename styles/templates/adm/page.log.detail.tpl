{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Audit détaillé</span>
			<h2>Entrée #{$id}</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">{$log_admin} {$admin}</span>
			<span class="admin-pill">{$log_target} {$target}</span>
			<span class="admin-pill">{$log_time} {$time}</span>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Ancienne valeur</span>
				<span class="admin-pill">Nouvelle valeur</span>
			</div>
		</div>
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
