var Gate	= {
	max: function(ID) {
		$('#ship'+ID+'_input').val($('#ship'+ID+'_value').text().replace(/\./g, ""));
	},
	
	submit: function() {
		$.getJSON('?page=information&mode=sendFleet&'+$('.jumpgate').serialize(), function(data) {
			showGameToast(data.message, data.error ? 'danger' : 'success');
			if(!data.error)
			{
				parent.$.fancybox.close();
			}
		});		
	}
}
