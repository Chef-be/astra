{include file="overall_header.tpl"}
<script>
document.addEventListener('DOMContentLoaded', function () {
	var selectAll = document.getElementById('resetSelectAll');
	var clearAll = document.getElementById('resetClearAll');
	var toggles = document.querySelectorAll('.admin-asset-toggle__input');

	if (selectAll) {
		selectAll.addEventListener('click', function () {
			toggles.forEach(function (toggle) {
				toggle.checked = true;
			});
		});
	}

	if (clearAll) {
		clearAll.addEventListener('click', function () {
			toggles.forEach(function (toggle) {
				toggle.checked = false;
			});
		});
	}
});
</script>

<div class="admin-settings-shell admin-stack my-4">
	<section class="admin-headerline">
		<div class="admin-headerline__lead">
			<span class="admin-headerline__eyebrow">Maintenance lourde</span>
			<h1 class="admin-headerline__title">Réinitialisation d’univers</h1>
		</div>
		<div class="admin-actions admin-actions--header">
			<button id="resetSelectAll" type="button" class="btn btn-outline-light">Tout sélectionner</button>
			<button id="resetClearAll" type="button" class="btn btn-outline-light">Tout désélectionner</button>
		</div>
	</section>

	<form action="" method="post" class="admin-stack" onsubmit="return confirm('{$re_reset_universe_confirmation}');">
		{foreach from=$resetGroups item=group}
			<section class="admin-asset-panel">
				<div class="admin-asset-panel__header">
					<h4>{$group.title}</h4>
				</div>
				<div class="admin-asset-board admin-asset-board--dense">
					{foreach from=$group.items item=item}
						{include file='component.asset_toggle.tpl'
							name=$item.name
							title=$item.label
							tag=$item.tag
							image=$item.image
							checked=false
						}
					{/foreach}
				</div>
			</section>
		{/foreach}

		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$button_submit}</button>
		</div>
	</form>
</div>
{include file="overall_footer.tpl"}
