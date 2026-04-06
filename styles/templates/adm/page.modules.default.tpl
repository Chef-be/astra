{block name="content"}
<script>
$(document).ready(function(){
  $("#searchInModules").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $(".js-module-card").each(function() {
      var matches = $(this).find(".js-module-name").text().toLowerCase().indexOf(value) > -1;
      $(this).toggleClass('d-none', !matches);
    });
  });
});
</script>

<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Fonctionnalités</span>
			<h1 class="admin-hero__title">Modules applicatifs</h1>
			<p class="admin-hero__subtitle">Activez ou désactivez les fonctionnalités du jeu depuis une vue lisible, filtrable et orientée exploitation.</p>
		</div>
	</section>

	<div class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<div>
				<h2 class="h5 mb-1">Catalogue des modules</h2>
				<p class="text-white-50 mb-0">Les changements sont immédiatement propagés après sauvegarde et purge de cache.</p>
			</div>
			<input style="max-width: 320px;" id="searchInModules" class="form-control bg-dark text-white border-secondary" type="text" placeholder="Rechercher un module…">
		</div>

		<div class="admin-stack">
			{foreach key=ID item=Info from=$Modules}
				<div class="admin-field-card js-module-card">
					<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
						<div>
							<div class="fw-semibold js-module-name">{$Info.name}</div>
							<div class="text-white-50 small">{if $Info.state == 1}Module actif dans la configuration courante.{else}Module neutralisé dans la configuration courante.{/if}</div>
						</div>
						<div class="d-flex align-items-center gap-2 flex-wrap">
							<span class="badge {if $Info.state == 1}admin-badge-success{else}admin-badge-danger{/if}">{if $Info.state == 1}{$LNG.mod_active}{else}{$LNG.mod_deactive}{/if}</span>
							<a class="btn btn-sm {if $Info.state == 1}btn-outline-warning{else}btn-outline-success{/if}" href="admin.php?page=module&amp;mode=change&amp;type={if $Info.state == 1}deaktivate{else}activate{/if}&amp;id={$ID}">
								{if $Info.state == 1}{$LNG.mod_change_deactive}{else}{$LNG.mod_change_active}{/if}
							</a>
						</div>
					</div>
				</div>
			{/foreach}
		</div>
	</div>
</div>
{/block}
