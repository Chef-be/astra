<form action="?page=fleetTable&amp;action=acs" method="post" class="fleet-acs-form">
	<input name="fleetID" value="{$acsData.mainFleetID}" type="hidden">

	<div class="fleet-acs-grid">
		<section class="fleet-acs-card fleet-acs-card--wide">
			<div class="fleet-acs-card__head">
				<div>
					<span class="fleet-acs-card__eyebrow">{$LNG.fl_sac_of_fleet}</span>
					<h3>{$acsData.acsName}</h3>
				</div>
				<button type="button" class="btn btn-sm btn-outline-light" onclick="Rename();">{$LNG.fl_acs_change}</button>
			</div>

			<div class="fleet-acs-name" id="acsName">{$acsData.acsName}</div>

			{if !empty($acsData.statusMessage)}
			<div class="fleet-acs-status">
				{$acsData.statusMessage}
			</div>
			{/if}

			<div class="fleet-acs-select-shell">
				<label class="form-label" for="fleetAcsInvited">{$LNG.fl_members_invited}</label>
				<select id="fleetAcsInvited" class="form-select bg-dark text-white border-secondary" size="6">
					{html_options options=$acsData.invitedUsers}
				</select>
			</div>
		</section>

		<section class="fleet-acs-card">
			<div class="fleet-acs-card__head">
				<div>
					<span class="fleet-acs-card__eyebrow">{$LNG.fl_invite_members}</span>
					<h3>Ajouter un joueur</h3>
				</div>
			</div>
			<label class="form-label" for="fleetAcsUsername">Pseudo</label>
			<input id="fleetAcsUsername" class="form-control bg-dark text-white border-secondary" name="username" type="text" autocomplete="off">
			<input class="btn btn-primary mt-3" type="submit" value="{$LNG.fl_continue}">
		</section>
	</div>
</form>

<script type="text/javascript">
function Rename(){
	Dialog.prompt("{$LNG.fl_acs_change_name|escape:'javascript'}", "{$acsData.acsName|escape:'javascript'}", {
		title: 'ACS',
		confirmLabel: 'Renommer'
	}).then(function(Name) {
		if (Name === null) {
			return;
		}

		$.getJSON('?page=fleetTable&action=acs&fleetID={$acsData.mainFleetID}&acsName=' + encodeURIComponent(Name), function(data) {
			if(data != "") {
				Dialog.alert(data, null, { title: 'ACS' });
				return;
			}
			$('#acsName').text(Name);
			showGameToast('Nom ACS mis à jour.', 'success');
		});
	});
}
</script>
