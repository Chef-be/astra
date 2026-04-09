{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Éditeur de compte</span>
			<h2>{$allianceHero.title}</h2>
		</div>
	</section>

	<form action="admin.php?page=accounts&amp;mode=allianceSend" method="post" class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<a class="btn btn-outline-light" href="admin.php?page=accounts">{$LNG.ad_back_to_menu}</a>
		</div>
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.input_id_ally}</span>
				<input class="form-control bg-dark text-white border-secondary" name="id" type="text" size="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_ally_change_id} {$LNG.ad_ally_user_id}</span>
				<input class="form-control bg-dark text-white border-secondary" name="changeleader" type="text" size="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_ally_name}</span>
				<input class="form-control bg-dark text-white border-secondary" name="name" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_ally_tag}</span>
				<input class="form-control bg-dark text-white border-secondary" name="tag" type="text" size="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_ally_delete_u} {$LNG.ad_ally_user_id}</span>
				<input class="form-control bg-dark text-white border-secondary" name="delete_u" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_ally_delete}</span>
				<input class="form-check-input mt-2" name="delete" type="checkbox">
			</label>
		</div>
		<label class="admin-field-card">
			<span>{$LNG.ad_ally_text1}</span>
			<textarea class="form-control bg-dark text-white border-secondary rich-editor" name="externo" rows="10"></textarea>
		</label>
		<label class="admin-field-card">
			<span>{$LNG.ad_ally_text2}</span>
			<textarea class="form-control bg-dark text-white border-secondary rich-editor" name="interno" rows="10"></textarea>
		</label>
		<label class="admin-field-card">
			<span>{$LNG.ad_ally_text3}</span>
			<textarea class="form-control bg-dark text-white border-secondary rich-editor" name="solicitud" rows="10"></textarea>
		</label>
		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
		</div>
	</form>
</div>
{/block}
