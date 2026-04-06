function instant(event){
	if (event.keyCode == $.ui.keyCode.ENTER) {
		event.preventDefault();
	}
	
	if ($.inArray(event.keyCode, [
		91, // WINDOWS
		18, // ALT
		20, // CAPS_LOCK
		188, // COMMA
		91, // COMMAND
		91, // COMMAND_LEFT
		93, // COMMAND_RIGHT
		17, // CONTROL
		40, // DOWN
		35, // END
		13, // ENTER
		27, // ESCAPE
		36, // HOME
		45, // INSERT
		37, // LEFT
		93, // MENU
		107, // NUMPAD_ADD
		110, // NUMPAD_DECIMAL
		111, // NUMPAD_DIVIDE
		108, // NUMPAD_ENTER
		106, // NUMPAD_MULTIPLY
		109, // NUMPAD_SUBTRACT
		34, // PAGE_DOWN
		33, // PAGE_UP
		190, // PERIOD
		39, // RIGHT
		16, // SHIFT
		32, // SPACE
		9, // TAB
		38, // UP
		91 // WINDOWS
	]) !== -1) {
		return;
	}
	
	var searchText = $('#searchtext').val();
	if(searchText.trim() === '') {
		$('#searchResults').html('<div class="search-results-placeholder">Saisissez au moins quelques caractères pour lancer une recherche dans l’univers.</div>');
		$('#loading').hide();
		return;
	}

	$('#loading').show();
	$.get('game.php?page=search&mode=result&type='+$('#type').val()+'&search='+encodeURIComponent(searchText)+'&ajax=1', function(data) {
		$('#searchResults').html(data);
		$('#loading').hide();
	});
}

$(document).ready(function() {
	$('#searchtext').on('keyup', instant);
	$('#type').on('change', instant);
	$('#searchButton').on('click', function() {
		instant({ keyCode: 0, preventDefault: function() {} });
	});
});
