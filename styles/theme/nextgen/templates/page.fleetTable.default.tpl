{block name="title" prepend}{$LNG.lm_fleet}{/block}
{block name="content"}
<div class="fleet-page fleet-page--compact">
	<section class="fleet-strip">
		<h1 class="fleet-strip__title">{$LNG.lm_fleet}</h1>
		<div class="fleet-strip__stats">
			<span class="fleet-strip__pill"><strong>{$activeFleetSlots} / {$maxFleetSlots}</strong><small>Flottes</small></span>
			<span class="fleet-strip__pill"><strong>{$activeExpedition} / {$maxExpedition}</strong><small>Expéditions</small></span>
			<span class="fleet-strip__pill"><strong>[{$targetGalaxy}:{$targetSystem}:{$targetPlanet}]</strong><small>Cible</small></span>
		</div>
	</section>

	<section class="fleet-surface fleet-surface--compact">
		<div class="fleet-surface__head fleet-surface__head--tight">
			<h2>En vol</h2>
			<span class="fleet-surface__badge">{if $FlyingFleetList|@count > 0}{$FlyingFleetList|@count}{else}0{/if}</span>
		</div>

		{if $FlyingFleetList|@count > 0}
		<div class="fleet-table-shell">
			<div class="fleet-table-responsive">
				<table class="table table-sm fs-12 table-gow fleet-table-grid">
					<colgroup>
						<col class="fleet-table-grid__col fleet-table-grid__col--index">
						<col class="fleet-table-grid__col fleet-table-grid__col--mission">
						<col class="fleet-table-grid__col fleet-table-grid__col--ships">
						<col class="fleet-table-grid__col fleet-table-grid__col--start">
						<col class="fleet-table-grid__col fleet-table-grid__col--launch">
						<col class="fleet-table-grid__col fleet-table-grid__col--target">
						<col class="fleet-table-grid__col fleet-table-grid__col--arrival">
						<col class="fleet-table-grid__col fleet-table-grid__col--timer">
						<col class="fleet-table-grid__col fleet-table-grid__col--actions">
					</colgroup>
					<thead>
						<tr>
							<th>#</th>
							<th>Mission</th>
							<th>Vaisseaux</th>
							<th>Départ</th>
							<th>Décollage</th>
							<th>Destination</th>
							<th>Arrivée</th>
							<th>Reste</th>
							<th>Ordre</th>
						</tr>
					</thead>
					<tbody>
						{foreach name=FlyingFleets item=FlyingFleetRow from=$FlyingFleetList}
						<tr>
							<td>{$smarty.foreach.FlyingFleets.iteration}</td>
							<td class="fleet-table-grid__mission">
								<a data-bs-toggle="tooltip"
								data-bs-placement="top"
								data-bs-html="true" title="
								<table class='fs-12'>
									<tbody>
										<tr><td style='width:50%;color:white'>{$LNG['tech'][901]}</td><td style='width:50%;color:white'>{$FlyingFleetRow.metal}</td></tr>
										<tr><td style='width:50%;color:white'>{$LNG['tech'][902]}</td><td style='width:50%;color:white'>{$FlyingFleetRow.crystal}</td></tr>
										<tr><td style='width:50%;color:white'>{$LNG['tech'][903]}</td><td style='width:50%;color:white'>{$FlyingFleetRow.deuterium}</td></tr>
										<tr><td style='width:50%;color:white'>{$LNG['tech'][921]}</td><td style='width:50%;color:white'>{$FlyingFleetRow.dm}</td></tr>
									</tbody>
								</table>">{$LNG["type_mission_{$FlyingFleetRow.mission}"]}</a>
								<span class="fleet-table-grid__status {if $FlyingFleetRow.state == 1}is-return{else}is-outbound{/if}">
									{if $FlyingFleetRow.state == 1}{$LNG.fl_r}{else}{$LNG.fl_a}{/if}
								</span>
							</td>
							<td><a class="tooltip_sticky" data-tooltip-content="<table><tr><th colspan='2' style='text-align:center;'>{$LNG.fl_info_detail}</th></tr>{foreach $FlyingFleetRow.FleetList as $shipID => $shipCount}<tr><td class='transparent'>{$LNG.tech.{$shipID}}:</td><td class='transparent'>{$shipCount}</td></tr>{/foreach}</table>">{$FlyingFleetRow.amount}</a></td>
							<td><a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.startGalaxy}&amp;system={$FlyingFleetRow.startSystem}">[{$FlyingFleetRow.startGalaxy}:{$FlyingFleetRow.startSystem}:{$FlyingFleetRow.startPlanet}]</a></td>
							<td{if $FlyingFleetRow.state == 0} class="fleet-table-grid__time is-active"{/if}>{$FlyingFleetRow.startTime}</td>
							<td><a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.endGalaxy}&amp;system={$FlyingFleetRow.endSystem}">[{$FlyingFleetRow.endGalaxy}:{$FlyingFleetRow.endSystem}:{$FlyingFleetRow.endPlanet}]</a></td>
							{if $FlyingFleetRow.mission == 4 && $FlyingFleetRow.state == 0}
							<td>-</td>
							{else}
							<td{if $FlyingFleetRow.state != 0} class="fleet-table-grid__time is-active"{/if}>{$FlyingFleetRow.endTime}</td>
							{/if}
							<td id="fleettime_{$smarty.foreach.FlyingFleets.iteration}" class="fleets fleet-table-grid__timer" data-fleet-end-time="{$FlyingFleetRow.returntime}" data-fleet-time="{$FlyingFleetRow.resttime}">{pretty_fly_time({$FlyingFleetRow.resttime})}</td>
							<td>
								<div class="fleet-action-stack">
									{if !$isVacation && $FlyingFleetRow.state != 1 && $FlyingFleetRow.no_returnable != 1}
									<form action="game.php?page=fleetTable&amp;action=sendfleetback" method="post">
										<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
										<input class="btn btn-sm btn-outline-light fleet-action-stack__button" value="{$LNG.fl_send_back}" type="submit">
									</form>
									{if $FlyingFleetRow.mission == 1}
									<form action="game.php?page=fleetTable&amp;action=acs" method="post">
										<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
										<input class="btn btn-sm btn-primary fleet-action-stack__button" value="{$LNG.fl_acs}" type="submit">
									</form>
									{/if}
									{else}
									<span class="fleet-action-stack__muted">-</span>
									{/if}
								</div>
							</td>
						</tr>
						{/foreach}
						{if $maxFleetSlots == $activeFleetSlots}
						<tr><td colspan="9" class="fleet-table-grid__limit">{$LNG.fl_no_more_slots}</td></tr>
						{/if}
					</tbody>
				</table>
			</div>

			<div class="fleet-card-list">
				{foreach name=FlyingFleetsMobile item=FlyingFleetRow from=$FlyingFleetList}
				<article class="fleet-mobile-card fleet-mobile-card--dense">
					<div class="fleet-mobile-card__head">
						<h3>{$LNG["type_mission_{$FlyingFleetRow.mission}"]}</h3>
						<span class="fleet-mobile-card__badge {if $FlyingFleetRow.state == 1}is-return{else}is-outbound{/if}">
							{if $FlyingFleetRow.state == 1}{$LNG.fl_r}{else}{$LNG.fl_a}{/if}
						</span>
					</div>
					<div class="fleet-mobile-card__meta">
						<div class="fleet-mobile-card__stat">
							<span>#</span>
							<strong>{$smarty.foreach.FlyingFleetsMobile.iteration}</strong>
						</div>
						<div class="fleet-mobile-card__stat">
							<span>Vaisseaux</span>
							<strong>{$FlyingFleetRow.amount}</strong>
						</div>
						<div class="fleet-mobile-card__stat">
							<span>Reste</span>
							<strong id="fleettime_mobile_{$smarty.foreach.FlyingFleetsMobile.iteration}" class="fleets" data-fleet-end-time="{$FlyingFleetRow.returntime}" data-fleet-time="{$FlyingFleetRow.resttime}">{pretty_fly_time({$FlyingFleetRow.resttime})}</strong>
						</div>
					</div>
					<div class="fleet-mobile-card__route">
						<div class="fleet-mobile-card__route-point">
							<span>Départ</span>
							<a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.startGalaxy}&amp;system={$FlyingFleetRow.startSystem}">[{$FlyingFleetRow.startGalaxy}:{$FlyingFleetRow.startSystem}:{$FlyingFleetRow.startPlanet}]</a>
						</div>
						<div class="fleet-mobile-card__route-arrow" aria-hidden="true">→</div>
						<div class="fleet-mobile-card__route-point">
							<span>Destination</span>
							<a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.endGalaxy}&amp;system={$FlyingFleetRow.endSystem}">[{$FlyingFleetRow.endGalaxy}:{$FlyingFleetRow.endSystem}:{$FlyingFleetRow.endPlanet}]</a>
						</div>
					</div>
					<div class="fleet-mobile-card__actions fleet-mobile-card__actions--inline">
						{if !$isVacation && $FlyingFleetRow.state != 1 && $FlyingFleetRow.no_returnable != 1}
						<form action="game.php?page=fleetTable&amp;action=sendfleetback" method="post">
							<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
							<input class="btn btn-sm btn-outline-light" value="{$LNG.fl_send_back}" type="submit">
						</form>
						{if $FlyingFleetRow.mission == 1}
						<form action="game.php?page=fleetTable&amp;action=acs" method="post">
							<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
							<input class="btn btn-sm btn-primary" value="{$LNG.fl_acs}" type="submit">
						</form>
						{/if}
						{/if}
					</div>
				</article>
				{/foreach}
			</div>
		</div>
		{else}
		<div class="fleet-empty-state fleet-empty-state--compact">
			<strong>{$LNG.fm_no_fleet_movements}</strong>
		</div>
		{/if}
	</section>

	{if !empty($acsData)}
	<section class="fleet-surface fleet-surface--compact">
		<div class="fleet-surface__head fleet-surface__head--tight">
			<h2>ACS</h2>
			<span class="fleet-surface__badge">{$acsData.acsName}</span>
		</div>
		{include file="shared.fleetTable.acsTable.tpl"}
	</section>
	{/if}

	<div class="fleet-builder-grid fleet-builder-grid--compact">
		<section class="fleet-surface fleet-surface--compact fleet-surface--builder-main">
			<div class="fleet-surface__head fleet-surface__head--tight">
				<h2>{$LNG.fl_new_mission_title}</h2>
				<span class="fleet-surface__badge">[{$targetGalaxy}:{$targetSystem}:{$targetPlanet}]</span>
			</div>

			<form action="?page=fleetStep1" method="post">
				<input type="hidden" name="galaxy" value="{$targetGalaxy}">
				<input type="hidden" name="system" value="{$targetSystem}">
				<input type="hidden" name="planet" value="{$targetPlanet}">
				<input type="hidden" name="type" value="{$targetType}">
				<input type="hidden" name="target_mission" value="{$targetMission}">

				<div class="fleet-builder-table-shell">
					<div class="fleet-table-responsive">
						<table class="table table-sm bg-black fs-12 table-gow fleet-builder-table fleet-builder-table--dense">
							<colgroup>
								<col class="fleet-builder-table__col fleet-builder-table__col--ship">
								<col class="fleet-builder-table__col fleet-builder-table__col--available">
								<col class="fleet-builder-table__col fleet-builder-table__col--max">
								<col class="fleet-builder-table__col fleet-builder-table__col--qty">
							</colgroup>
							<thead>
								<tr>
									<th>{$LNG.fl_ship_type}</th>
									<th>{$LNG.fl_ship_available}</th>
									<th>Max</th>
									<th>Qté</th>
								</tr>
							</thead>
							<tbody>
								{foreach $FleetsOnPlanet as $FleetRow}
								<tr>
									<td class="align-middle">
										{if $FleetRow.speed != 0}
										<a class="hover-underline hover-pointer" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-html="true" title='<table class="table-tooltip"><tbody><tr><td>{$LNG.fl_speed_title}</td></tr><tr><td>{$FleetRow.speed}</td></tr></tbody></table>'>{$LNG.tech.{$FleetRow.id}}</a>
										{else}
										{$LNG.tech.{$FleetRow.id}}
										{/if}
									</td>
									<td class="align-middle" id="ship{$FleetRow.id}_value">{$FleetRow.count}</td>
									{if $FleetRow.speed != 0}
									<td class="align-middle text-center"><a class="hover-underline hover-pointer" href="javascript:maxShip('ship{$FleetRow.id}');">max</a></td>
									<td><input class="form-control bg-dark text-white text-center fleet-builder-input" name="ship{$FleetRow.id}" id="ship{$FleetRow.id}_input" size="10" value="0"></td>
									{else}
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									{/if}
								</tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>

				<div class="fleet-builder-actions fleet-builder-actions--compact">
					{if count($FleetsOnPlanet) == 0}
					<span class="fleet-action-stack__muted">{$LNG.fl_no_ships}</span>
					{else}
					<a class="btn btn-outline-light btn-sm" href="javascript:noShips();">Vider</a>
					<a class="btn btn-outline-light btn-sm" href="javascript:maxShips();">Tout</a>
					{/if}
					{if $maxFleetSlots != $activeFleetSlots}
					<input class="btn btn-primary btn-sm" type="submit" value="{$LNG.fl_continue}">
					{else}
					<span class="fleet-action-stack__muted">{$LNG.fl_no_more_slots}</span>
					{/if}
				</div>
			</form>
		</section>

		<section class="fleet-surface fleet-surface--compact fleet-surface--bonus-below">
			<div class="fleet-surface__head fleet-surface__head--tight">
				<h2>{$LNG.fl_bonus}</h2>
			</div>
			<div class="fleet-bonus-grid">
				<div class="fleet-bonus-chip">
					<span>{$LNG.fl_bonus_attack}</span>
					<strong>+{$bonusAttack} %</strong>
				</div>
				<div class="fleet-bonus-chip">
					<span>{$LNG.fl_bonus_defensive}</span>
					<strong>+{$bonusDefensive} %</strong>
				</div>
				<div class="fleet-bonus-chip">
					<span>{$LNG.fl_bonus_shield}</span>
					<strong>+{$bonusShield} %</strong>
				</div>
				<div class="fleet-bonus-chip">
					<span>{$LNG.tech.115}</span>
					<strong>+{$bonusCombustion} %</strong>
				</div>
				<div class="fleet-bonus-chip">
					<span>{$LNG.tech.117}</span>
					<strong>+{$bonusImpulse} %</strong>
				</div>
				<div class="fleet-bonus-chip">
					<span>{$LNG.tech.118}</span>
					<strong>+{$bonusHyperspace} %</strong>
				</div>
			</div>
		</section>
	</div>
</div>
{/block}

{block name="script" append}
<script src="scripts/game/fleetTable.js"></script>
{/block}
