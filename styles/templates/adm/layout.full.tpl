{include file="main.header.tpl" bodyclass="full"}

<div class="bridge-layout">
	<div class="bridge-drawer">
		<div class="bridge-drawer__backdrop"></div>
		<div class="bridge-drawer__panel">
			{include file="main.navigation.tpl" bodyclass="full"}
		</div>
	</div>

	<div class="bridge-shell">
		<header class="bridge-topbar">
			{include file="main.topnav.tpl" bodyclass="full"}
		</header>

		<main class="bridge-main">
			<section class="bridge-headline">
				<div class="bridge-headline__lead">
					<div class="bridge-headline__path">
						{if !empty($currentPageMeta.icon)}<i class="bi {$currentPageMeta.icon}"></i>{/if}
						<a href="admin.php?page=overview" class="bridge-headline__crumb">Administration</a>
						<i class="bi bi-chevron-right"></i>
						<a href="{$adminSectionUrl}" class="bridge-headline__crumb">{$adminSectionLabel}</a>
						<i class="bi bi-chevron-right"></i>
						<a href="{$adminCurrentUrl}" class="bridge-headline__crumb is-current">{$currentPageMeta.title}</a>
						{if !empty($currentPageMeta.description)}
							<button
								class="bridge-headline__hint"
								type="button"
								data-bs-toggle="tooltip"
								data-bs-placement="bottom"
								title="{$currentPageMeta.description|escape:'html'}"
								aria-label="Aide sur la page"
							>?</button>
						{/if}
					</div>
					<h1 class="bridge-headline__title">{$currentPageMeta.title}</h1>
				</div>

				<div class="bridge-headline__facts">
					<span class="bridge-chip">Univers {$UNI}</span>
					<a href="admin.php?page=support" class="bridge-chip" title="Ouvrir le support">Tickets {$supportticks|default:0}</a>
					<span class="bridge-chip">{$adminTabs|@count} onglet(s)</span>
				</div>
			</section>

			{if $adminTabs|@count > 0 || !empty($currentPageMeta.actions)}
				<section class="bridge-commandbar">
					{if $adminTabs|@count > 0}
						<nav class="bridge-tabs" aria-label="Navigation locale">
							{foreach from=$adminTabs item=adminTab}
								<a href="{$adminTab.url}" class="bridge-tab {if $adminTab.active}is-active{/if}">
									<i class="bi {$adminTab.icon|default:'bi-dot'}"></i>
									<span>{$adminTab.label}</span>
								</a>
							{/foreach}
						</nav>
					{/if}

					{if !empty($currentPageMeta.actions)}
						<div class="bridge-actions">
							{foreach from=$currentPageMeta.actions item=pageAction}
								<a href="{$pageAction.url}" class="bridge-actionchip bridge-actionchip--{$pageAction.tone|default:'light'}">{$pageAction.label}</a>
							{/foreach}
						</div>
					{/if}
				</section>
			{/if}

			<section class="bridge-content">
				{block name="content"}{/block}
			</section>
		</main>
	</div>

	<div class="bridge-footer">
		{include file="overall_footer.tpl" bodyclass="full"}
	</div>
</div>
</body>
</html>
