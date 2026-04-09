<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="{$lang}" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="{$lang}" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="{$lang}" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="{$lang}" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="{$lang}" class="no-js {$bg_img}"> <!--<![endif]-->
<head>
	<title>{block name="title"} - {$uni_name} - {$game_name}{/block}</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">

	<!-- Bootstrap 5 - No IE support -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">




	{if !empty($goto)}
	<meta http-equiv="refresh" content="{$gotoinsec};URL={$goto}">
	{/if}
	{assign var="REV" value="1.0.0.187" nocache}

	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="./styles/resource/css/base/boilerplate.css?v={$REV}">
	<link rel="stylesheet" type="text/css" href="./styles/resource/css/base/jquery.css?v={$REV}">
	<link rel="stylesheet" type="text/css" href="./styles/resource/css/base/validationEngine.jquery.css?v={$REV}">
	<link rel="stylesheet" type="text/css" href="./styles/resource/css/admin/rich-editor.css?v={$REV}">
	<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/tinymce@7.6.1/tinymce.min.js" referrerpolicy="origin"></script>
	<script type="text/javascript" src="./scripts/admin/rich-editor.js?v={$REV}"></script>
	<link rel="stylesheet" type="text/css" href="{$dpath}formate.css?v={$REV}">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.12/css/all.css">
	<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon">

	<!-- NG Fonts -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/fonts.css?v={$REV}">
	<!-- NG Libraries -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/uikit.min.css?v={$REV}">
	<script src="styles/theme/nextgen/js/uikit.min.js	"></script>
	<script src="styles/theme/nextgen/js/uikit-icons.min.js"></script>
	<!-- NG CSS -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/style.css?v={$REV}">
	<link rel="stylesheet" href="styles/theme/nextgen/css/mobile.css?v={$REV}">
	<!-- Favicons  -->
	<link rel="shortcut icon" href="/styles/resource/favicon/favicon.ico" type="image/x-icon">
	<link rel="apple-touch-icon" sizes="180x180" href="/styles/resource/favicon/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/styles/resource/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/styles/resource/favicon/favicon-16x16.png">
	<link rel="manifest" href="/styles/resource/favicon/site.webmanifest">

	<script type="text/javascript">
	var ServerTimezoneOffset = {$Offset};
	var serverTime 	= new Date({$date.0}, {$date.1 - 1}, {$date.2}, {$date.3}, {$date.4}, {$date.5});
	var startTime	= serverTime.getTime();
	var localTime 	= serverTime;
	var localTS 	= startTime;
	var Gamename	= document.title;
	var Ready		= "{$LNG.ready}";
	var Skin		= "{$dpath}";
	var Lang		= "{$lang}";
	var head_info	= "{$LNG.fcm_info}";
	var auth		= {$authlevel|default:'0'};
	var days 		= {$LNG.week_day|json|default:'[]'}
	var months 		= {$LNG.months|json|default:'[]'} ;
	var tdformat	= "{$LNG.js_tdformat}";
	var queryString	= "{$queryString|escape:'javascript'}";
	var isPlayerCardActive	= "{$isPlayerCardActive|json}";
	var relativeTime = Math.floor(Date.now() / 1000);
	var attackListenTime = {$attackListenTime};

	setInterval(function() {
		if(relativeTime < Math.floor(Date.now() / 1000)) {
		serverTime.setSeconds(serverTime.getSeconds()+1);
		relativeTime++;
		}
	}, 1);
	</script>



	<script type="text/javascript" src="./scripts/base/jquery.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/base/jquery.ui.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/base/jquery.cookie.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/base/jquery.validationEngine.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/l18n/validationEngine/jquery.validationEngine-{$lang}.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/base/tooltip.js?v={$REV}"></script>
	<script type="text/javascript" src="./scripts/game/base.js?v={$REV}"></script>
	{foreach item=scriptname from=$scripts}
	<script type="text/javascript" src="./scripts/game/{$scriptname}.js?v={$REV}"></script>
	{/foreach}
	{if isModuleAvailable($smarty.const.MODULE_ATTACK_ALERT)}
	<script type="text/javascript">
	var attackListenTime = {$attackListenTime};
	</script>
	<script type="text/javascript" src="./scripts/game/attackAlert.js?v={$REV}"></script>
	{/if}
	<!-- fancybox 5.0 -->
	<script src="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css"/>

<script>
		var myDefaultWhiteList = bootstrap.Tooltip.Default.allowList
		myDefaultWhiteList.table = ['class','style'];
		myDefaultWhiteList.tbody = [];
		myDefaultWhiteList.thead = [];
		myDefaultWhiteList.th = ['colspan'];
		myDefaultWhiteList.tr = [];
		myDefaultWhiteList.td = ['colspan','style'];
		myDefaultWhiteList.span = ['class','onclick'];
		myDefaultWhiteList.img = ['src','alt','width','height'];
		myDefaultWhiteList.form = ['class','action','method'];
		myDefaultWhiteList.input = ['type','name','value'];
		myDefaultWhiteList.button = ['type','class','onclick','style'];
		myDefaultWhiteList.font = ['color'];
		myDefaultWhiteList.a = ['href','class','onclick'];
		myDefaultWhiteList.br = [];

			//initialize bootstrap tooltips
			$(document).ready(function(){
			  $('[data-bs-toggle="tooltip"]').tooltip({
					container: 'body',
				  html: true,
				  whiteList: myDefaultWhiteList
				});
			});

			// To allow elements
			//popovers

			$(document).ready(function(){
				$('[data-bs-toggle="popover"]').popover({
					container: 'body',
				  html: true,
					whiteList: myDefaultWhiteList
				});

			});
