{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Publication</span>
			<h2>Actualités du jeu</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">Articles {$NewsList|@count}</span>
			<a class="btn btn-primary" href="admin.php?page=news&amp;mode=create">Nouvelle actualité</a>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">Liste</span>
			</div>
		</div>

		{if $NewsList|@count > 0}
			<div class="table-responsive">
				<table class="table table-dark align-middle mb-0">
					<thead>
						<tr>
							<th>ID</th>
							<th>Titre</th>
							<th>Date</th>
							<th>Auteur</th>
							<th class="text-end">Actions</th>
						</tr>
					</thead>
					<tbody>
						{foreach name=NewsList item=NewsRow from=$NewsList}
							<tr>
								<td class="fw-semibold">{$NewsRow.id}</td>
								<td><a class="text-decoration-none fw-semibold" href="admin.php?page=news&amp;mode=edit&amp;id={$NewsRow.id}">{$NewsRow.title}</a></td>
								<td>{$NewsRow.date}</td>
								<td>{$NewsRow.user}</td>
								<td class="text-end">
									<div class="d-flex justify-content-end gap-2">
										<a class="btn btn-sm btn-outline-light" href="admin.php?page=news&amp;mode=edit&amp;id={$NewsRow.id}">Modifier</a>
										<a class="btn btn-sm btn-outline-danger" href="admin.php?page=news&amp;mode=delete&amp;id={$NewsRow.id}" onclick="return confirm('{$NewsRow.confirm}');">Supprimer</a>
									</div>
								</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{else}
			<div class="admin-empty-state">
				Aucune actualité n’a encore été publiée.
			</div>
		{/if}
	</div>
</div>
{/block}
