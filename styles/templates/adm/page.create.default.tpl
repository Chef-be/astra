{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Création assistée</h2>
					<p class="text-white-50 mb-0">Sélectionnez le bon assistant selon l’objet à créer, sans repasser par des menus secondaires ni des formulaires ambigus.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=accounts">Éditeur de comptes</a>
					<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=search">Trouver un joueur</a>
				</div>
			</div>

			<div class="admin-fact-grid">
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Assistants</span>
					<strong class="admin-fact-card__value">3</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Compte</span>
					<strong class="admin-fact-card__value">Joueur + planète mère</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Planète</span>
					<strong class="admin-fact-card__value">Ajout ciblé</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Lune</span>
					<strong class="admin-fact-card__value">Rattachement direct</strong>
				</div>
			</div>
		</div>
	</section>

	<section class="admin-feature-grid">
		<a class="admin-feature-card" href="?page=create&mode=user">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/gebaeude/902.gif" alt="Créer un compte">
			</div>
			<div class="admin-feature-card__title">Créer un compte</div>
			<div class="admin-feature-card__description">Assistant complet pour générer un joueur, sa planète d’origine et ses paramètres de base.</div>
			<div class="admin-feature-card__foot">Ouvrir l’assistant</div>
		</a>
		<a class="admin-feature-card" href="?page=create&mode=planet">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/planeten/small/s_normaltempplanet04.jpg" alt="Créer une planète">
			</div>
			<div class="admin-feature-card__title">Créer une planète</div>
			<div class="admin-feature-card__description">Ajoutez rapidement une planète supplémentaire sur un compte existant, avec coordonnées contrôlées.</div>
			<div class="admin-feature-card__foot">Ouvrir l’assistant</div>
		</a>
		<a class="admin-feature-card" href="?page=create&mode=moon">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/planeten/mond_small.webp" alt="Créer une lune">
			</div>
			<div class="admin-feature-card__title">Créer une lune</div>
			<div class="admin-feature-card__description">Rattachez une lune à une planète existante avec diamètre défini manuellement ou calculé automatiquement.</div>
			<div class="admin-feature-card__foot">Ouvrir l’assistant</div>
		</a>
	</section>
</div>
{/block}
