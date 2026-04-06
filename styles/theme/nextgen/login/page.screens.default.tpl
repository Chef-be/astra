{block name="title" prepend}{$LNG.siteTitleScreens}{/block}
{block name="content"}
<section class="public-reading-shell">
	<header class="public-reading-hero">
		<h1>{$LNG.siteTitleScreens}</h1>
		<p>Un aperçu rapide de l’interface et des écrans majeurs d’Astra Dominion.</p>
	</header>
	<div class="public-screens-grid">
		{foreach $screenshots as $screenshot}
			<a class="public-screen-card gallery" href="{$screenshot.path}" target="_blank" rel="gallery">
				<span class="public-screen-thumb" style="background-image:url('{$screenshot.thumbnail}');"></span>
				<span class="public-screen-label">{$screenshot.label|default:$LNG.siteTitleScreens}</span>
			</a>
		{/foreach}
	</div>
</section>
{/block}
{block name="script"}
<script>
$(function() {
	$(".gallery").fancybox();
});
</script>
{/block}
