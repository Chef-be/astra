function number_format (number, decimals) {
    number = (number + '').replace(/[^0-9+\-Ee.]/g, '');
    var n = !isFinite(+number) ? 0 : +number,
        prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
        sep = '.',
        dec = ',',
        s = '',
        toFixedFix = function (n, prec) {
            var k = Math.pow(10, prec);
            return '' + Math.round(n * k) / k;
        };
    // Fix for IE parseFloat(0.55).toFixed(0) = 0;
    s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
    if (s[0].length > 3) {        s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
    }
    if ((s[1] || '').length < prec) {
        s[1] = s[1] || '';
        s[1] += new Array(prec - s[1].length + 1).join('0');    }
    return s.join(dec);
}

function NumberGetHumanReadable(value, dec) {
	if(typeof dec === "undefined") {
		dec = 0;
	}
	if(dec == 0)
	{
		value	= removeE(Math.floor(value));
	}
	return number_format(value, dec);
}

function shortly_number(number)
{
    var unit	= ["", "K", "M", "B", "T", "Q", "Q+", "S", "S+", "O", "N"];
	var negate	= number < 0 ? -1 : 1;
	var key		= 0;
	number		= Math.abs(number);

	if(number >= 1000000) {
		++key;
		while(number >= 1000000)
		{
			++key;
			number = number / 1000000;
		}
	} else if(number >= 1000) {
		++key;
		number = number / 1000;
	}

	decial	= key != 0 && number != 0 && number < 100;
	return NumberGetHumanReadable(negate * number, decial)+(key !== 0 ? '&nbsp;'+unit[key] : '');
}

function removeE(Number) {
	Number = String(Number);
	if (Number.search(/e\+/) == -1)
		return Number;
	var e = parseInt(Number.replace(/\S+.?e\+/g, ''));
	if (isNaN(e) || e == 0)
		return Number;
	else if ($.browser.webkit || $.browser.msie)
		return parseFloat(Number).toPrecision(Math.min(e + 1, 21));
	else
		return parseFloat(Number).toPrecision(e + 1);
}

function getFormatedDate(timestamp, format) {
	var currTime = new Date();
	currTime.setTime(timestamp + (ServerTimezoneOffset * 1000));
	str = format;
	str = str.replace('[d]', dezInt(currTime.getDate(), 2));
	str = str.replace('[D]', days[currTime.getDay()]);
	str = str.replace('[m]', dezInt(currTime.getMonth() + 1, 2));
	str = str.replace('[M]', months[currTime.getMonth()]);
	str = str.replace('[j]', parseInt(currTime.getDate()));
	str = str.replace('[Y]', currTime.getFullYear());
	str = str.replace('[y]', currTime.getFullYear().toString().substr(2, 4));
	str = str.replace('[G]', currTime.getHours());
	str = str.replace('[H]', dezInt(currTime.getHours(), 2));
	str = str.replace('[i]', dezInt(currTime.getMinutes(), 2));
	str = str.replace('[s]', dezInt(currTime.getSeconds(), 2));
	return str;
}
function dezInt(num, size, prefix) {
	prefix = (prefix) ? prefix : "0";
	var minus = (num < 0) ? "-" : "",
	result = (prefix == "0") ? minus : "";
	num = Math.abs(parseInt(num, 10));
	size -= ("" + num).length;
	for (var i = 1; i <= size; i++) {
		result += "" + prefix;
	}
	result += ((prefix != "0") ? minus : "") + num;
	return result;
}

function getFormatedTime(time) {
	hours = Math.floor(time / 3600);
	timeleft = time % 3600;
	minutes = Math.floor(timeleft / 60);
	timeleft = timeleft % 60;
	seconds = timeleft;
	return dezInt(hours, 2) + ":" + dezInt(minutes, 2) + ":" + dezInt(seconds, 2);
}

function GetRestTimeFormat(Secs) {
	var s = Secs;
	var m = 0;
	var h = 0;
	if (s > 59) {
		m = Math.floor(s / 60);
		s = s - m * 60;
	}
	if (m > 59) {
		h = Math.floor(m / 60);
		m = m - h * 60;
	}
	return dezInt(h, 2) + ':' + dezInt(m, 2) + ":" + dezInt(s, 2);
}