</script>

<script src="scripts/game/overview.js?v={$VERSION}-overview2"></script>

<style>
	.ng-disclosure {
		border-radius: 1.05rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
		overflow: hidden;
		transition: border-color 0.18s ease, box-shadow 0.18s ease;
	}

	.ng-disclosure[open] {
		border-color: rgba(255, 214, 102, 0.18);
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.24);
	}

	.ng-disclosure > summary {
		position: relative;
		list-style: none;
		cursor: pointer;
		transition: background-color 0.18s ease;
	}

	.ng-disclosure > summary:hover {
		background: rgba(255, 255, 255, 0.025);
	}

	.ng-disclosure > summary::-webkit-details-marker {
		display: none;
	}

	.ng-disclosure > summary:focus-visible {
		outline: 2px solid rgba(255, 214, 102, 0.28);
		outline-offset: -2px;
	}

	.ng-disclosure--chevron > summary {
		padding-right: 2.9rem !important;
	}

	.ng-disclosure--chevron > summary::after {
		content: "";
		position: absolute;
		top: 50%;
		right: 1.05rem;
		width: 0.68rem;
		height: 0.68rem;
		border-right: 2px solid rgba(255, 255, 255, 0.62);
		border-bottom: 2px solid rgba(255, 255, 255, 0.62);
		transform: translateY(-65%) rotate(45deg);
		transition: transform 0.2s ease, border-color 0.2s ease;
		pointer-events: none;
	}

	.ng-disclosure[open].ng-disclosure--chevron > summary::after {
		transform: translateY(-35%) rotate(225deg);
		border-color: rgba(255, 214, 102, 0.92);
	}

	.ng-disclosure__body {
		border-top: 1px solid rgba(255, 255, 255, 0.06);
		padding-top: 0.72rem;
	}

	.game-toast-container {
		position: fixed;
		top: 1rem;
		right: 1rem;
		z-index: 2000;
		display: flex;
		flex-direction: column;
		gap: 0.65rem;
		max-width: min(92vw, 24rem);
		pointer-events: none;
	}

	.game-toast {
		pointer-events: auto;
		border-radius: 0.95rem;
		border: 1px solid rgba(255, 255, 255, 0.1);
		background: linear-gradient(180deg, rgba(12, 18, 33, 0.96), rgba(7, 11, 22, 0.98));
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.35);
		backdrop-filter: blur(10px);
		overflow: hidden;
	}

	.game-toast--success {
		border-left: 4px solid #35c98d;
	}

	.game-toast--danger {
		border-left: 4px solid #ff7b7b;
	}

	.game-toast--warning {
		border-left: 4px solid #ffd666;
	}

	.game-toast--info {
		border-left: 4px solid #6ab7ff;
	}

	.game-toast__body {
		display: flex;
		align-items: flex-start;
		gap: 0.75rem;
		padding: 0.85rem 1rem;
		color: #edf2ff;
	}

	.game-toast__icon {
		flex: 0 0 auto;
		font-size: 1rem;
		line-height: 1.4;
	}

	.game-toast__message {
		flex: 1 1 auto;
		font-size: 0.9rem;
		line-height: 1.45;
	}

	.game-toast .btn-close {
		filter: invert(1) grayscale(1);
		opacity: 0.82;
	}

	.game-toast .btn-close:hover {
		opacity: 1;
	}

	.game-global-modal .modal-content {
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.1);
		background: linear-gradient(180deg, rgba(13, 19, 35, 0.98), rgba(8, 12, 24, 0.99));
		box-shadow: 0 1.2rem 2.5rem rgba(0, 0, 0, 0.38);
	}

	.game-global-modal .modal-dialog {
		max-width: min(92vw, 42rem);
	}

	.game-global-modal .modal-header,
	.game-global-modal .modal-footer {
		border-color: rgba(255, 255, 255, 0.08);
	}

	.game-global-modal__body {
		color: #edf2ff;
		white-space: pre-line;
		line-height: 1.55;
	}

	@media (max-width: 767px) {
		.game-toast-container {
			left: 0.75rem;
			right: 0.75rem;
			top: 0.75rem;
			max-width: none;
		}
	}
</style>

</head>
<body id="{if isset($smarty.get.page)}{$smarty.get.page|htmlspecialchars|default:'overview'}{/if}" class="{$bodyclass}">
	<div id="tooltipNotify" class="tip"></div>
	<div id="gameToastContainer" class="game-toast-container" aria-live="polite" aria-atomic="true"></div>
	<div class="modal fade game-global-modal" id="gameGlobalModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content text-white">
				<div class="modal-header">
					<h5 class="modal-title" id="gameGlobalModalTitle">Information</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Fermer"></button>
				</div>
				<div class="modal-body">
					<div id="gameGlobalModalBody" class="game-global-modal__body"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-light" data-role="cancel" data-bs-dismiss="modal">Annuler</button>
					<button type="button" class="btn btn-primary" data-role="confirm">Fermer</button>
				</div>
			</div>
		</div>
	</div>
