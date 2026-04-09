{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Diagnostic</span>
			<h2>Informations techniques</h2>
		</div>
	</section>

	<div class="admin-split">
		<div class="admin-table-shell admin-stack">
			<div><h2 class="h5 mb-1">Plateforme et serveur</h2></div>
			<div class="admin-overview-grid">
				<div class="admin-overview-card">
					<strong>{$vPHP}</strong>
					<span>PHP</span>
				</div>
				<div class="admin-overview-card">
					<strong>{$vMySQLc}</strong>
					<span>MySQL client</span>
				</div>
				<div class="admin-overview-card">
					<strong>{$dbVersion}</strong>
					<span>Base</span>
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
			<div><h2 class="h5 mb-1">Jeu et accès</h2></div>
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
