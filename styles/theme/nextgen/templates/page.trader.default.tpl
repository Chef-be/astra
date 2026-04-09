{block name="title" prepend}{$LNG.lm_trader}{/block}
{block name="content"}
<style>
	.trader-shell {
		display: grid;
		gap: 0.9rem;
	}

	.trader-card {
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
		overflow: hidden;
	}

	.trader-panel > summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		padding: 0.82rem 0.95rem;
		list-style: none;
		cursor: pointer;
	}

	.trader-panel > summary::-webkit-details-marker {
		display: none;
	}

	.trader-panel__title {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.5rem;
	}

	.trader-panel__title h2 {
		margin: 0;
		font-size: 1.02rem;
		color: #ffd666;
	}

	.trader-panel__meta {
		color: rgba(255, 255, 255, 0.68);
		font-size: 0.78rem;
	}

	.trader-pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.24rem 0.55rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.trader-pill--neutral {
		background: rgba(255, 255, 255, 0.08);
		color: #dce8ff;
	}

	.trader-pill--surplus {
		background: rgba(82, 196, 26, 0.14);
		color: #a8ef84;
	}

	.trader-pill--shortage {
		background: rgba(255, 134, 134, 0.12);
		color: #ffb2b2;
	}

	.trader-panel__body {
		padding: 0.8rem 0.95rem 0.95rem;
	}

	.trader-card--hero {
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 38%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.trader-hero-copy {
		display: grid;
		gap: 0.6rem;
		color: rgba(255, 255, 255, 0.78);
		font-size: 0.9rem;
		line-height: 1.5;
	}

	.trader-overview-grid,
	.trader-grid {
		display: grid;
		gap: 0.8rem;
	}

	.trader-overview-grid {
		grid-template-columns: repeat(3, minmax(0, 1fr));
	}

	.trader-overview-card {
		padding: 0.82rem 0.88rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.trader-overview-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.55rem;
		margin-bottom: 0.55rem;
	}

	.trader-overview-head strong {
		color: #f8fbff;
		font-size: 0.95rem;
	}

	.trader-overview-lines {
		display: grid;
		gap: 0.35rem;
		font-size: 0.82rem;
		color: rgba(255, 255, 255, 0.72);
	}

	.trader-overview-lines span {
		display: flex;
		justify-content: space-between;
		gap: 0.75rem;
	}

	.trader-grid {
		grid-template-columns: repeat(3, minmax(0, 1fr));
	}

	.trader-offer {
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.07);
		overflow: hidden;
	}

	.trader-offer > summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.7rem;
		padding: 0.8rem 0.88rem;
		list-style: none;
		cursor: pointer;
	}

	.trader-offer > summary::-webkit-details-marker {
		display: none;
	}

	.trader-offer-head {
		display: flex;
		align-items: center;
		gap: 0.7rem;
	}

	.trader-offer-head img {
		width: 48px;
		height: 48px;
		object-fit: contain;
	}

	.trader-offer-head strong {
		color: #f8fbff;
		display: block;
	}

	.trader-offer-head span {
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.78rem;
	}

	.trader-offer-body {
		padding: 0.76rem 0.88rem 0.88rem;
	}

	.trader-ratio {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin-bottom: 0.75rem;
	}

	.trader-ratio span {
		padding: 0.28rem 0.5rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.05);
		border: 1px solid rgba(255, 255, 255, 0.08);
		font-size: 0.76rem;
		color: rgba(255, 255, 255, 0.82);
	}

	.trader-offer-note {
		margin-bottom: 0.8rem;
		font-size: 0.8rem;
		color: rgba(255, 255, 255, 0.66);
	}

	.trader-alert {
		color: #ffb3b3;
		font-weight: 700;
	}

	@media (max-width: 991px) {
		.trader-overview-grid,
		.trader-grid {
			grid-template-columns: 1fr;
		}
	}
</style>
<div class="trader-shell">
{if $requiredDarkMatter}
<section class="trader-card">
	<div class="trader-panel__body">
		<div class="trader-alert">{$requiredDarkMatter}</div>
	</div>
</section>
{/if}

