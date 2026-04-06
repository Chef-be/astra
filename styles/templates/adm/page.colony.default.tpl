{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Paramètres d’univers</span>
			<h1 class="admin-hero__title">Réglages des colonies</h1>
			<p class="admin-hero__subtitle">Définissez le kit de départ appliqué aux nouvelles colonies, par groupes de ressources, bâtiments, vaisseaux et défenses.</p>
		</div>
	</section>

	<form id="colonySettings" action="admin.php?page=colonySettings&amp;mode=saveSettings" method="post" class="admin-stack">
		{foreach from=$colonySettingGroups item=group}
			<div class="admin-table-shell admin-stack">
				<div>
					<h2 class="h5 mb-1">{$group.title}</h2>
					<p class="text-white-50 mb-0">{$group.description}</p>
				</div>
				<div class="admin-media-grid">
					{foreach from=$group.fields item=field}
						<label class="admin-media-tile">
							<img src="{$field.image}" alt="{$field.label|escape:'html'}">
							<strong>{$field.label}</strong>
							<input id="{$field.name}" class="form-control bg-dark text-white border-secondary text-center" name="{$field.name}" value="{$field.value}" type="text" maxlength="5">
						</label>
					{/foreach}
				</div>
			</div>
		{/foreach}

		<div class="admin-actions">
			<button class="btn btn-primary" value="{$LNG.se_save_parameters}" type="submit">{$LNG.se_save_parameters}</button>
		</div>
	</form>
</div>
{/block}
