{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Éditeur de compte</span>
			<h1 class="admin-hero__title">{$planetHero.title}</h1>
			<p class="admin-hero__subtitle">{$planetHero.subtitle}</p>
		</div>
	</section>

	<form action="admin.php?page=accounts&amp;mode=planetsSend" method="post" class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<a class="btn btn-outline-light" href="admin.php?page=accounts">{$LNG.ad_back_to_menu}</a>
		</div>
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.input_id_p_m}</span>
				<input class="form-control bg-dark text-white border-secondary" name="id" type="text" size="5" maxlength="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_pla_edit_name}</span>
				<input class="form-control bg-dark text-white border-secondary" name="name" type="text" size="20">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_pla_edit_diameter}</span>
				<input class="form-control bg-dark text-white border-secondary" name="diameter" type="text" size="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_pla_edit_fields}</span>
				<input class="form-control bg-dark text-white border-secondary" name="fields" type="text" size="5">
			</label>
		</div>

		<div class="admin-form-row">
			<label class="admin-field-card"><span>{$LNG.ad_pla_delete_b}</span><input class="form-check-input mt-2" name="0_buildings" type="checkbox"></label>
			<label class="admin-field-card"><span>{$LNG.ad_pla_delete_s}</span><input class="form-check-input mt-2" name="0_ships" type="checkbox"></label>
			<label class="admin-field-card"><span>{$LNG.ad_pla_delete_d}</span><input class="form-check-input mt-2" name="0_defenses" type="checkbox"></label>
			<label class="admin-field-card"><span>{$LNG.ad_pla_delete_hd}</span><input class="form-check-input mt-2" name="0_c_hangar" type="checkbox"></label>
			<label class="admin-field-card"><span>{$LNG.ad_pla_delete_cb}</span><input class="form-check-input mt-2" name="0_c_buildings" type="checkbox"></label>
		</div>

		<div class="admin-field-card">
			<span>{$LNG.ad_pla_change_p}</span>
			<div class="d-flex flex-wrap gap-2 align-items-center">
				<input class="form-check-input" name="change_position" type="checkbox" title="{$LNG.ad_pla_change_pp}">
				<input class="form-control bg-dark text-white border-secondary" name="g" type="text" size="1" maxlength="1" placeholder="G">
				<input class="form-control bg-dark text-white border-secondary" name="s" type="text" size="3" maxlength="3" placeholder="S">
				<input class="form-control bg-dark text-white border-secondary" name="p" type="text" size="2" maxlength="2" placeholder="P">
			</div>
		</div>

		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
			<button type="reset" class="btn btn-outline-light">{$LNG.button_reset}</button>
		</div>
	</form>
</div>
{/block}
