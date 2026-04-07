{include file="main.header.tpl" bodyclass="full"}

<div class="admin-shell">
	<aside class="admin-shell__sidebar">
		{include file="main.navigation.tpl" bodyclass="full"}
	</aside>
	<div class="admin-shell__main">
		<div class="admin-shell__topbar">
			{include file="main.topnav.tpl" bodyclass="full"}
		</div>
		<main class="content admin-shell__content px-2 px-lg-4">
			<section class="admin-hero admin-hero--shell my-3">
				<div class="admin-hero__content">
					<div class="admin-hero__eyebrow">
						{if !empty($currentPageMeta.icon)}<i class="bi {$currentPageMeta.icon}"></i>{/if}
						<span>{$adminSectionLabel}</span>
					</div>
					<h1 class="admin-hero__title">{$currentPageMeta.title}</h1>
					<p class="admin-hero__description">{$currentPageMeta.description}</p>
				</div>
				<div class="admin-hero__aside">
					<div class="admin-hero__meta">
						<div class="admin-hero__chip">Univers <strong>{$UNI}</strong></div>
						<div class="admin-hero__chip">Tickets <strong>{$supportticks|default:0}</strong></div>
						<div class="admin-hero__chip">Page <strong>{$currentPageMeta.title}</strong></div>
					</div>
					{if !empty($currentPageMeta.actions)}
						<div class="admin-hero__actions">
							{foreach from=$currentPageMeta.actions item=heroAction}
								<a href="{$heroAction.url}" class="admin-shell-action admin-shell-action--{$heroAction.tone|default:'light'}">{$heroAction.label}</a>
							{/foreach}
						</div>
					{/if}
				</div>
			</section>
			{if $adminTabs|@count > 0}
				<nav class="admin-tabs mb-3" aria-label="Navigation locale">
					{foreach from=$adminTabs item=adminTab}
						<a href="{$adminTab.url}" class="admin-tab {if $adminTab.active}is-active{/if}">
							<i class="bi {$adminTab.icon|default:'bi-dot'}"></i>
							<span>{$adminTab.label}</span>
						</a>
					{/foreach}
				</nav>
			{/if}
			{block name="content"}{/block}
		</main>
		<div class="admin-shell__footer">
			{include file="overall_footer.tpl" bodyclass="full"}
		</div>
	</div>
</div>
</body>
</html>
