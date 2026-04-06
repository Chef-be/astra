{include file="main.header.tpl" bodyclass="full"}

<div class="container-fluid px-0">
	<div class="row g-0">
		<div class="col-12 col-xl-auto">
			{include file="main.navigation.tpl" bodyclass="full"}
		</div>
		<div class="col">
			<div class="row g-0 bg-black py-3 topnav sticky-top" style="z-index:1040;">
				{include file="main.topnav.tpl" bodyclass="full"}
			</div>
			<div class="content px-2 px-lg-3">
				<div class="admin-hero my-3">
					<div class="admin-hero__content">
						<div class="admin-hero__eyebrow">{$adminSectionLabel}</div>
						<h1 class="admin-hero__title">{$currentPageMeta.title}</h1>
						<p class="admin-hero__description">{$currentPageMeta.description}</p>
					</div>
					<div class="admin-hero__meta">
						<div class="admin-hero__chip">Univers {$UNI}</div>
						<div class="admin-hero__chip">Assistance {$supportticks|default:0}</div>
					</div>
				</div>
				{if $adminTabs|@count > 0}
					<div class="admin-tabs mb-3">
						{foreach from=$adminTabs item=adminTab}
							<a href="{$adminTab.url}" class="admin-tab {if $adminTab.active}is-active{/if}">{$adminTab.label}</a>
						{/foreach}
					</div>
				{/if}
				{block name="content"}{/block}
			</div>
		</div>
	</div>
	<div class="row g-0">
		{include file="overall_footer.tpl" bodyclass="full"}
	</div>
</div>
</body>
</html>
