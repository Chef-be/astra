{block name="content"}
<script>
$(function() {
	function filterModules() {
		var value = ($('#searchInModules').val() || '').toLowerCase().trim();
		var visible = 0;

		$('.js-module-card').each(function() {
			var matches = ($(this).data('moduleName') || '').toLowerCase().indexOf(value) !== -1;
			$(this).toggleClass('d-none', !matches);
			if (matches) {
				visible++;
			}
		});

		$('#modulesVisibleCount').text(visible);
	}

	$('#searchInModules').on('keyup change', filterModules);
	filterModules();

	$('.js-module-toggle').on('change', function() {
		var target = this.checked ? $(this).data('enableUrl') : $(this).data('disableUrl');
		window.location.href = target;
	});
});
</script>

<div class="admin-settings-shell">
	<section class="admin-card">
		<div class="card-body d-flex flex-wrap justify-content-between align-items-center gap-3">
			<div>
				<h2 class="h4 mb-1">Modules applicatifs</h2>
			</div>
			<div class="admin-cluster">
				<span class="admin-pill">{$moduleActiveCount} actif(s)</span>
				<span class="admin-pill">{$moduleInactiveCount} inactif(s)</span>
			</div>
		</div>
	</section>

	<section class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<div>
				<h3 class="h5 mb-0">Catalogue</h3>
			</div>
			<div class="admin-modules-toolbar">
				<span class="admin-pill"><strong id="modulesVisibleCount">0</strong> visible(s)</span>
				<input id="searchInModules" class="form-control" type="text" placeholder="Rechercher un module…">
			</div>
		</div>

		<div class="admin-modules-grid">
			{foreach key=ID item=Info from=$Modules}
				<article class="admin-module-card js-module-card" data-module-name="{$Info.name|escape:'html'}">
					<div class="admin-module-card__meta">
						<span class="admin-module-card__state {if $Info.state == 1}is-active{else}is-inactive{/if}">
							{if $Info.state == 1}{$LNG.mod_active}{else}{$LNG.mod_deactive}{/if}
						</span>
					</div>

					<div class="admin-module-card__body">
						<strong class="js-module-name">{$Info.name}</strong>
					</div>

					<div class="admin-module-card__foot">
						<label class="admin-switch" title="Basculer l’état du module">
							<input
								class="admin-switch__input js-module-toggle"
								type="checkbox"
								{if $Info.state == 1}checked="checked"{/if}
								data-enable-url="admin.php?page=module&amp;mode=change&amp;type=activate&amp;id={$ID}"
								data-disable-url="admin.php?page=module&amp;mode=change&amp;type=deaktivate&amp;id={$ID}"
							>
							<span class="admin-switch__track">
								<span class="admin-switch__thumb"></span>
							</span>
							<span class="admin-switch__label">{if $Info.state == 1}Actif{else}Inactif{/if}</span>
						</label>
					</div>
				</article>
			{/foreach}
		</div>
	</section>
</div>
{/block}