function OpenPopup(target_url, win_name, width, height) {
	var new_win = window.open(target_url+'&ajax=1', win_name, 'scrollbars=yes,statusbar=no,toolbar=no,location=no,directories=no,resizable=no,menubar=no,width='+width+',height='+height+',screenX='+((screen.width-width) / 2)+",screenY="+((screen.height-height) / 2)+",top="+((screen.height-height) / 2)+",left="+((screen.width-width) / 2));
	new_win.focus();
}

function DestroyMissiles() {
	$.getJSON('?page=information&mode=destroyMissiles&'+$('.missile').serialize(), function(data) {
		$('#missile_502').text(NumberGetHumanReadable(data[0]));
		$('#missile_503').text(NumberGetHumanReadable(data[1]));
		$('.missile').val('');
	});
}

function handleErr(errMessage, url, line)
{
	error = "There is an error at this page.\n";
	error += "Error: " + errMessage+ "\n";
	error += "URL: " + url + "\n";
	error += "Line: " + line + "\n\n";
	error += "Click OK to continue viewing this page,\n";
	Dialog.alert(error, null, { title: 'Erreur JavaScript' });
	if(typeof console == "object")
		console.log(error);

	return true;
}

function getGameUiWindow() {
	var currentWindow = window;

	try {
		while (currentWindow.parent && currentWindow.parent !== currentWindow) {
			if (currentWindow.parent.location.origin !== currentWindow.location.origin) {
				break;
			}

			currentWindow = currentWindow.parent;
		}
	} catch (error) {
		return window;
	}

	return currentWindow;
}

function normalizeGameMessage(message) {
	if (message === null || typeof message === 'undefined') {
		return '';
	}

	if ($.isArray(message)) {
		return message.join("\n");
	}

	if (typeof message === 'object') {
		if (typeof message.message !== 'undefined') {
			return normalizeGameMessage(message.message);
		}

		if (typeof message.mess !== 'undefined') {
			return normalizeGameMessage(message.mess);
		}

		try {
			return JSON.stringify(message);
		} catch (error) {
			return String(message);
		}
	}

	return String(message);
}

function escapeGameHtml(value) {
	return $('<div>').text(value === null || typeof value === 'undefined' ? '' : String(value)).html();
}

function getGameModalContext() {
	var uiWindow = getGameUiWindow();
	var doc = uiWindow.document;

	return {
		win: uiWindow,
		doc: doc,
		element: doc.getElementById('gameGlobalModal'),
		title: doc.getElementById('gameGlobalModalTitle'),
		body: doc.getElementById('gameGlobalModalBody'),
		cancelButton: doc.querySelector('#gameGlobalModal [data-role="cancel"]'),
		confirmButton: doc.querySelector('#gameGlobalModal [data-role="confirm"]'),
		closeButton: doc.querySelector('#gameGlobalModal .btn-close')
	};
}

