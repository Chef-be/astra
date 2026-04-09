$(function() {
	$('#tabs').tabs();
});

function checkrename()
{
	var newname = $('#name').val();

	$.ajax({
		type: 'POST',
		url: 'game.php?page=overview&mode=rename&ajax=1&name=' + newname,
		dataType: 'json',
		success: function (data) {
			if ($.isArray(data)) {
				Dialog.alert(data, null, { title: 'Renommer la planète' });
				return;
			}

			showGameToast(data, 'success');
			if (window.parent && window.parent !== window) {
				window.parent.location.reload();
			}
		}
	});
}

function checkcancel()
{
	var password = $('#password').val();

	$.ajax({
		type: 'POST',
		url: 'game.php?page=overview&mode=delete&ajax=1&password=' + password,
		dataType: 'json',
		success: function (data) {
			if ($.isArray(data)) {
				Dialog.alert(data, null, { title: 'Abandonner la planète' });
				return;
			}

			showGameToast(data, 'success');
			if (window.parent && window.parent !== window) {
				window.parent.location.reload();
			}
		}
	});

}
