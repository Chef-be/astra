{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Audit</span>
			<h2>Historique des messages</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">Page {$page}</span>
			<span class="admin-pill">Total {$maxPage}</span>
		</div>
	</section>

	<form action="admin.php?page=messagelist" method="post" id="form" class="admin-stack">
		<input type="hidden" name="side" value="{$page}" id="side">

		<div class="admin-table-shell">
			<div class="admin-table-toolbar">
				<div class="admin-table-toolbar__meta">
					<span class="admin-pill">Filtres</span>
				</div>
			</div>

			<div class="admin-form-grid">
				<label class="admin-field-card">
					<span>Type de message</span>
					{html_options class="form-select bg-dark text-white border-secondary" options=$categories selected=$type name="type"}
				</label>
				<label class="admin-field-card">
					<span>Expéditeur</span>
					<input class="form-control bg-dark text-white border-secondary" type="text" id="sender" name="sender" value="{$sender}" maxlength="64" placeholder="Nom du joueur">
				</label>
				<label class="admin-field-card">
					<span>Destinataire</span>
					<input class="form-control bg-dark text-white border-secondary" type="text" id="receiver" name="receiver" value="{$receiver}" maxlength="64" placeholder="Nom du joueur">
				</label>
			</div>

			<div class="admin-form-row mt-3">
				<div class="admin-field-card">
					<span>Début</span>
					<div class="d-flex gap-2">
						<input value="{$dateStart.day|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateStartDay" name="dateStart[day]" maxlength="2" placeholder="jj">
						<input value="{$dateStart.month|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateStartMonth" name="dateStart[month]" maxlength="2" placeholder="mm">
						<input value="{$dateStart.year|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateStartYear" name="dateStart[year]" maxlength="4" placeholder="aaaa">
					</div>
				</div>
				<div class="admin-field-card">
					<span>Fin</span>
					<div class="d-flex gap-2">
						<input value="{$dateEnd.day|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateEndDay" name="dateEnd[day]" maxlength="2" placeholder="jj">
						<input value="{$dateEnd.month|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateEndMonth" name="dateEnd[month]" maxlength="2" placeholder="mm">
						<input value="{$dateEnd.year|default:''}" type="text" class="form-control bg-dark text-white border-secondary" id="dateEndYear" name="dateEnd[year]" maxlength="4" placeholder="aaaa">
					</div>
				</div>
			</div>

			<div class="admin-actions mt-3">
				<button class="btn btn-primary" type="submit">Appliquer les filtres</button>
				<a class="btn btn-outline-light" href="admin.php?page=messagelist">Réinitialiser</a>
			</div>
		</div>

		<div class="admin-table-shell">
			<div class="admin-table-toolbar">
				<div class="admin-table-toolbar__meta">
					<span class="admin-pill">Résultats</span>
				</div>
				<div class="admin-table-toolbar__meta">
					{if $page != 1}
						<a class="admin-pill text-decoration-none" href="#" onclick="gotoPage({$page - 1});return false;">Page précédente</a>
					{/if}
					{for $site=1 to $maxPage}
						<a class="admin-pill text-decoration-none {if $site == $page}admin-badge-info{/if}" href="#" onclick="gotoPage({$site});return false;">{$site}</a>
					{/for}
					{if $page != $maxPage}
						<a class="admin-pill text-decoration-none" href="#" onclick="gotoPage({$page + 1});return false;">Page suivante</a>
					{/if}
				</div>
			</div>

			{if $messageList|@count > 0}
				<div class="table-responsive">
					<table class="table table-dark align-middle mb-0">
						<thead>
							<tr>
								<th style="width: 90px;">#</th>
								{if $type == 100}<th>Type</th>{/if}
								<th>Date</th>
								<th>Expéditeur</th>
								<th>Destinataire</th>
								<th>Objet</th>
							</tr>
						</thead>
						<tbody>
							{foreach $messageList as $messageID => $messageRow}
								<tr data-messageID="{$messageID}">
									<td><a href="#" class="toggle text-decoration-none fw-semibold">{$messageID}</a></td>
									{if $type == 100}<td><a href="#" class="toggle text-decoration-none">{$LNG.mg_type[$messageRow.type]}</a></td>{/if}
									<td><a href="#" class="toggle text-decoration-none">{$messageRow.time}</a></td>
									<td><a href="#" class="toggle text-decoration-none">{$messageRow.sender}</a></td>
									<td><a href="#" class="toggle text-decoration-none">{$messageRow.receiver}</a></td>
									<td>
										<a href="#" class="toggle text-decoration-none">
											{$messageRow.subject|default:'Sans objet'}
											{if $messageRow.deleted}
												<span class="badge bg-warning text-dark ms-2">Supprimé</span>
											{/if}
										</a>
									</td>
								</tr>
								<tr id="contentID{$messageID}" style="display:none;">
									<td colspan="{if $type == 100}6{else}5{/if}">
										<div class="admin-empty-state text-start">
											{$messageRow.text}
										</div>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			{else}
				<div class="admin-empty-state">
					Aucun message ne correspond aux filtres saisis.
				</div>
			{/if}
		</div>
	</form>
</div>
<script src="scripts/admin/messageList.js"></script>
{/block}
