{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Positions orbitables</span>
			<strong class="admin-kpi-card__value">15</strong>
			<span class="admin-kpi-card__meta">de la plus chaude à la plus froide</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Réglage</span>
			<strong class="admin-kpi-card__value">Min / Max</strong>
			<span class="admin-kpi-card__meta">pour chaque case orbitale</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Secours</span>
			<strong class="admin-kpi-card__value">Valeurs par défaut</strong>
			<span class="admin-kpi-card__meta">restauration globale disponible</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Champs planétaires par position</h2>
					<p class="text-white-50 mb-0">Définissez les bornes minimales et maximales de champs pour chaque position orbitale afin d’équilibrer la génération des planètes.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="?page=universe">Univers</a>
					<a class="admin-shell-action admin-shell-action--warning" href="?page=planetFields&mode=default">Rétablir les valeurs par défaut</a>
				</div>
			</div>
		</div>
	</section>

	<form action="?page=planetFields&mode=send" method="post" class="admin-stack">
		<input type="hidden" name="opt_save" value="1">

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
					<div>
						<h2 class="h5 mb-1">Grille orbitale complète</h2>
						<p class="text-white-50 mb-0">15 positions à régler, de la plus chaude à la plus froide.</p>
					</div>
					<span class="admin-pill">15 positions</span>
				</div>
			</summary>
			<div class="admin-fold__body">
		<section class="admin-orbit-grid">
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 1</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_1_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_1_field_min" maxlength="5" value="{$planet_1_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_1_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_1_field_max" maxlength="5" value="{$planet_1_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 2</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_2_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_2_field_min" maxlength="5" value="{$planet_2_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_2_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_2_field_max" maxlength="5" value="{$planet_2_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 3</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_3_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_3_field_min" maxlength="5" value="{$planet_3_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_3_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_3_field_max" maxlength="5" value="{$planet_3_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 4</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_4_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_4_field_min" maxlength="5" value="{$planet_4_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_4_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_4_field_max" maxlength="5" value="{$planet_4_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 5</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_5_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_5_field_min" maxlength="5" value="{$planet_5_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_5_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_5_field_max" maxlength="5" value="{$planet_5_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 6</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_6_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_6_field_min" maxlength="5" value="{$planet_6_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_6_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_6_field_max" maxlength="5" value="{$planet_6_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 7</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_7_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_7_field_min" maxlength="5" value="{$planet_7_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_7_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_7_field_max" maxlength="5" value="{$planet_7_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 8</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_8_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_8_field_min" maxlength="5" value="{$planet_8_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_8_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_8_field_max" maxlength="5" value="{$planet_8_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 9</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_9_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_9_field_min" maxlength="5" value="{$planet_9_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_9_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_9_field_max" maxlength="5" value="{$planet_9_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 10</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_10_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_10_field_min" maxlength="5" value="{$planet_10_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_10_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_10_field_max" maxlength="5" value="{$planet_10_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 11</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_11_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_11_field_min" maxlength="5" value="{$planet_11_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_11_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_11_field_max" maxlength="5" value="{$planet_11_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 12</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_12_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_12_field_min" maxlength="5" value="{$planet_12_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_12_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_12_field_max" maxlength="5" value="{$planet_12_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 13</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_13_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_13_field_min" maxlength="5" value="{$planet_13_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_13_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_13_field_max" maxlength="5" value="{$planet_13_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 14</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_14_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_14_field_min" maxlength="5" value="{$planet_14_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_14_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_14_field_max" maxlength="5" value="{$planet_14_field_max}" type="text"></label>
				</div>
			</article>
			<article class="admin-orbit-card">
				<div class="admin-orbit-card__title">Position 15</div>
				<div class="admin-orbit-card__inputs">
					<label class="admin-field-card"><span>Minimum</span><input id="planet_15_field_min" class="form-control bg-dark text-white border-secondary text-center" name="planet_15_field_min" maxlength="5" value="{$planet_15_field_min}" type="text"></label>
					<label class="admin-field-card"><span>Maximum</span><input id="planet_15_field_max" class="form-control bg-dark text-white border-secondary text-center" name="planet_15_field_max" maxlength="5" value="{$planet_15_field_max}" type="text"></label>
				</div>
			</article>
		</section>
			</div>
		</details>

		<section class="admin-form-submitbar">
			<div class="admin-form-submitbar__copy">
				<strong>Enregistrer les bornes orbitales</strong>
				<span>Chaque paire min / max s’applique immédiatement à la génération de planètes selon la position choisie.</span>
			</div>
			<div class="d-flex justify-content-end">
				<button class="btn btn-primary px-4" type="submit">{$LNG.se_save_parameters}</button>
			</div>
		</section>
	</form>

	<form action="?page=planetFields&mode=default" method="post" class="admin-card">
		<div class="card-body d-flex flex-wrap justify-content-between align-items-center gap-3">
			<div>
				<h3 class="h6 mb-1">Restauration rapide</h3>
				<p class="text-white-50 mb-0">Réapplique les valeurs orbitales par défaut prévues par la plateforme.</p>
			</div>
			<button class="btn btn-outline-light" type="submit">Rétablir les valeurs par défaut</button>
		</div>
	</form>
</div>
{/block}
