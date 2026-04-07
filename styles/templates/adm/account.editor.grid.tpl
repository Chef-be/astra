<div class="admin-settings-shell admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Module</span>
			<strong class="admin-kpi-card__value">{$editorConfig.title}</strong>
			<span class="admin-kpi-card__meta">édition ciblée par domaine</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Entrées pilotables</span>
			<strong class="admin-kpi-card__value">{$inputlist|@count}</strong>
			<span class="admin-kpi-card__meta">éléments disponibles dans cette grille</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Cible attendue</span>
			<strong class="admin-kpi-card__value">{$editorConfig.targetLabel}</strong>
			<span class="admin-kpi-card__meta">identifiant demandé avant application</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">{$editorConfig.title}</h2>
					<p class="text-white-50 mb-0">{$editorConfig.subtitle}</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="{$editorConfig.backUrl}">{$editorConfig.backLabel}</a>
					<span class="admin-pill">Valeur saisie par case</span>
				</div>
			</div>
		</div>
	</section>

	<form action="{$editorConfig.actionUrl}" method="post" class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Ajout ou retrait</span>
				<span class="admin-pill">Application immédiate</span>
			</div>
			<div class="small text-white-50">Les cases laissées à 0 ne modifient rien.</div>
		</div>

		<div class="admin-form-row admin-form-row--editor">
			<label class="admin-field-card">
				<span>{$editorConfig.targetLabel}</span>
				<input class="form-control bg-dark text-white border-secondary" name="{$editorConfig.targetName}" type="text" value="0" size="{$editorConfig.targetSize|default:5}" placeholder="{$editorConfig.targetPlaceholder|default:''}">
			</label>
			<label class="admin-field-card">
				<span>Opération</span>
				<select name="type" class="form-select bg-dark text-white border-secondary">
					<option value="add" selected>{$LNG.button_add}</option>
					<option value="delete">{$LNG.button_delete}</option>
				</select>
			</label>
		</div>

		<div class="admin-media-grid admin-media-grid--editor">
			{foreach from=$inputlist item=input}
				<label class="admin-media-tile">
					<img src="{$input.image}" alt="{$input.label|escape:'html'}">
					<strong>{$input.label}</strong>
					<span>#{$input.id}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="{$input.type}" type="text" value="0" placeholder="{$editorConfig.valueLabel}">
				</label>
			{/foreach}
		</div>

		<div class="admin-actions justify-content-between align-items-center">
			<div class="small text-white-50">Travaillez par lots courts pour garder une trace d’audit lisible.</div>
			<div class="d-flex gap-2 flex-wrap">
				<button type="reset" class="btn btn-outline-light">{$LNG.button_reset}</button>
				<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
			</div>
		</div>
	</form>
</div>
