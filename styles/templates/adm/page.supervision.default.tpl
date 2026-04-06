{block name="content"}
<div class="container-fluid py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Supervision</h1>
			<p class="text-white-50 mb-0">Vue détaillée des ressources hôte, Docker, cache applicatif et Redis.</p>
		</div>
		<div class="d-flex flex-wrap gap-2">
			<a class="btn btn-outline-light btn-sm" href="?page=overview">Tableau de bord</a>
			<a class="btn btn-warning btn-sm" href="?page=clearCache">Pilotage du cache</a>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Hôte</h2>
					<div class="d-flex justify-content-between small mb-2"><span>Charge</span><span>{$dashboard.system.loadAverage.one} / {$dashboard.system.loadAverage.five} / {$dashboard.system.loadAverage.fifteen}</span></div>
					<div class="d-flex justify-content-between small mb-2"><span>Mémoire</span><span>{$dashboard.system.memory.usedHuman} / {$dashboard.system.memory.totalHuman}</span></div>
					<div class="progress mt-2 mb-3" style="height:8px;"><div class="progress-bar bg-danger" style="width: {$dashboard.system.memory.percent}%"></div></div>
					<div class="d-flex justify-content-between small mb-2"><span>Disque</span><span>{$dashboard.system.disk.usedHuman} / {$dashboard.system.disk.totalHuman}</span></div>
					<div class="progress mt-2" style="height:8px;"><div class="progress-bar bg-warning" style="width: {$dashboard.system.disk.percent}%"></div></div>
				</div>
			</div>
		</div>
		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Cache applicatif</h2>
					<div class="d-flex justify-content-between small mb-2"><span>Fichiers</span><span>{$cacheSnapshot.filesystem.files}</span></div>
					<div class="d-flex justify-content-between small mb-3"><span>Taille</span><span>{$cacheSnapshot.filesystem.sizeHuman}</span></div>
					<div class="small text-white-50 mb-3">Écriture : {if $cacheSnapshot.filesystem.cacheWritable}oui{else}non{/if}</div>
					<a class="btn btn-outline-warning btn-sm" href="?page=clearCache">Ouvrir le pilotage du cache</a>
				</div>
			</div>
		</div>
		<div class="col-12 col-lg-4">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Redis</h2>
					{if $cacheSnapshot.redis.available}
						<div class="d-flex justify-content-between small mb-2"><span>Version</span><span>{$cacheSnapshot.redis.version}</span></div>
						<div class="d-flex justify-content-between small mb-2"><span>Clés</span><span>{$cacheSnapshot.redis.dbSize}</span></div>
						<div class="d-flex justify-content-between small mb-2"><span>Mémoire</span><span>{$cacheSnapshot.redis.usedMemoryHuman}</span></div>
						<div class="d-flex justify-content-between small mb-2"><span>Clients</span><span>{$cacheSnapshot.redis.clients}</span></div>
						<div class="d-flex justify-content-between small mb-2"><span>Disponibilité</span><span>{$cacheSnapshot.redis.uptimeHuman}</span></div>
						<div class="progress mt-2" style="height:8px;"><div class="progress-bar bg-info" style="width: {$cacheSnapshot.redis.memoryPercent}%"></div></div>
					{else}
						<div class="alert alert-secondary mb-0">{$cacheSnapshot.redis.error|default:'Redis indisponible.'}</div>
					{/if}
				</div>
			</div>
		</div>
	</div>

	<div class="card bg-dark border-secondary">
		<div class="card-body">
			<h2 class="h5 mb-3">Conteneurs Docker Astra</h2>
			{if $dashboard.docker.available && $dashboard.docker.astraDetected}
				<div class="row g-3">
					{foreach from=$dashboard.docker.astraServices item=service}
						<div class="col-12 col-lg-6 col-xl-4">
							<div class="border border-secondary rounded p-3 h-100">
								<div class="d-flex justify-content-between align-items-center mb-2">
									<div class="fw-bold">{$service.name}</div>
									<span class="badge {if $service.healthy}bg-success{elseif $service.running}bg-warning text-dark{else}bg-secondary{/if}">{$service.status}</span>
								</div>
								<div class="small text-white-50">{$service.image}</div>
							</div>
						</div>
					{/foreach}
				</div>
			{else}
				<div class="alert alert-secondary mb-0">Docker Astra n’est pas encore exploitable depuis cette page.</div>
			{/if}
		</div>
	</div>
</div>
{/block}
