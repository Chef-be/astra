{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Contrôle</span>
			<h2>Analyse des écarts de fichiers</h2>
		</div>
	</section>

	<div class="admin-table-shell admin-stack">
		<div class="admin-empty-state text-start">{$LNG.vt_info}</div>
		<div>
			<div class="processbar" style="background-color: green; height: 14px; width: 0; border-radius: 999px;"></div>
			<div class="info small text-white-50 mt-2"></div>
		</div>
		<div class="admin-kpi-grid admin-kpi-grid--vertify">
			<div class="admin-kpi-card admin-kpi-card--micro"><span class="admin-kpi-card__label">{$LNG.vt_fileok}</span><strong class="admin-kpi-card__value" id="fileok">0</strong></div>
			<div class="admin-kpi-card admin-kpi-card--micro"><span class="admin-kpi-card__label">{$LNG.vt_filefail}</span><strong class="admin-kpi-card__value" id="filefail">0</strong></div>
			<div class="admin-kpi-card admin-kpi-card--micro"><span class="admin-kpi-card__label">{$LNG.vt_filenew}</span><strong class="admin-kpi-card__value" id="filenew">0</strong></div>
			<div class="admin-kpi-card admin-kpi-card--micro"><span class="admin-kpi-card__label">{$LNG.vt_fileerror}</span><strong class="admin-kpi-card__value" id="fileerror">0</strong></div>
		</div>
		<div id="result" class="admin-empty-state text-start" style="max-height: 22rem; overflow-y: auto;">
			<div>{$LNG.vt_loadfile}</div>
		</div>
	</div>
</div>
{/block}
