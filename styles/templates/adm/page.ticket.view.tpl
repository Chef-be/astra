{block name="content"}

<div class="container-fluid py-4 text-white">
	<div class="admin-toolbar mb-4">
		<div class="admin-mini-hero flex-grow-1">
			<h1 class="h3 mb-1">Ticket #{$ticketID}</h1>
			<p class="text-white-50 mb-0">Lecture complète, réponse et changement d’état.</p>
		</div>
		<a class="btn btn-outline-light btn-sm" href="admin.php?page=support">Retour à la liste</a>
	</div>

	<div class="admin-card mb-4">
		<div class="admin-card__body d-flex flex-column gap-3">
			{foreach $answerList as $answerID => $answerRow}
				<div class="admin-field-card">
					<div class="d-flex flex-wrap justify-content-between gap-2 mb-2">
						<div>
							<div class="fw-bold text-info">{if $answerRow@first}{$LNG.ti_read} : {$answerRow.subject}{else}{$answerRow.subject}{/if}</div>
							<div class="small text-white-50">
								{if $answerRow@first}{$LNG.ti_create}{else}{$LNG.ti_responded}{/if} : {$answerRow.time} {$LNG.ti_from} {$answerRow.ownerName}
							</div>
						</div>
						{if $answerRow@first}
							<div class="small text-white-50">{$LNG.ti_category}: {$categoryList[$answerRow.categoryID]|default:'-'}</div>
						{/if}
					</div>
					<div class="small text-white rich-content" style="white-space:normal;">{$answerRow.message nofilter}</div>
				</div>
			{/foreach}
		</div>
	</div>

	<form action="admin.php?page=support&mode=send" method="post" id="form">
		<input type="hidden" name="id" value="{$ticketID}">
		<div class="admin-card">
			<div class="admin-card__body">
				<h2 class="h5 mb-3">{$LNG.ti_answer}</h2>
				<div class="mb-3">
					<label class="form-label" for="message">{$LNG.ti_message}</label>
					<textarea class="validate[required] form-control bg-dark text-white border-secondary rich-editor" id="message" name="message" rows="6"></textarea>
				</div>
				<div class="form-check mb-3">
					<input class="form-check-input" type="checkbox" name="change_status" value="1" id="change_status">
					<label class="form-check-label" for="change_status">{if $ticket_status < 2}{$LNG.ti_close}{else}{$LNG.ti_open}{/if}</label>
				</div>
				<button class="btn btn-primary" type="submit">{$LNG.ti_submit}</button>
			</div>
		</div>
	</form>
</div>

{/block}
