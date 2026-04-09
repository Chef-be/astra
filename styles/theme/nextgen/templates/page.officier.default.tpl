{block name="title" prepend}{$LNG.lm_officiers}{/block}
{block name="content"}
<style>
	.officer-shell {
		display: grid;
		gap: 0.85rem;
	}

	.officer-hero {
		display: grid;
		grid-template-columns: minmax(180px, 220px) minmax(0, 1fr);
		gap: 0.75rem;
		padding: 0.88rem 1rem;
		border-radius: 1.25rem;
		border: 1px solid rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.18), transparent 38%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
		box-shadow: 0 1.2rem 2.4rem rgba(0, 0, 0, 0.26);
		align-items: end;
	}

	.officer-hero h1 {
		margin: 0;
		font-size: 1.32rem;
		color: #f8fbff;
	}

	.officer-hero p {
		margin: 0;
		max-width: 60ch;
		color: rgba(255, 255, 255, 0.74);
		line-height: 1.45;
		font-size: 0.92rem;
	}

	.officer-hero-metrics {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.6rem;
	}

	.officer-metric {
		padding: 0.58rem 0.68rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.officer-metric-label {
		display: block;
		margin-bottom: 0.12rem;
		color: rgba(255, 255, 255, 0.56);
		font-size: 0.68rem;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	.officer-metric-value {
		display: block;
		color: #f8fbff;
		font-size: 0.96rem;
		font-weight: 700;
	}

	.officer-section {
		display: grid;
		gap: 0.7rem;
	}

	.officer-section-head {
		display: flex;
		flex-wrap: wrap;
		align-items: end;
		justify-content: space-between;
		gap: 0.75rem;
	}

	.officer-section-head h2 {
		margin: 0;
		color: #ffd666;
		font-size: 1.2rem;
	}

	.officer-section-head p {
		margin: 0.15rem 0 0;
		color: rgba(255, 255, 255, 0.68);
		font-size: 0.88rem;
	}

	.officer-section-count {
		padding: 0.4rem 0.7rem;
		border-radius: 999px;
		background: rgba(255, 214, 102, 0.12);
		color: #ffe29c;
		font-size: 0.78rem;
		font-weight: 600;
	}

	.officer-list {
		display: grid;
		gap: 0.55rem;
	}

	.officer-entry {
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		overflow: hidden;
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.officer-entry[open] {
		border-color: rgba(255, 214, 102, 0.2);
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.26);
	}

	.officer-summary {
		display: grid;
		grid-template-columns: 68px minmax(0, 1.35fr) minmax(220px, 0.85fr) auto;
		gap: 0.8rem;
		align-items: center;
		padding: 0.72rem 0.85rem;
		list-style: none;
		cursor: pointer;
	}

	.officer-summary::-webkit-details-marker {
		display: none;
	}

	.officer-thumb {
		width: 68px;
		height: 68px;
		border-radius: 1rem;
		border: 1px solid rgba(255, 214, 102, 0.2);
		object-fit: cover;
		background: rgba(255, 255, 255, 0.03);
	}

	.officer-name-line {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.45rem;
		margin-bottom: 0.18rem;
	}

	.officer-name-line a {
		color: #f8fbff;
		font-size: 0.95rem;
		font-weight: 700;
		text-decoration: none;
	}

	.officer-name-line a:hover {
		color: #ffd666;
	}

	.officer-status,
	.officer-level,
	.officer-badge {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.22rem 0.55rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.officer-status {
		background: rgba(82, 196, 26, 0.14);
		color: #a8ef84;
	}

	.officer-level {
		background: rgba(255, 214, 102, 0.12);
		color: #ffd666;
	}

	.officer-badge {
		background: rgba(77, 208, 225, 0.12);
		color: #b8f5ff;
	}

	.officer-summary-text p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.35;
		font-size: 0.83rem;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}

	.officer-summary-meta {
		display: grid;
		gap: 0.35rem;
	}

	.officer-inline-list,
	.officer-cost-preview {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.officer-inline-item,
	.officer-cost-chip {
		display: inline-flex;
		align-items: center;
		padding: 0.24rem 0.48rem;
		border-radius: 999px;
		font-size: 0.7rem;
	}

	.officer-inline-item {
		background: rgba(77, 208, 225, 0.1);
		border: 1px solid rgba(77, 208, 225, 0.18);
		color: #d0fbff;
	}

	.officer-cost-chip {
		background: rgba(255, 255, 255, 0.05);
		border: 1px solid rgba(255, 255, 255, 0.08);
		color: rgba(255, 255, 255, 0.82);
	}

	.officer-cost-chip.is-missing {
		color: #ffacac;
		border-color: rgba(255, 134, 134, 0.18);
	}

	.officer-toggle {
		display: inline-flex;
		align-items: center;
		gap: 0.55rem;
		padding: 0.45rem 0.72rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.04);
		color: #d8e6ff;
		font-size: 0.76rem;
		font-weight: 600;
	}

	.officer-toggle::after {
		content: "▾";
		font-size: 0.95rem;
		transition: transform 0.2s ease;
	}

	.officer-entry[open] .officer-toggle::after {
		transform: rotate(180deg);
	}

	.officer-body {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.75rem;
		padding: 0 0.85rem 0.85rem;
	}

	.officer-panel {
		padding: 0.8rem 0.9rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.officer-panel h3 {
		margin: 0 0 0.55rem;
		font-size: 0.9rem;
		color: #f8fbff;
	}

	.officer-bonus-list,
	.officer-cost-list {
		display: grid;
		gap: 0.4rem;
	}

	.officer-bonus-line,
	.officer-cost-line {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 0.8rem;
		padding-bottom: 0.38rem;
		border-bottom: 1px solid rgba(255, 255, 255, 0.06);
		color: rgba(255, 255, 255, 0.82);
		font-size: 0.85rem;
	}

	.officer-bonus-line:last-child,
	.officer-cost-line:last-child {
		padding-bottom: 0;
		border-bottom: 0;
	}

	.officer-bonus-value {
		color: #b8f5ff;
		font-weight: 700;
	}

	.officer-cost-line.is-missing strong {
		color: #ff9e9e;
	}

	.officer-actions {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.65rem;
		margin-top: 0.7rem;
	}

	.officer-state {
		color: rgba(255, 255, 255, 0.72);
		font-size: 0.84rem;
	}

	.officer-state strong {
		color: #ffd666;
	}

	@media (max-width: 1199px) {
		.officer-hero,
		.officer-body {
			grid-template-columns: 1fr;
		}

		.officer-hero-metrics {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}

		.officer-summary {
			grid-template-columns: 84px minmax(0, 1fr);
		}

		.officer-summary-meta,
		.officer-toggle {
			grid-column: 2;
		}

		.officer-toggle {
			justify-self: start;
		}
	}

	@media (max-width: 767px) {
		.officer-hero {
			padding: 1rem;
		}

		.officer-hero h1 {
			font-size: 1.55rem;
		}

		.officer-hero-metrics {
			grid-template-columns: 1fr;
		}

		.officer-summary {
			grid-template-columns: 1fr;
			padding: 0.9rem;
		}

		.officer-thumb {
			width: 72px;
			height: 72px;
		}

		.officer-summary-meta,
		.officer-toggle {
			grid-column: auto;
		}

		.officer-toggle {
			width: 100%;
			justify-content: center;
		}
	}
</style>

<div class="officer-shell">
	<section class="officer-hero">
		<div>
			<h1>{$LNG.lm_officiers}</h1>
		</div>
		<div class="officer-hero-metrics">
			<div class="officer-metric">
				<span class="officer-metric-label">Bonus temporaires</span>
				<span class="officer-metric-value">{$dmCount|number}</span>
			</div>
			<div class="officer-metric">
				<span class="officer-metric-label">Activés</span>
				<span class="officer-metric-value">{$activeDmCount|number}</span>
			</div>
			<div class="officer-metric">
				<span class="officer-metric-label">Officiers disponibles</span>
				<span class="officer-metric-value">{$officerCount|number}</span>
			</div>
			<div class="officer-metric">
				<span class="officer-metric-label">Au niveau maximal</span>
				<span class="officer-metric-value">{$maxedOfficerCount|number}</span>
			</div>
		</div>
	</section>

	{if !empty($darkmatterList)}
	<section class="officer-section">
		<div class="officer-section-head">
			<div>
				<h2>{$of_dm_trade}</h2>
			</div>
			<span class="officer-section-count">{$dmCount|number} élément{if $dmCount > 1}s{/if}</span>
		</div>
		<div class="officer-list">
			{foreach $darkmatterList as $ID => $Element}
			<details class="officer-entry ng-disclosure">
				<summary class="officer-summary">
					<img class="officer-thumb" src="{$dpath}gebaeude/{$ID}.gif" alt="{$LNG.tech.{$ID}}">
					<div class="officer-summary-text">
						<div class="officer-name-line">
							<a href="#" onclick="return Dialog.info({$ID});">{$LNG.tech.{$ID}}</a>
							{if $Element.timeLeft > 0}
							<span class="officer-status">Actif</span>
							{else}
							<span class="officer-badge">Disponible</span>
							{/if}
						</div>
						<p>{$Element.description|default:$LNG.shortDescription.{$ID}}</p>
					</div>
					<div class="officer-summary-meta">
						<div class="officer-inline-list">
							{foreach $Element.elementBonus as $BonusName => $Bonus}
							<span class="officer-inline-item">{if $Bonus[0] < 0}-{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{$Bonus[0]}{/if} {$LNG.bonus.$BonusName}</span>
							{/foreach}
						</div>
						<div class="officer-cost-preview">
							{foreach $Element.costResources as $RessID => $RessAmount}
							<span class="officer-cost-chip{if $Element.costOverflow[$RessID] != 0} is-missing{/if}">{$LNG.tech.{$RessID}} {$RessAmount|number}</span>
							{/foreach}
							<span class="officer-cost-chip">{$LNG.in_dest_durati} {$Element.time|time}</span>
						</div>
					</div>
					<span class="officer-toggle">Détails</span>
				</summary>
				<div class="officer-body ng-disclosure__body">
					<div class="officer-panel">
						<h3>Bonus et effets</h3>
						<div class="officer-bonus-list">
							{foreach $Element.elementBonus as $BonusName => $Bonus}
							<div class="officer-bonus-line">
								<span>{$LNG.bonus.$BonusName}</span>
								<span class="officer-bonus-value">{if $Bonus[0] < 0}-{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{$Bonus[0]}{/if}</span>
							</div>
							{/foreach}
						</div>
						<div class="officer-actions">
							<div class="officer-state">
								{if $Element.timeLeft > 0}
									{$LNG.of_still} <strong id="time_{$ID}">-</strong> {$LNG.of_active}
								{else}
									Prêt à être activé
								{/if}
							</div>
							<div>
								{if $Element.buyable}
									<form action="game.php?page=officier" method="post" class="build_form m-0">
										<input type="hidden" name="id" value="{$ID}">
										<button type="submit" class="btn btn-warning btn-sm fw-semibold text-dark">{$LNG.of_recruit}</button>
									</form>
								{else}
									<span class="text-danger fw-semibold">{$LNG.of_recruit}</span>
								{/if}
							</div>
						</div>
					</div>
					<div class="officer-panel">
						<h3>Coût d’activation</h3>
						<div class="officer-cost-list">
							{foreach $Element.costResources as $RessID => $RessAmount}
							<div class="officer-cost-line{if $Element.costOverflow[$RessID] != 0} is-missing{/if}">
								<span>{$LNG.tech.{$RessID}}</span>
								<strong>{$RessAmount|number}</strong>
							</div>
							{/foreach}
							<div class="officer-cost-line">
								<span>{$LNG.in_dest_durati}</span>
								<strong>{$Element.time|time}</strong>
							</div>
						</div>
					</div>
				</div>
			</details>
			{/foreach}
		</div>
	</section>
	{/if}

	{if !empty($officierList)}
	<section class="officer-section">
		<div class="officer-section-head">
			<div>
				<h2>{$LNG.of_offi}</h2>
			</div>
			<span class="officer-section-count">{$officerCount|number} officier{if $officerCount > 1}s{/if}</span>
		</div>
		<div class="officer-list">
			{foreach $officierList as $ID => $Element}
			<details class="officer-entry ng-disclosure">
				<summary class="officer-summary">
					<img class="officer-thumb" src="{$dpath}gebaeude/{$ID}.jpg" alt="{$LNG.tech.{$ID}}">
					<div class="officer-summary-text">
						<div class="officer-name-line">
							<a href="#" onclick="return Dialog.info({$ID});">{$LNG.tech.{$ID}}</a>
							<span class="officer-level">{$LNG.of_lvl} {$Element.level}/{$Element.maxLevel}</span>
							{if $Element.maxLevel <= $Element.level}
							<span class="officer-status">Maximum</span>
							{/if}
						</div>
						<p>{$Element.description|default:$LNG.shortDescription.{$ID}}</p>
					</div>
					<div class="officer-summary-meta">
						<div class="officer-inline-list">
							{foreach $Element.elementBonus as $BonusName => $Bonus}
							<span class="officer-inline-item">{if $Bonus[0] < 0}-{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{floatval($Bonus[0])}{/if} {$LNG.bonus.$BonusName}</span>
							{/foreach}
						</div>
						<div class="officer-cost-preview">
							{foreach $Element.costResources as $RessID => $RessAmount}
							<span class="officer-cost-chip{if $Element.costOverflow[$RessID] != 0} is-missing{/if}">{$LNG.tech.{$RessID}} {$RessAmount|number}</span>
							{/foreach}
						</div>
					</div>
					<span class="officer-toggle">Détails</span>
				</summary>
				<div class="officer-body ng-disclosure__body">
					<div class="officer-panel">
						<h3>Bonus et progression</h3>
						<div class="officer-bonus-list">
							{foreach $Element.elementBonus as $BonusName => $Bonus}
							<div class="officer-bonus-line">
								<span>{$LNG.bonus.$BonusName}</span>
								<span class="officer-bonus-value">{if $Bonus[0] < 0}-{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{floatval($Bonus[0])}{/if}</span>
							</div>
							{/foreach}
						</div>
						<div class="officer-actions">
							<div class="officer-state">
								{if $Element.maxLevel <= $Element.level}
									<span class="text-danger fw-semibold">{$LNG.bd_maxlevel}</span>
								{else}
									Amélioration permanente prête
								{/if}
							</div>
							<div>
								{if $Element.maxLevel <= $Element.level}
									<span class="text-danger fw-semibold">{$LNG.bd_maxlevel}</span>
								{elseif $Element.buyable}
									<form action="game.php?page=officier" method="post" class="build_form m-0">
										<input type="hidden" name="id" value="{$ID}">
										<button type="submit" class="btn btn-warning btn-sm fw-semibold text-dark">{$LNG.of_recruit}</button>
									</form>
								{else}
									<span class="text-danger fw-semibold">{$LNG.of_recruit}</span>
								{/if}
							</div>
						</div>
					</div>
					<div class="officer-panel">
						<h3>Coût du niveau suivant</h3>
						<div class="officer-cost-list">
							{foreach $Element.costResources as $RessID => $RessAmount}
							<div class="officer-cost-line{if $Element.costOverflow[$RessID] != 0} is-missing{/if}">
								<span>{$LNG.tech.{$RessID}}</span>
								<strong>{$RessAmount|number}</strong>
							</div>
							{/foreach}
						</div>
					</div>
				</div>
			</details>
			{/foreach}
		</div>
	</section>
	{/if}
</div>
{/block}
{block name="script"}
<script src="scripts/game/officier.js"></script>
{/block}
