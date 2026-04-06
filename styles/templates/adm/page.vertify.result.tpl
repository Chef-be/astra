{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Résultat de contrôle</span>
			<h1 class="admin-hero__title">Analyse des écarts de fichiers</h1>
			<p class="admin-hero__subtitle">Suivez la progression du contrôle et repérez les fichiers conformes, divergents, nouveaux ou inaccessibles.</p>
		</div>
	</section>

	<div class="admin-table-shell admin-stack">
		<div class="admin-empty-state text-start">{$LNG.vt_info}</div>
		<div>
			<div class="processbar" style="background-color: green; height: 14px; width: 0; border-radius: 999px;"></div>
			<div class="info small text-white-50 mt-2"></div>
		</div>
		<div class="admin-stat-strip">
			<div class="admin-stat-card"><span class="admin-stat-card__label">{$LNG.vt_fileok}</span><strong class="admin-stat-card__value" id="fileok">0</strong></div>
			<div class="admin-stat-card"><span class="admin-stat-card__label">{$LNG.vt_filefail}</span><strong class="admin-stat-card__value" id="filefail">0</strong></div>
			<div class="admin-stat-card"><span class="admin-stat-card__label">{$LNG.vt_filenew}</span><strong class="admin-stat-card__value" id="filenew">0</strong></div>
			<div class="admin-stat-card"><span class="admin-stat-card__label">{$LNG.vt_fileerror}</span><strong class="admin-stat-card__value" id="fileerror">0</strong></div>
		</div>
		<div id="result" class="admin-empty-state text-start" style="max-height: 22rem; overflow-y: auto;">
			<div>{$LNG.vt_loadfile}</div>
		</div>
	</div>
</div>
{/block}
