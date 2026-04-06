{block name="title" prepend}{$LNG.lm_trader}{/block}
{block name="content"}
<style>
	.trader-trade-shell {
		display: grid;
		gap: 0.85rem;
	}

	.trader-trade-card {
		padding: 0.95rem 1rem;
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.trader-trade-list {
		display: grid;
		gap: 0.65rem;
	}

	.trader-trade-row {
		display: grid;
		grid-template-columns: minmax(0, 1.1fr) minmax(120px, 160px) minmax(90px, 120px) 70px;
		gap: 0.7rem;
		align-items: center;
		padding: 0.75rem 0.8rem;
		border-radius: 0.95rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.trader-trade-row--source {
		border-color: rgba(255, 214, 102, 0.18);
		background: rgba(255, 214, 102, 0.06);
	}

	.trader-trade-ress {
		display: flex;
		align-items: center;
		gap: 0.7rem;
	}

	.trader-trade-ress img {
		width: 40px;
		height: 40px;
		object-fit: contain;
	}

	@media (max-width: 991px) {
		.trader-trade-row {
			grid-template-columns: 1fr;
		}
	}
</style>
<form id="trader" action="" method="post">
	<input type="hidden" name="mode" value="send">
	<input type="hidden" name="resource" value="{$tradeResourceID}">
	<div class="trader-trade-shell">
		<section class="trader-trade-card">
			<h2 class="text-yellow fs-4 m-0">{$LNG.tr_sell} {$LNG.tech.$tradeResourceID}</h2>
			<p class="text-white-50 mt-2 mb-0">Indiquez les ressources à recevoir. Le total prélevé sur {$LNG.tech.$tradeResourceID|lower} est recalculé en direct.</p>
		</section>

		<section class="trader-trade-card">
			<div class="trader-trade-list">
				<div class="trader-trade-row trader-trade-row--source">
					<div class="trader-trade-ress">
						<img src="{$dpath}images/{$resource.$tradeResourceID}.gif" alt="{$LNG.tech.$tradeResourceID}">
						<div>
							<div class="text-white fw-semibold">{$LNG.tech.$tradeResourceID}</div>
							<div class="small text-white-50">Ressource vendue</div>
						</div>
					</div>
					<input class="form-control bg-dark text-white border-secondary text-center" readonly id="ress" value="0">
					<div class="small text-white-50 text-center">Total requis</div>
					<div class="text-center text-warning fw-semibold">1</div>
				</div>
				{foreach $tradeResources as $tradeResource}
				<div class="trader-trade-row">
					<label class="trader-trade-ress" for="resource{$tradeResource}">
						<img src="{$dpath}images/{$resource.$tradeResource}.gif" alt="{$LNG.tech.$tradeResource}">
						<div>
							<div class="text-white fw-semibold">{$LNG.tech[$tradeResource]}</div>
							<div class="small text-white-50">Ressource reçue</div>
						</div>
					</label>
					<input name="trade[{$tradeResource}]" id="resource{$tradeResource}" class="form-control bg-dark text-white border-secondary trade_input text-center" type="text" value="0" data-resource="{$tradeResource}">
					<div class="small text-center text-white-50">
						<span id="resource{$tradeResource}Shortly">0</span>
					</div>
					<div class="text-center text-warning fw-semibold">{$charge[$tradeResource]}</div>
				</div>
				{/foreach}
			</div>
		</section>

		<div class="d-flex justify-content-end">
			<input class="btn btn-warning px-4 fw-semibold text-dark" type="submit" value="{$LNG.tr_exchange}">
		</div>
	</div>
</form>

{block name="script" append}
<script type="text/javascript">
var charge = {$charge|json};
</script>
{/block}

{/block}
