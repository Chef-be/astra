<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Éditeur de compte</span>
			<h1 class="admin-hero__title">{$editorConfig.title}</h1>
			<p class="admin-hero__subtitle">{$editorConfig.subtitle}</p>
		</div>
	</section>

	<form action="{$editorConfig.actionUrl}" method="post" class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<a class="btn btn-outline-light" href="{$editorConfig.backUrl}">{$editorConfig.backLabel}</a>
		</div>

		<div class="admin-form-row">
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

		<div class="admin-media-grid">
			{foreach from=$inputlist item=input}
				<label class="admin-media-tile">
					<img src="{$input.image}" alt="{$input.label|escape:'html'}">
					<strong>{$input.label}</strong>
					<span>#{$input.id}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="{$input.type}" type="text" value="0" placeholder="{$editorConfig.valueLabel}">
				</label>
			{/foreach}
		</div>

		<div class="admin-actions">
			<button type="reset" class="btn btn-outline-light">{$LNG.button_reset}</button>
			<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
		</div>
	</form>
</div>
