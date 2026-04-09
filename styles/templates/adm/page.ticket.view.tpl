{block name="content"}

<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Support</span>
			<h2>Ticket #{$ticketID}</h2>
		</div>
		<div class="admin-headerline__actions">
			<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=support">Retour à la liste</a>
		</div>
	</section>

	<section class="admin-panel-grid">
		<div class="admin-panel-grid__wide">
			<div class="admin-card">
				<div class="admin-card__body admin-ticket-thread">
					{foreach $answerList as $answerID => $answerRow}
						<article class="admin-ticket-entry {if $answerRow@first}admin-ticket-entry--lead{/if}">
							<div class="admin-ticket-entry__meta">
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
							<div class="admin-ticket-entry__body rich-content">{$answerRow.message nofilter}</div>
						</article>
					{/foreach}
				</div>
			</div>
		</div>

		<aside class="admin-panel-grid__side">
			<form action="admin.php?page=support&mode=send" method="post" id="form" class="admin-card">
				<input type="hidden" name="id" value="{$ticketID}">
				<div class="admin-card__body admin-stack">
					<h2 class="h5 mb-0">{$LNG.ti_answer}</h2>
					<div class="admin-field-card">
						<label class="form-label" for="message">{$LNG.ti_message}</label>
						<textarea class="validate[required] form-control bg-dark text-white border-secondary rich-editor" id="message" name="message" rows="8"></textarea>
					</div>
					<div class="admin-field-card">
						<span>Statut</span>
						<div class="form-check mb-0">
							<input class="form-check-input" type="checkbox" name="change_status" value="1" id="change_status">
							<label class="form-check-label" for="change_status">{if $ticket_status < 2}{$LNG.ti_close}{else}{$LNG.ti_open}{/if}</label>
						</div>
					</div>
					<button class="btn btn-primary" type="submit">{$LNG.ti_submit}</button>
				</div>
			</form>
		</aside>
	</section>
</div>

{/block}
