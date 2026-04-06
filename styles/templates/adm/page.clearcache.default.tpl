{block name="content"}
<div class="container-fluid py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Pilotage du cache</h1>
			<p class="text-white-50 mb-0">Purge du cache applicatif fichier, du cache Redis et contrôle rapide de l’état courant.</p>
		</div>
		<a class="btn btn-outline-light btn-sm" href="?page=supervision">Retour à la supervision</a>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-lg-6">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Cache applicatif</h2>
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
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Redis</h2>
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
	</div>

	<div class="card bg-dark border-secondary">
		<div class="card-body">
			<h2 class="h5 mb-3">Purge complète</h2>
			<p class="text-white-50">Cette action vide le cache applicatif, les templates compilés et Redis.</p>
			<form action="?page=clearCache&mode=run" method="post">
				<input type="hidden" name="scope" value="all">
				<button class="btn btn-danger" type="submit" onclick="return confirm('Confirmer la purge complète du cache applicatif et de Redis ?');">Purger tous les caches</button>
			</form>
		</div>
	</div>
</div>
{/block}
