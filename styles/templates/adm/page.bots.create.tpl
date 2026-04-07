{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Population automatisée</span>
			<h1 class="admin-hero__title">Création de bots</h1>
			<p class="admin-hero__subtitle">Préparez une vague cohérente de bots avec profil, dotation initiale, galaxie cible, adresse mail commune et mots de passe aléatoires distincts.</p>
		</div>
	</section>

	<form action="admin.php?page=bots&amp;mode=createSend" method="post" class="admin-table-shell admin-stack">
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>Nombre de bots</span>
				<input id="bots_number" class="form-control bg-dark text-white border-secondary" type="number" name="bots_number" value="0">
			</label>
			<label class="admin-field-card">
				<span>Nom des bots</span>
				<select id="bot_name_type" class="form-select bg-dark text-white border-secondary" name="bot_name_type">
					<option selected value="0">Nom de personnage</option>
					<option value="1">Nom de personnage + identifiant</option>
				</select>
			</label>
			<label class="admin-field-card">
				<span>Profil d’activité</span>
				<select id="bot_profile_id" class="form-select bg-dark text-white border-secondary" name="bot_profile_id">
					<option value="0">Répartition automatique</option>
					{foreach from=$botProfiles item=profile}
						<option value="{$profile.id}">{$profile.name}</option>
					{/foreach}
				</select>
			</label>
			<label class="admin-field-card">
				<span>Galaxie cible</span>
				<input id="target_galaxy" class="form-control bg-dark text-white border-secondary" type="number" name="target_galaxy" value="1">
			</label>
			<label class="admin-field-card">
				<span>Matière noire initiale</span>
				<input id="bots_dm" class="form-control bg-dark text-white border-secondary" type="number" name="bots_dm" value="0">
			</label>
			<label class="admin-field-card">
				<span>Adresse mail commune</span>
				<input class="form-control bg-dark text-white border-secondary" type="text" value="{$botConfig.shared_email|escape}" readonly="readonly">
			</label>
		</div>

		<div class="admin-media-grid">
			<label class="admin-media-tile">
				<img src="./styles/theme/nextgen/gebaeude/901.gif" alt="Métal">
				<strong>Métal</strong>
				<input id="planet_metal" class="form-control bg-dark text-white border-secondary text-center" type="number" name="planet_metal" value="10000">
			</label>
			<label class="admin-media-tile">
				<img src="./styles/theme/nextgen/gebaeude/902.gif" alt="Cristal">
				<strong>Cristal</strong>
				<input id="planet_crystal" class="form-control bg-dark text-white border-secondary text-center" type="number" name="planet_crystal" value="10000">
			</label>
			<label class="admin-media-tile">
				<img src="./styles/theme/nextgen/gebaeude/903.gif" alt="Deutérium">
				<strong>Deutérium</strong>
				<input id="planet_deuterium" class="form-control bg-dark text-white border-secondary text-center" type="number" name="planet_deuterium" value="10000">
			</label>
			<label class="admin-media-tile">
				<img src="./styles/theme/nextgen/planeten/small/s_normaltempplanet04.jpg" alt="Champs">
				<strong>Champs</strong>
				<input id="planet_field_max" class="form-control bg-dark text-white border-secondary text-center" type="number" name="planet_field_max" value="163">
			</label>
		</div>

		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">Créer les bots</button>
		</div>
	</form>
</div>
{/block}
