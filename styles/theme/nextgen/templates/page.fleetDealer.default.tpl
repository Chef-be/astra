{block name="title" prepend}{$LNG.lm_fleettrader}{/block}
{block name="content"}
<style>
	.fleet-dealer-layout {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.85rem;
	}

	.fleet-dealer-card {
		padding: 0.9rem 1rem;
		border: 1px solid rgba(255, 214, 102, 0.18);
		border-radius: 1rem;
		background: linear-gradient(180deg, rgba(10, 18, 34, 0.94), rgba(7, 12, 24, 0.96));
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.25);
	}

	.fleet-dealer-preview {
		display: grid;
		grid-template-columns: 92px minmax(0, 1fr);
		gap: 0.85rem;
		align-items: center;
	}

	.fleet-dealer-preview img {
		width: 92px;
		height: 92px;
		border-radius: 1rem;
		border: 1px solid rgba(255, 214, 102, 0.22);
		background: rgba(255, 255, 255, 0.03);
	}

	.fleet-dealer-meta {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.55rem;
		margin-top: 0.85rem;
	}

	.fleet-dealer-stat {
		padding: 0.7rem 0.75rem;
		border-radius: 0.85rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.fleet-dealer-stat-label {
		font-size: 0.74rem;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: rgba(255, 235, 193, 0.68);
	}

	.fleet-dealer-stat-value {
		margin-top: 0.25rem;
		font-size: 0.95rem;
		font-weight: 700;
		color: #f7fbff;
	}

	.fleet-dealer-form-grid {
		display: grid;
		gap: 0.8rem;
	}

	.fleet-dealer-totals {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.55rem;
	}

	.fleet-dealer-total {
		padding: 0.7rem 0.75rem;
		border-radius: 0.85rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.fleet-dealer-headline {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.65rem;
	}

	.fleet-dealer-compact-note {
		font-size: 0.85rem;
		color: rgba(255, 255, 255, 0.68);
	}

	@media (max-width: 991px) {
		.fleet-dealer-preview,
		.fleet-dealer-meta,
		.fleet-dealer-totals {
			grid-template-columns: 1fr;
		}
	}
</style>
<form action="game.php?page=fleetDealer" method="post">
	<input type="hidden" name="mode" value="send">
	<div class="fleet-dealer-card mb-3">
		<div class="fleet-dealer-headline">
			<div>
				<h2 class="fs-4 m-0 text-yellow">{$LNG.ft_head}</h2>
			</div>
			<div class="text-white-50">{$LNG.ft_charge}: <strong class="text-warning">{$Charge}%</strong></div>
		</div>
	</div>

	<div class="fleet-dealer-layout">
		<section class="fleet-dealer-card">
			<div class="fleet-dealer-preview">
				<div>
					<img id="img" alt="" data-src="{$dpath}gebaeude/">
				</div>
				<div>
					<label class="form-label text-white-50" for="shipID">Élément à revendre</label>
					<select class="form-select bg-dark text-white border-warning-subtle" name="shipID" id="shipID" onchange="updateVars()">
						{foreach $shipIDs as $shipID}
						<option value="{$shipID}">{$LNG.tech.$shipID}</option>
						{/foreach}
					</select>
					<h3 id="traderHead" class="text-yellow mt-3 mb-2"></h3>
					<p id="traderDescription" class="text-white-50 mb-0"></p>
				</div>
			</div>
			<div class="fleet-dealer-meta">
				<div class="fleet-dealer-stat">
					<div class="fleet-dealer-stat-label">Disponibles</div>
					<div class="fleet-dealer-stat-value" id="availableCount">0</div>
				</div>
				<div class="fleet-dealer-stat">
					<div class="fleet-dealer-stat-label">Taux appliqué</div>
					<div class="fleet-dealer-stat-value">{$Charge}%</div>
				</div>
				<div class="fleet-dealer-stat">
					<div class="fleet-dealer-stat-label">Rendement métal</div>
					<div class="fleet-dealer-stat-value" id="metal"></div>
				</div>
				<div class="fleet-dealer-stat">
					<div class="fleet-dealer-stat-label">Rendement cristal</div>
					<div class="fleet-dealer-stat-value" id="crystal"></div>
				</div>
			</div>
		</section>

		<section class="fleet-dealer-card">
			<div class="fleet-dealer-form-grid">
				<div>
					<label class="form-label text-white-50" for="count">{$LNG.ft_count}</label>
					<div class="input-group">
						<input type="text" class="form-control bg-dark text-white border-warning-subtle" id="count" name="count" onkeyup="Total();">
						<button class="btn btn-outline-warning" onclick="MaxShips();return false;">{$LNG.ft_max}</button>
					</div>
				</div>
				<div>
					<h4 class="text-yellow mb-3">{$LNG.ft_total}</h4>
					<div class="fleet-dealer-totals">
						<div class="fleet-dealer-total"><div class="fleet-dealer-stat-label">{$LNG.tech.901}</div><div class="fleet-dealer-stat-value" id="total_metal"></div></div>
						<div class="fleet-dealer-total"><div class="fleet-dealer-stat-label">{$LNG.tech.902}</div><div class="fleet-dealer-stat-value" id="total_crystal"></div></div>
						<div class="fleet-dealer-total"><div class="fleet-dealer-stat-label">{$LNG.tech.903}</div><div class="fleet-dealer-stat-value" id="total_deuterium"></div></div>
						<div class="fleet-dealer-total"><div class="fleet-dealer-stat-label">{$LNG.tech.921}</div><div class="fleet-dealer-stat-value" id="total_darkmatter"></div></div>
					</div>
				</div>
				<div class="d-flex justify-content-end">
					<input class="btn btn-warning fw-semibold text-dark" type="submit" value="{$LNG.ft_absenden}">
				</div>
			</div>
		</section>
	</div>
</form>
{block name="script" append}
<script src="scripts/game/fleettrader.js"></script>
<script>
var CostInfo = {$CostInfos|json};
var ShipDescriptions = {$shipDescriptions|json};
var Charge = {$Charge};
$(function(){
    updateVars();
});
</script>
{/block}
{/block}
