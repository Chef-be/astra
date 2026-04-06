{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Classements</span>
			<h1 class="admin-hero__title">Réglages des statistiques</h1>
			<p class="admin-hero__subtitle">Ajustez la pondération des points, la visibilité du classement et le niveau de droit requis pour accéder aux statistiques.</p>
		</div>
	</section>

	<form class="admin-table-shell admin-stack" method="post" action="admin.php?page=stats&mode=saveSettings">
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$cs_point_per_resources_used} ({$cs_resources})</span>
				<input id="stat_settings" class="form-control bg-dark text-white border-secondary" type="text" name="stat_settings" value="{$stat_settings}">
			</label>
			<label class="admin-field-card">
				<span>{$cs_points_to_zero}</span>
				<select id="stat" class="form-select bg-dark text-white border-secondary" name="stat">
					{foreach $Selector as $key => $optionText}
						<option value="{$key}" {if $key == $stat}selected{/if}>{$optionText}</option>
					{/foreach}
				</select>
			</label>
			<label class="admin-field-card">
				<span>{$cs_access_lvl}</span>
				<input id="stat_level" class="form-control bg-dark text-white border-secondary" type="text" name="stat_level" value="{$stat_level}">
			</label>
		</div>
		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$cs_save_changes}</button>
		</div>
	</form>
</div>
{/block}
