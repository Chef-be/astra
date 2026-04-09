{block name="content"}
<div class="admin-settings-shell text-white admin-stack admin-supervision-page">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Charge 1 min</span>
			<strong class="admin-kpi-card__value">{$dashboard.system.loadAverage.one}</strong>
			<span class="admin-kpi-card__meta">5 min : {$dashboard.system.loadAverage.five}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Mémoire utilisée</span>
			<strong class="admin-kpi-card__value">{$dashboard.system.memory.percent}%</strong>
			<span class="admin-kpi-card__meta">{$dashboard.system.memory.usedHuman}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Disque utilisé</span>
			<strong class="admin-kpi-card__value">{$dashboard.system.disk.percent}%</strong>
			<span class="admin-kpi-card__meta">{$dashboard.system.disk.usedHuman}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Cache fichiers</span>
			<strong class="admin-kpi-card__value">{$cacheSnapshot.filesystem.files}</strong>
			<span class="admin-kpi-card__meta">{$cacheSnapshot.filesystem.sizeHuman}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Redis</span>
			<strong class="admin-kpi-card__value">{if $cacheSnapshot.redis.available}{$cacheSnapshot.redis.dbSize}{else}0{/if}</strong>
			<span class="admin-kpi-card__meta">{if $cacheSnapshot.redis.available}{$cacheSnapshot.redis.usedMemoryHuman}{else}Indisponible{/if}</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Docker Astra</span>
			<strong class="admin-kpi-card__value">{$dashboard.docker.servicesTotal}</strong>
			<span class="admin-kpi-card__meta">{if $dashboard.docker.available}services détectés{else}supervision indisponible{/if}</span>
		</article>
	</section>

	<section class="admin-panel-grid">
		<div class="admin-panel-grid__wide admin-stack">
			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
						<div>
							<h2 class="h5 mb-0">Capacité système et conteneurs</h2>
						</div>
						<span class="admin-pill">Infra</span>
					</div>
				</summary>
				<div class="admin-fold__body admin-stack">
					<div class="admin-card">
						<div class="card-body">
							<h2 class="h5 mb-2">Capacité système</h2>
							<div class="admin-summary-list">
								<div class="admin-summary-row">
									<span>Mémoire hôte</span>
									<strong>{$dashboard.system.memory.usedHuman} / {$dashboard.system.memory.totalHuman}</strong>
								</div>
								<div class="progress mt-2" style="height:10px;">
									<div class="progress-bar bg-danger" role="progressbar" style="width: {$dashboard.system.memory.percent}%"></div>
								</div>
								<div class="admin-summary-row">
									<span>Disque</span>
									<strong>{$dashboard.system.disk.usedHuman} / {$dashboard.system.disk.totalHuman}</strong>
								</div>
								<div class="progress mt-2" style="height:10px;">
									<div class="progress-bar bg-warning" role="progressbar" style="width: {$dashboard.system.disk.percent}%"></div>
								</div>
							</div>
						</div>
					</div>

					<div class="admin-card">
						<div class="card-body">
							<h2 class="h5 mb-2">Conteneurs Astra</h2>
							{if $dashboard.docker.available && $dashboard.docker.astraDetected}
								<div class="row g-3">
									{foreach from=$dashboard.docker.astraServices item=service}
										<div class="col-12 col-md-6 col-xl-4">
											<div class="admin-fact-card h-100">
												<div class="d-flex justify-content-between align-items-start gap-2">
													<div>
														<div class="admin-fact-card__label">{$service.image}</div>
														<strong class="admin-fact-card__value">{$service.name}</strong>
													</div>
													<span class="badge {if $service.healthy}admin-badge-success{elseif $service.running}admin-badge-warning{else}admin-badge-danger{/if}">{$service.status}</span>
												</div>
											</div>
										</div>
									{/foreach}
								</div>
							{else}
								<div class="admin-empty-state">Docker Astra n’est pas encore exploitable depuis cette page.</div>
							{/if}
						</div>
					</div>
				</div>
			</details>
		</div>

		<div class="admin-panel-grid__side admin-stack">
			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
						<div>
							<h2 class="h5 mb-0">Cache et Redis</h2>
						</div>
						<span class="admin-pill">Cache</span>
					</div>
				</summary>
				<div class="admin-fold__body admin-stack">
					<div class="admin-card">
						<div class="card-body">
							<h2 class="h5 mb-2">Cache applicatif</h2>
							<div class="admin-status-list">
								<div class="admin-status-row">
									<span>Fichiers</span>
									<strong>{$cacheSnapshot.filesystem.files}</strong>
								</div>
								<div class="admin-status-row">
									<span>Taille</span>
									<strong>{$cacheSnapshot.filesystem.sizeHuman}</strong>
								</div>
								<div class="admin-status-row">
									<span>Écriture</span>
									<strong>{if $cacheSnapshot.filesystem.cacheWritable}Oui{else}Non{/if}</strong>
								</div>
							</div>
							<div class="mt-3 d-grid">
								<a class="admin-shell-action admin-shell-action--warning" href="?page=clearCache">Ouvrir le pilotage du cache</a>
							</div>
						</div>
					</div>

					<div class="admin-card">
						<div class="card-body">
							<h2 class="h5 mb-2">Redis</h2>
							{if $cacheSnapshot.redis.available}
								<div class="admin-status-list">
									<div class="admin-status-row">
										<span>Version</span>
										<strong>{$cacheSnapshot.redis.version}</strong>
									</div>
									<div class="admin-status-row">
										<span>Clés</span>
										<strong>{$cacheSnapshot.redis.dbSize}</strong>
									</div>
									<div class="admin-status-row">
										<span>Mémoire</span>
										<strong>{$cacheSnapshot.redis.usedMemoryHuman}</strong>
									</div>
									<div class="admin-status-row">
										<span>Clients</span>
										<strong>{$cacheSnapshot.redis.clients}</strong>
									</div>
								</div>
							{else}
								<div class="admin-empty-state">{$cacheSnapshot.redis.error|default:'Redis indisponible.'}</div>
							{/if}
						</div>
					</div>
				</div>
			</details>
		</div>
	</section>
</div>
{/block}
