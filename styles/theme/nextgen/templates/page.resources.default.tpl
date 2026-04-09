{block name="title" prepend}{$LNG.lm_resources}{/block}
{block name="content"}
<style>
	.resource-shell {
		display: grid;
		gap: 1rem;
	}

	.resource-hero {
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		gap: 0.85rem;
		padding: 0.95rem 1rem;
		border-radius: 1.25rem;
		border: 1px solid rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.18), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
		box-shadow: 0 1.2rem 2.4rem rgba(0, 0, 0, 0.26);
		align-items: end;
	}

	.resource-hero h1 {
		margin: 0;
		font-size: 1.34rem;
		color: #f8fbff;
		line-height: 1.2;
	}

	.resource-hero-actions {
		display: flex;
		flex-wrap: wrap;
		justify-content: flex-end;
		align-items: center;
		gap: 0.75rem;
	}

	.resource-metrics {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 0.75rem;
	}

	.resource-metric {
		padding: 0.8rem 0.9rem;
		border-radius: 1rem;
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		border: 1px solid rgba(255, 255, 255, 0.07);
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.resource-metric-top {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		margin-bottom: 0.7rem;
	}

	.resource-metric-top img {
		width: 46px;
		height: 46px;
		border-radius: 0.8rem;
		border: 1px solid rgba(255, 214, 102, 0.2);
		background: rgba(255, 255, 255, 0.03);
	}

	.resource-metric-label {
		display: block;
		color: rgba(255, 235, 193, 0.72);
		font-size: 0.72rem;
		letter-spacing: 0.08em;
		text-transform: uppercase;
	}

	.resource-metric-value {
		display: block;
		color: #f8fbff;
		font-size: 1.02rem;
		font-weight: 700;
	}

	.resource-metric-sub {
		display: flex;
		justify-content: space-between;
		gap: 0.8rem;
		font-size: 0.82rem;
		color: rgba(255, 255, 255, 0.7);
	}

	.resource-workspace {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.9rem;
		align-items: start;
	}

	.resource-panel {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 214, 102, 0.14);
		background: linear-gradient(180deg, rgba(10, 18, 34, 0.94), rgba(7, 12, 24, 0.96));
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.24);
		overflow: hidden;
	}

	.resource-disclosure > summary {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		padding: 0.82rem 0.95rem;
		list-style: none;
		cursor: pointer;
	}

	.resource-disclosure > summary::-webkit-details-marker {
		display: none;
	}

	.resource-main-head h2,
	.resource-rail-head h3 {
		margin: 0;
		color: #ffd666;
	}

	.resource-main-head p,
	.resource-rail-head p {
		margin: 0.2rem 0 0;
		color: rgba(255, 255, 255, 0.68);
	}

	.resource-head-badge {
		padding: 0.42rem 0.72rem;
		border-radius: 999px;
		background: rgba(255, 214, 102, 0.12);
		color: #ffe29c;
		font-size: 0.78rem;
		font-weight: 700;
	}

	.resource-list-head {
		display: none;
	}

	.resource-line {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.75rem;
		align-items: center;
		padding: 0.78rem 0.95rem;
	}

	.resource-line {
		border-top: 1px solid rgba(255, 255, 255, 0.05);
	}

	.resource-main-body > .resource-line:first-child {
		border-top: 0;
	}

	.resource-line--summary {
		background: rgba(255, 255, 255, 0.02);
	}

	.resource-line--total {
		background: rgba(255, 214, 102, 0.05);
	}

	.resource-meta {
		display: flex;
		align-items: center;
		gap: 0.85rem;
		min-width: 0;
	}

	.resource-meta img {
		width: 52px;
		height: 52px;
		border-radius: 0.9rem;
		border: 1px solid rgba(255, 214, 102, 0.2);
		background: rgba(255, 255, 255, 0.03);
	}

	.resource-meta-text {
		min-width: 0;
	}

	.resource-meta-text a,
	.resource-meta-text strong {
		display: inline-block;
		color: #f8fbff;
		font-size: 0.98rem;
		font-weight: 700;
		text-decoration: none;
	}

	.resource-meta-text a:hover {
		color: #ffd666;
	}

	.resource-meta-sub {
		display: block;
		margin-top: 0.18rem;
		color: rgba(255, 255, 255, 0.66);
		font-size: 0.82rem;
	}

	.resource-line-top {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
	}

	.resource-yields {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
	}

	.resource-chip {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.32rem 0.55rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
		font-size: 0.78rem;
		color: rgba(255, 255, 255, 0.82);
	}

	.resource-chip strong {
		font-weight: 700;
	}

	.resource-chip.is-pos strong {
		color: #7ff0a6;
	}

	.resource-chip.is-neg strong {
		color: #ff9c9c;
	}

	.resource-chip.is-neutral strong {
		color: #edf2ff;
	}

	.resource-control {
		display: flex;
		justify-content: flex-start;
	}

	.resource-control select {
		min-width: 112px;
		border-radius: 0.85rem;
	}

	.resource-main-body {
		padding-bottom: 0.95rem;
	}

	.resource-footer {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.85rem;
		padding: 0.95rem 0.95rem 0;
		border-top: 1px solid rgba(255, 255, 255, 0.06);
	}

	.resource-footer-note {
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.84rem;
	}

	.resource-rail-grid {
		display: grid;
		gap: 0.85rem;
	}

	.resource-rail-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.6rem;
	}

	.resource-rail-list {
		display: grid;
		gap: 0.55rem;
		padding: 0 0.95rem 0.95rem;
	}

	.resource-rail-line {
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		gap: 0.8rem;
		font-size: 0.88rem;
		color: rgba(255, 255, 255, 0.78);
	}

	.resource-rail-line span {
		color: rgba(255, 255, 255, 0.62);
	}

	.resource-rail-line strong {
		color: #f8fbff;
		text-align: right;
	}

	.resource-rail-line strong.is-pos {
		color: #7ff0a6;
	}

	.resource-rail-line strong.is-neg {
		color: #ff9c9c;
	}

	@media (max-width: 767px) {
		.resource-hero {
			grid-template-columns: 1fr;
		}

		.resource-metrics {
			grid-template-columns: 1fr;
		}

		.resource-hero-actions,
		.resource-control {
			justify-content: start;
		}

		.resource-line {
			gap: 0.7rem;
		}
	}
