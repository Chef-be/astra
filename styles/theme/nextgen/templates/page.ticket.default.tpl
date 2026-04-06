{block name="title" prepend}{$LNG.lm_support}{/block}
{block name="content"}
<div class="container-fluid py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<div>
			<h1 class="h3 text-white mb-1">{$LNG.lm_support}</h1>
			<p class="text-white-50 mb-0">Consultez vos tickets et échangez avec l’équipe de support.</p>
		</div>
		<a class="btn btn-primary" href="game.php?page=ticket&amp;mode=create">{$LNG.ti_new}</a>
	</div>

	<div class="card bg-dark border-secondary">
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-dark table-striped align-middle mb-0">
					<thead>
						<tr>
							<th>{$LNG.ti_id}</th>
							<th>{$LNG.ti_subject}</th>
							<th>{$LNG.ti_answers}</th>
							<th>{$LNG.ti_date}</th>
							<th>{$LNG.ti_status}</th>
						</tr>
					</thead>
					<tbody>
						{foreach $ticketList as $TicketID => $TicketInfo}
						<tr>
							<td><a class="text-white text-decoration-none" href="game.php?page=ticket&amp;mode=view&amp;id={$TicketID}">#{$TicketID}</a></td>
							<td><a class="text-white text-decoration-none" href="game.php?page=ticket&amp;mode=view&amp;id={$TicketID}">{$TicketInfo.subject}</a></td>
							<td>{$TicketInfo.answer - 1}</td>
							<td>{$TicketInfo.time}</td>
							<td>{if $TicketInfo.status == 0}<span class="badge bg-success">{$LNG.ti_status_open}</span>{elseif $TicketInfo.status == 1}<span class="badge bg-warning text-dark">{$LNG.ti_status_answer}</span>{else}<span class="badge bg-danger">{$LNG.ti_status_closed}</span>{/if}</td>
						</tr>
						{foreachelse}
						<tr>
							<td colspan="5" class="text-center text-white-50 py-4">Aucun ticket pour le moment.</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
{/block}
