<script>
$(function() {
	function filterAdminNav() {
		var value = ($('#adminNavSearch').val() || '').toLowerCase();
		var visible = 0;

		$('#menu [data-menu-item]').each(function() {
			var haystack = ($(this).data('keywords') || $(this).text() || '').toLowerCase();
			var matches = value.length === 0 || haystack.indexOf(value) !== -1;
			$(this).toggleClass('d-none', !matches);
			if (matches) {
				visible++;
			}
		});

		$('#menu .menu-section').each(function() {
			var visibleItems = $(this).find('[data-menu-item]:not(.d-none)').length;
			$(this).toggleClass('d-none', visibleItems === 0);
			if (value.length > 0 && visibleItems > 0) {
				$(this).find('.accordion-collapse').addClass('show');
				$(this).find('.accordion-button').removeClass('collapsed');
			}
		});

		$('#adminNavSearchCount').text(visible);
	}

	$('#adminNavSearch').on('keyup change', filterAdminNav);
	$('#adminNavSearchClear').on('click', function() {
		$('#adminNavSearch').val('');
		filterAdminNav();
	});

	$('#adminSidebarToggle').on('click', function() {
		$('body').toggleClass('admin-sidebar-collapsed');
		localStorage.setItem('astra-admin-sidebar-collapsed', $('body').hasClass('admin-sidebar-collapsed') ? '1' : '0');
	});

	if (localStorage.getItem('astra-admin-sidebar-collapsed') === '1') {
		$('body').addClass('admin-sidebar-collapsed');
	}
});
</script>

<nav id="leftmenu" class="admin-sidebar">
	<div class="admin-sidebar__sticky">
		<a href="admin.php?page=overview" class="admin-sidebar__brand text-decoration-none">
			{if $brandLogoUrl}
				<div class="admin-brandmark">
					<img src="{$brandLogoUrl}" alt="{$title|escape:'html'}" class="admin-brandmark__image">
				</div>
			{/if}
			<div class="admin-sidebar__brand-text">
				<strong>{$gameName|default:'Astra Dominion'}</strong>
				<span>Administration centrale</span>
			</div>
		</a>

		<div class="admin-sidebar__search">
			<div class="admin-searchbox">
				<i class="bi bi-search"></i>
				<input id="adminNavSearch" type="text" placeholder="Trouver une page, un module, un outil…">
				<button id="adminNavSearchClear" type="button" aria-label="Effacer la recherche">
					<i class="bi bi-x-lg"></i>
				</button>
			</div>
			<div class="admin-sidebar__microcopy">
				<span>{$adminSectionLabel}</span>
				<span><strong id="adminNavSearchCount">{$adminNavigationFlat|@count}</strong> entrées visibles</span>
			</div>
		</div>

		<div class="admin-sidebar__context">
			<div class="admin-context-card">
				<span class="admin-context-card__label">Univers actif</span>
				<strong class="admin-context-card__value">{$UNI}</strong>
			</div>
			<div class="admin-context-card">
				<span class="admin-context-card__label">Tickets ouverts</span>
				<strong class="admin-context-card__value">{$supportticks|default:0}</strong>
			</div>
		</div>

		<div id="menu" class="accordion accordion-flush admin-nav-accordion">
			{foreach from=$adminNavigation item=section}
				<div class="accordion-item bg-transparent border-0 menu-section">
					<h2 class="accordion-header" id="heading-{$section.key}">
						<button class="accordion-button {if $adminSectionLabel != $section.label}collapsed{/if}" type="button" data-bs-toggle="collapse" data-bs-target="#section-{$section.key}">
							<span class="admin-section-trigger__icon"><i class="bi {$section.icon}"></i></span>
							<span class="admin-section-trigger__content">
								<span class="admin-section-trigger__label">{$section.label}</span>
								<span class="admin-section-trigger__description">{$section.description}</span>
							</span>
							<span class="admin-section-trigger__count">{$section.count}</span>
						</button>
					</h2>
					<div id="section-{$section.key}" class="accordion-collapse collapse {if $adminSectionLabel == $section.label}show{/if}">
						<div class="accordion-body">
							<ul class="list-unstyled m-0 admin-nav-list">
								{foreach from=$section.items item=menuItem}
									<li data-menu-item data-keywords="{$section.label} {$menuItem.label}" class="{if $currentPage == $menuItem.page}menu-active{/if}">
										<a class="admin-nav-link" href="{$menuItem.url}">
											<span class="admin-nav-link__icon"><i class="bi {$menuItem.icon|default:'bi-dot'}"></i></span>
											<span class="admin-nav-link__text">{$menuItem.label}</span>
											{if $menuItem.page == 'support' && isset($supportticks) && $supportticks > 0}
												<span class="admin-nav-link__badge">{$supportticks}</span>
											{/if}
										</a>
									</li>
								{/foreach}
							</ul>
						</div>
					</div>
				</div>
			{/foreach}
		</div>
	</div>
</nav>