function openGamePromptDialog(options) {
	options = options || {};

	var context = getGameModalContext();
	if (!context.element || !context.win.bootstrap || typeof context.win.bootstrap.Modal !== 'function') {
		return Promise.resolve(context.win.prompt(options.message || '', options.defaultValue || ''));
	}

	context.title.textContent = options.title || 'Saisie requise';
	context.body.innerHTML =
		'<label class="form-label text-white-50 mb-2" for="gameGlobalModalInput">' + escapeGameHtml(options.message || '') + '</label>' +
		'<input id="gameGlobalModalInput" class="form-control bg-dark text-white border-secondary" type="' + escapeGameHtml(options.inputType || 'text') + '" value="' + escapeGameHtml(options.defaultValue || '') + '">';

	context.cancelButton.textContent = options.cancelLabel || 'Annuler';
	context.confirmButton.textContent = options.confirmLabel || 'Valider';
	context.cancelButton.classList.remove('d-none');
	context.confirmButton.className = 'btn ' + (options.confirmClass || 'btn-primary');

	return new Promise(function(resolve) {
		var modal = context.win.bootstrap.Modal.getOrCreateInstance(context.element);
		var result = null;
		var input = context.doc.getElementById('gameGlobalModalInput');

		var cleanup = function() {
			context.confirmButton.removeEventListener('click', onConfirm);
			context.cancelButton.removeEventListener('click', onCancel);
			context.closeButton.removeEventListener('click', onCancel);
			context.element.removeEventListener('hidden.bs.modal', onHidden);
		};

		var onConfirm = function() {
			result = input ? input.value : '';
			modal.hide();
		};

		var onCancel = function() {
			result = null;
		};

		var onHidden = function() {
			cleanup();
			resolve(result);
		};

		context.confirmButton.addEventListener('click', onConfirm);
		context.cancelButton.addEventListener('click', onCancel);
		context.closeButton.addEventListener('click', onCancel);
		context.element.addEventListener('hidden.bs.modal', onHidden);

		modal.show();

		context.win.setTimeout(function() {
			if (!input) {
				return;
			}

			input.focus();
			input.select();
		}, 150);
	});
}

function openGameDialog(options) {
	options = options || {};

	var context = getGameModalContext();
	var message = normalizeGameMessage(options.message);

	if (!context.element || !context.win.bootstrap || typeof context.win.bootstrap.Modal !== 'function') {
		if (options.showCancel) {
			return Promise.resolve(context.win.confirm(message));
		}

		context.win.alert(message);
		return Promise.resolve(true);
	}

	context.title.textContent = options.title || (options.showCancel ? 'Confirmation' : 'Information');
	context.body.textContent = message;
	context.body.innerHTML = options.html === true ? message : context.body.innerHTML;

	context.cancelButton.textContent = options.cancelLabel || 'Annuler';
	context.confirmButton.textContent = options.confirmLabel || (options.showCancel ? 'Confirmer' : 'Fermer');
	context.cancelButton.classList.toggle('d-none', !options.showCancel);
	context.confirmButton.className = 'btn ' + (options.confirmClass || (options.showCancel ? 'btn-primary' : 'btn-primary'));

	return new Promise(function(resolve) {
		var modal = context.win.bootstrap.Modal.getOrCreateInstance(context.element);
		var result = options.showCancel ? false : true;

		var cleanup = function() {
			context.confirmButton.removeEventListener('click', onConfirm);
			context.cancelButton.removeEventListener('click', onCancel);
			context.closeButton.removeEventListener('click', onCancel);
			context.element.removeEventListener('hidden.bs.modal', onHidden);
		};

		var onConfirm = function() {
			result = true;
			modal.hide();
		};

		var onCancel = function() {
			result = options.showCancel ? false : true;
		};

		var onHidden = function() {
			cleanup();
			resolve(result);
		};

		context.confirmButton.addEventListener('click', onConfirm);
		context.cancelButton.addEventListener('click', onCancel);
		context.closeButton.addEventListener('click', onCancel);
		context.element.addEventListener('hidden.bs.modal', onHidden);

		modal.show();
	});
}

