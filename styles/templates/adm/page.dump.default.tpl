{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Export</span>
			<h2>Sauvegarde SQL</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">Tables {$dumpData.sqlTables|@count}</span>
		</div>
	</section>

	<form action="admin.php?page=dump&mode=dump" class="admin-card" method="post">
		<input type="hidden" name="action" value="dump">
		<div class="admin-card__body">
			<div class="admin-overview-grid mb-3">
				<div class="admin-overview-card">
					<strong>{$dumpData.sqlTables|@count}</strong>
					<span>Tables indexées</span>
				</div>
				<div class="admin-overview-card">
					<strong>SQL</strong>
					<span>Export brut, prêt à télécharger</span>
				</div>
			</div>
			<div class="admin-table-toolbar mb-3">
				<div class="form-check mb-0">
					<input type="checkbox" id="selectAll" class="form-check-input">
					<label class="form-check-label" for="selectAll">{$LNG.du_select_all_tables}</label>
				</div>
				<div class="admin-table-toolbar__meta">
					<span class="admin-pill">Sélection multiple</span>
					<span class="admin-pill">Export à la demande</span>
				</div>
			</div>
			<details class="admin-fold admin-fold--compact" open>
				<summary class="admin-fold__summary">
					<div>
						<h3 class="h5 mb-1">{$LNG.du_choose_tables}</h3>
					</div>
					<span class="admin-pill">{$dumpData.sqlTables|@count} tables</span>
				</summary>
				<div class="admin-fold__body">
					<div class="admin-field-card">
						<div class="admin-checkbox-grid admin-checkbox-grid--scroll">
							{foreach $dumpData.sqlTables as $tableName}
								<label class="admin-checkbox-card">
									<input type="checkbox" class="form-check-input dbtable-checkbox" name="dbtables[]" value="{$tableName}">
									<span>
										<strong>{$tableName}</strong>
										<span>Inclure dans l’export SQL</span>
									</span>
								</label>
							{/foreach}
						</div>
					</div>
				</div>
			</details>
			<div class="admin-actions mt-4">
				<input class="btn btn-primary" type="submit" value="{$LNG.du_submit}">
			</div>
		</div>
	</form>
</div>

<script>
$(function() {
	$('#selectAll').on('click', function() {
		$('.dbtable-checkbox').prop('checked', $('#selectAll').prop('checked'));
	});
});
</script>
{/block}
