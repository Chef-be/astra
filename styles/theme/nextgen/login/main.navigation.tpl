<header>
	<div class="dark-blur-bg menu-container box-shadow-large">
		<div class="uk-container">
		
		<nav id="navbar" class="uk-navbar">
			<div class="uk-navbar-left">
				<a class="brand-title text-decoration-none text-white fw-bold fs-3 d-flex align-items-center gap-3" href="index.php?page=index">
					{if $brandLogoUrl}
						<img src="{$brandLogoUrl}" alt="{$gameName}" style="max-height:54px;width:auto;">
					{else}
						{$gameName}
					{/if}
				</a>
			</div>
				<div class="uk-navbar-right">
				<ul class="uk-navbar-nav">
					{foreach $publicMenuItems as $menuItem}
						<li class="menu-item">
							<a class="uk-preserve-width {if $page == $menuItem.id || ($menuItem.id == 'index' && $page == '')}uk-active{/if}" href="{$menuItem.url}">{$menuItem.title}</a>
						</li>
					{/foreach}
					{if $discordEnabled}
						<li class="menu-item">
							<a class="uk-preserve-width" href="{$discordUrl}" target="_blank" rel="noopener"><img src="styles/theme/nextgen/img/social/discord-mark-white.svg" width="30px" alt="Discord"></a>
						</li>
					{/if}
					
				</ul>

				{if count($languages) > 1}
				<i class="bi bi-list d-flex d-md-none px-3 text-white fs-2 menu_icon" data-bs-toggle="offcanvas" data-bs-target="#phoneMenu"></i>

				<div class="dropdown">
				<button style="width:120px;height:32px;" class="btn btn-secondary dropdown-toggle p-1 menu-item justify-content-center" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown">
					Langue
				</button>
				<ul style="width:auto;" class="dropdown-menu flex-column bg-dark p-0" aria-labelledby="dropdownMenuButton1">
						{foreach $languages as $langKey => $langName}
						<li class="d-flex w-100">
								<a class="text-decoration-none hover-bg-color-grey menu-item w-100 px-2" href="?lang={$langKey}" rel="alternate" hreflang="{$langKey}" title="{$langName}">
									<img src="styles/theme/nextgen/img/lang/{$langKey}.svg" class="lang-flag">
									<span class="">{$langName}</span>
								</a>
							</li>
						{/foreach}
				</ul>
				</div>
			
				{/if}
				
				</div>
				
			</nav>
		</div>
	</div>

	<div class="offcanvas offcanvas-start dark-blur-bg box-shadow" id="phoneMenu">
	  <div class="offcanvas-header">
	    <span class="offcanvas-title fs-2">
	    	{if $brandLogoUrl}
	    		<img src="{$brandLogoUrl}" alt="{$gameName}" style="max-height:48px;width:auto;">
	    	{else}
	    		{$gameName}
	    	{/if}
	    </span>
	    <button type="button" class="btn-close btn-close-white" aria-label="Close" data-bs-dismiss="offcanvas"></button>
	  </div>
	  <div class="offcanvas-body p-0" >

	    <ul style="list-style:none;" class="main-menu p-0 m-0" p-0 m-0">
					{foreach $publicMenuItems as $menuItem}
						<li class="menu-item">
		  				<a class="fs-6 w-100 hover-color-yellow text-decoration-none py-2 border-light {if $page == $menuItem.id || ($menuItem.id == 'index' && $page == '')}active{/if}" href="{$menuItem.url}">{$menuItem.title}</a>
		  			</li>
					{/foreach}
					{if $discordEnabled}
						<li class="menu-item">
							<a class="fs-6 w-100 hover-color-yellow text-decoration-none py-2 border-light" href="{$discordUrl}" target="_blank" rel="noopener">Discord</a>
						</li>
					{/if}
	      </ul>
	  </div>
	</div>

</header>
<div class="uk-container">
