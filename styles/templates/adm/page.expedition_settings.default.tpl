{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Gameplay</span>
			<h1 class="admin-hero__title">Réglages des expéditions</h1>
			<p class="admin-hero__subtitle">Ajustez les événements possibles, les facteurs de gains et les probabilités qui pilotent le contenu des expéditions.</p>
		</div>
	</section>

	<form class="admin-stack" action="admin.php?page=expedition&amp;mode=send" method="post">
		<input type="hidden" name="opt_save" value="1">

		<details class="admin-fold admin-fold--compact" open>
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">Événements autorisés</h2>
					<p class="text-white-50 mb-0">Activez ou neutralisez chaque famille d’événements.</p>
				</div>
				<span class="admin-pill">9 paramètres</span>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-table-shell admin-stack">
					<div class="admin-form-row">
						<label class="admin-field-card"><span>Perte de flotte</span><input class="form-check-input mt-2" id="expedition_allow_fleet_loss" name="expedition_allow_fleet_loss" {if $expedition_allow_fleet_loss}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Retard de flotte</span><input class="form-check-input mt-2" id="expedition_allow_fleet_delay" name="expedition_allow_fleet_delay" {if $expedition_allow_fleet_delay}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Accélération de flotte</span><input class="form-check-input mt-2" id="expedition_allow_fleet_speedup" name="expedition_allow_fleet_speedup" {if $expedition_allow_fleet_speedup}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Combats en expédition</span><input class="form-check-input mt-2" id="expedition_allow_expedition_war" name="expedition_allow_expedition_war" {if $expedition_allow_expedition_war}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Découverte de matière noire</span><input class="form-check-input mt-2" id="expedition_allow_darkmatter_find" name="expedition_allow_darkmatter_find" {if $expedition_allow_darkmatter_find}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Découverte de ressources</span><input class="form-check-input mt-2" id="expedition_allow_resources_find" name="expedition_allow_resources_find" {if $expedition_allow_resources_find}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Découverte de vaisseaux</span><input class="form-check-input mt-2" id="expedition_allow_ships_find" name="expedition_allow_ships_find" {if $expedition_allow_ships_find}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Prendre en compte le maintien</span><input class="form-check-input mt-2" id="expedition_consider_holdtime" name="expedition_consider_holdtime" {if $expedition_consider_holdtime}checked="checked"{/if} type="checkbox"></label>
						<label class="admin-field-card"><span>Prendre en compte les coordonnées identiques</span><input class="form-check-input mt-2" id="expedition_consider_same_coordinate" name="expedition_consider_same_coordinate" {if $expedition_consider_same_coordinate}checked="checked"{/if} type="checkbox"></label>
					</div>
				</div>
			</div>
		</details>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">Facteurs</h2>
					<p class="text-white-50 mb-0">Volume des gains générés pour les expéditions récompensantes.</p>
				</div>
				<span class="admin-pill">2 facteurs</span>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-table-shell admin-stack">
					<div class="admin-form-grid">
						<label class="admin-field-card">
							<span>Facteur de ressources</span>
							<input class="form-control bg-dark text-white border-secondary" id="expedition_factor_resources" name="expedition_factor_resources" value="{$expedition_factor_resources}" type="number" min="0" max="1000" step="0.1">
						</label>
						<label class="admin-field-card">
							<span>Facteur de vaisseaux</span>
							<input class="form-control bg-dark text-white border-secondary" id="expedition_factor_ships" name="expedition_factor_ships" value="{$expedition_factor_ships}" type="number" min="0" max="1000" step="0.1">
						</label>
					</div>
				</div>
			</div>
		</details>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">Probabilités</h2>
					<p class="text-white-50 mb-0">Chances de rencontrer chaque type d’issue.</p>
				</div>
				<span class="admin-pill">4 chances</span>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-table-shell admin-stack">
					<div class="admin-form-grid">
						<label class="admin-field-card"><span>Ressources</span><input class="form-control bg-dark text-white border-secondary" id="expedition_chances_percent_resources" name="expedition_chances_percent_resources" value="{$expedition_chances_percent_resources}" type="number" min="0" max="100" step="0.1"></label>
						<label class="admin-field-card"><span>Matière noire</span><input class="form-control bg-dark text-white border-secondary" id="expedition_chances_percent_darkmatter" name="expedition_chances_percent_darkmatter" value="{$expedition_chances_percent_darkmatter}" type="number" min="0" max="100" step="0.1"></label>
						<label class="admin-field-card"><span>Vaisseaux</span><input class="form-control bg-dark text-white border-secondary" id="expedition_chances_percent_ships" name="expedition_chances_percent_ships" value="{$expedition_chances_percent_ships}" type="number" min="0" max="100" step="0.1"></label>
						<label class="admin-field-card"><span>Pirates</span><input class="form-control bg-dark text-white border-secondary" id="expedition_chances_percent_pirates" name="expedition_chances_percent_pirates" value="{$expedition_chances_percent_pirates}" type="number" min="0" max="100" step="0.1"></label>
					</div>
				</div>
			</div>
		</details>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">Rendement en matière noire</h2>
					<p class="text-white-50 mb-0">Barèmes des événements petit, grand et très grand format.</p>
				</div>
				<span class="admin-pill">6 bornes</span>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-table-shell admin-stack">
					<div class="admin-form-grid">
						<label class="admin-field-card"><span>Petit événement minimum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_small_min" name="expedition_min_darkmatter_small_min" value="{$expedition_min_darkmatter_small_min}" type="text"></label>
						<label class="admin-field-card"><span>Petit événement maximum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_small_max" name="expedition_min_darkmatter_small_max" value="{$expedition_min_darkmatter_small_max}" type="text"></label>
						<label class="admin-field-card"><span>Grand événement minimum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_large_min" name="expedition_min_darkmatter_large_min" value="{$expedition_min_darkmatter_large_min}" type="text"></label>
						<label class="admin-field-card"><span>Grand événement maximum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_large_max" name="expedition_min_darkmatter_large_max" value="{$expedition_min_darkmatter_large_max}" type="text"></label>
						<label class="admin-field-card"><span>Très grand événement minimum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_vlarge_min" name="expedition_min_darkmatter_vlarge_min" value="{$expedition_min_darkmatter_vlarge_min}" type="text"></label>
						<label class="admin-field-card"><span>Très grand événement maximum</span><input class="form-control bg-dark text-white border-secondary" id="expedition_min_darkmatter_vlarge_max" name="expedition_min_darkmatter_vlarge_max" value="{$expedition_min_darkmatter_vlarge_max}" type="text"></label>
					</div>
				</div>
			</div>
		</details>

		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.se_save_parameters}</button>
		</div>
	</form>

	<form class="admin-table-shell admin-stack mt-3" action="admin.php?page=expedition&amp;mode=default" method="post">
		<div>
			<h2 class="h5 mb-1">Valeurs par défaut</h2>
			<p class="text-white-50 mb-0">Réapplique le profil d’équilibrage de base défini pour les expéditions.</p>
		</div>
		<div class="admin-actions">
			<button class="btn btn-outline-light" type="submit">Rétablir les valeurs par défaut</button>
		</div>
	</form>
</div>
{/block}
