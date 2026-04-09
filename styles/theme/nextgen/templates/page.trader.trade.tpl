{block name="title" prepend}{$LNG.lm_trader}{/block}
{block name="content"}
<style>
	.trader-trade-shell {
		display: grid;
		gap: 0.85rem;
	}

	.trader-trade-card {
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
		overflow: hidden;
	}

	.trader-trade-card > summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		padding: 0.82rem 0.95rem;
		list-style: none;
		cursor: pointer;
	}

	.trader-trade-card > summary::-webkit-details-marker {
		display: none;
	}

	.trader-trade-title {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.55rem;
	}

	.trader-trade-title h2 {
		margin: 0;
		font-size: 1.02rem;
		color: #ffd666;
	}

	.trader-trade-meta {
		color: rgba(255, 255, 255, 0.68);
		font-size: 0.78rem;
	}

	.trader-trade-pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.24rem 0.55rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
		background: rgba(255, 255, 255, 0.08);
		color: #dce8ff;
	}

	.trader-trade-body {
		padding: 0.78rem 0.95rem 0.95rem;
	}

	.trader-trade-overview {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.75rem;
	}

	.trader-trade-overview-card {
		padding: 0.76rem 0.82rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.trader-trade-overview-card strong {
		display: block;
		margin-bottom: 0.45rem;
		color: #f8fbff;
		font-size: 0.92rem;
	}

	.trader-trade-overview-card span {
		display: block;
		font-size: 0.8rem;
		color: rgba(255, 255, 255, 0.7);
	}

	.trader-trade-list {
		display: grid;
		gap: 0.65rem;
	}

	.trader-trade-row {
		display: grid;
		grid-template-columns: minmax(0, 1.1fr) minmax(120px, 160px) minmax(100px, 160px) 78px;
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

	.trader-trade-sub {
		display: block;
		margin-top: 0.14rem;
		font-size: 0.76rem;
		color: rgba(255, 255, 255, 0.62);
	}

	@media (max-width: 991px) {
		.trader-trade-overview,
		.trader-trade-row {
			grid-template-columns: 1fr;
		}
	}
</style>
<form id="trader" action="" method="post">
	<input type="hidden" name="mode" value="send">
	<input type="hidden" name="resource" value="{$tradeResourceID}">
	<div class="trader-trade-shell">
		<details class="trader-trade-card ng-disclosure ng-disclosure--chevron" open>
			<summary>
				<div class="trader-trade-title">
					<h2>{$LNG.tr_sell} {$LNG.tech.$tradeResourceID}</h2>
					<span class="trader-trade-pill">Cours dynamiques</span>
				</div>
				<div class="trader-trade-meta">Les taux sont calculés selon l’activité marchande récente.</div>
			</summary>
			<div class="trader-trade-body ng-disclosure__body">
				<div class="trader-trade-overview">
					{foreach $tradeResources as $tradeResource}
					<div class="trader-trade-overview-card">
						<strong>{$LNG.tech[$tradeResource]}</strong>
						<span>1 unité reçue = {$chargeDisplay[$tradeResource]} {$LNG.tech.$tradeResourceID|lower}</span>
					</div>
					{/foreach}
				</div>
			</div>
		</details>

		<details class="trader-trade-card ng-disclosure ng-disclosure--chevron" open>
			<summary>
				<div class="trader-trade-title">
					<h2>Paramètres d’échange</h2>
				</div>
				<div class="trader-trade-meta">Le total prélevé se met à jour en direct.</div>
			</summary>
			<div class="trader-trade-body ng-disclosure__body">
				<div class="trader-trade-list">
					<div class="trader-trade-row trader-trade-row--source">
						<div class="trader-trade-ress">
							<img src="{$dpath}images/{$resource.$tradeResourceID}.gif" alt="{$LNG.tech.$tradeResourceID}">
							<div>
								<div class="text-white fw-semibold">{$LNG.tech.$tradeResourceID}</div>
								<span class="trader-trade-sub">Ressource vendue</span>
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
								<span class="trader-trade-sub">Ressource reçue</span>
							</div>
						</label>
						<input name="trade[{$tradeResource}]" id="resource{$tradeResource}" class="form-control bg-dark text-white border-secondary trade_input text-center" type="text" value="0" data-resource="{$tradeResource}">
						<div class="small text-center text-white-50">
							<span id="resource{$tradeResource}Shortly">0</span>
						</div>
						<div class="text-center text-warning fw-semibold">{$chargeDisplay[$tradeResource]}</div>
					</div>
					{/foreach}
				</div>
			</div>
		</details>

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
