<script>
$(function() {
	function filterBridgeNav() {
		var value = ($('#bridgeNavSearch').val() || '').toLowerCase();
		var visible = 0;

		$('#bridgeMenu [data-menu-item]').each(function() {
			var haystack = ($(this).data('keywords') || $(this).text() || '').toLowerCase();
			var matches = value.length === 0 || haystack.indexOf(value) !== -1;
			$(this).toggleClass('d-none', !matches);
			if (matches) {
				visible++;
			}
		});

		$('#bridgeMenu .menu-section').each(function() {
			var visibleItems = $(this).find('[data-menu-item]:not(.d-none)').length;
			$(this).toggleClass('d-none', visibleItems === 0);
		});

		$('#bridgeNavSearchCount').text(visible);
	}

	$('#bridgeNavSearch').on('keyup change', filterBridgeNav);
	$('#bridgeNavSearchClear').on('click', function() {
		$('#bridgeNavSearch').val('');
		filterBridgeNav();
	});

	$('#bridgeCloseNav').on('click', function() {
		$('body').removeClass('bridge-nav-open');
	});

	$('.bridge-nav__link').on('click', function() {
		$('body').removeClass('bridge-nav-open');
	});
});
</script>

<nav class="bridge-nav">
	<div class="bridge-nav__head">
		<a href="admin.php?page=overview" class="bridge-nav__brand" title="Retour au tableau de bord">
			{if $brandLogoUrl}
				<div class="bridge-nav__logo">
					<img src="{$brandLogoUrl}" alt="{$gameName|escape:'html'}">
				</div>
			{/if}
			<div class="bridge-nav__brand-copy">
				<strong>{$gameName|default:'Astra Dominion'}</strong>
				<span>Palette de commandes</span>
			</div>
		</a>
		<button id="bridgeCloseNav" class="bridge-nav__close" type="button" aria-label="Fermer">
			<i class="bi bi-x-lg"></i>
		</button>
	</div>

	<div class="bridge-nav__search">
		<div class="bridge-nav__searchbox">
			<i class="bi bi-search"></i>
			<input id="bridgeNavSearch" type="text" placeholder="Trouver une page ou un réglage">
			<button id="bridgeNavSearchClear" type="button" aria-label="Effacer">
				<i class="bi bi-x-lg"></i>
			</button>
		</div>
		<div class="bridge-nav__meta">
			<span>{$adminSectionLabel}</span>
			<span><strong id="bridgeNavSearchCount">{$adminNavigationFlat|@count}</strong> entrées</span>
		</div>
	</div>

	<div class="bridge-nav__summary">
		<span class="bridge-nav__token">Univers {$UNI}</span>
		<span class="bridge-nav__token">{$supportticks|default:0} ticket(s)</span>
		<span class="bridge-nav__token">{$adminTabs|@count} onglet(s)</span>
	</div>

	<div id="bridgeMenu" class="bridge-nav__sections">
		{foreach from=$adminNavigation item=section}
			<section class="bridge-nav-section menu-section">
				<div class="bridge-nav-section__head" title="{$section.description|escape:'html'}">
					<div class="bridge-nav-section__title">
						<i class="bi {$section.icon}"></i>
						<div>
							<strong>{$section.label}</strong>
						</div>
					</div>
					<em>{$section.count}</em>
				</div>

				<div class="bridge-nav-section__links">
					{foreach from=$section.items item=menuItem}
						<a class="bridge-nav__link {if $currentPage == $menuItem.page}is-active{/if}" href="{$menuItem.url}" data-menu-item data-keywords="{$section.label} {$menuItem.label}">
							<i class="bi {$menuItem.icon|default:'bi-dot'}"></i>
							<span>{$menuItem.label}</span>
							{if $menuItem.page == 'support' && isset($supportticks) && $supportticks > 0}
								<small>{$supportticks}</small>
							{/if}
						</a>
					{/foreach}
				</div>
			</section>
		{/foreach}
	</div>
</nav>
