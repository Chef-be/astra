{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Centre des journaux</h2>
					<p class="text-white-50 mb-0">Isolez vite le bon flux d’audit selon la cible modifiée, au lieu de fouiller tout l’historique d’administration.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=overview">Vue d’ensemble</a>
					<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=supervision">Supervision</a>
				</div>
			</div>

			<div class="admin-fact-grid">
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Flux disponibles</span>
					<strong class="admin-fact-card__value">4</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">But</span>
					<strong class="admin-fact-card__value">Audit ciblé</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Lecture</span>
					<strong class="admin-fact-card__value">Par domaine</strong>
				</div>
				<div class="admin-fact-card">
					<span class="admin-fact-card__label">Usage</span>
					<strong class="admin-fact-card__value">Support et traçabilité</strong>
				</div>
			</div>
		</div>
	</section>

	<section class="admin-feature-grid">
		<a class="admin-feature-card" href="?page=log&mode=planet">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/planeten/small/s_normaltempplanet04.jpg" alt="Journaux planétaires">
			</div>
			<div class="admin-feature-card__title">Journal planétaire</div>
			<div class="admin-feature-card__description">Édits sur planètes, lunes, coordonnées et états associés au monde.</div>
			<div class="admin-feature-card__foot">Ouvrir le journal</div>
		</a>
		<a class="admin-feature-card" href="?page=log&mode=player">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/gebaeude/902.gif" alt="Journaux joueurs">
			</div>
			<div class="admin-feature-card__title">Journal joueur</div>
			<div class="admin-feature-card__description">Modifications de comptes, attributs, ressources et états individuels.</div>
			<div class="admin-feature-card__foot">Ouvrir le journal</div>
		</a>
		<a class="admin-feature-card" href="?page=log&mode=settings">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/gebaeude/108.gif" alt="Journaux de configuration">
			</div>
			<div class="admin-feature-card__title">Journal de configuration</div>
			<div class="admin-feature-card__description">Historique des changements serveur, univers, chat et paramètres d’exploitation.</div>
			<div class="admin-feature-card__foot">Ouvrir le journal</div>
		</a>
		<a class="admin-feature-card" href="?page=log&mode=present">
			<div class="admin-feature-card__media">
				<img src="./styles/theme/nextgen/gebaeude/121.gif" alt="Journaux de distributions">
			</div>
			<div class="admin-feature-card__title">Journal des distributions</div>
			<div class="admin-feature-card__description">Traçabilité des cadeaux, crédits et opérations globales de diffusion.</div>
			<div class="admin-feature-card__foot">Ouvrir le journal</div>
		</a>
	</section>
</div>
{/block}
