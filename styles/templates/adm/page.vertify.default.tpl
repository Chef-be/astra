{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Contrôle d’intégrité</span>
			<h1 class="admin-hero__title">Vérification des fichiers</h1>
			<p class="admin-hero__subtitle">Comparez rapidement les fichiers locaux du projet avec les références distantes selon le type de ressource à auditer.</p>
		</div>
	</section>

	<div class="admin-table-shell admin-stack">
		<div class="admin-empty-state text-start">{$LNG.vt_info}</div>
		<div class="admin-filter-letters">
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=php">{$LNG.vt_filephp}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=tpl">{$LNG.vt_filetpl}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=css">{$LNG.vt_filecss}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=js">{$LNG.vt_filejs}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=png|jpg|gif">{$LNG.vt_fileimg}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=htaccess">{$LNG.vt_filehtaccess}</a>
			<a href="admin.php?page=vertify&amp;mode=getFileList&amp;ext=php|tpl|js|css|png|jpg|gif|htaccess">{$LNG.vt_all}</a>
		</div>
	</div>
</div>
{/block}
