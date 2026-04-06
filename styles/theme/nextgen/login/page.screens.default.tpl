{block name="title" prepend}{$LNG.siteTitleScreens}{/block}
{block name="content"}
<section class="public-reading-shell public-screens-shell">
	<header class="public-reading-hero">
		<h1>{$LNG.siteTitleScreens}</h1>
		<p>Explorez les écrans clés d’Astra Dominion à travers une galerie plus immersive, pensée comme une visite guidée de l’interface.</p>
	</header>

	{if $featuredScreenshot}
	<div class="public-screens-stage">
		<a id="publicScreenFeaturedLink" class="public-screen-feature gallery" href="{$featuredScreenshot.path}" target="_blank" rel="gallery">
			<span id="publicScreenFeaturedThumb" class="public-screen-feature-thumb" style="background-image:url('{$featuredScreenshot.thumbnail}');"></span>
			<span class="public-screen-feature-content">
				<span class="public-screen-kicker">Vue principale</span>
				<span id="publicScreenFeaturedTitle" class="public-screen-feature-title">{$featuredScreenshot.title|default:$featuredScreenshot.label|default:$LNG.siteTitleScreens}</span>
				<span id="publicScreenFeaturedCopy" class="public-screen-feature-copy">{if $featuredScreenshot.description}{$featuredScreenshot.description}{else}Cliquez sur une vignette pour changer la vue principale, ou ouvrez la capture en grand pour observer les détails de l’interface.{/if}</span>
			</span>
		</a>
		<button type="button" class="public-screen-arrow public-screen-arrow-prev" id="publicScreenPrev" aria-label="Capture précédente">‹</button>
		<button type="button" class="public-screen-arrow public-screen-arrow-next" id="publicScreenNext" aria-label="Capture suivante">›</button>

		<div class="public-screen-filmstrip">
			<a class="public-screen-mini public-screen-switch is-active" href="{$featuredScreenshot.path}" data-path="{$featuredScreenshot.path}" data-thumb="{$featuredScreenshot.thumbnail}" data-label="{$featuredScreenshot.title|default:$featuredScreenshot.label|default:$LNG.siteTitleScreens|escape:'html'}" data-description="{$featuredScreenshot.description|default:''|escape:'html'}">
				<span class="public-screen-mini-thumb" style="background-image:url('{$featuredScreenshot.thumbnail}');"></span>
				<span class="public-screen-mini-label">{$featuredScreenshot.title|default:$featuredScreenshot.label|default:$LNG.siteTitleScreens}</span>
			</a>
			{foreach $screenshots as $screenshot}
				<a class="public-screen-mini public-screen-switch" href="{$screenshot.path}" data-path="{$screenshot.path}" data-thumb="{$screenshot.thumbnail}" data-label="{$screenshot.title|default:$screenshot.label|default:$LNG.siteTitleScreens|escape:'html'}" data-description="{$screenshot.description|default:''|escape:'html'}">
					<span class="public-screen-mini-thumb" style="background-image:url('{$screenshot.thumbnail}');"></span>
					<span class="public-screen-mini-label">{$screenshot.title|default:$screenshot.label|default:$LNG.siteTitleScreens}</span>
				</a>
			{/foreach}
		</div>
	</div>
	{/if}

	{if $screenshots|@count > 0}
	<div class="public-screens-grid public-screens-grid-secondary">
		{foreach $screenshots as $screenshot}
			<a class="public-screen-card public-screen-switch" href="{$screenshot.path}" data-path="{$screenshot.path}" data-thumb="{$screenshot.thumbnail}" data-label="{$screenshot.title|default:$screenshot.label|default:$LNG.siteTitleScreens|escape:'html'}" data-description="{$screenshot.description|default:''|escape:'html'}">
				<span class="public-screen-thumb" style="background-image:url('{$screenshot.thumbnail}');"></span>
				<span class="public-screen-label">{$screenshot.title|default:$screenshot.label|default:$LNG.siteTitleScreens}</span>
			</a>
		{/foreach}
	</div>
	{/if}
</section>
{/block}
{block name="script"}
<script>
$(function() {
	$("#publicScreenFeaturedLink").fancybox();
	var $switches = $(".public-screen-switch");
	var slides = [];
	var autoRotate = null;
	var defaultTitle = "{$LNG.siteTitleScreens|escape:'javascript'}";
	var defaultDescription = "Cliquez sur une vignette pour changer la vue principale, ou ouvrez la capture en grand pour observer les détails de l’interface.";

	$switches.each(function() {
		var $item = $(this);
		var path = String($item.data("path") || "");

		if (!path) {
			return;
		}

		var alreadyExists = slides.some(function(slide) {
			return slide.path === path;
		});

		if (alreadyExists) {
			return;
		}

		slides.push({
			path: path,
			thumb: String($item.data("thumb") || ""),
			label: String($item.data("label") || ""),
			description: String($item.data("description") || "")
		});
	});

	function activateScreenByPath(path) {
		if (!path) {
			return;
		}

		var slide = slides.find(function(entry) {
			return entry.path === path;
		});

		if (!slide || !slide.thumb) {
			return;
		}

		$("#publicScreenFeaturedLink").attr("href", slide.path);
		$("#publicScreenFeaturedThumb").css("background-image", "url('" + slide.thumb + "')");
		$("#publicScreenFeaturedTitle").text(slide.label || defaultTitle);
		$("#publicScreenFeaturedCopy").text(slide.description || defaultDescription);

		$switches.removeClass("is-active");
		$switches.filter(function() {
			return String($(this).data("path") || "") === slide.path;
		}).addClass("is-active");
	}

	function activateByIndex(index) {
		if (!slides.length) {
			return;
		}

		var normalized = index;
		if (normalized < 0) {
			normalized = slides.length - 1;
		}
		if (normalized >= slides.length) {
			normalized = 0;
		}

		activateScreenByPath(slides[normalized].path);
	}

	function getActiveIndex() {
		var activePath = String($switches.filter(".is-active").first().data("path") || "");
		var index = slides.findIndex(function(slide) {
			return slide.path === activePath;
		});
		return index >= 0 ? index : 0;
	}

	function restartAutoplay() {
		if (autoRotate) {
			window.clearInterval(autoRotate);
		}

		autoRotate = window.setInterval(function() {
			activateByIndex(getActiveIndex() + 1);
		}, 5000);
	}

	$switches.on("click", function(event) {
		event.preventDefault();
		activateScreenByPath(String($(this).data("path") || ""));
		restartAutoplay();
	});

	$("#publicScreenPrev").on("click", function() {
		activateByIndex(getActiveIndex() - 1);
		restartAutoplay();
	});

	$("#publicScreenNext").on("click", function() {
		activateByIndex(getActiveIndex() + 1);
		restartAutoplay();
	});

	$(".public-screens-stage").on("mouseenter focusin", function() {
		if (autoRotate) {
			window.clearInterval(autoRotate);
			autoRotate = null;
		}
	}).on("mouseleave focusout", function() {
		restartAutoplay();
	});

	restartAutoplay();
});
</script>
{/block}
