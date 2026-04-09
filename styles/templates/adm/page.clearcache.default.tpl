{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Cache</span>
			<h2>Gestion du cache</h2>
		</div>
		<div class="admin-headerline__actions">
			<a class="admin-shell-action admin-shell-action--light" href="?page=supervision">Supervision</a>
			<a class="admin-shell-action admin-shell-action--light" href="?page=overview">Tableau de bord</a>
		</div>
	</section>

	<section class="admin-kpi-grid admin-kpi-grid--cache">
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Fichiers de cache</span>
			<strong class="admin-kpi-card__value">{$cacheSnapshot.filesystem.files}</strong>
			<span class="admin-kpi-card__meta">Volume : {$cacheSnapshot.filesystem.sizeHuman}</span>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Écriture</span>
			<strong class="admin-kpi-card__value">{if $cacheSnapshot.filesystem.cacheWritable}Oui{else}Non{/if}</strong>
			<span class="admin-kpi-card__meta">Accès au dossier applicatif</span>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Clés Redis</span>
			<strong class="admin-kpi-card__value">{if $cacheSnapshot.redis.available}{$cacheSnapshot.redis.dbSize}{else}0{/if}</strong>
			<span class="admin-kpi-card__meta">{if $cacheSnapshot.redis.available}{$cacheSnapshot.redis.usedMemoryHuman}{else}Redis indisponible{/if}</span>
		</article>
	</section>

	<section class="row g-3">
			<div class="col-12 col-lg-6">
				<div class="admin-card h-100">
					<div class="admin-card__body">
						<h2 class="h6 mb-3">Cache applicatif</h2>
					<div class="d-flex justify-content-between small mb-2">
						<span>Fichiers détectés</span>
						<span>{$cacheSnapshot.filesystem.files}</span>
					</div>
					<div class="d-flex justify-content-between small mb-3">
						<span>Taille estimée</span>
						<span>{$cacheSnapshot.filesystem.sizeHuman}</span>
					</div>
					<form action="?page=clearCache&mode=run" method="post">
						<input type="hidden" name="scope" value="filesystem">
						<button class="btn btn-warning" type="submit">Purger le cache applicatif</button>
					</form>
				</div>
			</div>
		</div>
			<div class="col-12 col-lg-6">
				<div class="admin-card h-100">
					<div class="admin-card__body">
						<h2 class="h6 mb-3">Redis</h2>
					{if $cacheSnapshot.redis.available}
						<div class="d-flex justify-content-between small mb-2">
							<span>Clés en base</span>
							<span>{$cacheSnapshot.redis.dbSize}</span>
						</div>
						<div class="d-flex justify-content-between small mb-2">
							<span>Mémoire utilisée</span>
							<span>{$cacheSnapshot.redis.usedMemoryHuman}</span>
						</div>
						<div class="d-flex justify-content-between small mb-3">
							<span>Clients connectés</span>
							<span>{$cacheSnapshot.redis.clients}</span>
						</div>
						<form action="?page=clearCache&mode=run" method="post">
							<input type="hidden" name="scope" value="redis">
							<button class="btn btn-outline-warning" type="submit">Purger Redis</button>
						</form>
					{else}
						<div class="alert alert-secondary mb-0">Redis indisponible : {$cacheSnapshot.redis.error|default:'erreur inconnue'}</div>
					{/if}
				</div>
			</div>
		</div>
	</section>

	<section class="admin-card">
		<div class="admin-card__body">
			<h2 class="h6 mb-3">Purge complète</h2>
			<form action="?page=clearCache&mode=run" method="post">
				<input type="hidden" name="scope" value="all">
				<button class="btn btn-danger" type="submit" onclick="return confirm('Confirmer la purge complète du cache applicatif et de Redis ?');">Purger tous les caches</button>
			</form>
		</div>
	</section>
</div>
{/block}
