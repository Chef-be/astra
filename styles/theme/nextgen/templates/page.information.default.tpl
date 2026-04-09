{block name="title" prepend}{$LNG.lm_info}{/block}
{block name="content"}
<style>
	.info-shell {
		display: grid;
		gap: 0.8rem;
		padding: 0.55rem;
	}

	.info-card {
		padding: 0.9rem 0.95rem;
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.08);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.98), rgba(7, 11, 20, 1));
		box-shadow: 0 0.7rem 1.6rem rgba(0, 0, 0, 0.22);
		color: #edf2ff;
	}

	.info-card h1,
	.info-card h2 {
		margin: 0 0 0.7rem;
		color: #ffd666;
	}

	.info-card h1 {
		font-size: 1.15rem;
	}

	.info-card h2 {
		font-size: 0.95rem;
	}

	.info-richtext,
	.info-copy {
		color: rgba(255, 255, 255, 0.78);
		line-height: 1.55;
		font-size: 0.88rem;
	}

	.info-copy + .info-copy {
		margin-top: 0.7rem;
	}

	.info-bonus-list,
	.info-rapidfire-list {
		display: grid;
		gap: 0.4rem;
		margin-top: 0.6rem;
	}

	.info-line {
		display: flex;
		justify-content: space-between;
		gap: 0.75rem;
		padding: 0.45rem 0.55rem;
		border-radius: 0.82rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.06);
		font-size: 0.82rem;
	}

	.info-line strong {
		color: #f8fbff;
	}

	.info-shell table {
		width: 100%;
		margin: 0;
		color: #edf2ff;
	}

	.info-shell table table {
		width: 100%;
	}

	.info-shell th,
	.info-shell td {
		padding: 0.42rem 0.5rem;
		border-color: rgba(255, 255, 255, 0.08) !important;
		background: transparent !important;
		font-size: 0.8rem;
	}

	.info-shell input,
	.info-shell select {
		border-radius: 0.7rem;
		border: 1px solid rgba(255, 255, 255, 0.16);
		background: rgba(7, 11, 20, 0.9);
		color: #edf2ff;
		padding: 0.35rem 0.5rem;
	}

	.info-shell input[type="button"],
	.info-shell input[type="submit"],
	.info-shell button {
		border-radius: 0.8rem;
		border: 0;
		background: #ffd666;
		color: #121722;
		font-weight: 700;
		padding: 0.45rem 0.75rem;
	}

	.info-shell a {
		color: #ffd666;
		text-decoration: none;
	}

	.info-shell a:hover {
		color: #fff2bf;
	}
</style>

<div class="info-shell">
	<section class="info-card">
		<h1>{$LNG.tech.$elementID}</h1>
		<div class="info-richtext">{$LNG.longDescription.$elementID}</div>

		{if !empty($Bonus)}
		<div class="info-copy">
			<strong>{$LNG.in_bonus}</strong>
			<div class="info-bonus-list">
				{foreach $Bonus as $BonusName => $elementBouns}
				<div class="info-line">
					<span>{$LNG.bonus.$BonusName}</span>
					<strong>{if $elementBouns[0] < 0}-{else}+{/if}{if $elementBouns[1] == 0}{abs($elementBouns[0] * 100)}%{else}{floatval($elementBouns[0])}{/if}</strong>
				</div>
				{/foreach}
			</div>
		</div>
		{/if}

		{if !empty($FleetInfo)}
			{if !empty($FleetInfo.rapidfire.to)}
			<div class="info-copy">
				<strong>{$LNG.in_rf_again}</strong>
				<div class="info-rapidfire-list">
					{foreach $FleetInfo.rapidfire.to as $rapidfireID => $shoots}
					<div class="info-line">
						<span>{$LNG.tech.$rapidfireID}</span>
						<strong>{$shoots|number}</strong>
					</div>
					{/foreach}
				</div>
			</div>
			{/if}
			{if !empty($FleetInfo.rapidfire.from)}
			<div class="info-copy">
				<strong>{$LNG.in_rf_from}</strong>
				<div class="info-rapidfire-list">
					{foreach $FleetInfo.rapidfire.from as $rapidfireID => $shoots}
					<div class="info-line">
						<span>{$LNG.tech.$rapidfireID}</span>
						<strong>{$shoots|number}</strong>
					</div>
					{/foreach}
				</div>
			</div>
			{/if}
		{/if}
	</section>

	{if !empty($FleetInfo)}
	<section class="info-card">
		<h2>Fiche technique</h2>
		{include file="shared.information.shipInfo.tpl"}
	</section>
	{/if}
	{if !empty($gateData)}
	<section class="info-card">
		<h2>{$LNG.tech.$elementID}</h2>
		{include file="shared.information.gate.tpl"}
	</section>
	{/if}
	{if !empty($MissileList)}
	<section class="info-card">
		<h2>{$LNG.in_destroy}</h2>
		{include file="shared.information.missiles.tpl"}
	</section>
	{/if}
	{if !empty($productionTable.production)}
	<section class="info-card">
		<h2>{$LNG.in_prod_p_hour}</h2>
		{include file="shared.information.production.tpl"}
	</section>
	{/if}
	{if !empty($productionTable.storage)}
	<section class="info-card">
		<h2>{$LNG.in_storage}</h2>
		{include file="shared.information.storage.tpl"}
	</section>
	{/if}
</div>
{/block}
