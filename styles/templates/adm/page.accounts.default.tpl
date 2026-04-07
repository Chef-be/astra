{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Éditeur de comptes</h2>
					<p class="text-white-50 mb-0">Chaque module cible une zone précise du compte pour éviter les erreurs et limiter le bruit visuel.</p>
				</div>
				<div class="admin-cluster">
					<span class="admin-pill">{$accountEditorModules|@count} modules</span>
					<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=search">Trouver un joueur</a>
					<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=create">Créer un compte</a>
				</div>
			</div>

			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
						<div>
							<h3 class="h5 mb-1">Repères d’édition</h3>
							<p class="text-white-50 mb-0">Contexte d’usage et garde-fous, repliés par défaut sur petit écran.</p>
						</div>
						<span class="admin-pill">Guide rapide</span>
					</div>
				</summary>
				<div class="admin-fold__body">
					<div class="admin-fact-grid">
						<div class="admin-fact-card">
							<span class="admin-fact-card__label">Parcours conseillé</span>
							<strong class="admin-fact-card__value">Recherche → compte → module</strong>
						</div>
						<div class="admin-fact-card">
							<span class="admin-fact-card__label">Usage</span>
							<strong class="admin-fact-card__value">Intervention ciblée</strong>
						</div>
						<div class="admin-fact-card">
							<span class="admin-fact-card__label">Sécurité</span>
							<strong class="admin-fact-card__value">Édition par domaine</strong>
						</div>
						<div class="admin-fact-card">
							<span class="admin-fact-card__label">Objectif</span>
							<strong class="admin-fact-card__value">Moins d’erreurs, plus vite</strong>
						</div>
					</div>
				</div>
			</details>
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
				<div class="admin-feature-card__foot">Ouvrir le module</div>
			</a>
		{/foreach}
	</section>
</div>
{/block}
