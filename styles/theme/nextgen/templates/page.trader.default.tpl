{block name="title" prepend}{$LNG.lm_trader}{/block}
{block name="content"}
<style>
	.trader-shell {
		display: grid;
		gap: 0.9rem;
	}

	.trader-card {
		padding: 0.95rem 1rem;
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.trader-card--hero {
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 38%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.trader-grid {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.8rem;
	}

	.trader-offer {
		display: grid;
		gap: 0.7rem;
		padding: 0.95rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.trader-offer-head {
		display: flex;
		align-items: center;
		gap: 0.7rem;
	}

	.trader-offer-head img {
		width: 52px;
		height: 52px;
		object-fit: contain;
	}

	.trader-ratio {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.trader-ratio span {
		padding: 0.28rem 0.5rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.05);
		border: 1px solid rgba(255, 255, 255, 0.08);
		font-size: 0.76rem;
		color: rgba(255, 255, 255, 0.82);
	}

	.trader-alert {
		color: #ffb3b3;
		font-weight: 700;
	}

	@media (max-width: 991px) {
		.trader-grid {
			grid-template-columns: 1fr;
		}
	}
</style>
<div class="trader-shell">
{if $requiredDarkMatter}
<section class="trader-card">
	<div class="trader-alert">{$requiredDarkMatter}</div>
</section>
{/if}
<section class="trader-card trader-card--hero">
	<h2 class="text-yellow fs-4 m-0">{$LNG.tr_call_trader}</h2>
	<p class="text-white-50 mb-0 mt-2">Choisissez la ressource que vous souhaitez céder. Le marchand convertit ensuite vos stocks selon le taux indiqué et applique le coût en matière noire.</p>
</section>

<section class="trader-grid">
	{foreach $charge as $resourceID => $chageData}
	<div class="trader-offer">
		<div class="trader-offer-head">
			<img src="{$dpath}images/{$resource.$resourceID}.gif" alt="{$LNG.tech.$resourceID}">
			<div>
				<div class="text-white fw-semibold">{$LNG.tech.$resourceID}</div>
				<div class="small text-white-50">{$LNG.tr_call_trader_who_buys}{$LNG.tech.$resourceID|lower}</div>
			</div>
		</div>
		<div class="trader-ratio">
			{foreach $chageData as $targetResourceID => $ratio}
			<span>{$LNG.tech.$targetResourceID}: {$ratio}</span>
			{/foreach}
		</div>
		<div class="small text-white-50">{$tr_cost_dm_trader}</div>
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
	{/foreach}
</section>

<section class="trader-card">
	<div class="small text-white-50">{$LNG.tr_exchange_quota}: {$charge.901.903}/{$charge.902.903}/{$charge.903.903}</div>
</section>
</div>
{/block}
