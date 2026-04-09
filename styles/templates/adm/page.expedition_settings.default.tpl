{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Console d’expéditions</h2>
					<p class="text-white-50 mb-0">Les événements sont pilotés par familles visuelles: flotte, butin, calcul.</p>
				</div>
				<div class="admin-cluster">
					<span class="admin-pill">{$expeditionEventGroups|@count} blocs</span>
					<span class="admin-pill">Réglage compact</span>
				</div>
			</div>
		</div>
	</section>

	<form class="admin-stack" action="admin.php?page=expedition&amp;mode=send" method="post">
		<input type="hidden" name="opt_save" value="1">

		<section class="admin-table-shell admin-stack">
			<div class="admin-table-toolbar">
				<div>
					<h3 class="h5 mb-1">Activation des événements</h3>
					<p class="text-white-50 mb-0">Chaque carte représente une issue réellement possible en expédition.</p>
				</div>
			</div>

			<div class="admin-stack">
				{foreach from=$expeditionEventGroups item=group}
					<div class="admin-asset-panel">
						<div class="admin-asset-panel__header">
							<h4>{$group.title}</h4>
						</div>
						<div class="admin-asset-board admin-asset-board--toggles">
							{foreach from=$group.entries item=entry}
								{include file='component.asset_toggle.tpl'
									name=$entry.name
									title=$entry.title
									tag=$entry.tag
									tooltip=$entry.tooltip
									image=$entry.image
									checked=$entry.checked
								}
							{/foreach}
						</div>
					</div>
				{/foreach}
			</div>
		</section>

		<section class="admin-table-shell admin-stack">
			<div class="admin-table-toolbar">
				<div>
					<h3 class="h5 mb-1">Multiplicateurs</h3>
					<p class="text-white-50 mb-0">Les gains ressources et vaisseaux restent réglables directement depuis leurs cartes.</p>
				</div>
			</div>
			<div class="admin-asset-board admin-asset-board--metrics">
				{foreach from=$expeditionFactorCards item=card}
					{include file='component.asset_metric.tpl'
						name=$card.name
						title=$card.title
						tag=$card.tag
						tooltip=$card.tooltip
						image=$card.image
						value=$card.value
						min=$card.min
						max=$card.max
						step=$card.step
					}
				{/foreach}
			</div>
		</section>

		<section class="admin-table-shell admin-stack">
			<div class="admin-table-toolbar">
				<div>
					<h3 class="h5 mb-1">Chances d’apparition</h3>
					<p class="text-white-50 mb-0">Répartition directe des issues majeures d’expédition.</p>
				</div>
			</div>
			<div class="admin-asset-board admin-asset-board--metrics admin-asset-board--dense">
				{foreach from=$expeditionChanceCards item=card}
					{include file='component.asset_metric.tpl'
						name=$card.name
						title=$card.title
						tag=$card.tag
						tooltip=$card.tooltip
						image=$card.image
						value=$card.value
						min=$card.min
						max=$card.max
						step=$card.step
					}
				{/foreach}
			</div>
		</section>

		<section class="admin-table-shell admin-stack">
			<div class="admin-table-toolbar">
				<div>
					<h3 class="h5 mb-1">Rendement matière noire</h3>
					<p class="text-white-50 mb-0">Les paliers sont regroupés par tranche de récompense.</p>
				</div>
			</div>
			<div class="admin-asset-board admin-asset-board--ranges">
				{foreach from=$expeditionDarkmatterBands item=band}
					{include file='component.asset_range.tpl'
						title=$band.title
						tooltip=$band.tooltip
						image=$band.image
						min_name=$band.min_name
						min_value=$band.min_value
						max_name=$band.max_name
						max_value=$band.max_value
					}
				{/foreach}
			</div>
		</section>

		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.se_save_parameters}</button>
		</div>
	</form>

	<form class="admin-table-shell admin-stack" action="admin.php?page=expedition&amp;mode=default" method="post">
		<div class="admin-table-toolbar">
			<div>
				<h3 class="h5 mb-1">Réinitialisation</h3>
				<p class="text-white-50 mb-0">Recharge le profil de base des expéditions.</p>
			</div>
			<button class="btn btn-outline-light" type="submit">Rétablir les valeurs par défaut</button>
		</div>
	</form>
</div>
{/block}
