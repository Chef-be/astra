{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Détection technique</span>
			<h1 class="admin-hero__title">Multi-comptes et recouvrements IP</h1>
			<p class="admin-hero__subtitle">Visualisez rapidement les comptes partageant une même adresse IP et marquez les cas connus pour le suivi d’exploitation.</p>
		</div>
		<div class="admin-stat-strip">
			<div class="admin-stat-card">
				<span class="admin-stat-card__label">Groupes IP</span>
				<strong class="admin-stat-card__value">{$multiGroups|@count}</strong>
			</div>
		</div>
	</section>

	{if $multiGroups|@count > 0}
		<div class="admin-stack">
			{foreach $multiGroups as $IP => $Users name=multiGroupLoop}
				<details class="admin-fold admin-fold--compact" {if $smarty.foreach.multiGroupLoop.iteration <= 2}open{/if}>
					<summary class="admin-fold__summary">
						<div>
							<h2 class="h5 mb-1"><code>{$IP}</code></h2>
							<p class="text-white-50 mb-0">{$Users|@count} compte(s) liés à cette adresse IP.</p>
						</div>
						<div class="admin-table-toolbar__meta">
							<span class="admin-pill">IP surveillée</span>
						</div>
					</summary>
					<div class="admin-fold__body">
						<div class="admin-table-shell">
							<div class="table-responsive admin-table-responsive--tall">
								<table class="table table-dark align-middle mb-0">
									<thead>
										<tr>
											<th>ID</th>
											<th>Compte</th>
											<th>Adresse électronique</th>
											<th>Inscription</th>
											<th>Dernière activité</th>
											<th class="text-end">Suivi</th>
										</tr>
									</thead>
									<tbody>
										{foreach $Users as $ID => $User}
											<tr>
												<td class="fw-semibold">{$ID}</td>
												<td>
													<a class="text-decoration-none fw-semibold" href="admin.php?page=accountdata&id_u={$ID}">{$User.username}</a>
												</td>
												<td>{$User.email}</td>
												<td>{$User.register_time}</td>
												<td>{$User.onlinetime}</td>
												<td class="text-end">
													{if $User.isKnown != 0}
														<a class="btn btn-sm btn-outline-success" href="admin.php?page=multi&amp;mode=unknown&amp;id={$ID}">Marqué comme connu</a>
													{else}
														<a class="btn btn-sm btn-outline-warning" href="admin.php?page=multi&amp;mode=known&amp;id={$ID}">Marquer comme connu</a>
													{/if}
												</td>
											</tr>
										{/foreach}
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</details>
			{/foreach}
		</div>
	{else}
		<div class="admin-table-shell">
			<div class="admin-empty-state">
				Aucun recouvrement IP suspect n’a été détecté pour le moment.
			</div>
		</div>
	{/if}
</div>
{/block}
