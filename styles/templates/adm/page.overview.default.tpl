{block name="content"}

<div class="container-fluid py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Tableau de bord</h1>
			<p class="text-white-50 mb-0">Supervision de l’univers {$dashboard.game.universe} et état technique de l’instance.</p>
		</div>
		<div class="d-flex flex-wrap gap-2">
			<a class="btn btn-outline-light btn-sm" href="?page=server">Configuration serveur</a>
			<a class="btn btn-outline-light btn-sm" href="?page=universe">Configuration de l’univers</a>
			<a class="btn btn-outline-light btn-sm" href="?page=supervision">Supervision détaillée</a>
			<a class="btn btn-outline-light btn-sm" href="?page=public">Contenu public</a>
			<a class="btn btn-outline-light btn-sm" href="?page=bots">Gestion des bots</a>
			<a class="btn btn-warning btn-sm" href="?page=clearCache">Pilotage du cache</a>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-xl-8">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<h2 class="h5 mb-0">Indicateurs de jeu</h2>
						<span class="badge bg-primary">Mis à jour {$dashboard.generatedAt}</span>
					</div>
					<div class="row g-3">
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Joueurs humains</div>
								<div class="fs-4 fw-bold">{$dashboard.game.humanUsers}</div>
								<div class="small text-white-50">Bots: {$dashboard.game.botsTotal}</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Joueurs actifs</div>
								<div class="fs-4 fw-bold">{$dashboard.game.activePlayers}</div>
								<div class="progress mt-2" style="height:8px;">
									<div class="progress-bar bg-success" role="progressbar" style="width: {$dashboard.game.activePlayersPercent}%"></div>
								</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Bots connectés</div>
								<div class="fs-4 fw-bold">{$dashboard.game.activeBots}</div>
								<div class="progress mt-2" style="height:8px;">
									<div class="progress-bar bg-info" role="progressbar" style="width: {$dashboard.game.activeBotsPercent}%"></div>
								</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Sessions actives</div>
								<div class="fs-4 fw-bold">{$dashboard.game.sessionsActive}</div>
								<div class="small text-white-50">15 dernières minutes</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Planètes</div>
								<div class="fs-4 fw-bold">{$dashboard.game.planetsTotal}</div>
								<div class="small text-white-50">Tous comptes confondus</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Flottes en vol</div>
								<div class="fs-4 fw-bold">{$dashboard.game.fleetsFlying}</div>
								<div class="small text-white-50">Missions en cours</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Tickets ouverts</div>
								<div class="fs-4 fw-bold">{$dashboard.game.ticketsOpen}</div>
								<div class="small text-white-50">Support à traiter</div>
							</div>
						</div>
						<div class="col-6 col-md-3">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="text-white-50 small">Inscriptions 24h</div>
								<div class="fs-4 fw-bold">{$dashboard.game.registrations24}</div>
								<div class="small text-white-50">Actualités: {$dashboard.game.newsTotal}</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 col-xl-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Alertes techniques</h2>
					<div class="d-flex flex-column gap-2">
						{foreach from=$dashboard.alerts item=alert}
							<div class="alert alert-{$alert.level} mb-0 py-2 px-3">{$alert.message}</div>
						{/foreach}
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Ressources système</h2>
					<div class="mb-3">
						<div class="d-flex justify-content-between small text-white-50">
							<span>Charge système</span>
							<span>{$dashboard.system.loadAverage.one} / {$dashboard.system.loadAverage.five} / {$dashboard.system.loadAverage.fifteen}</span>
						</div>
					</div>
					<div class="mb-3">
						<div class="d-flex justify-content-between small">
							<span>Mémoire hôte</span>
							<span>{$dashboard.system.memory.usedHuman} / {$dashboard.system.memory.totalHuman}</span>
						</div>
						<div class="progress mt-2" style="height:8px;">
							<div class="progress-bar bg-danger" role="progressbar" style="width: {$dashboard.system.memory.percent}%"></div>
						</div>
						<div class="small text-white-50 mt-1">Disponible: {$dashboard.system.memory.availableHuman}</div>
					</div>
					<div class="mb-0">
						<div class="d-flex justify-content-between small">
							<span>Espace disque</span>
							<span>{$dashboard.system.disk.usedHuman} / {$dashboard.system.disk.totalHuman}</span>
						</div>
						<div class="progress mt-2" style="height:8px;">
							<div class="progress-bar bg-warning" role="progressbar" style="width: {$dashboard.system.disk.percent}%"></div>
						</div>
						<div class="small text-white-50 mt-1">Libre: {$dashboard.system.disk.freeHuman}</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Application</h2>
					<ul class="list-group list-group-flush">
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Hôte</span>
							<span>{$dashboard.system.hostName}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Version PHP</span>
							<span>{$dashboard.system.phpVersion}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Version du jeu</span>
							<span>{$dashboard.system.appVersion}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Univers disponibles</span>
							<span>{$dashboard.game.universesTotal}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Fichiers de cache</span>
							<span>{$dashboard.system.cacheFiles}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Taille du cache</span>
							<span>{$dashboard.system.cacheSizeHuman}</span>
						</li>
						<li class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
							<span>Redis</span>
							<span>{if $dashboard.system.redis.available}{$dashboard.system.redis.usedMemoryHuman}{else}indisponible{/if}</span>
						</li>
					</ul>
					<div class="mt-3 d-grid gap-2">
						<a class="btn btn-outline-warning btn-sm" href="?page=clearCache">Ouvrir le pilotage du cache</a>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Docker</h2>
					<p class="text-white-50 mb-3">{$dashboard.docker.statusMessage}</p>
					<div class="border border-secondary rounded p-3 mb-3">
						<div class="text-white-50 small">Conteneurs du stack Astra</div>
						<div class="fs-4 fw-bold">{$dashboard.docker.servicesTotal}</div>
					</div>
					{if $dashboard.docker.available}
						{if $dashboard.docker.astraDetected}
							<div class="small text-uppercase text-white-50 mb-2">Services Astra</div>
							<div class="d-flex flex-column gap-2">
								{foreach from=$dashboard.docker.astraServices item=service}
									<div class="border border-secondary rounded px-3 py-2 d-flex justify-content-between align-items-center">
										<div>
											<div class="fw-bold">{$service.name}</div>
											<div class="small text-white-50">{$service.image}</div>
										</div>
										<span class="badge {if $service.healthy}bg-success{elseif $service.running}bg-warning text-dark{else}bg-secondary{/if}">{$service.status}</span>
									</div>
								{/foreach}
							</div>
						{else}
							<div class="alert alert-secondary mb-0">Aucun conteneur Astra n’a été trouvé. Les autres conteneurs de l’hôte ne sont pas affichés ici.</div>
						{/if}
					{else}
						<div class="alert alert-secondary mb-0">La supervision Docker sera disponible dès que le relais Docker sera accessible depuis l’application.</div>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

{/block}
