//topnav.js
// Affichage temps réel des ressources pour Astra Dominion
// @version 1.0
// @copyright 2010 by ShadoX

function resourceTicker(config, init) {
	if(typeof init !== "undefined" && init === true)
		window.setInterval(function(){resourceTicker(config)}, 1000);

	var element	= $('#'+config.valueElem);
	if(element.hasClass('res_current_max'))
	{
		return false;
	}

	var nrResource = Math.max(0, Math.floor(parseFloat(config.available) + parseFloat(config.production) / 3600 * (serverTime.getTime() - startTime) / 1000));

	if (nrResource < config.limit[1])
	{
		if (!element.hasClass('res_current_warn') && nrResource >= config.limit[1] * 0.9)
		{
			element.addClass('res_current_warn');
		}
		if(viewShortlyNumber) {
			element.attr('data-tooltip-content', NumberGetHumanReadable(nrResource));
			element.html(shortly_number(nrResource));
		} else {
			element.html(NumberGetHumanReadable(nrResource));
		}
	} else {
		element.addClass('res_current_max');
	}
}

function getRessource(name) {
	return parseInt($('#current_'+name).data('real'));
}

(function(window, document) {
	'use strict';

	function initMissionIndicator() {
		var data = window.astraMissionTopnav || {};
		var icon = document.getElementById('astraMissionIcon');
		var link = document.getElementById('astraMissionLink');
		var userId = parseInt(data.userId || 0, 10);
		var signature = String(data.signature || '');
		var attentionCount = parseInt(data.attentionCount || 0, 10);
		var page = '';
		var storageKey;
		var seenSignature = '';

		if (!icon || !link || !signature || !userId) {
			return;
		}

		page = String(window.location.search || '').indexOf('page=missions') !== -1 ? 'missions' : '';
		storageKey = 'astra-missions-seen:' + userId;

		try {
			seenSignature = window.localStorage.getItem(storageKey) || '';
		} catch (error) {
			seenSignature = '';
		}

		function markSeen() {
			try {
				window.localStorage.setItem(storageKey, signature);
			} catch (error) {}

			icon.classList.remove('astra-mission-attention');
		}

		if (page === 'missions') {
			markSeen();
			return;
		}

		if (attentionCount > 0 && seenSignature !== signature) {
			icon.classList.add('astra-mission-attention');
		} else {
			icon.classList.remove('astra-mission-attention');
		}

		link.addEventListener('click', markSeen);
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', initMissionIndicator);
	} else {
		initMissionIndicator();
	}
})(window, document);
