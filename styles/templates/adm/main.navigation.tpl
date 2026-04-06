
<script>
$(document).ready(function(){
  $("#searchInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#menu [data-menu-item]").each(function() {
      var matches = $(this).text().toLowerCase().indexOf(value) > -1;
      $(this).toggleClass('d-none', !matches);
    });

    $("#menu .menu-section").each(function() {
      var visibleItems = $(this).find("[data-menu-item]:not(.d-none)").length;
      $(this).toggleClass('d-none', visibleItems === 0);
      if (value.length > 0 && visibleItems > 0) {
        $(this).find(".accordion-collapse").addClass("show");
      }
    });
  });
});
</script>

<div id="leftmenu" class="bg-black text-white border-end border-secondary" style="min-height:100vh;">
	<div class="sticky-top p-3">
		<div class="adm-logo text-center mb-3">
			<a href="admin.php?page=overview" class="text-decoration-none text-white d-inline-flex flex-column align-items-center">
				{if $brandLogoUrl}
					<div class="admin-brandmark mb-2">
						<img src="{$brandLogoUrl}" alt="{$title|escape:'html'}" class="admin-brandmark__image">
					</div>
				{/if}
				<div class="fs-4 fw-bold">{$gameName|default:'Astra Dominion'}</div>
				<div class="text-secondary small">Centre de pilotage</div>
			</a>
		</div>
		<input class="bg-dark text-white py-2 my-1 form-control border-secondary" id="searchInput" type="text" placeholder="Rechercher dans l’administration…">
		<div id="menu" class="accordion accordion-flush mt-3">
			{foreach from=$adminNavigation item=section}
				<div class="accordion-item bg-transparent border-secondary menu-section">
					<h2 class="accordion-header" id="heading-{$section.key}">
						<button class="accordion-button bg-transparent text-white {if $adminSectionLabel != $section.label}collapsed{/if} px-0" type="button" data-bs-toggle="collapse" data-bs-target="#section-{$section.key}">
							<i class="bi {$section.icon} me-2"></i>{$section.label}
						</button>
					</h2>
					<div id="section-{$section.key}" class="accordion-collapse collapse {if $adminSectionLabel == $section.label}show{/if}">
						<div class="accordion-body px-0 pt-2 pb-0">
							<ul class="list-unstyled d-flex flex-column gap-1 m-0">
								{foreach from=$section.items item=menuItem}
									<li data-menu-item class="{if $currentPage == $menuItem.page}menu-active{/if}">
										<a class="d-flex w-100 p-2 rounded text-decoration-none text-white" href="{$menuItem.url}">
											<span>{$menuItem.label}</span>
											{if $menuItem.page == 'support' && isset($supportticks) && $supportticks > 0}
												<span class="badge bg-danger ms-auto">{$supportticks}</span>
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
</div>
