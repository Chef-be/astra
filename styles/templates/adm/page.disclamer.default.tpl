{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Conformité</span>
			<h2>Mentions légales</h2>
		</div>
	</section>

	<form class="admin-table-shell admin-stack" action="admin.php?page=disclamer&amp;mode=saveSettings" method="post">
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.se_disclaimerAddress}</span>
				<textarea id="disclaimerAddress" class="form-control bg-dark text-white border-secondary" name="disclaimerAddress" rows="5">{$disclaimerAddress}</textarea>
			</label>
			<label class="admin-field-card">
				<span>{$LNG.se_disclaimerPhone}</span>
				<input id="disclaimerPhone" class="form-control bg-dark text-white border-secondary" name="disclaimerPhone" value="{$disclaimerPhone}" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.se_disclaimerMail}</span>
				<input id="disclaimerMail" class="form-control bg-dark text-white border-secondary" name="disclaimerMail" value="{$disclaimerMail}" type="text">
			</label>
		</div>
		<label class="admin-field-card">
			<span>{$LNG.se_disclaimerNotice}</span>
			<textarea id="disclaimerNotice" class="form-control bg-dark text-white border-secondary rich-editor" name="disclaimerNotice" rows="12">{$disclaimerNotice|escape:'html'}</textarea>
		</label>
		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.se_save_parameters}</button>
		</div>
	</form>
</div>
{/block}