<details class="trader-card trader-card--hero trader-panel ng-disclosure ng-disclosure--chevron" open>
	<summary>
		<div class="trader-panel__title">
			<h2>Matière noire - Magasin</h2>
			<span class="trader-pill trader-pill--neutral">{$LNG.tr_call_trader}</span>
		</div>
		<div class="trader-panel__meta">{$LNG.tech.921} requis à chaque transaction</div>
	</summary>
	<div class="trader-panel__body ng-disclosure__body">
		<div class="trader-hero-copy">
			<div>{$tr_cost_dm_trader}</div>
			<div>{$LNG.tr_exchange_quota}: {$charge[901][903]|string_format:"%.2f"}/{$charge[902][903]|string_format:"%.2f"}/{$charge[903][903]|string_format:"%.2f"}</div>
		</div>
	</div>
</details>

<details class="trader-card trader-panel ng-disclosure ng-disclosure--chevron" open>
	<summary>
		<div class="trader-panel__title">
			<h2>Influence du marché</h2>
			<span class="trader-pill trader-pill--neutral">7 derniers jours</span>
		</div>
		<div class="trader-panel__meta">Les activités récentes des joueurs et des bots font varier les cours.</div>
	</summary>
	<div class="trader-panel__body ng-disclosure__body">
		<div class="trader-overview-grid">
			{foreach $marketOverview as $marketResource => $marketItem}
			<div class="trader-overview-card">
				<div class="trader-overview-head">
					<strong>{$marketItem.label}</strong>
					<span class="trader-pill {if $marketItem.state == 'shortage'}trader-pill--shortage{elseif $marketItem.state == 'surplus'}trader-pill--surplus{else}trader-pill--neutral{/if}">{$marketItem.stateLabel}</span>
				</div>
				<div class="trader-overview-lines">
					<span><em>Entrées</em><strong>{$marketItem.incoming}</strong></span>
					<span><em>Sorties</em><strong>{$marketItem.outgoing}</strong></span>
					<span><em>Variation</em><strong>{$marketItem.biasPercent}%</strong></span>
				</div>
			</div>
			{/foreach}
		</div>
	</div>
</details>

<details class="trader-card trader-panel ng-disclosure ng-disclosure--chevron" open>
	<summary>
		<div class="trader-panel__title">
			<h2>Échanges disponibles</h2>
		</div>
		<div class="trader-panel__meta">Choisissez la ressource à vendre au Marchand.</div>
	</summary>
	<div class="trader-panel__body ng-disclosure__body">
		<section class="trader-grid">
			{foreach $charge as $resourceID => $chageData}
			<details class="trader-offer ng-disclosure" open>
				<summary>
					<div class="trader-offer-head">
						<img src="{$dpath}images/{$resource.$resourceID}.gif" alt="{$LNG.tech.$resourceID}">
						<div>
							<strong>{$LNG.tech.$resourceID}</strong>
							<span>Vendre {$LNG.tech.$resourceID|lower}</span>
						</div>
					</div>
					<span class="trader-pill {if $marketOverview[$resourceID].state == 'shortage'}trader-pill--shortage{elseif $marketOverview[$resourceID].state == 'surplus'}trader-pill--surplus{else}trader-pill--neutral{/if}">{$marketOverview[$resourceID].stateLabel}</span>
				</summary>
				<div class="trader-offer-body ng-disclosure__body">
					<div class="trader-ratio">
						{foreach $chageData as $targetResourceID => $ratio}
						<span>{$LNG.tech.$targetResourceID}: {$chargeDisplay[$resourceID][$targetResourceID]}</span>
						{/foreach}
					</div>
					<div class="trader-offer-note">
						Pression actuelle sur {$marketOverview[$resourceID].label|lower}: {$marketOverview[$resourceID].stateLabel|lower}.
					</div>
					{if !$requiredDarkMatter}
					<form action="game.php?page=trader" method="post" class="m-0">
						<input type="hidden" name="mode" value="trade">
						<input type="hidden" name="resource" value="{$resourceID}">
						<button class="btn btn-warning w-100 text-dark fw-semibold" type="submit">Choisir {$LNG.tech.$resourceID|lower}</button>
					</form>
					{else}
					<button class="btn btn-outline-light w-100" type="button" disabled>Indisponible</button>
					{/if}
				</div>
			</details>
			{/foreach}
		</section>
	</div>
</details>
</div>
{/block}
