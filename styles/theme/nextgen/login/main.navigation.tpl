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
						{if $menuItem.id == 'index' || $menuItem.id == 'register' || $menuItem.id == 'news'}
						<li class="menu-item">
							<a class="uk-preserve-width {if $page == $menuItem.id || ($menuItem.id == 'index' && $page == '')}uk-active{/if}" href="{$menuItem.url}">{$menuItem.title}</a>
						</li>
						{/if}
					{/foreach}
					{if count($publicMenuItems) > 3}
						<li class="menu-item dropdown public-nav-more">
							<a class="uk-preserve-width dropdown-toggle" href="#" id="publicMoreMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">Découvrir</a>
							<ul class="dropdown-menu dropdown-menu-dark public-nav-dropdown" aria-labelledby="publicMoreMenu">
								{foreach $publicMenuItems as $menuItem}
									{if $menuItem.id != 'index' && $menuItem.id != 'register' && $menuItem.id != 'news'}
									<li><a class="dropdown-item {if $page == $menuItem.id}active{/if}" href="{$menuItem.url}">{$menuItem.title}</a></li>
									{/if}
								{/foreach}
							</ul>
						</li>
					{/if}
					{if $discordEnabled}
						<li class="menu-item">
							<a class="uk-preserve-width" href="{$discordUrl}" target="_blank" rel="noopener"><img src="styles/theme/nextgen/img/social/discord-mark-white.svg" width="30px" alt="Discord"></a>
						</li>
					{/if}
					
				</ul>

				<i class="bi bi-list d-flex d-md-none px-3 text-white fs-2 menu_icon" data-bs-toggle="offcanvas" data-bs-target="#phoneMenu"></i>
				
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
