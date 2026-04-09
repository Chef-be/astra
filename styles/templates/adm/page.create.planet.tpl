{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline">
		<div class="admin-headerline__lead">
			<span class="admin-headerline__eyebrow">Création orbitale</span>
			<h1 class="admin-headerline__title">Créer une planète</h1>
		</div>
		<div class="admin-actions admin-actions--header">
			<a class="admin-shell-action admin-shell-action--light" href="?page=create">Retour</a>
			<a class="admin-shell-action admin-shell-action--light" href="?page=create&mode=planet">Réinitialiser</a>
		</div>
	</section>

	<form class="admin-card" action="?page=create&mode=createPlanet" method="post">
		<div class="admin-card__body">
			<div class="admin-form-grid">
				<div class="admin-field-card">
					<label for="id">{$LNG.input_id_user}</label>
					<input id="id" name="id" class="form-control bg-dark text-white border-secondary" type="text">
				</div>
				<div class="admin-field-card admin-field--full">
					<label for="galaxy">{$LNG.new_creator_coor}</label>
					<div class="admin-actions align-items-center">
						<input id="galaxy" style="width:90px;" name="galaxy" class="form-control bg-dark text-white border-secondary" type="text" maxlength="1" title="{$LNG.po_galaxy}">
						<span>:</span>
						<input style="width:90px;" name="system" class="form-control bg-dark text-white border-secondary" type="text" maxlength="3" title="{$LNG.po_system}">
						<span>:</span>
						<input style="width:90px;" name="planet" class="form-control bg-dark text-white border-secondary" type="text" maxlength="2" title="{$LNG.po_planet}">
					</div>
				</div>
				<div class="admin-field-card">
					<label for="name">{$LNG.po_name_planet}</label>
					<input id="name" name="name" class="form-control bg-dark text-white border-secondary" type="text" maxlength="25" value="{$LNG.po_colony}">
				</div>
				<div class="admin-field-card">
					<label for="field_max">{$LNG.po_fields_max}</label>
					<input id="field_max" name="field_max" class="form-control bg-dark text-white border-secondary" type="text" maxlength="10">
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
