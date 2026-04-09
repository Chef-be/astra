{block name="content"}
<div class="container-fluid py-4 text-white admin-stack admin-accounts-page">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Éditeur de comptes</span>
			<h2>Éditeur de comptes</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">{$accountEditorModules|@count} modules</span>
			<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=search">Trouver un joueur</a>
			<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=create">Créer un compte</a>
		</div>
	</section>

	<section class="admin-feature-grid">
		{foreach from=$accountEditorModules item=module}
			<a class="admin-feature-card" href="{$module.url}">
				<div class="admin-feature-card__media">
					<img src="{$module.image}" alt="{$module.label|escape:'html'}">
				</div>
				<div class="admin-feature-card__title">{$module.label}</div>
				<div class="admin-feature-card__description">{$module.description}</div>
				<div class="admin-feature-card__foot">Ouvrir</div>
			</a>
		{/foreach}
	</section>
</div>
{/block}
