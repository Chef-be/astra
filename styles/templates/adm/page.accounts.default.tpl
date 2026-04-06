{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-mini-hero mb-4">
		<h2 class="h3">Éditeur de comptes</h2>
		<p>Accédez aux outils de modification par domaine fonctionnel. Les raccourcis utilisent des visuels du jeu pour rendre l’action plus lisible.</p>
	</div>

	<div class="admin-feature-grid">
		{foreach from=$accountEditorModules item=module}
			<a class="admin-feature-card" href="{$module.url}">
				<div class="admin-feature-card__media">
					<img src="{$module.image}" alt="{$module.label|escape:'html'}">
				</div>
				<div class="admin-feature-card__title">{$module.label}</div>
				<div class="admin-feature-card__description">{$module.description}</div>
				<div class="admin-feature-card__foot">Ouvrir le module</div>
			</a>
		{/foreach}
	</div>
</div>
{/block}