</style>

<form action="?page=resources" method="post">
<input type="hidden" name="mode" value="send">
<div class="resource-shell">
	<section class="resource-hero">
		<h1>{$header}</h1>
		<div class="resource-hero-actions">
			<button class="btn btn-warning fw-semibold text-dark" type="submit">{$LNG.rs_calculate}</button>
		</div>
	</section>

	<div class="resource-metrics">
		<div class="resource-metric">
			<div class="resource-metric-top">
				<img src="{$dpath}gebaeude/901.gif" alt="{$LNG.tech.901}">
				<div>
					<span class="resource-metric-label">{$LNG.tech.901}</span>
					<span class="resource-metric-value">{if $totalProduction.901 > 0}+{/if}{$totalProduction.901|number}/h</span>
				</div>
			</div>
			<div class="resource-metric-sub">
				<span>Stock actuel</span>
				<strong>{$currentResources.901|number}</strong>
			</div>
		</div>
		<div class="resource-metric">
			<div class="resource-metric-top">
				<img src="{$dpath}gebaeude/902.gif" alt="{$LNG.tech.902}">
				<div>
					<span class="resource-metric-label">{$LNG.tech.902}</span>
					<span class="resource-metric-value">{if $totalProduction.902 > 0}+{/if}{$totalProduction.902|number}/h</span>
				</div>
			</div>
			<div class="resource-metric-sub">
				<span>Stock actuel</span>
				<strong>{$currentResources.902|number}</strong>
			</div>
		</div>
		<div class="resource-metric">
			<div class="resource-metric-top">
				<img src="{$dpath}gebaeude/903.gif" alt="{$LNG.tech.903}">
				<div>
					<span class="resource-metric-label">{$LNG.tech.903}</span>
					<span class="resource-metric-value">{if $totalProduction.903 > 0}+{/if}{$totalProduction.903|number}/h</span>
				</div>
			</div>
			<div class="resource-metric-sub">
				<span>Stock actuel</span>
				<strong>{$currentResources.903|number}</strong>
			</div>
		</div>
		<div class="resource-metric">
			<div class="resource-metric-top">
				<img src="{$dpath}gebaeude/911.gif" alt="{$LNG.tech.911}">
				<div>
					<span class="resource-metric-label">{$LNG.tech.911}</span>
					<span class="resource-metric-value">{if $totalProduction.911 > 0}+{/if}{$totalProduction.911|number}</span>
				</div>
			</div>
			<div class="resource-metric-sub">
				<span>Énergie disponible</span>
				<strong>{$currentResources.911|number}</strong>
			</div>
		</div>
	</div>

	<div class="resource-workspace">
		<details class="resource-panel resource-disclosure ng-disclosure ng-disclosure--chevron" open>
			<summary class="resource-main-head">
				<div>
					<h2>Pilotage des installations</h2>
				</div>
				<span class="resource-head-badge">{$resourceEntryCount|number} installation{if $resourceEntryCount > 1}s{/if}</span>
			</summary>

			<div class="resource-main-body ng-disclosure__body">
			<div class="resource-line resource-line--summary">
				<div class="resource-line-top">
					<div class="resource-meta">
						<div class="resource-meta-text">
							<strong>{$LNG.rs_basic_income}</strong>
							<span class="resource-meta-sub">Base planète</span>
						</div>
					</div>
					<div class="resource-control text-white-50">-</div>
				</div>
				<div class="resource-yields">
					<span class="resource-chip is-pos">{$LNG.tech.901} <strong>{$basicProduction.901|number}</strong></span>
					<span class="resource-chip is-pos">{$LNG.tech.902} <strong>{$basicProduction.902|number}</strong></span>
					<span class="resource-chip is-pos">{$LNG.tech.903} <strong>{$basicProduction.903|number}</strong></span>
					<span class="resource-chip is-pos">{$LNG.tech.911} <strong>{$basicProduction.911|number}</strong></span>
				</div>
			</div>

			{foreach $productionList as $productionID => $productionRow}
			<div class="resource-line">
				<div class="resource-line-top">
					<div class="resource-meta">
						<img src="{$dpath}gebaeude/{$productionID}.{if $productionID >= 600 && $productionID <= 699}jpg{else}gif{/if}" alt="{$LNG.tech.$productionID}">
						<div class="resource-meta-text">
							<a href="#" onclick="return Dialog.info({$productionID});">{$LNG.tech.$productionID}</a>
							<span class="resource-meta-sub">{if $productionID > 200}{$LNG.rs_amount}{else}{$LNG.rs_lvl}{/if} {$productionRow.elementLevel}</span>
						</div>
					</div>
					<div class="resource-control">
						{html_options name="prod[{$productionID}]" options=$prodSelector selected=$productionRow.prodLevel class="form-select form-select-sm"}
					</div>
				</div>
				<div class="resource-yields">
					<span class="resource-chip {if $productionRow.production.901 > 0}is-pos{elseif $productionRow.production.901 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.901} <strong>{$productionRow.production.901|number}</strong></span>
					<span class="resource-chip {if $productionRow.production.902 > 0}is-pos{elseif $productionRow.production.902 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.902} <strong>{$productionRow.production.902|number}</strong></span>
					<span class="resource-chip {if $productionRow.production.903 > 0}is-pos{elseif $productionRow.production.903 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.903} <strong>{$productionRow.production.903|number}</strong></span>
					<span class="resource-chip {if $productionRow.production.911 > 0}is-pos{elseif $productionRow.production.911 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.911} <strong>{$productionRow.production.911|number}</strong></span>
				</div>
			</div>
			{/foreach}

			<div class="resource-line resource-line--summary">
				<div class="resource-line-top">
					<div class="resource-meta">
						<div class="resource-meta-text">
							<strong>{$LNG.rs_ress_bonus}</strong>
							<span class="resource-meta-sub">Bonus cumulés</span>
						</div>
					</div>
					<div class="resource-control text-white-50">-</div>
				</div>
				<div class="resource-yields">
					<span class="resource-chip {if $bonusProduction.901 > 0}is-pos{elseif $bonusProduction.901 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.901} <strong>{$bonusProduction.901|number}</strong></span>
					<span class="resource-chip {if $bonusProduction.902 > 0}is-pos{elseif $bonusProduction.902 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.902} <strong>{$bonusProduction.902|number}</strong></span>
					<span class="resource-chip {if $bonusProduction.903 > 0}is-pos{elseif $bonusProduction.903 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.903} <strong>{$bonusProduction.903|number}</strong></span>
					<span class="resource-chip {if $bonusProduction.911 > 0}is-pos{elseif $bonusProduction.911 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.911} <strong>{$bonusProduction.911|number}</strong></span>
				</div>
			</div>

			<div class="resource-line resource-line--total">
				<div class="resource-line-top">
					<div class="resource-meta">
						<div class="resource-meta-text">
							<strong>{$LNG.rs_sum}</strong>
							<span class="resource-meta-sub">Production nette</span>
						</div>
					</div>
					<div class="resource-control text-white-50">-</div>
				</div>
				<div class="resource-yields">
					<span class="resource-chip {if $totalProduction.901 > 0}is-pos{elseif $totalProduction.901 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.901} <strong>{if $totalProduction.901 > 0}+{/if}{$totalProduction.901|number}/h</strong></span>
					<span class="resource-chip {if $totalProduction.902 > 0}is-pos{elseif $totalProduction.902 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.902} <strong>{if $totalProduction.902 > 0}+{/if}{$totalProduction.902|number}/h</strong></span>
					<span class="resource-chip {if $totalProduction.903 > 0}is-pos{elseif $totalProduction.903 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.903} <strong>{if $totalProduction.903 > 0}+{/if}{$totalProduction.903|number}/h</strong></span>
					<span class="resource-chip {if $totalProduction.911 > 0}is-pos{elseif $totalProduction.911 < 0}is-neg{else}is-neutral{/if}">{$LNG.tech.911} <strong>{if $totalProduction.911 > 0}+{/if}{$totalProduction.911|number}</strong></span>
				</div>
			</div>

			<div class="resource-footer">
				<button class="btn btn-warning fw-semibold text-dark" type="submit">{$LNG.rs_calculate}</button>
			</div>
			</div>
		</details>

		<div class="resource-rail-grid">
			<details class="resource-panel resource-disclosure ng-disclosure ng-disclosure--chevron" open>
				<summary class="resource-rail-head">
					<h3>Capacité de stockage</h3>
					<span class="resource-head-badge">3 ressources</span>
				</summary>
				<div class="resource-rail-list">
					<div class="resource-rail-line"><span>{$LNG.tech.901}</span><strong>{$storage.901}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.902}</span><strong>{$storage.902}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.903}</span><strong>{$storage.903}</strong></div>
				</div>
			</details>

			<details class="resource-panel resource-disclosure ng-disclosure ng-disclosure--chevron" open>
				<summary class="resource-rail-head">
					<h3>Cadence journalière</h3>
					<span class="resource-head-badge">24 h</span>
				</summary>
				<div class="resource-rail-list">
					<div class="resource-rail-line"><span>{$LNG.tech.901}</span><strong class="{if $dailyProduction.901 > 0}is-pos{elseif $dailyProduction.901 < 0}is-neg{/if}">{if $dailyProduction.901 > 0}+{/if}{$dailyProduction.901|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.902}</span><strong class="{if $dailyProduction.902 > 0}is-pos{elseif $dailyProduction.902 < 0}is-neg{/if}">{if $dailyProduction.902 > 0}+{/if}{$dailyProduction.902|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.903}</span><strong class="{if $dailyProduction.903 > 0}is-pos{elseif $dailyProduction.903 < 0}is-neg{/if}">{if $dailyProduction.903 > 0}+{/if}{$dailyProduction.903|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.911}</span><strong class="{if $dailyProduction.911 > 0}is-pos{elseif $dailyProduction.911 < 0}is-neg{/if}">{if $dailyProduction.911 > 0}+{/if}{$dailyProduction.911|number}</strong></div>
				</div>
			</details>

			<details class="resource-panel resource-disclosure ng-disclosure ng-disclosure--chevron" open>
				<summary class="resource-rail-head">
					<h3>Cadence hebdomadaire</h3>
					<span class="resource-head-badge">7 jours</span>
				</summary>
				<div class="resource-rail-list">
					<div class="resource-rail-line"><span>{$LNG.tech.901}</span><strong class="{if $weeklyProduction.901 > 0}is-pos{elseif $weeklyProduction.901 < 0}is-neg{/if}">{if $weeklyProduction.901 > 0}+{/if}{$weeklyProduction.901|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.902}</span><strong class="{if $weeklyProduction.902 > 0}is-pos{elseif $weeklyProduction.902 < 0}is-neg{/if}">{if $weeklyProduction.902 > 0}+{/if}{$weeklyProduction.902|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.903}</span><strong class="{if $weeklyProduction.903 > 0}is-pos{elseif $weeklyProduction.903 < 0}is-neg{/if}">{if $weeklyProduction.903 > 0}+{/if}{$weeklyProduction.903|number}</strong></div>
					<div class="resource-rail-line"><span>{$LNG.tech.911}</span><strong class="{if $weeklyProduction.911 > 0}is-pos{elseif $weeklyProduction.911 < 0}is-neg{/if}">{if $weeklyProduction.911 > 0}+{/if}{$weeklyProduction.911|number}</strong></div>
				</div>
			</details>
		</div>
	</div>
</div>
</form>
{/block}
