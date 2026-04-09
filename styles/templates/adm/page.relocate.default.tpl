{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Mobilité</span>
			<h2>Relocalisation</h2>
		</div>
	</section>

	<form class="admin-table-shell admin-stack" action="admin.php?page=relocate&amp;mode=saveSettings" method="post">
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>Prix de relocalisation (matière noire)</span>
				<input id="relocate_price" class="form-control bg-dark text-white border-secondary" name="relocate_price" value="{$relocate_price}" type="text" maxlength="5">
			</label>
			<label class="admin-field-card">
				<span>Délai avant la prochaine relocalisation (heures)</span>
				<input id="relocate_next_time" class="form-control bg-dark text-white border-secondary" name="relocate_next_time" value="{$relocate_next_time}" type="text" maxlength="5">
			</label>
			<label class="admin-field-card">
				<span>Temps de recharge de la porte de saut après relocalisation (heures)</span>
				<input id="relocate_jump_gate_active" class="form-control bg-dark text-white border-secondary" name="relocate_jump_gate_active" value="{$relocate_jump_gate_active}" type="text" maxlength="5">
			</label>
			<label class="admin-field-card">
				<span>Déplacer la flotte directement avec la planète</span>
				<input id="relocate_move_fleet_directly" class="form-check-input mt-2" type="checkbox" {if $relocate_move_fleet_directly}checked="checked"{/if} name="relocate_move_fleet_directly">
			</label>
		</div>

		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.se_save_parameters}</button>
		</div>
	</form>
</div>
{/block}
