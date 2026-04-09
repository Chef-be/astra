{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-headerline">
		<div class="admin-headerline__lead">
			<span class="admin-headerline__eyebrow">Validation des comptes</span>
			<h1 class="admin-headerline__title">Comptes en attente d’activation</h1>
		</div>
		<div class="admin-headerline__meta">
			<span class="admin-pill">{$pendingCount|default:0} en attente</span>
			<span class="admin-pill">Univers {$uni}</span>
		</div>
	</section>

	<div class="admin-table-shell">
		<div class="admin-table-toolbar">
			<div>
				<h2 class="h5 mb-1">File de validation</h2>
			</div>
			<div class="admin-table-toolbar__meta">
				<span class="admin-pill">{$pendingCount|default:0} compte(s) à traiter</span>
			</div>
		</div>

		{if $Users|@count > 0}
			<div class="table-responsive">
				<table class="table table-dark align-middle mb-0">
					<thead>
						<tr>
							<th>#</th>
							<th>Compte</th>
							<th>Inscription</th>
							<th>Adresse électronique</th>
							<th>Adresse IP</th>
							<th class="text-end">Actions</th>
						</tr>
					</thead>
					<tbody>
						{foreach from=$Users item=User}
							<tr data-validation-id="{$User.id}">
								<td class="fw-semibold">{$User.id}</td>
								<td>
									<div class="fw-semibold">{$User.name}</div>
									<div class="text-white-50 small">Clé : {$User.validationKey}</div>
								</td>
								<td>{$User.date}</td>
								<td>{$User.email}</td>
								<td><code>{$User.ip}</code></td>
								<td class="text-end">
									<div class="d-flex justify-content-end gap-2 flex-wrap">
										<button
											type="button"
											class="btn btn-success btn-sm js-activate-user"
											data-id="{$User.id}"
											data-key="{$User.validationKey|escape:'html'}">
											Activer
										</button>
										<a class="btn btn-outline-danger btn-sm" href="admin.php?page=active&amp;mode=delete&amp;id={$User.id}" onclick="return confirm('Supprimer définitivement la demande de {$User.username|escape:'html'} ?');">
											Supprimer
										</a>
									</div>
								</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{else}
			<div class="admin-empty-state">
				Aucun compte n’est actuellement en attente de validation.
			</div>
		{/if}
	</div>
</div>

<script>
$(function() {
	$('.js-activate-user').on('click', function () {
		var button = $(this);
		var validationId = button.data('id');
		var validationKey = button.data('key');
		button.prop('disabled', true).text('Activation…');

		$.getJSON('index.php?page=vertify&mode=json&i=' + validationId + '&k=' + encodeURIComponent(validationKey))
			.done(function (message) {
				alert(message);
				window.location.reload();
			})
			.fail(function () {
				alert('L’activation a échoué. Vérifiez les journaux puis réessayez.');
				button.prop('disabled', false).text('Activer');
			});
	});
});
</script>
{/block}
