{block name="title" prepend}{$LNG.lm_galaxy}{/block}
{block name="content"}

<script type="text/javascript">
	function hideGalaxyPopovers() {
		if (typeof bootstrap !== 'undefined' && bootstrap.Popover) {
			document.querySelectorAll('[data-bs-toggle="popover"]').forEach(function(element) {
				var instance = bootstrap.Popover.getInstance(element);
				if (instance) {
					instance.hide();
				}
			});
		}
		$('.popover').remove();
	}
	function closePopovers(){
		hideGalaxyPopovers();
	}
	function closePopover(){
		hideGalaxyPopovers();
	}
	$(document).on('click', '.galaxy-popover-close', function(event) {
		event.preventDefault();
		event.stopPropagation();
		closePopover();
	});
</script>
<style>
	.galaxy-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
	}

	.galaxy-hero,
	.galaxy-toolbar,
	.galaxy-panel {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.galaxy-hero {
		padding: 1.1rem 1.2rem;
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.galaxy-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.galaxy-hero p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.55;
	}

	.galaxy-summary {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.7rem;
		margin-top: 0.9rem;
	}

	.galaxy-summary-item {
		padding: 0.75rem 0.85rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.galaxy-summary-item span {
		display: block;
		margin-bottom: 0.18rem;
		font-size: 0.72rem;
		color: rgba(255, 255, 255, 0.58);
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}

	.galaxy-summary-item strong {
		display: block;
		font-size: 1rem;
		color: #f8fbff;
	}

	.galaxy-toolbar,
	.galaxy-panel {
		padding: 0.95rem;
	}

	.galaxy-section-title {
		margin: 0 0 0.75rem;
		font-size: 1rem;
		color: #ffd666;
	}

	.galaxy-occupied-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
		gap: 0.75rem;
	}

	.galaxy-slot-card {
		padding: 0.8rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.galaxy-slot-head {
		display: grid;
		grid-template-columns: 56px minmax(0, 1fr);
		gap: 0.7rem;
		align-items: center;
	}

	.galaxy-slot-head img {
		width: 56px;
		height: 56px;
		object-fit: cover;
		border-radius: 0.85rem;
		border: 1px solid rgba(255, 214, 102, 0.16);
	}

	.galaxy-slot-name {
		color: #f8fbff;
		font-weight: 700;
	}

	.galaxy-slot-subline {
		font-size: 0.78rem;
		color: rgba(255, 255, 255, 0.62);
	}

	.galaxy-slot-meta,
	.galaxy-slot-actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		margin-top: 0.65rem;
	}

	.galaxy-slot-pill {
		display: inline-flex;
		align-items: center;
		padding: 0.24rem 0.46rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.05);
		border: 1px solid rgba(255, 255, 255, 0.08);
		font-size: 0.72rem;
		color: rgba(255, 255, 255, 0.82);
	}

	.galaxy-slot-card--destroyed {
		background: rgba(255, 120, 120, 0.05);
		border-color: rgba(255, 120, 120, 0.16);
	}

	.galaxy-system-details summary {
		cursor: pointer;
		list-style: none;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		color: #ffd666;
		font-weight: 700;
	}

	.galaxy-system-details summary::-webkit-details-marker {
		display: none;
	}

	.galaxy-system-details summary span {
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.78rem;
		font-weight: 400;
	}

	.galaxy-controls-grid {
		display: grid;
		grid-template-columns: repeat(6, minmax(0, 1fr)) 140px;
		gap: 0.6rem;
		align-items: center;
	}

	.galaxy-grid-wrap {
		overflow-x: auto;
	}

	.galaxy-grid {
		table-layout: fixed;
		min-width: 860px;
	}

	.galaxy-grid th:nth-child(1),
	.galaxy-grid td:nth-child(1) {
		width: 5%;
	}

	.galaxy-grid th:nth-child(2),
	.galaxy-grid td:nth-child(2) {
		width: 7%;
	}

	.galaxy-grid th:nth-child(4),
	.galaxy-grid td:nth-child(4),
	.galaxy-grid th:nth-child(5),
	.galaxy-grid td:nth-child(5) {
		width: 8%;
	}

	.galaxy-grid th:nth-child(8),
	.galaxy-grid td:nth-child(8) {
		width: 12%;
	}

	.galaxy-grid .galaxy-actions {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-wrap: wrap;
		gap: 0.3rem;
	}

	.galaxy-grid .galaxy-action-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.9rem;
		height: 1.9rem;
		border: 1px solid rgba(255, 214, 102, 0.28);
		border-radius: 999px;
		background: rgba(8, 14, 28, 0.92);
		color: #ffd666;
		font-size: 0.95rem;
		line-height: 1;
		box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
	}

	.galaxy-grid .galaxy-action-btn:hover {
		color: #fff3cb;
		border-color: rgba(255, 214, 102, 0.6);
		background: rgba(26, 37, 58, 0.95);
	}

	.galaxy-grid .galaxy-action-btn span {
		display: inline-block;
		transform: translateY(-0.02rem);
		font-size: 1rem;
	}

	.galaxy-popover {
		--bs-popover-bg: #08101d;
		--bs-popover-border-color: rgba(255, 214, 102, 0.32);
		--bs-popover-header-bg: #111c31;
		--bs-popover-header-color: #ffd666;
		--bs-popover-body-color: #edf2ff;
		--bs-popover-max-width: 320px;
	}

	.galaxy-popover .popover {
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.45);
	}

	.galaxy-popover .table {
		margin-bottom: 0;
	}

	.galaxy-popover .table th,
	.galaxy-popover .table td {
		background: transparent !important;
		color: #edf2ff !important;
		border-color: rgba(255, 255, 255, 0.08) !important;
	}

	.galaxy-popover .popover-header {
		position: relative;
		padding-right: 2.1rem;
	}

	.galaxy-popover-close {
		position: absolute;
		top: 0.35rem;
		right: 0.35rem;
		width: 1.4rem;
		height: 1.4rem;
		border: 1px solid rgba(255, 214, 102, 0.35);
		border-radius: 999px;
		background: rgba(255, 214, 102, 0.08);
		color: #ffd666;
		font-size: 0.95rem;
		line-height: 1;
	}

	.galaxy-popover-close:hover {
		background: rgba(255, 214, 102, 0.18);
		color: #fff6da;
	}

	@media (max-width: 991px) {
		.galaxy-summary,
		.galaxy-controls-grid {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="galaxy-shell">
	<section class="galaxy-hero">
		<h1>{$LNG.lm_galaxy}</h1>
		<p>Explorez les systèmes voisins, repérez l’activité, surveillez les lunes et champs de débris, et déclenchez vos actions principales depuis une vue plus lisible.</p>
		<div class="galaxy-summary">
			<div class="galaxy-summary-item"><span>Coordonnées</span><strong>{$galaxy}:{$system}:{$planet}</strong></div>
			<div class="galaxy-summary-item"><span>Planètes repérées</span><strong>{$planetcount}</strong></div>
			<div class="galaxy-summary-item"><span>Flottes</span><strong>{$maxfleetcount}/{$fleetmax}</strong></div>
			<div class="galaxy-summary-item"><span>Sondes / recycleurs</span><strong>{$spyprobes|number} / {$recyclers|number}</strong></div>
		</div>
	</section>

	<section class="galaxy-toolbar">
	<form action="?page=galaxy" method="post" id="galaxy_form">
	<input type="hidden" id="auto" value="dr">
	<div class="galaxy-controls-grid">
		<input class="btn bg-dark text-yellow text-center fs-12 fw-bold" type="button" name="galaxyLeft" value="&lt;" onclick="galaxy_submit('galaxyLeft')">
		<input class="text-center form-control bg-dark text-white border-secondary" type="text" name="galaxy" value="{$galaxy}" maxlength="3" tabindex="1">
		<input class="btn bg-dark text-yellow text-center fs-12 fw-bold" type="button" name="galaxyRight" value="&gt;" onclick="galaxy_submit('galaxyRight')">
		<input class="btn bg-dark text-yellow text-center fs-12 fw-bold" type="button" name="systemLeft" value="&lt;" onclick="galaxy_submit('systemLeft')">
		<input class="text-center form-control bg-dark text-white border-secondary" type="text" name="system" value="{$system}" maxlength="3" tabindex="2">
		<input class="btn bg-dark text-yellow text-center fs-12 fw-bold" type="button" name="systemRight" value="&gt;" onclick="galaxy_submit('systemRight')">
		<input class="btn btn-warning text-dark fw-semibold" id="galaxySubmit" type="submit" value="{$LNG.gl_show}">
	</div>
	</form>
	</section>
	{if $action == 'sendMissle'}
    <section class="galaxy-panel">
	<form action="?page=fleetMissile" method="post">
			<input type="hidden" name="galaxy" value="{$galaxy}">
			<input type="hidden" name="system" value="{$system}">
			<input type="hidden" name="planet" value="{$planet}">
			<input type="hidden" name="type" value="{$type}">
		<table class="table table-gow table-sm fs-12 my-1">
			<tr>
				<th colspan="2">{$LNG.gl_missil_launch} [{$galaxy}:{$system}:{$planet}]</th>
			</tr>
			<tr>
				<td>{$missile_count} <input type="text" name="SendMI" size="2" maxlength="7"></td>
				<td>{$LNG.gl_objective}:
					{html_options name=Target options=$missileSelector}
				</td>
			</tr>
			<tr>
				<th colspan="2" style="text-align:center;"><input type="submit" value="{$LNG.gl_missil_launch_action}"></th>
			</tr>
		</table>
	</form>
	</section>
    {/if}
	<section class="galaxy-panel">
		<h2 class="galaxy-section-title">Positions actives du système</h2>
		<div class="galaxy-occupied-grid">
			{for $planet=1 to $max_planets}
				{if isset($GalaxyRows[$planet]) && $GalaxyRows[$planet] !== false}
					{$currentPlanet = $GalaxyRows[$planet]}
					<article class="galaxy-slot-card">
						<div class="galaxy-slot-head">
							<img src="{$dpath}planeten/{$currentPlanet.planet.image}.jpg" alt="{$currentPlanet.planet.name}">
							<div>
								<div class="galaxy-slot-name">{$planet}. {$currentPlanet.planet.name}</div>
								<div class="galaxy-slot-subline">
									<span class="{foreach $currentPlanet.user.class as $class}{if !$class@first} {/if}galaxy-username-{$class}{/foreach} galaxy-username">{$currentPlanet.user.username}</span>
									{if !empty($currentPlanet.user.class)}
									<span>({foreach $currentPlanet.user.class as $class}{if !$class@first} {/if}<span class="galaxy-short-{$class} galaxy-short">{$ShortStatus.$class}</span>{/foreach})</span>
									{/if}
								</div>
							</div>
						</div>
						<div class="galaxy-slot-meta">
							<span class="galaxy-slot-pill">Coordonnées [{$galaxy}:{$system}:{$planet}]</span>
							{if $currentPlanet.lastActivity}<span class="galaxy-slot-pill">Activité {$currentPlanet.lastActivity}</span>{/if}
							{if $currentPlanet.moon}<span class="galaxy-slot-pill">Lune {$currentPlanet.moon.name}</span>{/if}
							{if $currentPlanet.debris}<span class="galaxy-slot-pill">CDR {$currentPlanet.debris.metal|number} / {$currentPlanet.debris.crystal|number}</span>{/if}
							{if $currentPlanet.alliance}<span class="galaxy-slot-pill">Alliance {$currentPlanet.alliance.tag}</span>{/if}
						</div>
						<div class="galaxy-slot-actions">
							{if $currentPlanet.action}
								{if $currentPlanet.action.esp}
								<a class="galaxy-action-btn text-decoration-none" title="{$LNG.gl_spy}" onclick="doit(6,{$currentPlanet.planet.id},{$spyShips|json|escape:'html'})"><span>🔭</span></a>
								{/if}
								{if $currentPlanet.action.message}
								<a class="galaxy-action-btn text-decoration-none" title="{$LNG.write_message}" onclick="return Dialog.PM({$currentPlanet.user.id})"><span>✉</span></a>
								{/if}
								{if $currentPlanet.action.buddy}
								<a class="galaxy-action-btn text-decoration-none" title="{$LNG.gl_buddy_request}" onclick="return Dialog.Buddy({$currentPlanet.user.id})"><span>🤝</span></a>
								{/if}
								{if $currentPlanet.action.missle}
								<a class="galaxy-action-btn text-decoration-none" title="{$LNG.gl_missile_attack}" href="?page=galaxy&amp;action=sendMissle&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;type=1"><span>🚀</span></a>
								{/if}
							{/if}
							<a class="galaxy-action-btn text-decoration-none" title="{$LNG.gl_playercard}" onclick="return Dialog.Playercard({$currentPlanet.user.id});"><span>👤</span></a>
							<a class="galaxy-action-btn text-decoration-none" title="{$LNG.gl_see_on_stats}" href="?page=statistics&amp;who=1&amp;start={$currentPlanet.user.rank}"><span>📈</span></a>
						</div>
					</article>
				{elseif isset($GalaxyRows[$planet]) && $GalaxyRows[$planet] === false}
					<article class="galaxy-slot-card galaxy-slot-card--destroyed">
						<div class="galaxy-slot-name">{$planet}. Position détruite</div>
						<div class="galaxy-slot-subline">Cette orbite est détruite et ne contient plus de planète exploitable.</div>
					</article>
				{/if}
			{/for}
			<article class="galaxy-slot-card">
				<div class="galaxy-slot-name">{$max_planets + 1}. {$LNG.gl_out_space}</div>
				<div class="galaxy-slot-actions">
					<a class="btn btn-outline-light btn-sm" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 1}&amp;planettype=1&amp;target_mission=15">Expédition</a>
				</div>
			</article>
			<article class="galaxy-slot-card">
				<div class="galaxy-slot-name">Commerce</div>
				<div class="galaxy-slot-subline">Zone commerciale du système courant.</div>
				<div class="galaxy-slot-actions">
					<a class="btn btn-outline-light btn-sm" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 2}&amp;planettype=1&amp;target_mission=16">Accéder</a>
				</div>
			</article>
		</div>
	</section>

	<details class="galaxy-panel galaxy-system-details">
		<summary>
			<div>Vue complète du système</div>
			<span>{$planetcount} planète(s) occupée(s), {$maxfleetcount}/{$fleetmax} emplacements de flotte, {$spyprobes|number} sondes, {$recyclers|number} recycleurs</span>
		</summary>
		<div class="galaxy-grid-wrap mt-3">
	<table class="table table-sm table-gow fs-12 galaxy-grid">
    <tr>
			<th class="text-center" colspan="8">{$LNG.gl_solar_system} {$galaxy}:{$system}</th>
		</tr>
	<tr>
		<th>{$LNG.gl_pos}</th>
		<th>{$LNG.gl_planet}</th>
		<th>{$LNG.gl_name_activity}</th>
		<th>{$LNG.gl_moon}</th>
		<th>{$LNG.gl_debris}</th>
		<th>{$LNG.gl_player_estate}</th>
		<th>{$LNG.gl_alliance}</th>
		<th>{$LNG.gl_actions}</th>
	</tr>
    {for $planet=1 to $max_planets}
	<tr>
    {if !isset($GalaxyRows[$planet])}
		<td class="text-center align-middle">
			<a href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=7">{$planet}</a>
		</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    {elseif $GalaxyRows[$planet] === false}
		<td class="text-center align-middle">
			{$planet}
		</td>
        <td></td>
        <td style="white-space: nowrap;">{$LNG.gl_planet_destroyed}</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    {else}
		<td class="text-center align-middle">
			{$planet}
		</td>
        {$currentPlanet = $GalaxyRows[$planet]}
		<td class="text-center align-middle">
			<a onclick="closePopovers();" class="hover-pointer" data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			title ="
			<table class='table table-gow position-relative fs-11' style='width:220px'>
				<tr>
					<th colspan='2'>
						<span>{$LNG.gl_planet} {$currentPlanet.planet.name} [{$galaxy}:{$system}:{$planet}]</span>
						<button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button>
					</th>
				</tr>
				{if $userAuthLevel == 3}
				<tr>
					<td>user ID:</td>
					<td>{$currentPlanet['user']['id']}</td>
				</tr>
				<tr>
					<td>planet ID:</td>
					<td>{$currentPlanet['planet']['id']}</td>
				</tr>
				{/if}
				<tr>
					<td style='width:80px'><img src='{$dpath}planeten/{$currentPlanet.planet.image}.jpg' height='75' width='75'></td>
					<td>
						<div class='d-flex flex-column'>
						{if $currentPlanet.missions.6}
						<a class='hover-underline my-1 hover-pointer' onclick='doit(6,{$currentPlanet.planet.id})'>{$LNG.type_mission_6}</a>
						{/if}
						{foreach $currentPlanet.user.class as $class}
						{if $class != 'vacation' && $currentPlanet.planet.phalanx}
						<a class='hover-underline my-1 hover-pointer' onclick='OpenPopup(&quot;?page=phalanx&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&quot;, &quot;&quot;, 640, 510);'>
							{$LNG.gl_phalanx}
						</a>
						{/if}
						{foreachelse}
						{if $currentPlanet.planet.phalanx}
						<a class='hover-underline my-1 hover-pointer' onclick='OpenPopup(&quot;?page=phalanx&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&quot;, &quot;&quot;, 640, 510);'>{$LNG.gl_phalanx}</a>
						{/if}
						{/foreach}
						{if $currentPlanet.missions.1}
						<a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=1'>
							{$LNG.type_mission_1}
						</a>
						{/if}
						{if $currentPlanet.missions.5}
						<a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=5'>
							{$LNG.type_mission_5}
						</a>
						{/if}
						{if $currentPlanet.missions.4}
						<a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=4'>
							{$LNG.type_mission_4}
						</a>
						{/if}
						{if $currentPlanet.missions.3}
						<a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=3'>
							{$LNG.type_mission_3}
						</a>
						{/if}
						<a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=17'>
							{$LNG.type_mission_17}
						</a>
						{if $currentPlanet.missions.10}
						<a class='hover-underline my-1 hover-pointer' href='?page=galaxy&amp;action=sendMissle&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}'>{$LNG["type_mission_10"]}</a>
						{/if}
					</div>
					</td>
				</tr>
			</table>">
				<img class="hover-border-yellow" src="{$dpath}planeten/{$currentPlanet.planet.image}.jpg" height="30" width="30" alt="">
			</a>
		</td>
		<td class="text-center align-middle" style="white-space: nowrap;">{$currentPlanet.planet.name} {$currentPlanet.lastActivity}</td>
		<td class="text-center align-middle" style="white-space: nowrap;">
			{if $currentPlanet.moon}
			<a onclick="closePopovers();" class="hover-pointer" data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			 title="<table class='table table-gow table-sm fs-11' style='width:240px'>
				 <tr>
					 <th colspan='2'>{$LNG.gl_moon} {$currentPlanet.moon.name} [{$galaxy}:{$system}:{$planet}]</th>
					 <button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button>
				 </tr>
				 {if $userAuthLevel == 3}
 				<tr>
 					<td>user ID:</td>
 					<td>{$currentPlanet['user']['id']}</td>
 				</tr>
 				<tr>
 					<td>planet ID:</td>
 					<td>{$currentPlanet['moon']['id']}</td>
 				</tr>
 				{/if}
				 <tr>
					 <td style='width:80px'>
						 <img src='{$dpath}planeten/mond.jpg' height='75' width='75'>
					 </td>
					 <td>
						 <table class='table table-gow table-sm fs-11' style='width:100%'>
							 <tr>
								 <th colspan='2'>{$LNG.gl_features}</th>
							 </tr>
							 <tr>
								 <td>{$LNG.gl_diameter}</td>
								 <td>{$currentPlanet.moon.diameter|number}</td>
							 </tr>
							 <tr>
								 <td>{$LNG.gl_temperature}</td>
								 <td>{$currentPlanet.moon.temp_min}</td>
							 </tr>
							 <tr>
								 <th colspan='2'>{$LNG.gl_actions}</th>
							 </tr>
							 <tr>
								 <td colspan='2'>
									 <div class='d-flex flex-column'>
									 {if $currentPlanet.missions.1}
									 <a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&galaxy={$galaxy}&system={$system}&planet={$planet}&planettype=3&target_mission=1'>
										 {$LNG.type_mission_1}
									 </a>
									 {/if}
									 {if $currentPlanet.missions.3}
									 <a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&galaxy={$galaxy}&system={$system}&planet={$planet}&planettype=3&target_mission=3'>
										 {$LNG.type_mission_3}
									 </a>
									 {/if}
									 {if $currentPlanet.missions.3}
									 <a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&galaxy={$galaxy}&system={$system}&planet={$planet}&planettype=3&target_mission=4'>
										 {$LNG.type_mission_4}
									 </a>
									 {/if}
									 {if $currentPlanet.missions.5}
									 <a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&galaxy={$galaxy}&system={$system}&planet={$planet}&planettype=3&target_mission=5'>
										 {$LNG.type_mission_5}
									 </a>
									 {/if}
									 {if $currentPlanet.missions.6}
									 <a class='hover-underline my-1 hover-pointer' onclick='doit(6,{$currentPlanet.moon.id});'>
										 {$LNG.type_mission_6}
									 </a>
									 {/if}
									 {if $currentPlanet.missions.9}
									 <a class='hover-underline my-1 hover-pointer' href='?page=fleetTable&galaxy={$galaxy}&system={$system}&planet={$planet}&planettype=3&target_mission=9'>
										 {$LNG.type_mission_9}
									 </a>
										{/if}
									 {if $currentPlanet.missions.10}
									 <a class='hover-underline my-1 hover-pointer' href='?page=galaxy&action=sendMissle&galaxy={$galaxy}&system={$system}&planet={$planet}&type=3'>
										 {$LNG.type_mission_10}
									 </a>
									 {/if}
								 </div>
								</td>
							</tr>
						</table>
					</td>
			</table>">
				<img class="hover-border-yellow" src="{$dpath}planeten/mond.jpg" height="22" width="22" alt="{$currentPlanet.moon.name}">
			</a>
			{/if}
		</td>
		<td class="text-center align-middle" style="white-space: nowrap;">
        {if $currentPlanet.debris}
			<a onclick="closePopovers();" class="hover-pointer" data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			 title="<table class='table table-gow fs-11' style='width:240px'>
				 <tr>
					 <th colspan='2'>{$LNG.gl_debris_field} [{$galaxy}:{$system}:{$planet}]</th>
					 <button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button>
				 </tr>
				 <tr>
					 <td style='width:80px'><img src='{$dpath}planeten/debris.jpg' height='75' style='width:75'></td>
					 <td>
						 <table style='width:100%'>
							 <tr>
								 <th colspan='2'>{$LNG.gl_resources}:</th>
							 </tr>
							 <tr>
								 <td>{$LNG.tech.901}: </td>
								 <td>{$currentPlanet.debris.metal|number}</td>
							 </tr>
							 <tr>
								 <td>{$LNG.tech.902}: </td>
								 <td>{$currentPlanet.debris.crystal|number}</td>
							 </tr>{if $currentPlanet.missions.8 and $recyclers|number > 0}<tr>
								 <th colspan='2'>{$LNG.gl_actions}</th></tr><tr><td colspan='2'>
									 <a class='hover-underline my-1 hover-pointer' onclick='doit(8, {$currentPlanet.planet.id});'>{$LNG["type_mission_8"]}</a>
								 </td>
							 </tr>
							 {/if}
						 </table>
					 </td>
				 </tr>
			 </table>">
			<img class="hover-border-yellow" src="{$dpath}planeten/debris.jpg" height="22" width="22" alt="">
			</a>
        {/if}
		</td>
		<td class="text-center align-middle">
			<a onclick="closePopovers();" class="hover-underline hover-pointer user-select-none" data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			 title="<table class='table table-gow fs-11 w-100'>
				 <tr>
					 <th colspan='2'>{$currentPlanet.user.playerrank}</th>
				 </tr>
				 {if !$currentPlanet.ownPlanet}
				 	{if $currentPlanet.user.isBuddy}
					 <tr class='text-center py-1'>
						 <td>
							 <a class='hover-underline hover-pointer user-select-none' href='#' onclick='return Dialog.Buddy({$currentPlanet.user.id})'>{$LNG.gl_buddy_request}</a>
						 </td>
					 </tr>
					 {/if}
					 <tr class='text-center py-1'>
						 <td>
							 <a class='hover-underline hover-pointer user-select-none' href='#' onclick='return Dialog.Playercard({$currentPlanet.user.id});'>{$LNG.gl_playercard}</a>
						 </td>
					 </tr>
					{/if}
					 <tr class='text-center py-1'>
						 <td>
							 <a class='hover-underline hover-pointer user-select-none' href='?page=statistics&amp;who=1&amp;start={$currentPlanet.user.rank}'>{$LNG.gl_see_on_stats}</a>
						 </td>
					 </tr>
					 <button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button>
				 </table>">
				<span class="{foreach $currentPlanet.user.class as $class}{if !$class@first} {/if}galaxy-username-{$class}{/foreach} galaxy-username">{$currentPlanet.user.username}</span>

				{if !empty($currentPlanet.user.class)}
				<span>(</span>{foreach $currentPlanet.user.class as $class}{if !$class@first}&nbsp;{/if}<span class="galaxy-short-{$class} galaxy-short">{$ShortStatus.$class}</span>{/foreach}<span>)</span>
				{/if}
			</a>
		</td>
		<td class="text-center align-middle" style="white-space: nowrap;">
			{if $currentPlanet.alliance}
			<a onclick="closePopovers();" class="hover-underline hover-pointer user-select-none" data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			 title="<table class='table table-gow fs-11 w-100 px-0'>
				 <tr>
					 <th>{$LNG.gl_alliance} {$currentPlanet.alliance.name} {$currentPlanet.alliance.member}<button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button></th>
				 </tr>
				 <tr class='text-center py-1'>
					 <td>
						 <a class='hover-underline hover-pointer' href='?page=alliance&amp;mode=info&amp;id={$currentPlanet.alliance.id}'>{$LNG.gl_alliance_page}</a>
					 </td>
				 </tr>
				 <tr class='text-center py-1'>
					 <td>
						 <a class='hover-underline hover-pointer' href='?page=statistics&amp;start={$currentPlanet.alliance.rank}&amp;who=2'>{$LNG.gl_see_on_stats}</a>
					 </td>
				 </tr>
				 {if $currentPlanet.alliance.web}
				 <tr  class='text-center py-1'>
					 <td>
						 <a class='hover-underline hover-pointer' href='{$currentPlanet.alliance.web}' target='allyweb'>{$LNG.gl_alliance_web_page}</a>
						</td>
					</tr>
					{/if}
				 </table>">
				<span class="{foreach $currentPlanet.alliance.class as $class}{if !$class@first} {/if}galaxy-alliance-{$class}{/foreach} galaxy-alliance">{$currentPlanet.alliance.tag}</span>
			</a>
			{else}-{/if}
		</td>
		<td class="text-center align-middle">
			<div class="galaxy-actions">
			{if $currentPlanet.action}
				{if $currentPlanet.action.esp}
				<a class='hover-pointer text-decoration-none' data-bs-toggle="tooltip"
				data-bs-placement="top"
				data-bs-html="true"
				title="{$LNG.gl_spy}" class='hover-underline my-1 hover-pointer' onclick="doit(6,{$currentPlanet.planet.id},{$spyShips|json|escape:'html'})">
					<span class="galaxy-action-btn" aria-hidden="true"><span>🔭</span></span>
				</a>{/if}
				{if $currentPlanet.action.message}
				<a class='hover-pointer text-decoration-none' data-bs-toggle="tooltip"
				data-bs-placement="top"
				data-bs-html="true"
				title="{$LNG.write_message}" onclick="return Dialog.PM({$currentPlanet.user.id})">
					<span class="galaxy-action-btn" aria-hidden="true"><span>✉</span></span>
				</a>{/if}
				{if $currentPlanet.action.buddy}
        <a class='hover-pointer text-decoration-none' data-bs-toggle="tooltip"
				data-bs-placement="top"
				data-bs-html="true"
				title="{$LNG.gl_buddy_request}" onclick="return Dialog.Buddy({$currentPlanet.user.id})">
					<span class="galaxy-action-btn" aria-hidden="true"><span>🤝</span></span>
				</a>
				{/if}
				{if $currentPlanet.action.missle}
				<a data-bs-toggle="tooltip"
				data-bs-placement="top"
				data-bs-html="true"
				title="{$LNG.gl_missile_attack}" class='hover-pointer text-decoration-none' href="?page=galaxy&amp;action=sendMissle&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;type=1">
					<span class="galaxy-action-btn" aria-hidden="true"><span>🚀</span></span>
				</a>
				{/if}

			{/if}
			{if $currentPlanet.planet.phalanx}
			<a data-bs-toggle="tooltip"
			data-bs-placement="top"
			data-bs-html="true"
			title="{$LNG.gl_phalanx}" class='hover-pointer text-decoration-none' onclick="OpenPopup('?page=phalanx&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1','',640,510);return false;">
				<span class="galaxy-action-btn" aria-hidden="true"><span>📡</span></span>
			</a>
			{/if}
			</div>
		</td>
	{/if}
	</tr>
	{/for}
	<tr>
		<td class="text-center align-middle">{$max_planets + 1}</td>
		<td class="text-center align-middle" colspan="7"><a href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 1}&amp;planettype=1&amp;target_mission=15">{$LNG.gl_out_space}</a></td>
	</tr>
	<tr>
		<td class="text-center align-middle">Commerce</td>
		<td class="text-center align-middle" colspan="7"><a href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 2}&amp;planettype=1&amp;target_mission=16">{$LNG.gl_trade_space}</a></td>
	</tr>

	<tr>
		<td class="text-center align-middle" colspan="6">({$planetcount})</td>
		<td colspan="2">
			<a data-bs-toggle="popover"
			data-bs-placement="right"
			data-bs-html="true"
			data-bs-custom-class="galaxy-popover"
			 title="<table class='table table-gow fs-11' style='width:240px'><tr><th colspan='2'>{$LNG.gl_legend}<button type='button' class='galaxy-popover-close' aria-label='Fermer'>&times;</button></th></tr><tr><td style='width:220px'>{$LNG.gl_strong_player}</td><td><span class='galaxy-short-strong'>{$LNG.gl_short_strong}</span></td></tr><tr><td style='width:220px'>{$LNG.gl_week_player}</td><td><span class='galaxy-short-noob'>{$LNG.gl_short_newbie}</span></td></tr><tr><td style='width:220px'>{$LNG.gl_vacation}</td><td><span class='galaxy-short-vacation'>{$LNG.gl_short_vacation}</span></td></tr><tr><td style='width:220px'>{$LNG.gl_banned}</td><td><span class='galaxy-short-banned'>{$LNG.gl_short_ban}</span></td></tr><tr><td style='width:220px'>{$LNG.gl_inactive_seven}</td><td><span class='galaxy-short-inactive'>{$LNG.gl_short_inactive}</span></td></tr><tr><td style='width:220px'>{$LNG.gl_inactive_twentyeight}</td><td><span class='galaxy-short-longinactive'>{$LNG.gl_short_long_inactive}</span></td></tr></table>">{$LNG.gl_legend}</a>
		</td>
	</tr>
	<tr>
		<td colspan="4"><span id="missiles">{$currentmip|number}</span> {$LNG.gl_avaible_missiles}</td>
		<td colspan="4"><span id="slots">{$maxfleetcount}</span>/{$fleetmax} {$LNG.gl_fleets}</td>
	</tr>
	<tr>
		<td colspan="4">
			<span id="elementID210">{$spyprobes|number}</span> {$LNG.gl_avaible_spyprobes}
		</td>
		<td colspan="4">
			<span id="elementID209">{$recyclers|number}</span> {$LNG.gl_avaible_recyclers}
		</td>
	</tr>
	<tr style="display:none;" id="fleetstatusrow">
		<th class="text-center" colspan="8">{$LNG.cff_fleet_target}</th>
	</tr>
	</table>
	<script type="text/javascript">
		status_ok		= '{$LNG.gl_ajax_status_ok}';
		status_fail		= '{$LNG.gl_ajax_status_fail}';
		MaxFleetSetting = {$settings_fleetactions};
	</script>
		</div>
	</details>
</div>
{/block}
