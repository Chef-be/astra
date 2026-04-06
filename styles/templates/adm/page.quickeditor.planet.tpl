{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Édition rapide</span>
			<h1 class="admin-hero__title">Planète #{$planetId}</h1>
			<p class="admin-hero__subtitle">Ajustez la planète, ses ressources, ses bâtiments, ses flottes et ses défenses depuis une vue condensée mais lisible.</p>
		</div>
	</section>

	<form method="post" id="userform" action="admin.php?page=quickEditor&amp;mode=planetSend&amp;id={$planetId}" class="admin-stack">
		<div class="admin-table-shell">
			<div class="admin-form-grid">
				<div class="admin-field-card"><span>{$LNG.qe_id}</span><strong>{$planetId}</strong></div>
				<label class="admin-field-card"><span>{$LNG.qe_planetname}</span><input class="form-control bg-dark text-white border-secondary" name="name" type="text" value="{$name}"></label>
				<div class="admin-field-card"><span>{$LNG.qe_coords}</span><strong>[{$galaxy}:{$system}:{$planet}]</strong></div>
				<div class="admin-field-card"><span>{$LNG.qe_owner}</span><strong>{$ownername} ({$LNG.qe_id}: {$ownerid})</strong></div>
				<label class="admin-field-card"><span>{$LNG.qe_fields}</span><input class="form-control bg-dark text-white border-secondary" name="field_max" type="text" value="{$field_max}"></label>
				<div class="admin-field-card"><span>{$LNG.qe_temp}</span><strong>{$temp_min} / {$temp_max}</strong></div>
			</div>
		</div>

		<div class="admin-table-shell">
			<div class="admin-media-grid">
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/901.gif" alt="{$LNG.tech.901}">
					<strong>{$LNG.tech.901}</strong>
					<span>Actuel : {$metal_c}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="metal" type="text" value="{$metal}">
				</label>
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/902.gif" alt="{$LNG.tech.902}">
					<strong>{$LNG.tech.902}</strong>
					<span>Actuel : {$crystal_c}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="crystal" type="text" value="{$crystal}">
				</label>
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/903.gif" alt="{$LNG.tech.903}">
					<strong>{$LNG.tech.903}</strong>
					<span>Actuel : {$deuterium_c}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="deuterium" type="text" value="{$deuterium}">
				</label>
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div><h2 class="h5 mb-1">{$LNG.qe_build}</h2></div>
			<div class="admin-media-grid">
				{foreach item=Element from=$build}
					<label class="admin-media-tile">
						<img src="{$Element.image}" alt="{$Element.name|escape:'html'}">
						<strong>{$Element.name}</strong>
						<span>Actuel : {$Element.count}</span>
						<input class="form-control bg-dark text-white border-secondary text-center" name="{$Element.type}" type="text" value="{$Element.input}">
					</label>
				{/foreach}
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div><h2 class="h5 mb-1">{$LNG.qe_fleet}</h2></div>
			<div class="admin-media-grid">
				{foreach item=Element from=$fleet}
					<label class="admin-media-tile">
						<img src="{$Element.image}" alt="{$Element.name|escape:'html'}">
						<strong>{$Element.name}</strong>
						<span>Actuel : {$Element.count}</span>
						<input class="form-control bg-dark text-white border-secondary text-center" name="{$Element.type}" type="text" value="{$Element.input}">
					</label>
				{/foreach}
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div><h2 class="h5 mb-1">{$LNG.qe_defensive}</h2></div>
			<div class="admin-media-grid">
				{foreach item=Element from=$defense}
					<label class="admin-media-tile">
						<img src="{$Element.image}" alt="{$Element.name|escape:'html'}">
						<strong>{$Element.name}</strong>
						<span>Actuel : {$Element.count}</span>
						<input class="form-control bg-dark text-white border-secondary text-center" name="{$Element.type}" type="text" value="{$Element.input}">
					</label>
				{/foreach}
			</div>
		</div>

		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.qe_submit}</button>
			<button type="reset" class="btn btn-outline-light">{$LNG.qe_reset}</button>
		</div>
	</form>
</div>
{/block}
