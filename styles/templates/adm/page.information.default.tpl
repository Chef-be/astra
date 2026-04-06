{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Diagnostic</span>
			<h1 class="admin-hero__title">Informations techniques</h1>
			<p class="admin-hero__subtitle">Consolidez rapidement les versions, extensions PHP, fuseaux horaires, journaux et informations d’exécution utiles au support.</p>
		</div>
	</section>

	<div class="admin-split">
		<div class="admin-table-shell admin-stack">
			<div>
				<h2 class="h5 mb-1">Plateforme et serveur</h2>
				<p class="text-white-50 mb-0">Environnement d’exécution actuellement détecté.</p>
			</div>
			<div class="admin-stat-strip">
				<div class="admin-stat-card">
					<span class="admin-stat-card__label">PHP</span>
					<strong class="admin-stat-card__value">{$vPHP}</strong>
				</div>
				<div class="admin-stat-card">
					<span class="admin-stat-card__label">MySQL client</span>
					<strong class="admin-stat-card__value">{$vMySQLc}</strong>
				</div>
				<div class="admin-stat-card">
					<span class="admin-stat-card__label">Base</span>
					<strong class="admin-stat-card__value">{$dbVersion}</strong>
				</div>
			</div>
			<div class="admin-stack small">
				<div class="admin-pill">Serveur : {$info}</div>
				<div class="admin-pill">API PHP : {$vAPI}</div>
				<div class="admin-pill">JSON : {$json}</div>
				<div class="admin-pill">BCMath : {$bcmath}</div>
				<div class="admin-pill">cURL : {$curl}</div>
				<div class="admin-pill">Mode sécurisé : {$safemode}</div>
				<div class="admin-pill">Limite mémoire : {$memory}</div>
				<div class="admin-pill">Suhosin : {$suhosin}</div>
				<div class="admin-pill">Journal PHP : {$errorlog} ({$errorloglines}, {$log_errors})</div>
			</div>
		</div>

		<div class="admin-table-shell admin-stack">
			<div>
				<h2 class="h5 mb-1">Jeu et accès</h2>
				<p class="text-white-50 mb-0">Références utiles pour le support, la maintenance et les vérifications d’environnement.</p>
			</div>
			<div class="admin-stack small">
				<div class="admin-pill">Version de la plateforme : {$vGame}</div>
				<div class="admin-pill">Adresse publique : http://{$root}/</div>
				<div class="admin-pill">Entrée applicative : http://{$gameroot}/index.php</div>
				<div class="admin-pill">Fuseaux horaires : PHP {$php_tz} / serveur {$conf_tz} / utilisateur {$user_tz}</div>
				<div class="admin-pill">Navigateur courant : {$browser}</div>
			</div>
		</div>
	</div>
</div>
{/block}
