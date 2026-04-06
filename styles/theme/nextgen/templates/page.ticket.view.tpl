{block name="title" prepend}{$LNG.ti_read} - {$LNG.lm_support}{/block}
{block name="content"}
<div class="container-fluid py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<div>
			<h1 class="h3 text-white mb-1">Ticket #{$ticketID}</h1>
			<p class="text-white-50 mb-0">Consultez l’historique et répondez directement depuis cette page.</p>
		</div>
		<a class="btn btn-outline-light btn-sm" href="game.php?page=ticket">Retour à la liste</a>
	</div>

	<div class="card bg-dark border-secondary mb-4">
		<div class="card-body">
			<div class="d-flex flex-column gap-3">
				{foreach $answerList as $answerID => $answerRow}
					<div class="border border-secondary rounded-3 p-3">
						<div class="d-flex flex-wrap justify-content-between gap-2 mb-2">
							<div>
								<div class="fw-bold text-info">
									{if $answerRow@first}{$LNG.ti_read}: {$answerRow.subject}{else}{$answerRow.subject}{/if}
								</div>
								<div class="small text-white-50">
									{$LNG.ti_msgtime} {$answerRow.time} {$LNG.ti_from} {$answerRow.ownerName}
								</div>
							</div>
							{if $answerRow@first}
								<div class="small text-white-50">{$LNG.ti_category}: {$categoryList[$answerRow.categoryID]|default:'-'}</div>
							{/if}
						</div>
						<div class="text-white small rich-content" style="white-space:normal;">{$answerRow.message nofilter}</div>
					</div>
				{/foreach}
			</div>
		</div>
	</div>

	<form action="game.php?page=ticket&mode=send" method="post" id="form">
		<input type="hidden" name="id" value="{$ticketID}">
		<div class="card bg-dark border-secondary">
			<div class="card-body">
				<h2 class="h5 text-white mb-3">{$LNG.ti_answer}</h2>
				<div class="mb-3">
					<label class="form-label text-white" for="message">{$LNG.ti_message}</label>
					<textarea class="validate[required] form-control bg-dark text-white border-secondary rich-editor" id="message" name="message" rows="6"></textarea>
				</div>
				<button class="btn btn-primary" type="submit">{$LNG.ti_submit}</button>
			</div>
		</div>
	</form>
</div>
{/block}
{block name="script" append}
<script>
$(document).ready(function() {
	$("#form").validationEngine('attach');
});
</script>
{/block}
