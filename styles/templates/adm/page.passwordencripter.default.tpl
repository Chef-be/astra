{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Outil</span>
			<h2>Générateur de mot de passe chiffré</h2>
		</div>
	</section>

	<form class="admin-table-shell admin-stack" method="post" action="admin.php?page=passEncripter&amp;mode=send">
		<label class="admin-field-card">
			<span>{$LNG.et_pass}</span>
			<input id="md5q" class="form-control bg-dark text-white border-secondary" type="text" name="md5q" value="{if isset($md5_md5)}{$md5_md5}{/if}">
		</label>
		<label class="admin-field-card">
			<span>{$LNG.et_result}</span>
			<input id="md5w" class="form-control bg-dark text-white border-secondary" type="text" name="md5w" value="{if isset($md5_enc)}{$md5_enc}{/if}" readonly>
		</label>
		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.et_encript}</button>
		</div>
	</form>
</div>
{/block}
