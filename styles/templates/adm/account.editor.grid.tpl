<div class="admin-settings-shell admin-stack">
	<form action="{$editorConfig.actionUrl}" method="post" class="admin-table-shell admin-stack">
		<div class="admin-headerline admin-headerline--compact">
			<div class="admin-headerline__copy">
				<span class="admin-pill">{$editorConfig.title}</span>
				<h2>{$editorConfig.title}</h2>
			</div>
			<div class="admin-headerline__actions">
				<a class="admin-shell-action admin-shell-action--light" href="{$editorConfig.backUrl}">{$editorConfig.backLabel}</a>
			</div>
		</div>

		<div class="admin-kpi-grid admin-kpi-grid--editor">
			<article class="admin-kpi-card admin-kpi-card--micro">
				<span class="admin-kpi-card__label">Éléments</span>
				<strong class="admin-kpi-card__value">{$inputlist|@count}</strong>
				<span class="admin-kpi-card__meta">assets éditables</span>
			</article>
			<article class="admin-kpi-card admin-kpi-card--micro">
				<span class="admin-kpi-card__label">Cible</span>
				<strong class="admin-kpi-card__value">{$editorConfig.targetLabel}</strong>
				<span class="admin-kpi-card__meta">identifiant requis</span>
			</article>
			<article class="admin-kpi-card admin-kpi-card--micro">
				<span class="admin-kpi-card__label">Saisie</span>
				<strong class="admin-kpi-card__value">{$editorConfig.valueLabel}</strong>
				<span class="admin-kpi-card__meta">0 ignore la ligne</span>
			</article>
		</div>

		<div class="admin-table-toolbar admin-table-toolbar--editor">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Action globale</span>
				<span class="admin-pill">Application immédiate</span>
			</div>
			<div class="admin-segmented admin-segmented--editor" role="group" aria-label="Type d'opération">
				<label class="admin-segmented__item">
					<input type="radio" name="type" value="add" checked>
					<span>{$LNG.button_add}</span>
				</label>
				<label class="admin-segmented__item">
					<input type="radio" name="type" value="delete">
					<span>{$LNG.button_delete}</span>
				</label>
			</div>
		</div>

		<div class="admin-form-row admin-form-row--editor admin-form-row--editor-compact">
			<label class="admin-field-card">
				<span>{$editorConfig.targetLabel}</span>
				<input class="form-control bg-dark text-white border-secondary" name="{$editorConfig.targetName}" type="text" value="0" size="{$editorConfig.targetSize|default:5}" placeholder="{$editorConfig.targetPlaceholder|default:''}">
			</label>
			<div class="admin-field-card admin-field-card--hint">
				<span>Règle</span>
				<strong>{$editorConfig.valueLabel} par asset</strong>
				<small>Les champs à 0 restent inchangés.</small>
			</div>
		</div>

		<div class="admin-asset-editor-grid">
			{foreach from=$inputlist item=input}
				<label class="admin-asset-editor-card" {if !empty($input.tooltip)}title="{$input.tooltip|escape:'html'}"{/if}>
					<span class="admin-asset-editor-card__media">
						<img src="{$input.image}" alt="{$input.label|escape:'html'}">
					</span>
					<span class="admin-asset-editor-card__body">
						<strong>{$input.label}</strong>
						<span>#{$input.id}</span>
					</span>
					<span class="admin-asset-editor-card__entry">
						<input class="form-control bg-dark text-white border-secondary text-center" name="{$input.type}" type="text" inputmode="numeric" value="0" placeholder="{$editorConfig.valueLabel}">
					</span>
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
