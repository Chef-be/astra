<div class="col-12 col-lg d-flex align-items-center justify-content-center justify-content-lg-start text-white fw-bold px-3">
	<div class="d-flex flex-column">
		<span class="admin-topnav__title">{$currentPageMeta.title|default:$LNG.adm_cp_title}</span>
		<span class="admin-topnav__subtitle text-white-50">{$currentPageMeta.description|default:$LNG.adm_cp_title}</span>
	</div>
</div>
<div class="col-12 col-lg-auto d-flex flex-wrap justify-content-center align-items-center gap-2 px-3">
{if $authlevel == $smarty.const.AUTH_ADM}
<select style="width:auto;min-width:220px;" class="form-select bg-dark text-white border-secondary" id="universe">
{html_options options=$AvailableUnis selected=$UNI}
</select>
{/if}
<a href="admin.php?page=overview" class="border border-white rounded text-decoration-none text-white fs-6 px-3 py-1">Vue d’ensemble</a>
<a href="index.php" target="_blank" rel="noopener" class="border border-white rounded text-decoration-none text-white fs-6 px-3 py-1">Site public</a>
{if $id == 1}
<a href="?page=reset&amp;sid={$sid}" class="border border-warning rounded text-decoration-none text-warning fs-6 px-3 py-1">Réinitialiser l’univers</a>
{/if}
<a href="javascript:top.location.href='game.php';" target="_top" class="border border-danger rounded text-decoration-none text-danger fs-6 px-3 py-1">Retour au jeu</a>
</div>
<script>
$(function() {
	$('#universe').on('change', function(e) {
		var url = new URL(window.location.href);
		url.searchParams.set('uni', $(this).val());
		window.location.href = url.toString();
	});
});
</script>
