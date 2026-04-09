{block name="title" prepend}{$LNG.lm_empire}{/block}
{block name="content"}
<style>
	.imperium-shell {
		display: grid;
		gap: 0.9rem;
		padding: 1rem 0;
	}

	.imperium-card {
		padding: 0.95rem 1rem;
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.imperium-card--hero {
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 38%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.imperium-hero-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.9rem;
		align-items: start;
	}

	.imperium-hero-head {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.85rem;
		margin-bottom: 0.85rem;
	}

	.imperium-hero-title {
		display: grid;
		gap: 0.3rem;
	}

	.imperium-hero-title h1 {
		margin: 0;
		color: #ffd666;
		font-size: 1.35rem;
	}

	.imperium-hero-badge {
		display: inline-flex;
		align-items: center;
		padding: 0.3rem 0.6rem;
		border-radius: 999px;
		background: rgba(255, 214, 102, 0.08);
		border: 1px solid rgba(255, 214, 102, 0.16);
		color: rgba(255, 240, 214, 0.88);
		font-size: 0.76rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
	}

	.imperium-hero-metrics {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.6rem;
	}

	.imperium-metric {
		padding: 0.7rem 0.8rem;
		border-radius: 0.95rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.imperium-metric span {
		display: block;
		font-size: 0.72rem;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		color: rgba(255, 255, 255, 0.56);
	}

	.imperium-metric strong {
		display: block;
		margin-top: 0.16rem;
		font-size: 1.08rem;
		color: #f8fbff;
	}

	.imperium-planets {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
		gap: 0.75rem;
	}

	.imperium-planet {
		padding: 0.75rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.imperium-planet-head {
		display: grid;
		grid-template-columns: 64px minmax(0, 1fr);
		gap: 0.7rem;
		align-items: center;
	}

	.imperium-planet-head img {
		width: 64px;
		height: 64px;
		object-fit: cover;
		border-radius: 0.9rem;
		border: 1px solid rgba(255, 214, 102, 0.14);
	}

	.imperium-planet-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		margin-top: 0.55rem;
	}

	.imperium-pill {
		display: inline-flex;
		align-items: center;
		padding: 0.24rem 0.48rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.05);
		border: 1px solid rgba(255, 255, 255, 0.08);
		font-size: 0.72rem;
		color: rgba(255, 255, 255, 0.82);
	}

	.imperium-sections {
		display: grid;
		gap: 0.75rem;
	}

	.imperium-section {
		border-radius: 1.05rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		overflow: hidden;
	}

	.imperium-section[open] {
		border-color: rgba(255, 214, 102, 0.18);
	}

	.imperium-section-summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		padding: 0.85rem 1rem;
		cursor: pointer;
		list-style: none;
	}

	.imperium-section-summary::-webkit-details-marker {
		display: none;
	}

	.imperium-section-summary strong {
		color: #ffd666;
	}

	.imperium-section-summary span {
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.8rem;
	}

	.imperium-section-body {
		padding: 0 1rem 1rem;
		display: grid;
		gap: 0.6rem;
	}

	.imperium-row {
		display: grid;
		grid-template-columns: minmax(0, 220px) 110px minmax(0, 1fr);
		gap: 0.8rem;
		align-items: center;
		padding: 0.7rem 0.8rem;
		border-radius: 0.95rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.imperium-row-title {
		display: flex;
		align-items: center;
		gap: 0.65rem;
		min-width: 0;
	}

	.imperium-row-title img {
		width: 38px;
		height: 38px;
		object-fit: contain;
		border-radius: 0.65rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 214, 102, 0.1);
	}

	.imperium-row-title a {
		color: #f8fbff;
		text-decoration: none;
		font-weight: 700;
	}

	.imperium-row-title a:hover {
		color: #ffd666;
	}

	.imperium-row-total {
		font-weight: 700;
		color: #b8f5ff;
	}

	.imperium-row-planets {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
	}

	.imperium-row-planets .imperium-pill {
		font-size: 0.7rem;
	}

	@media (max-width: 1199px) {
		.imperium-hero-metrics {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
	}

	@media (max-width: 991px) {
		.imperium-hero-grid,
		.imperium-row {
			grid-template-columns: 1fr;
		}
	}

	@media (max-width: 575px) {
		.imperium-hero-metrics {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="imperium-shell">
	<section class="imperium-card imperium-card--hero">
		<div class="imperium-hero-grid">
			<div>
				<div class="imperium-hero-head">
					<div class="imperium-hero-title">
						<h1>{$LNG.lv_imperium_title}</h1>
					</div>
					<div class="imperium-hero-badge">{count($planetList.name)} positions suivies</div>
				</div>

				<div class="imperium-hero-metrics">
					<div class="imperium-metric"><span>Planètes</span><strong>{count($planetList.name)}</strong></div>
					<div class="imperium-metric"><span>Ressources</span><strong>{count($planetList.resource)}</strong></div>
					<div class="imperium-metric"><span>Bâtiments</span><strong>{count($planetList.build)}</strong></div>
					<div class="imperium-metric"><span>Flottes et défenses</span><strong>{count($planetList.fleet) + count($planetList.defense) + count($planetList.missiles)}</strong></div>
				</div>
			</div>
		</div>
	</section>

	<section class="imperium-planets">
		{foreach $planetList.name as $planetID => $name}
		<article class="imperium-planet">
			<div class="imperium-planet-head">
				<a href="game.php?page=overview&amp;cp={$planetID}">
					<img src="{$dpath}planeten/{$planetList.image[$planetID]}.jpg" alt="{$name}">
				</a>
				<div>
					<div class="text-white fw-semibold">{$name}</div>
					<div class="small text-white-50">
						<a class="text-decoration-none text-info" href="game.php?page=galaxy&amp;galaxy={$planetList.coords[$planetID].galaxy}&amp;system={$planetList.coords[$planetID].system}">
							[{$planetList.coords[$planetID].galaxy}:{$planetList.coords[$planetID].system}:{$planetList.coords[$planetID].planet}]
						</a>
					</div>
				</div>
			</div>
			<div class="imperium-planet-meta">
				<span class="imperium-pill">Champs {$planetList.field[$planetID].current}/{$planetList.field[$planetID].max}</span>
				<span class="imperium-pill">Métal {$planetList.resource[901][$planetID]|number}</span>
				<span class="imperium-pill">Cristal {$planetList.resource[902][$planetID]|number}</span>
				<span class="imperium-pill">Deutérium {$planetList.resource[903][$planetID]|number}</span>
			</div>
		</article>
		{/foreach}
	</section>

	<div class="imperium-sections">
		<details class="imperium-section ng-disclosure ng-disclosure--chevron" id="imperium-section-resources" open>
			<summary class="imperium-section-summary">
				<div><strong>{$LNG.lv_resources}</strong></div>
				<span>{count($planetList.resource)} lignes</span>
			</summary>
			<div class="imperium-section-body ng-disclosure__body">
				{foreach $planetList.resource as $elementID => $resourceArray}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div>
							<a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a>
						</div>
					</div>
					<div class="imperium-row-total">
						{array_sum($resourceArray)|number}
						{if in_array($elementID, [901, 902, 903])}
						<div class="small text-success">{array_sum($planetList.resourcePerHour[$elementID])|number}/h</div>
						{/if}
					</div>
					<div class="imperium-row-planets">
						{foreach $resourceArray as $planetID => $resource}
						<span class="imperium-pill">
							{$planetList.name[$planetID]}: {$resource|number}
							{if in_array($elementID, [901, 902, 903]) && $planetList.planet_type[$planetID] == 1}
								• {$planetList.resourcePerHour[$elementID][$planetID]|number}/h
							{/if}
						</span>
						{/foreach}
					</div>
				</div>
				{/foreach}
			</div>
		</details>

		<details class="imperium-section ng-disclosure ng-disclosure--chevron" id="imperium-section-buildings">
			<summary class="imperium-section-summary">
				<div><strong>{$LNG.lv_buildings}</strong></div>
				<span>{count($planetList.build)} lignes</span>
			</summary>
			<div class="imperium-section-body ng-disclosure__body">
				{foreach $planetList.build as $elementID => $buildArray}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div><a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a></div>
					</div>
					<div class="imperium-row-total">{array_sum($buildArray)|number}</div>
					<div class="imperium-row-planets">
						{foreach $buildArray as $planetID => $build}
						<span class="imperium-pill">{$planetList.name[$planetID]}: {$build|number}</span>
						{/foreach}
					</div>
				</div>
				{/foreach}
			</div>
		</details>

		<details class="imperium-section ng-disclosure ng-disclosure--chevron" id="imperium-section-technology">
			<summary class="imperium-section-summary">
				<div><strong>{$LNG.lv_technology}</strong></div>
				<span>{count($planetList.tech)} lignes</span>
			</summary>
			<div class="imperium-section-body ng-disclosure__body">
				{foreach $planetList.tech as $elementID => $tech}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div><a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a></div>
					</div>
					<div class="imperium-row-total">Niveau {$tech|number}</div>
					<div class="imperium-row-planets">
						<span class="imperium-pill">Recherche de compte</span>
					</div>
				</div>
				{/foreach}
			</div>
		</details>

		<details class="imperium-section ng-disclosure ng-disclosure--chevron" id="imperium-section-ships">
			<summary class="imperium-section-summary">
				<div><strong>{$LNG.lv_ships}</strong></div>
				<span>{count($planetList.fleet)} lignes</span>
			</summary>
			<div class="imperium-section-body ng-disclosure__body">
				{foreach $planetList.fleet as $elementID => $fleetArray}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div><a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a></div>
					</div>
					<div class="imperium-row-total">{array_sum($fleetArray)|number}</div>
					<div class="imperium-row-planets">
						{foreach $fleetArray as $planetID => $fleet}
						<span class="imperium-pill">{$planetList.name[$planetID]}: {$fleet|number}</span>
						{/foreach}
					</div>
				</div>
				{/foreach}
			</div>
		</details>

		<details class="imperium-section ng-disclosure ng-disclosure--chevron" id="imperium-section-defenses">
			<summary class="imperium-section-summary">
				<div><strong>{$LNG.lv_defenses}</strong></div>
				<span>{count($planetList.defense) + count($planetList.missiles)} lignes</span>
			</summary>
			<div class="imperium-section-body ng-disclosure__body">
				{foreach $planetList.defense as $elementID => $fleetArray}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div><a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a></div>
					</div>
					<div class="imperium-row-total">{array_sum($fleetArray)|number}</div>
					<div class="imperium-row-planets">
						{foreach $fleetArray as $planetID => $fleet}
						<span class="imperium-pill">{$planetList.name[$planetID]}: {$fleet|number}</span>
						{/foreach}
					</div>
				</div>
				{/foreach}
				{foreach $planetList.missiles as $elementID => $fleetArray}
				<div class="imperium-row">
					<div class="imperium-row-title">
						<img src="{$dpath}gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}">
						<div><a href="#" onclick="return Dialog.info({$elementID});">{$LNG.tech.$elementID}</a></div>
					</div>
					<div class="imperium-row-total">{array_sum($fleetArray)|number}</div>
					<div class="imperium-row-planets">
						{foreach $fleetArray as $planetID => $fleet}
						<span class="imperium-pill">{$planetList.name[$planetID]}: {$fleet|number}</span>
						{/foreach}
					</div>
				</div>
				{/foreach}
			</div>
		</details>
	</div>
</div>
{/block}
