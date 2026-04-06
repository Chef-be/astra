{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h2 class="h3">Sanction du compte {$name}</h2>
			<p>Définissez le motif, la durée et l’éventuel passage en mode vacances associé à la sanction.</p>
		</div>
		<div class="admin-actions">
			<a class="btn btn-outline-light" href="?page=banned">Retour aux bannissements</a>
		</div>
	</div>

	<form action="?page=banned&mode=banUser" method="post" class="admin-card">
		<input type="hidden" name="target_id" value="{$target_id}">
		<div class="admin-card__body">
			<div class="admin-stat-strip mb-4">
				<div class="admin-stat-pill">{$bantitle}</div>
				{if !empty($timesus)}
					<div class="admin-stat-pill">Sanction déjà active</div>
				{/if}
			</div>
			<div class="admin-form-grid">
				<div class="admin-field-card">
					<label for="ban_name">{$LNG.bo_username}</label>
					<input id="ban_name" name="ban_name" type="text" value="{$name}" readonly="true" class="form-control bg-dark text-white border-secondary"/>
				</div>
				<div class="admin-field-card admin-field--full">
					<label for="ban_reason">{$LNG.bo_reason}</label>
					<textarea id="ban_reason" name="ban_reason" maxlength="50" rows="5" onkeyup="$('#result2').val(50 - parseInt($(this).val().length));" class="form-control bg-dark text-white border-secondary">{$reas}</textarea>
					<div class="small text-white-50 mt-2">{$LNG.bo_characters_1}<input id="result2" value="50" size="2" readonly="true" class="form-control d-inline-block bg-dark text-white border-secondary ms-2" style="width:70px;"></div>
				</div>
				<div class="admin-field-card">
					<div class="form-check mt-4">
						<input name="ban_permanently" type="checkbox" id="ban_permanently" class="form-check-input">
						<label for="ban_permanently" class="form-check-label">{$LNG.bo_permanent}</label>
					</div>
				</div>
				<div class="admin-field-card">
					<div class="form-check mt-4">
						<input name="vacat" type="checkbox" id="vacat" class="form-check-input"{if $vacation} checked="checked"{/if}>
						<label for="vacat" class="form-check-label">{$LNG.bo_vacation_mode}</label>
					</div>
				</div>
				<div class="admin-field-card">
					<label for="days">{$LNG.time_days}</label>
					<input id="days" name="days" type="text" value="0" class="form-control bg-dark text-white border-secondary">
				</div>
				<div class="admin-field-card">
					<label for="hour">{$LNG.time_hours}</label>
					<input id="hour" name="hour" type="text" value="0" class="form-control bg-dark text-white border-secondary">
				</div>
				<div class="admin-field-card">
					<label for="mins">{$LNG.time_minutes}</label>
					<input id="mins" name="mins" type="text" value="0" class="form-control bg-dark text-white border-secondary">
				</div>
				<div class="admin-field-card">
					<label for="secs">{$LNG.time_seconds}</label>
					<input id="secs" name="secs" type="text" value="0" class="form-control bg-dark text-white border-secondary">
				</div>
			</div>
			<div class="admin-actions mt-4">
				<input type="submit" value="{$LNG.button_submit}" name="bannow" class="btn btn-warning">
				<a class="btn btn-outline-light" href="?page=banned">Annuler</a>
			</div>
		</div>
	</form>
</div>
{/block}