var Dialog	= {
	info: function(ID){
		var dialogWidth = 760;
		var dialogHeight = 680;

		if ((ID > 600 && ID < 800) || (ID > 900 && ID < 930)) {
			dialogWidth = 720;
			dialogHeight = 360;
		} else if (ID > 100 && ID < 200) {
			dialogWidth = 700;
			dialogHeight = 440;
		}

		return Dialog.open('game.php?page=information&id='+ID, dialogWidth, dialogHeight);
	},

	alert: function(msg, callback, options){
		var rootWindow = getGameUiWindow();

		if (rootWindow !== window && rootWindow.Dialog && typeof rootWindow.Dialog.alert === 'function') {
			return rootWindow.Dialog.alert(msg, callback, options);
		}

		return openGameDialog($.extend({
			message: msg,
			title: 'Information',
			confirmLabel: 'Fermer',
			showCancel: false
		}, options || {})).then(function() {
			if(typeof callback === "function") {
				callback();
			}
			return true;
		});
	},

	confirm: function(msg, options){
		var rootWindow = getGameUiWindow();

		if (rootWindow !== window && rootWindow.Dialog && typeof rootWindow.Dialog.confirm === 'function') {
			return rootWindow.Dialog.confirm(msg, options);
		}

		return openGameDialog($.extend({
			message: msg,
			title: 'Confirmation',
			confirmLabel: 'Confirmer',
			cancelLabel: 'Annuler',
			confirmClass: 'btn-danger',
			showCancel: true
		}, options || {}));
	},

	prompt: function(msg, defaultValue, options) {
		var rootWindow = getGameUiWindow();

		if (rootWindow !== window && rootWindow.Dialog && typeof rootWindow.Dialog.prompt === 'function') {
			return rootWindow.Dialog.prompt(msg, defaultValue, options);
		}

		return openGamePromptDialog($.extend({
			message: msg,
			defaultValue: defaultValue || '',
			title: 'Saisie requise',
			confirmLabel: 'Valider',
			cancelLabel: 'Annuler',
			confirmClass: 'btn-primary'
		}, options || {}));
	},

	PM: function(ID, Subject, Message) {
		if(typeof Subject !== 'string')
			Subject	= '';

		return Dialog.open('game.php?page=messages&mode=write&id='+ID+'&subject='+encodeURIComponent(Subject)+'&message='+encodeURIComponent(Subject), 650, 420);
	},

	Playercard: function(ID) {
		return isPlayerCardActive && Dialog.open('game.php?page=playerCard&id='+ID, 650, 600);
	},

	Buddy: function(ID) {
		return Dialog.open('game.php?page=buddyList&mode=request&id='+ID, 650, 380);
	},

	PlanetAction: function() {
		return Dialog.open('game.php?page=overview&mode=actions', 400, 400);
	},

	AllianceChat: function() {
	    return OpenPopup('game.php?page=chat&action=alliance', "alliance_chat", 960, 900);
	},

	open: function(url, width, height) {
    new Fancybox([{
    hideScrollbar: true,
    src: url,
    type: "iframe",
    width: width,
    height: height,
    iframeAttr:{
      scrolling: "no",
    },
  },
]);


		return false;
	}
}

function NotifyBox(text) {
	showGameToast(text, 'info');
}

function showGameToast(message, type, options) {
	options = options || {};
	message = normalizeGameMessage(message);

	if (!message) {
		return null;
	}

	var rootWindow = getGameUiWindow();
	if (rootWindow !== window && typeof rootWindow.showGameToast === 'function') {
		return rootWindow.showGameToast(message, type, options);
	}

	var toastType = typeof type === 'string' && type ? type : 'info';
	var icons = {
		success: '✓',
		danger: '!',
		warning: '!',
		info: 'i'
	};
	var container = document.getElementById('gameToastContainer');

	if (!container) {
		var tip = $('#tooltipNotify');
		if (!tip.length) {
			Dialog.alert(message);
			return null;
		}
		tip.stop(true, true).html(message).addClass('notify').css({
			left : (($(window).width() - $('#leftmenu').width()) / 2 - tip.outerWidth() / 2) + $('#leftmenu').width(),
		}).show();
		window.setTimeout(function() {
			tip.fadeOut(1000, function() {
				tip.removeClass('notify');
			});
		}, 1200);
		return null;
	}

	var toast = document.createElement('div');
	toast.className = 'toast game-toast game-toast--' + toastType;
	toast.setAttribute('role', 'alert');
	toast.setAttribute('aria-live', 'assertive');
	toast.setAttribute('aria-atomic', 'true');
	toast.innerHTML =
		'<div class="game-toast__body">' +
			'<span class="game-toast__icon" aria-hidden="true">' + (icons[toastType] || icons.info) + '</span>' +
			'<div class="game-toast__message"></div>' +
			'<button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="toast" aria-label="Fermer"></button>' +
		'</div>';

	toast.querySelector('.game-toast__message').textContent = message;
	container.appendChild(toast);

	var removeToast = function() {
		if (toast && toast.parentNode) {
			toast.parentNode.removeChild(toast);
		}
	};

	if (window.bootstrap && typeof bootstrap.Toast === 'function') {
		toast.addEventListener('hidden.bs.toast', removeToast, { once: true });
		var instance = new bootstrap.Toast(toast, {
			autohide: options.autohide !== false,
			delay: typeof options.delay === 'number' ? options.delay : 3600
		});
		instance.show();
		return instance;
	}

	$(toast).addClass('show');
	window.setTimeout(function() {
		$(toast).fadeOut(250, removeToast);
	}, typeof options.delay === 'number' ? options.delay : 3600);
	return toast;
}

