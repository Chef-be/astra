$(document).ready(function()
{
	function updateTemporaryBonusPanel() {
		var entries = $('.temporary-bonus-entry');
		var remaining = entries.length;
		var panel = $('.temporary-bonus-panel');
		var countNode = $('.temporary-bonus-count');

		if (!countNode.length) {
			return;
		}

		countNode.text(remaining + ' actif' + (remaining > 1 ? 's' : ''));

		if (remaining <= 0 && panel.length) {
			panel.remove();
		}
	}

	window.setInterval(function() {
		$('.fleets').each(function() {
			var s		= $(this).data('fleet-time') - (serverTime.getTime() - startTime) / 1000;
			if(s <= 0) {
				$(this).text('-');
			} else {
				$(this).text(GetRestTimeFormat(s));
			}
		})
	}, 1000);
	
	window.setInterval(function() {
		$('.timer').each(function() {
			var s		= $(this).data('time') - (serverTime.getTime() - startTime) / 1000;
			if(s == 0) {
				window.location.href = "game.php?page=overview";
			} else {
				$(this).text(GetRestTimeFormat(s));
			}
		});
	}, 1000);

	window.setInterval(function() {
		$('.temporary-bonus-timer').each(function() {
			var s = $(this).data('time') - (serverTime.getTime() - startTime) / 1000;
			if (s <= 0) {
				$(this).closest('.temporary-bonus-entry').remove();
				updateTemporaryBonusPanel();
			} else {
				$(this).text(GetRestTimeFormat(s));
			}
		});
	}, 1000);

	updateTemporaryBonusPanel();
});
