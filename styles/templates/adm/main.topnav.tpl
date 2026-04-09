<script>
$(function() {
	$('#adminSidebarToggle').on('click', function() {
		$('body').toggleClass('bridge-nav-open');
	});

	$('.js-bridge-quickjump').on('change', function() {
		if ($(this).val()) {
			window.location.href = $(this).val();
		}
	});

	$('.js-bridge-universe').on('change', function() {
		var url = new URL(window.location.href);
		url.searchParams.set('uni', $(this).val());
		window.location.href = url.toString();
	});

	$('.bridge-drawer__backdrop').on('click', function() {
		$('body').removeClass('bridge-nav-open');
	});

	$(document).on('keydown', function(event) {
		if (event.key === 'Escape') {
			$('body').removeClass('bridge-nav-open');
		}
	});

	$('.admin-section-title').each(function() {
		var help = $(this).find('small').first().text().trim();
		if (help !== '' && !$(this).attr('title')) {
			$(this).attr('title', help);
		}
	});

	$('.admin-table-toolbar').each(function() {
		var help = $(this).find('p').first().text().trim();
		if (help !== '' && !$(this).attr('title')) {
			$(this).attr('title', help);
		}
	});
});
</script>

<div class="bridge-bar">
	<div class="bridge-bar__cluster">
		<button id="adminSidebarToggle" class="bridge-bar__menu" type="button" aria-label="Ouvrir la navigation">
			<i class="bi bi-grid-3x3-gap-fill"></i>
			<span>Menu</span>
		</button>
		<a href="admin.php?page=overview" class="bridge-bar__brand" title="Retour au tableau de bord">
			<span class="bridge-bar__kicker">console admin</span>
			<strong>{$gameName|default:'Astra Dominion'}</strong>
		</a>
		<span class="bridge-status">U {$UNI}</span>
		<a href="admin.php?page=support" class="bridge-status" title="Ouvrir le support">{$supportticks|default:0} ticket(s)</a>
	</div>

	<div class="bridge-bar__cluster bridge-bar__cluster--fill">
		<select class="bridge-select js-bridge-quickjump bridge-select--wide">
			<option value="">Palette de pages…</option>
			{foreach from=$adminNavigation item=section}
				<optgroup label="{$section.label}">
					{foreach from=$section.items item=menuItem}
						<option value="{$menuItem.url}" {if $currentPage == $menuItem.page}selected{/if}>{$menuItem.label}</option>
					{/foreach}
				</optgroup>
			{/foreach}
		</select>
	</div>

	<div class="bridge-bar__cluster bridge-bar__cluster--tight">
		{if $authlevel == $smarty.const.AUTH_ADM}
			<select class="bridge-select js-bridge-universe bridge-select--compact">
				{html_options options=$AvailableUnis selected=$UNI}
			</select>
		{/if}
		<a href="admin.php?page=overview" class="bridge-iconlink" title="Tableau de bord">
			<i class="bi bi-speedometer2"></i>
		</a>
		<a href="admin.php?page=expedition" class="bridge-iconlink" title="Expéditions">
			<i class="bi bi-compass"></i>
		</a>
		<a href="index.php" target="_blank" rel="noopener" class="bridge-iconlink" title="Site public">
			<i class="bi bi-box-arrow-up-right"></i>
		</a>
		<a href="javascript:top.location.href='game.php';" target="_top" class="bridge-iconlink bridge-iconlink--accent" title="Retour au jeu">
			<i class="bi bi-controller"></i>
		</a>
	</div>
</div>
