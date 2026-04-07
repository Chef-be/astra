{block name="content"}

<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Joueurs humains</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.humanUsers}</strong>
			<span class="admin-kpi-card__meta">Bots : {$dashboard.game.botsTotal}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Joueurs actifs</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.activePlayers}</strong>
			<span class="admin-kpi-card__meta">{$dashboard.game.activePlayersPercent}% des joueurs humains</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Bots connectés</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.activeBots}</strong>
			<span class="admin-kpi-card__meta">{$dashboard.game.activeBotsPercent}% du parc bots</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Sessions actives</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.sessionsActive}</strong>
			<span class="admin-kpi-card__meta">Fenêtre des 15 dernières minutes</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Flottes en vol</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.fleetsFlying}</strong>
			<span class="admin-kpi-card__meta">Planètes : {$dashboard.game.planetsTotal}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Tickets ouverts</span>
			<strong class="admin-kpi-card__value">{$dashboard.game.ticketsOpen}</strong>
			<span class="admin-kpi-card__meta">Inscriptions 24h : {$dashboard.game.registrations24}</span>
		</article>
	</section>

	<section class="admin-overview-grid">
		<div class="admin-card">
			<div class="card-body admin-stack">
				<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
					<div>
						<h2 class="h4 mb-1">Exploitation en cours</h2>
						<p class="text-white-50 mb-0">Vue synthétique pour décider vite sans ouvrir cinq pages différentes.</p>
					</div>
					<span class="admin-pill">Mis à jour {$dashboard.generatedAt}</span>
				</div>

				<div class="admin-fact-grid">
					<div class="admin-fact-card">
						<span class="admin-fact-card__label">Univers</span>
						<strong class="admin-fact-card__value">{$dashboard.game.universe}</strong>
					</div>
					<div class="admin-fact-card">
						<span class="admin-fact-card__label">Univers disponibles</span>
						<strong class="admin-fact-card__value">{$dashboard.game.universesTotal}</strong>
					</div>
					<div class="admin-fact-card">
						<span class="admin-fact-card__label">Actualités publiées</span>
						<strong class="admin-fact-card__value">{$dashboard.game.newsTotal}</strong>
					</div>
					<div class="admin-fact-card">
						<span class="admin-fact-card__label">Cache applicatif</span>
						<strong class="admin-fact-card__value">{$dashboard.system.cacheSizeHuman}</strong>
					</div>
				</div>

				<div class="admin-panel-grid">
					<div class="admin-panel-grid__wide">
						<div class="admin-card h-100">
							<div class="card-body">
								<h3 class="h5 mb-3">Raccourcis d’exploitation</h3>
								<div class="admin-quick-links">
									<a class="admin-shortcut" href="?page=server">
										<span class="admin-shortcut__icon"><i class="bi bi-hdd-network"></i></span>
										<span class="admin-shortcut__content">
											<strong>Configuration serveur</strong>
											<span>Réglages globaux, identité, SMTP, sécurité, analytics.</span>
										</span>
									</a>
									<a class="admin-shortcut" href="?page=universe">
										<span class="admin-shortcut__icon"><i class="bi bi-globe2"></i></span>
										<span class="admin-shortcut__content">
											<strong>Configuration d’univers</strong>
											<span>Équilibrage, paramètres gameplay et règles structurelles.</span>
										</span>
									</a>
									<a class="admin-shortcut" href="?page=supervision">
										<span class="admin-shortcut__icon"><i class="bi bi-activity"></i></span>
										<span class="admin-shortcut__content">
											<strong>Supervision détaillée</strong>
											<span>Ressources hôte, Docker, Redis, cache et visibilité technique.</span>
										</span>
									</a>
									<a class="admin-shortcut" href="?page=bots">
										<span class="admin-shortcut__icon"><i class="bi bi-robot"></i></span>
										<span class="admin-shortcut__content">
											<strong>Pilotage des bots</strong>
											<span>Présence continue, campagnes, hiérarchie et conformité bots.</span>
										</span>
									</a>
								</div>
							</div>
						</div>
					</div>

					<div class="admin-panel-grid__side">
						<div class="admin-card h-100">
							<div class="card-body">
								<h3 class="h5 mb-3">Alertes immédiates</h3>
								<div class="admin-flag-list">
									{foreach from=$dashboard.alerts item=alert}
										<div class="admin-flag admin-flag--{$alert.level}">{$alert.message}</div>
									{/foreach}
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="admin-card">
			<div class="card-body admin-stack">
				<div>
					<h2 class="h4 mb-1">Santé de la plateforme</h2>
					<p class="text-white-50 mb-0">Les signaux clés à garder sous les yeux pendant l’exploitation.</p>
				</div>
				<div class="admin-status-list">
					<div class="admin-status-row">
						<span>Charge système</span>
						<strong>{$dashboard.system.loadAverage.one} / {$dashboard.system.loadAverage.five} / {$dashboard.system.loadAverage.fifteen}</strong>
					</div>
					<div class="admin-status-row">
						<span>Mémoire hôte</span>
						<strong>{$dashboard.system.memory.usedHuman} / {$dashboard.system.memory.totalHuman}</strong>
					</div>
					<div class="admin-status-row">
						<span>Espace disque</span>
						<strong>{$dashboard.system.disk.usedHuman} / {$dashboard.system.disk.totalHuman}</strong>
					</div>
					<div class="admin-status-row">
						<span>Redis</span>
						<strong>{if $dashboard.system.redis.available}{$dashboard.system.redis.usedMemoryHuman}{else}Indisponible{/if}</strong>
					</div>
					<div class="admin-status-row">
						<span>Docker Astra</span>
						<strong>{if $dashboard.docker.available && $dashboard.docker.astraDetected}{$dashboard.docker.servicesTotal} service(s){elseif $dashboard.docker.available}Aucun service Astra détecté{else}Indisponible{/if}</strong>
					</div>
				</div>
				<div class="admin-summary-list">
					<div class="admin-summary-row">
						<span>Hôte</span>
						<strong>{$dashboard.system.hostName}</strong>
					</div>
					<div class="admin-summary-row">
						<span>PHP</span>
						<strong>{$dashboard.system.phpVersion}</strong>
					</div>
					<div class="admin-summary-row">
						<span>Version jeu</span>
						<strong>{$dashboard.system.appVersion}</strong>
					</div>
				</div>
			</div>
		</div>
	</section>

	<details class="admin-fold admin-fold--compact">
		<summary class="admin-fold__summary">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Organisation de l’administration</h2>
					<p class="text-white-50 mb-0">Chaque bloc regroupe les pages par logique d’exploitation réelle pour éviter les allers-retours inutiles.</p>
				</div>
				<span class="admin-pill">{$adminNavigation|@count} espaces disponibles</span>
			</div>
		</summary>
		<div class="admin-fold__body">
			<div class="admin-overview-grid admin-overview-grid--sections">
				{foreach from=$adminNavigation item=section}
					<a class="admin-section-card" href="{$section.items[0].url|default:'admin.php?page=overview'}">
						<div class="admin-section-card__top">
							<div>
								<div class="admin-section-card__label">{$section.label}</div>
								<div class="admin-section-card__description">{$section.description}</div>
							</div>
							<span class="admin-section-card__icon"><i class="bi {$section.icon}"></i></span>
						</div>
						<div class="admin-section-card__links">
							{foreach from=$section.items item=sectionItem name=sectionPreview}
								{if $smarty.foreach.sectionPreview.iteration <= 3}
									<div class="admin-section-card__link">
										<i class="bi {$sectionItem.icon|default:'bi-dot'}"></i>
										<span>{$sectionItem.label}</span>
									</div>
								{/if}
							{/foreach}
						</div>
						<div class="admin-section-card__foot">
							<span>{$section.count} page(s)</span>
							<span>Ouvrir</span>
						</div>
					</a>
				{/foreach}
			</div>
		</div>
	</details>
</div>

{/block}
