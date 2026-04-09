{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Distribution</span>
			<h2>Distribution globale</h2>
		</div>
	</section>

	<form method="post" action="admin.php?page=giveaway&amp;mode=send" class="admin-stack">
		<div class="admin-table-shell admin-stack">
			<div><h2 class="h5 mb-1">{$LNG.ga_definetarget}</h2></div>
			<div class="admin-form-row">
				<label class="admin-field-card"><span>{$LNG.fcm_planet}</span><input class="form-check-input mt-2" type="checkbox" name="planet" value="1" checked></label>
				<label class="admin-field-card"><span>{$LNG.fcm_moon}</span><input class="form-check-input mt-2" type="checkbox" name="moon" value="1"></label>
				<label class="admin-field-card"><span>{$LNG.ga_homecoordinates}</span><input class="form-check-input mt-2" type="checkbox" name="mainplanet" value="1"></label>
				<label class="admin-field-card"><span>{$LNG.ga_no_inactives}</span><input class="form-check-input mt-2" type="checkbox" name="no_inactive" value="1"></label>
			</div>
		</div>

		{foreach from=$giveawayGroups item=group}
			<div class="admin-table-shell admin-stack">
				<div><h2 class="h5 mb-1">{$group.title}</h2></div>
				<div class="admin-media-grid">
					{foreach from=$group.items item=item}
						<label class="admin-media-tile">
							<img src="{$item.image}" alt="{$item.label|escape:'html'}">
							<strong>{$item.label}</strong>
							<span>#{$item.id}</span>
							<input class="form-control bg-dark text-white border-secondary text-center" type="text" name="element_{$item.id}" value="0" pattern="[0-9]*">
						</label>
					{/foreach}
				</div>
			</div>
		{/foreach}

		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.qe_send}</button>
		</div>
	</form>
</div>
{/block}