var GameUI = {
	toast: function(message, type, options) {
		return showGameToast(message, type, options);
	},

	alert: function(message, callback, options) {
		return Dialog.alert(message, callback, options);
	},

	confirm: function(message, options) {
		return Dialog.confirm(message, options);
	},

	prompt: function(message, defaultValue, options) {
		return Dialog.prompt(message, defaultValue, options);
	}
};


function UhrzeitAnzeigen() {
   $(".servertime").text(getFormatedDate(serverTime.getTime(), tdformat));
}


$.widget("custom.catcomplete", $.ui.autocomplete, {
	_renderMenu: function( ul, items ) {
		var self = this,
			currentCategory = "";
		$.each( items, function( index, item ) {
			if ( item.category != currentCategory ) {
				ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
				currentCategory = item.category;
			}
			self._renderItem( ul, item );
		});
	}
});

$(function() {
	$('#drop-admin').on('click', function() {
		$.get('admin.php?page=logout', function() {
			$('.globalWarning').animate({
				'height' :0,
				'padding' :0,
				'opacity' :0
			}, function() {
				$(this).hide();
        $(this).addClass('d-none');
			});
		});
	});


	window.setInterval(function() {
		$('.countdown').each(function() {
			var s		= $(this).data('time') - (serverTime.getTime() - startTime) / 1000;
			if(s <= 0) {
				$(this).text('-');
			} else {
				$(this).text(GetRestTimeFormat(s));
			}
		});
	}, 1000);

	$('#planetSelector').on('change', function() {
		document.location = '?'+queryString+'&cp='+$(this).val();
	});

	UhrzeitAnzeigen();
	setInterval(UhrzeitAnzeigen, 1000);

	$("button#create_new_alliance_rank").click(function() {
		$("div#new_alliance_rank").dialog(		{
			draggable: false,
			resizable: false,
			modal: true,
			width: 760
		});

		return false;
	});

	$(document).on('click', 'a[data-confirm-message]', function(event) {
		event.preventDefault();

		var link = this;
		Dialog.confirm($(link).attr('data-confirm-message'), {
			title: $(link).attr('data-confirm-title') || 'Confirmation',
			confirmLabel: $(link).attr('data-confirm-confirm-label') || 'Confirmer',
			cancelLabel: $(link).attr('data-confirm-cancel-label') || 'Annuler',
			confirmClass: $(link).attr('data-confirm-variant') === 'danger' ? 'btn-danger' : 'btn-primary'
		}).then(function(confirmed) {
			if (!confirmed) {
				return;
			}

			if (link.target && link.target !== '_self') {
				window.open(link.href, link.target);
				return;
			}

			window.location.href = link.href;
		});
	});

	$(document).on('submit', 'form[data-confirm-message]', function(event) {
		event.preventDefault();

		var form = this;
		Dialog.confirm($(form).attr('data-confirm-message'), {
			title: $(form).attr('data-confirm-title') || 'Confirmation',
			confirmLabel: $(form).attr('data-confirm-confirm-label') || 'Confirmer',
			cancelLabel: $(form).attr('data-confirm-cancel-label') || 'Annuler',
			confirmClass: $(form).attr('data-confirm-variant') === 'danger' ? 'btn-danger' : 'btn-primary'
		}).then(function(confirmed) {
			if (!confirmed) {
				return;
			}

			form.submit();
		});
	});
});
