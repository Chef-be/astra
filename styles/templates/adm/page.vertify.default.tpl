{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Contrôle</span>
			<h2>Vérification des fichiers</h2>
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
