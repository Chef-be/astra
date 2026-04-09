{block name="content"}

<div class="admin-settings-shell admin-stack admin-support-page">
	<section class="admin-support-strip">
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Ouverts</span>
			<strong class="admin-kpi-card__value">{$ticketSummary.open}</strong>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">En attente</span>
			<strong class="admin-kpi-card__value">{$ticketSummary.answer}</strong>
		</article>
		<article class="admin-kpi-card admin-kpi-card--micro">
			<span class="admin-kpi-card__label">Clôturés</span>
			<strong class="admin-kpi-card__value">{$ticketSummary.closed}</strong>
		</article>
		<section class="admin-card admin-support-control">
			<div class="admin-card__body">
				<div class="admin-support-control__meta">
					<span class="admin-kpi-card__label">Tickets</span>
					<strong>{$ticketSummary.total}</strong>
				</div>
				<form action="admin.php?page=support&amp;mode=purgeAll" method="post" onsubmit="return confirm('Supprimer tous les tickets, toutes les réponses et réinitialiser les compteurs ?');">
					<button type="submit" class="btn btn-outline-danger">Tout supprimer</button>
				</form>
			</div>
		</section>
	</section>

	<div class="admin-table-shell admin-table-shell--support">
		<form action="admin.php?page=support&amp;mode=bulk" method="post" id="supportBulkForm">
		<div class="admin-table-toolbar admin-table-toolbar--support">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Tickets récents en tête</span>
				<span class="admin-pill">{$ticketSummary.total} élément(s)</span>
			</div>
			<div class="admin-actions admin-actions--support">
				<select name="bulkAction" id="supportBulkAction" class="form-select bg-dark text-white border-secondary">
					<option value="">Action de masse</option>
					<option value="answer">Prendre en charge</option>
					<option value="reopen">Rouvrir</option>
					<option value="close">Clôturer</option>
					<option value="delete">Supprimer</option>
				</select>
				<button type="submit" class="btn btn-primary" onclick="return astraSubmitSupportBulk();">Appliquer</button>
			</div>
		</div>
		<div class="card-body px-0 py-0">
			<div class="table-responsive admin-scroll-region">
				<table class="table table-dark table-striped align-middle mb-0">
					<thead>
						<tr>
							<th style="width:48px;"><input type="checkbox" class="form-check-input" id="supportSelectAll"></th>
							<th>{$LNG.ti_id}</th>
							<th>{$LNG.ti_username}</th>
							<th>{$LNG.ti_subject}</th>
							<th>{$LNG.ti_answers}</th>
							<th>{$LNG.ti_date}</th>
							<th>{$LNG.ti_status}</th>
							<th class="text-end">Actions</th>
						</tr>
					</thead>
					<tbody>
						{foreach $ticketList as $TicketID => $TicketInfo}
						<tr>
							<td><input type="checkbox" class="form-check-input support-ticket-checkbox" name="ticketIds[]" value="{$TicketID}"></td>
							<td><a class="text-white text-decoration-none fw-semibold" href="admin.php?page=support&amp;mode=view&amp;id={$TicketID}">#{$TicketID}</a></td>
							<td><a class="text-white text-decoration-none" href="admin.php?page=support&amp;mode=view&amp;id={$TicketID}">{$TicketInfo.username}</a></td>
							<td style="max-width:320px;">
								<a class="text-white text-decoration-none d-inline-block" href="admin.php?page=support&amp;mode=view&amp;id={$TicketID}">
									{$TicketInfo.subject}
								</a>
							</td>
							<td>{$TicketInfo.replyCount}</td>
							<td>{$TicketInfo.time}</td>
							<td>
								{if $TicketInfo.status == 0}
									<span class="badge admin-badge-success">{$LNG.ti_status_open}</span>
								{elseif $TicketInfo.status == 1}
									<span class="badge admin-badge-warning">{$LNG.ti_status_answer}</span>
								{else}
									<span class="badge admin-badge-danger">{$LNG.ti_status_closed}</span>
								{/if}
							</td>
							<td class="text-end">
								<div class="btn-group btn-group-sm" role="group" aria-label="Actions ticket {$TicketID}">
									<a class="btn btn-outline-light" href="admin.php?page=support&amp;mode=view&amp;id={$TicketID}" title="Ouvrir le fil">
										<i class="bi bi-eye"></i>
									</a>
									<a class="btn btn-outline-info" href="admin.php?page=support&amp;mode=quick&amp;action=answer&amp;id={$TicketID}" title="Prendre en charge">
										<i class="bi bi-reply-fill"></i>
									</a>
									<a class="btn btn-outline-warning" href="admin.php?page=support&amp;mode=quick&amp;action=reopen&amp;id={$TicketID}" title="Rouvrir">
										<i class="bi bi-arrow-counterclockwise"></i>
									</a>
									<a class="btn btn-outline-success" href="admin.php?page=support&amp;mode=quick&amp;action=close&amp;id={$TicketID}" title="Clôturer">
										<i class="bi bi-check2-circle"></i>
									</a>
									<a class="btn btn-outline-danger" href="admin.php?page=support&amp;mode=quick&amp;action=delete&amp;id={$TicketID}" title="Supprimer" onclick="return confirm('Supprimer ce ticket et toutes ses réponses ?');">
										<i class="bi bi-trash3"></i>
									</a>
								</div>
							</td>
						</tr>
						{foreachelse}
						<tr>
							<td colspan="8" class="text-center text-white-50 py-4">Aucun ticket à afficher.</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>

<script>
function astraSubmitSupportBulk() {
	var action = document.getElementById('supportBulkAction');
	var selected = document.querySelectorAll('.support-ticket-checkbox:checked').length;
	if (!action || action.value === '') {
		return false;
	}
	if (selected === 0) {
		return false;
	}
	if (action.value === 'delete') {
		return confirm('Supprimer les tickets sélectionnés et toutes leurs réponses ?');
	}
	return true;
}

document.addEventListener('DOMContentLoaded', function() {
	var selectAll = document.getElementById('supportSelectAll');
	if (!selectAll) {
		return;
	}

	selectAll.addEventListener('change', function() {
		document.querySelectorAll('.support-ticket-checkbox').forEach(function(checkbox) {
			checkbox.checked = selectAll.checked;
		});
	});
});
</script>

{/block}
