{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline">
		<div class="admin-headerline__lead">
			<span class="admin-headerline__eyebrow">Création orbitale</span>
			<h1 class="admin-headerline__title">Créer une lune</h1>
		</div>
		<div class="admin-actions admin-actions--header">
			<a class="admin-shell-action admin-shell-action--light" href="?page=create">Retour</a>
			<a class="admin-shell-action admin-shell-action--light" href="?page=create&mode=moon">Réinitialiser</a>
		</div>
	</section>

	<form class="admin-card" action="?page=create&mode=createMoon" method="post">
		<div class="admin-card__body">
			<div class="admin-form-grid">
				<div class="admin-field-card">
					<label for="add_moon">{$LNG.input_id_planet}</label>
					<input id="add_moon" class="form-control bg-dark text-white border-secondary" type="text" name="add_moon">
				</div>
				<div class="admin-field-card">
					<label for="name">{$LNG.mo_moon_name}</label>
					<input id="name" class="form-control bg-dark text-white border-secondary" type="text" value="{$LNG.mo_moon}" name="name">
				</div>
				<div class="admin-field-card">
					<label for="diameter">{$LNG.mo_diameter}</label>
					<input id="diameter" class="form-control bg-dark text-white border-secondary" type="text" name="diameter" maxlength="5">
				</div>
				<div class="admin-field-card">
					<div class="form-check mt-4">
						<input id="diameter_check" class="form-check-input" type="checkbox" checked="checked" name="diameter_check">
						<label for="diameter_check" class="form-check-label">{$LNG.mo_moon_random}</label>
					</div>
				</div>
				<div class="admin-field-card">
					<label for="field_max">{$LNG.mo_fields_avaibles}</label>
					<input id="field_max" class="form-control bg-dark text-white border-secondary" type="text" name="field_max" maxlength="5" value="1">
				</div>
			</div>
			<div class="admin-actions mt-4">
				<button class="btn btn-primary" type="submit">{$LNG.button_add}</button>
				<a class="btn btn-outline-light" href="?page=create">{$LNG.new_creator_go_back}</a>
			</div>
		</div>
	</form>
</div>
{/block}
