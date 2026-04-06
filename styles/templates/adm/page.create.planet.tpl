{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h2 class="h3">Créer une planète</h2>
			<p>Ajoutez une planète à un joueur existant en définissant sa position orbitale et sa capacité initiale.</p>
		</div>
		<div class="admin-actions">
			<a class="btn btn-outline-light" href="?page=create">Retour</a>
			<a class="btn btn-outline-info" href="?page=create&mode=planet">Réinitialiser</a>
		</div>
	</div>

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
