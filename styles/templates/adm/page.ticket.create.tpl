{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Assistance</span>
			<h2>Créer un ticket</h2>
		</div>
	</section>

	<form action="admin.php?page=support&amp;mode=send" method="post" id="form" class="admin-table-shell admin-stack">
		<input type="hidden" name="id" value="0">
		<div class="admin-empty-state text-start">{$LNG.ti_create_info}</div>
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.ti_category}</span>
				<select id="category" name="category" class="form-select bg-dark text-white border-secondary">{html_options options=$categoryList}</select>
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ti_subject}</span>
				<input class="validate[required] form-control bg-dark text-white border-secondary" type="text" id="subject" name="subject" maxlength="255">
			</label>
		</div>
		<label class="admin-field-card">
			<span>{$LNG.ti_message}</span>
			<textarea class="validate[required] form-control bg-dark text-white border-secondary rich-editor" id="message" name="message" rows="10"></textarea>
		</label>
		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.ti_submit}</button>
		</div>
	</form>
</div>
{/block}
