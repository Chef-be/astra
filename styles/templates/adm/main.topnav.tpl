<script>
$(function() {
	$('.js-admin-universe').on('change', function() {
		var url = new URL(window.location.href);
		url.searchParams.set('uni', $(this).val());
		window.location.href = url.toString();
	});

	$('.js-admin-quickjump').on('change', function() {
		if ($(this).val()) {
			window.location.href = $(this).val();
		}
	});

	$('.js-admin-density-toggle').on('click', function() {
		$('body').toggleClass('admin-density-compact');
		localStorage.setItem('astra-admin-density', $('body').hasClass('admin-density-compact') ? 'compact' : 'comfortable');
	});

	if (localStorage.getItem('astra-admin-density') === 'compact') {
		$('body').addClass('admin-density-compact');
	}
});
</script>

{capture name="adminTopbarTools"}
	<select class="form-select admin-topbar__select admin-topbar__select--jump js-admin-quickjump">
		<option value="">Aller vers une page…</option>
		{foreach from=$adminNavigation item=section}
			<optgroup label="{$section.label}">
				{foreach from=$section.items item=menuItem}
					<option value="{$menuItem.url}" {if $currentPage == $menuItem.page}selected{/if}>{$menuItem.label}</option>
				{/foreach}
			</optgroup>
		{/foreach}
	</select>

	{if $authlevel == $smarty.const.AUTH_ADM}
		<select class="form-select admin-topbar__select admin-topbar__select--uni js-admin-universe">
			{html_options options=$AvailableUnis selected=$UNI}
		</select>
	{/if}

	<button class="admin-icon-button js-admin-density-toggle" type="button" aria-label="Basculer la densité d’affichage">
		<i class="bi bi-arrows-collapse"></i>
	</button>

	<a href="admin.php?page=overview" class="admin-topbar__link admin-topbar__link--ghost">Vue d’ensemble</a>
	<a href="index.php" target="_blank" rel="noopener" class="admin-topbar__link admin-topbar__link--ghost">Site public</a>
	{if $id == 1}
		<a href="?page=reset&amp;sid={$sid}" class="admin-topbar__link admin-topbar__link--warning">Réinitialiser</a>
	{/if}
	<a href="javascript:top.location.href='game.php';" target="_top" class="admin-topbar__link admin-topbar__link--danger">Retour au jeu</a>
{/capture}

<div class="admin-topbar">
	<div class="admin-topbar__group admin-topbar__group--primary">
		<button id="adminSidebarToggle" class="admin-icon-button" type="button" aria-label="Réduire ou ouvrir le menu latéral">
			<i class="bi bi-layout-sidebar-inset"></i>
		</button>
		<div class="admin-topbar__headline">
			<span class="admin-topbar__kicker">Centre d’exploitation</span>
			<strong class="admin-topbar__title">{$currentPageMeta.title|default:$LNG.adm_cp_title}</strong>
			<span class="admin-topbar__subtitle">{$currentPageMeta.description|default:$LNG.adm_cp_title}</span>
		</div>
	</div>

	<div class="admin-topbar__group admin-topbar__group--tools admin-topbar__group--desktop">
		{$smarty.capture.adminTopbarTools nofilter}
	</div>

	<details class="admin-topbar__mobile-tools">
		<summary class="admin-topbar__mobile-summary">
			<span>Actions rapides</span>
			<span class="admin-pill">Navigation</span>
		</summary>
		<div class="admin-topbar__mobile-panel">
			<div class="admin-topbar__group admin-topbar__group--tools admin-topbar__group--mobile">
				{$smarty.capture.adminTopbarTools nofilter}
			</div>
		</div>
	</details>
</div>
