{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Édition rapide</span>
			<h2>Joueur #{$targetID}</h2>
		</div>
	</section>

	<form method="post" id="userform" action="admin.php?page=quickEditor&amp;mode=playerSend&amp;id={$targetID}" class="admin-stack">
		<div class="admin-table-shell admin-stack">
			<div class="admin-form-grid">
				<div class="admin-field-card"><span>{$LNG.qe_id}</span><strong>{$targetID}</strong></div>
				<label class="admin-field-card"><span>{$LNG.qe_username}</span><input class="form-control bg-dark text-white border-secondary" name="name" type="text" value="{$name}" autocomplete="off"></label>
				<div class="admin-field-card"><span>{$LNG.qe_hpcoords}</span><strong>{$planetname} [{$galaxy}:{$system}:{$planet}] ({$LNG.qe_id}: {$planetid})</strong></div>
				{if $authlevel != $smarty.const.AUTH_USER}
					<label class="admin-field-card"><span>{$LNG.qe_authattack}</span><input class="form-check-input mt-2" type="checkbox" name="authattack"{if $authattack != 0} checked{/if}></label>
				{/if}
				{if $ChangePW}
					<label class="admin-field-card"><span>{$LNG.qe_password}</span><input id="password" class="form-control bg-dark text-white border-secondary" name="password" type="password" autocomplete="off" placeholder="{$LNG.qe_change}"></label>
					<label class="admin-field-card"><span>{$LNG.qe_allowmulti}</span>{html_options class="form-select bg-dark text-white border-secondary" name="multi" options=$yesorno selected=$multi}</label>
				{/if}
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div class="admin-media-grid">
				<label class="admin-media-tile">
					<img src="./styles/theme/nextgen/gebaeude/921.gif" alt="{$LNG.tech.921}">
					<strong>{$LNG.tech.921}</strong>
					<span>Actuel : {$darkmatter_c}</span>
					<input class="form-control bg-dark text-white border-secondary text-center" name="darkmatter" type="text" value="{$darkmatter}">
				</label>
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div>
				<h2 class="h5 mb-1">{$LNG.qe_tech}</h2>
			</div>
			<div class="admin-media-grid">
				{foreach item=Element from=$tech}
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
			<div>
				<h2 class="h5 mb-1">{$LNG.qe_officier}</h2>
			</div>
			<div class="admin-media-grid">
				{foreach item=Element from=$officier}
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
