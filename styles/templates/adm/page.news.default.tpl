{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Publication</span>
			<h1 class="admin-hero__title">Actualités du jeu</h1>
			<p class="admin-hero__subtitle">Rédigez, mettez à jour et retirez les actualités visibles sur la page publique sans casser la présentation existante.</p>
		</div>
		<div class="admin-stat-strip">
			<div class="admin-stat-card">
				<span class="admin-stat-card__label">Articles publiés</span>
				<strong class="admin-stat-card__value">{$NewsList|@count}</strong>
			</div>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div>
				<h2 class="h5 mb-1">Liste des actualités</h2>
				<p class="text-white-50 mb-0">L’éditeur riche sombre reste cohérent avec le thème d’administration.</p>
			</div>
			<a class="btn btn-primary" href="admin.php?page=news&amp;mode=create">Nouvelle actualité</a>
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
