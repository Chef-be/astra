{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Éditeur de compte</span>
			<h1 class="admin-hero__title">Ressources et matière noire</h1>
			<p class="admin-hero__subtitle">Distribuez ou retirez des ressources par identifiant de planète, par coordonnées, ou directement sur le compte pour la matière noire.</p>
		</div>
	</section>

	<div class="admin-split">
		<form action="admin.php?page=accounts&amp;mode=resourcesSend" method="post" class="admin-table-shell admin-stack">
			<div class="admin-table-toolbar">
				<a class="btn btn-outline-light" href="admin.php?page=accounts">{$LNG.ad_back_to_menu}</a>
			</div>
			<div class="admin-form-grid">
				<label class="admin-field-card">
					<span>{$LNG.input_id_p_m}</span>
					<input class="form-control bg-dark text-white border-secondary" name="id" type="text" value="0" size="3">
				</label>
				<label class="admin-field-card">
					<span>Coordonnées</span>
					<div class="d-flex gap-2 align-items-center">
						<input class="form-control bg-dark text-white border-secondary" name="galaxy" type="text" value="0" size="3">
						<input class="form-control bg-dark text-white border-secondary" name="system" type="text" value="0" size="3">
						<input class="form-control bg-dark text-white border-secondary" name="planet" type="text" value="0" size="3">
						<select class="form-select bg-dark text-white border-secondary" name="planet_type">
							<option value="1">Planète</option>
							<option value="3">Lune</option>
						</select>
					</div>
				</label>
				<label class="admin-field-card">
					<span>Opération</span>
					<select class="form-select bg-dark text-white border-secondary" name="type">
						<option value="add" selected>{$LNG.button_add}</option>
						<option value="delete">{$LNG.button_delete}</option>
					</select>
				</label>
			</div>

			<div class="admin-media-grid">
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/901.gif" alt="{$LNG.tech.901}">
					<strong>{$LNG.tech.901}</strong>
					<input class="form-control bg-dark text-white border-secondary text-center" name="metal" type="text" value="0">
				</label>
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/902.gif" alt="{$LNG.tech.902}">
					<strong>{$LNG.tech.902}</strong>
					<input class="form-control bg-dark text-white border-secondary text-center" name="cristal" type="text" value="0">
				</label>
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/903.gif" alt="{$LNG.tech.903}">
					<strong>{$LNG.tech.903}</strong>
					<input class="form-control bg-dark text-white border-secondary text-center" name="deut" type="text" value="0">
				</label>
			</div>

			<div class="admin-actions">
				<button type="reset" class="btn btn-outline-light">{$LNG.button_reset}</button>
				<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
			</div>
		</form>

		<form action="admin.php?page=accounts&amp;mode=darkmatterSend" method="post" class="admin-table-shell admin-stack">
			<div>
				<h2 class="h5 mb-1">{$LNG.tech.921}</h2>
				<p class="text-white-50 mb-0">Intervenez directement sur la matière noire d’un compte joueur.</p>
			</div>
			<label class="admin-field-card">
				<span>{$LNG.input_id_user}</span>
				<input class="form-control bg-dark text-white border-secondary" name="user_id" type="text" value="0" size="3">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.tech.921}</span>
				<input class="form-control bg-dark text-white border-secondary" name="dark" type="text" value="0">
			</label>
			<label class="admin-field-card">
				<span>Opération</span>
				<select class="form-select bg-dark text-white border-secondary" name="type">
					<option value="add" selected>{$LNG.button_add}</option>
					<option value="delete">{$LNG.button_delete}</option>
				</select>
			</label>
			<div class="admin-actions">
				<button type="reset" class="btn btn-outline-light">{$LNG.button_reset}</button>
				<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
			</div>
		</form>
	</div>
</div>
{/block}
