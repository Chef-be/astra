{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h2 class="h3">Créer un nouveau compte</h2>
			<p>Assistant de création complet avec positionnement initial, niveau d’accès et langue.</p>
		</div>
		<div class="admin-actions">
			<a class="btn btn-outline-light" href="?page=create">Retour</a>
			<a class="btn btn-outline-info" href="?page=create&mode=user">Réinitialiser</a>
		</div>
	</div>

	<form class="admin-card" action="?page=create&mode=createUser" method="post">
		<div class="admin-card__body">
			<div class="admin-form-grid">
				<div class="admin-field-card">
					<label for="name">{$LNG.user_reg}</label>
					<input id="name" class="form-control bg-dark text-white border-secondary" type="text" name="name">
				</div>
				<div class="admin-field-card">
					<label for="authlevel">{$LNG.new_range}</label>
					<select id="authlevel" class="form-select bg-dark text-white border-secondary" name="authlevel">
						{foreach $Selector.auth as $key => $currentAuth}
							<option value="{$key}">{$currentAuth}</option>
						{/foreach}
					</select>
				</div>
				<div class="admin-field-card">
					<label for="password">{$LNG.pass_reg}</label>
					<input id="password" class="form-control bg-dark text-white border-secondary" type="password" name="password" autocomplete="new-password">
				</div>
				<div class="admin-field-card">
					<label for="password2">{$LNG.pass2_reg}</label>
					<input id="password2" class="form-control bg-dark text-white border-secondary" type="password" name="password2" autocomplete="new-password">
				</div>
				<div class="admin-field-card">
					<label for="email">{$LNG.email_reg}</label>
					<input id="email" class="form-control bg-dark text-white border-secondary" type="email" name="email">
				</div>
				<div class="admin-field-card">
					<label for="email2">{$LNG.email2_reg}</label>
					<input id="email2" class="form-control bg-dark text-white border-secondary" type="email" name="email2">
				</div>
				<div class="admin-field-card">
					<label for="lang">{$LNG.lang_reg}</label>
					<select id="lang" class="form-select bg-dark text-white border-secondary" name="lang">
						{foreach $Selector.lang as $key => $currentLang}
							<option value="{$key}">{$currentLang}</option>
						{/foreach}
					</select>
				</div>
				<div class="admin-field-card admin-field--full">
					<label for="galaxy">{$LNG.new_coord}</label>
					<div class="admin-actions align-items-center">
						<input id="galaxy" style="width:90px;" class="form-control bg-dark text-white border-secondary" type="text" name="galaxy" maxlength="1" placeholder="G">
						<span>:</span>
						<input style="width:90px;" class="form-control bg-dark text-white border-secondary" type="text" name="system" maxlength="3" placeholder="S">
						<span>:</span>
						<input style="width:90px;" class="form-control bg-dark text-white border-secondary" type="text" name="planet" maxlength="2" placeholder="P">
					</div>
				</div>
			</div>
			<div class="admin-actions mt-4">
				<button class="btn btn-primary" type="submit">{$LNG.new_add_user}</button>
				<a class="btn btn-outline-light" href="?page=create">{$LNG.new_creator_go_back}</a>
			</div>
		</div>
	</form>
</div>
{/block}
