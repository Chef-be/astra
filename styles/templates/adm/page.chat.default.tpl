{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Relais temps réel</span>
			<strong class="admin-kpi-card__value">{if $realtimeStatus.available}En ligne{else}Hors ligne{/if}</strong>
			<span class="admin-kpi-card__meta">état courant du serveur WebSocket</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Restrictions</span>
			<strong class="admin-kpi-card__value">{$muteCountTotal}</strong>
			<span class="admin-kpi-card__meta">joueur(s) actuellement bridés</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Canaux</span>
			<strong class="admin-kpi-card__value">{$channelSettings|@count}</strong>
			<span class="admin-kpi-card__meta">espaces structurés administrés</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Messages inspectés</span>
			<strong class="admin-kpi-card__value">{$messageCountTotal}</strong>
			<span class="admin-kpi-card__meta">fenêtre récente de modération</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Pilotage du chat temps réel</h2>
					<p class="text-white-50 mb-0">Réglez le relais, la modération, la rétention et les canaux depuis une vue unique, sans basculer entre plusieurs écrans techniques.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="game.php?page=chat" target="_blank" rel="noopener">Ouvrir le chat joueur</a>
					<a class="admin-shell-action admin-shell-action--accent" href="{$realtimeStatus.healthUrl}" target="_blank" rel="noopener">Santé du relais</a>
				</div>
			</div>
		</div>
	</section>

	<section class="admin-panel-grid">
		<div class="admin-panel-grid__side admin-stack">
			<div class="admin-card">
				<div class="card-body admin-stack">
					<div class="d-flex justify-content-between align-items-start gap-3">
						<div>
							<h2 class="h5 mb-1">État du relais</h2>
							<p class="text-white-50 small mb-0">Vérification immédiate du point d’entrée et de l’URL de santé.</p>
						</div>
						<span class="badge {if $realtimeStatus.available}admin-badge-success{else}admin-badge-danger{/if}">
							{if $realtimeStatus.available}Disponible{else}Indisponible{/if}
						</span>
					</div>
					<div class="admin-surface">
						<div class="small text-white-50 mb-2">Point d’entrée WebSocket</div>
						<div class="text-break">{$realtimeStatus.endpoint}</div>
					</div>
					<div class="admin-surface">
						<div class="small text-white-50 mb-2">Point de contrôle</div>
						<div class="text-break">{$realtimeStatus.healthUrl}</div>
					</div>
				</div>
			</div>

			<div class="admin-card">
				<div class="card-body">
					<h2 class="h5 mb-3">Modération rapide</h2>
					<form action="?page=chat&mode=mute" method="post" class="d-flex flex-column gap-3">
						<div>
							<label class="form-label" for="target_user">Joueur ciblé</label>
							<input id="target_user" class="form-control bg-black text-white border-secondary" name="target_user" type="text" placeholder="Pseudo, e-mail ou identifiant">
						</div>
						<div class="row g-3">
							<div class="col-md-4">
								<label class="form-label" for="duration_minutes">Durée</label>
								<input id="duration_minutes" class="form-control bg-black text-white border-secondary" name="duration_minutes" type="number" min="0" value="30">
								<div class="small text-white-50 mt-1">0 pour une restriction permanente.</div>
							</div>
							<div class="col-md-8">
								<label class="form-label" for="reason">Motif</label>
								<input id="reason" class="form-control bg-black text-white border-secondary" name="reason" type="text" placeholder="Ex. spam, insultes, flood">
							</div>
						</div>
						<div>
							<button class="btn btn-warning" type="submit">Appliquer la restriction</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<div class="admin-panel-grid__wide admin-stack">
			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
						<div>
							<h2 class="h5 mb-1">Configuration avancée du relais</h2>
							<p class="text-white-50 mb-0">Endpoints, historique, rétention et options globales. Replié par défaut pour garder la modération au premier plan.</p>
						</div>
						<span class="admin-pill">Réglages</span>
					</div>
				</summary>
				<div class="admin-fold__body">
					<div class="admin-card">
						<div class="card-body admin-stack">
							<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
								<div>
									<h2 class="h5 mb-1">Paramètres du relais</h2>
									<p class="text-white-50 mb-0">Conservez les mêmes endpoints et noms de champs que le backend existant, mais dans une lecture beaucoup plus exploitable.</p>
								</div>
								<a class="admin-shell-action admin-shell-action--warning" href="?page=chat&mode=runRetention">Purger selon la rétention</a>
							</div>

							<form action="?page=chat&mode=saveSettings" method="post" class="admin-stack">
								<input type="hidden" name="opt_save" value="1">
								<div class="row g-3">
									<div class="col-md-6">
										<label class="form-label" for="chat_channelname">{$ch_channelname}</label>
										<input id="chat_channelname" class="form-control bg-black text-white border-secondary" name="chat_channelname" value="{$chat_channelname}" type="text">
									</div>
									<div class="col-md-6">
										<label class="form-label" for="chat_botname">{$ch_botname}</label>
										<input id="chat_botname" class="form-control bg-black text-white border-secondary" name="chat_botname" value="{$chat_botname}" type="text">
									</div>
									<div class="col-md-6">
										<label class="form-label" for="chat_history_limit">Historique chargé par canal</label>
										<input id="chat_history_limit" class="form-control bg-black text-white border-secondary" name="chat_history_limit" value="{$chat_history_limit}" type="number" min="20" max="300">
									</div>
									<div class="col-md-6">
										<label class="form-label" for="chat_retention_days">Durée de conservation</label>
										<div class="input-group">
											<input id="chat_retention_days" class="form-control bg-black text-white border-secondary" name="chat_retention_days" value="{$chat_retention_days}" type="number" min="1">
											<span class="input-group-text bg-secondary text-white border-secondary">jours</span>
										</div>
									</div>
								</div>

								<div class="admin-toggle-list">
									<label class="form-check-label"><input id="chat_nickchange" class="form-check-input me-2" name="chat_nickchange"{if $chat_nickchange == '1'} checked="checked"{/if} type="checkbox">Changement de pseudo autorisé</label>
									<label class="form-check-label"><input id="chat_logmessage" class="form-check-input me-2" name="chat_logmessage"{if $chat_logmessage == '1'} checked="checked"{/if} type="checkbox">Journaliser les messages</label>
									<label class="form-check-label"><input id="chat_allowmes" class="form-check-input me-2" name="chat_allowmes"{if $chat_allowmes == '1'} checked="checked"{/if} type="checkbox">Messages privés autorisés</label>
									<label class="form-check-label"><input id="chat_allowdelmes" class="form-check-input me-2" name="chat_allowdelmes"{if $chat_allowdelmes == '1'} checked="checked"{/if} type="checkbox">Suppression des messages par la modération</label>
									<label class="form-check-label"><input id="chat_allowchan" class="form-check-input me-2" name="chat_allowchan"{if $chat_allowchan == '1'} checked="checked"{/if} type="checkbox">Canaux personnalisés autorisés</label>
									<label class="form-check-label"><input id="chat_closed" class="form-check-input me-2" name="chat_closed"{if $chat_closed == '1'} checked="checked"{/if} type="checkbox">Fermer le chat pour les joueurs</label>
								</div>

								<section class="admin-form-submitbar">
									<div class="admin-form-submitbar__copy">
										<strong>Enregistrer la configuration chat</strong>
										<span>Le relais conserve l’historique chargé et la rétention selon les paramètres saisis ici.</span>
									</div>
									<div class="d-flex justify-content-end">
										<button class="btn btn-primary px-4" type="submit">Enregistrer</button>
									</div>
								</section>
							</form>
						</div>
					</div>
				</div>
			</details>

			<div id="chat-mutes" class="admin-card">
				<div class="card-body admin-stack">
					<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
						<div>
							<h2 class="h5 mb-1">Restrictions actives</h2>
							<p class="text-white-50 mb-0">Historique court des joueurs encore bridés avec levée manuelle immédiate.</p>
						</div>
						<span class="admin-pill">{$muteCountTotal} active(s)</span>
					</div>
					{if $activeMutes|@count > 0}
						<div class="admin-table-shell">
							<div class="table-responsive admin-scroll-region">
								<table class="table table-dark table-striped align-middle mb-0">
									<thead>
										<tr>
											<th>Joueur</th>
											<th>Motif</th>
											<th>Début</th>
											<th>Fin</th>
											<th class="text-end">Action</th>
										</tr>
									</thead>
									<tbody>
										{foreach from=$activeMutes item=mute}
											<tr>
												<td>
													<div class="fw-bold">{$mute.username|default:'Inconnu'}</div>
													<div class="small text-white-50">Par {$mute.moderator_name|default:'Administration'}</div>
												</td>
												<td>{$mute.reason}</td>
												<td>{$mute.created_at_formatted}</td>
												<td>{$mute.expires_at_formatted}</td>
												<td class="text-end">
													<form action="?page=chat&mode=unmute" method="post">
														<input type="hidden" name="mute_id" value="{$mute.id}">
														<button class="btn btn-sm btn-outline-light" type="submit">Lever</button>
													</form>
												</td>
											</tr>
										{/foreach}
									</tbody>
								</table>
							</div>
						</div>
						{if $mutePagination.total_pages > 1}
							<nav class="admin-pagination" aria-label="Pagination des restrictions">
								{if $mutePagination.has_previous}<a class="admin-pagination__link" href="{$mutePagination.previous_url}">Précédent</a>{/if}
								{foreach from=$mutePagination.pages item=item}
									<a class="admin-pagination__link {if $item.active}is-active{/if}" href="{$item.url}">{$item.number}</a>
								{/foreach}
								{if $mutePagination.has_next}<a class="admin-pagination__link" href="{$mutePagination.next_url}">Suivant</a>{/if}
							</nav>
						{/if}
					{else}
						<div class="admin-empty-state">Aucune restriction active sur le chat.</div>
					{/if}
				</div>
			</div>

			<div id="chat-messages" class="admin-card">
				<div class="card-body admin-stack">
					<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
						<div>
							<h2 class="h5 mb-1">Messages récents</h2>
							<p class="text-white-50 mb-0">Coupe courte de modération pour suppression rapide et lecture par canal.</p>
						</div>
						<span class="admin-pill">{$messageCountTotal} message(s)</span>
					</div>
					<div class="admin-table-shell">
						<div class="table-responsive admin-scroll-region">
							<table class="table table-dark table-striped align-middle mb-0">
								<thead>
									<tr>
										<th>Date</th>
										<th>Canal</th>
										<th>Joueur</th>
										<th>Message</th>
										<th>État</th>
										<th class="text-end">Action</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$recentMessages item=message}
										<tr>
											<td>{$message.created_at_formatted}</td>
											<td>{$message.channel_label}</td>
											<td>
												<div class="fw-bold">{$message.username}</div>
												<div class="small text-white-50">ID {$message.user_id}</div>
											</td>
											<td style="white-space:pre-wrap;min-width:280px;">{$message.message_text|escape:'html'}</td>
											<td><span class="badge {if $message.is_deleted}admin-badge-info{else}admin-badge-success{/if}">{$message.status_label}</span></td>
											<td class="text-end">
												{if !$message.is_deleted}
													<form action="?page=chat&mode=deleteMessage" method="post">
														<input type="hidden" name="message_id" value="{$message.id}">
														<button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
													</form>
												{/if}
											</td>
										</tr>
									{foreachelse}
										<tr>
											<td colspan="6"><div class="admin-empty">Aucun message récent disponible.</div></td>
										</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
					{if $messagePagination.total_pages > 1}
						<nav class="admin-pagination" aria-label="Pagination des messages">
							{if $messagePagination.has_previous}<a class="admin-pagination__link" href="{$messagePagination.previous_url}">Précédent</a>{/if}
							{foreach from=$messagePagination.pages item=item}
								<a class="admin-pagination__link {if $item.active}is-active{/if}" href="{$item.url}">{$item.number}</a>
							{/foreach}
							{if $messagePagination.has_next}<a class="admin-pagination__link" href="{$messagePagination.next_url}">Suivant</a>{/if}
						</nav>
					{/if}
				</div>
			</div>
		</div>
	</section>

	<details class="admin-fold admin-fold--compact">
		<summary class="admin-fold__summary">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
				<div>
					<h2 class="h5 mb-1">Canaux structurés</h2>
					<p class="text-white-50 mb-0">Le canal administrateur et le canal bots gardent leur rôle système, les autres canaux restent pilotables depuis ce tableau.</p>
				</div>
				<span class="admin-pill">{$channelSettings|@count} canal(aux)</span>
			</div>
		</summary>
		<div class="admin-fold__body">
			<section class="admin-card">
				<div class="card-body admin-stack">

					<div class="admin-card admin-channel-card">
						<div class="card-body">
							<h3 class="h6 mb-3">Créer un nouveau canal</h3>
							<form action="?page=chat&mode=createChannel" method="post" class="row g-3">
								<div class="col-md-4">
									<label class="form-label" for="channel_key_new">Clé technique</label>
									<input id="channel_key_new" class="form-control bg-black text-white border-secondary" type="text" name="channel_key_new" placeholder="ex. commerce-galactique">
								</div>
								<div class="col-md-4">
									<label class="form-label" for="label_new">Libellé</label>
									<input id="label_new" class="form-control bg-black text-white border-secondary" type="text" name="label_new" placeholder="ex. Commerce galactique">
								</div>
								<div class="col-md-4">
									<label class="form-label" for="moderator_user_new">Modérateur référent</label>
									<input id="moderator_user_new" class="form-control bg-black text-white border-secondary" type="text" name="moderator_user_new" placeholder="Pseudo, e-mail ou identifiant">
								</div>
								<div class="col-12">
									<label class="form-label" for="description_new">Description</label>
									<input id="description_new" class="form-control bg-black text-white border-secondary" type="text" name="description_new" placeholder="Ce canal sert à…">
								</div>
								<div class="col-12">
									<label class="form-check-label"><input id="requires_admin_new" class="form-check-input me-2" type="checkbox" name="requires_admin_new">Canal réservé aux administrateurs</label>
								</div>
								<div class="col-12">
									<button class="btn btn-outline-light btn-sm" type="submit">Créer le canal</button>
								</div>
							</form>
						</div>
					</div>

					<div class="row g-3">
						{foreach from=$channelSettings item=channel}
							<div class="col-12 col-xl-6">
								<div class="admin-card admin-channel-card h-100">
									<div class="card-body">
										<div class="admin-channel-card__header">
											<div>
												<div class="fw-bold">{$channel.label}</div>
												<div class="small text-white-50">{$channel.description}</div>
											</div>
											<span class="badge {if $channel.is_active}admin-badge-success{else}admin-badge-info{/if}">{if $channel.is_active}Actif{else}Masqué{/if}</span>
										</div>
										<form action="?page=chat&mode=saveChannel" method="post" class="row g-3">
											<input type="hidden" name="channel_key" value="{$channel.channel_key}">
											<div class="col-md-6">
												<label class="form-label">Libellé</label>
												<input class="form-control bg-black text-white border-secondary" type="text" name="label" value="{$channel.label|escape:'html'}">
											</div>
											<div class="col-md-6">
												<label class="form-label">Modérateur référent</label>
												<input class="form-control bg-black text-white border-secondary" type="text" name="moderator_user" value="{$channel.moderator_name|default:''|escape:'html'}" placeholder="Pseudo, e-mail ou identifiant">
											</div>
											<div class="col-12">
												<label class="form-label">Description</label>
												<input class="form-control bg-black text-white border-secondary" type="text" name="description" value="{$channel.description|escape:'html'}">
											</div>
											<div class="col-12 admin-toggle-list">
												<label class="form-check-label">
													<input id="channel_access_{$channel.channel_key}" class="form-check-input me-2" type="checkbox" name="requires_admin"{if $channel.requires_admin} checked="checked"{/if}{if $channel.is_system} disabled="disabled"{/if}>
													Canal réservé aux administrateurs
												</label>
												<label class="form-check-label">
													<input id="channel_{$channel.channel_key}" class="form-check-input me-2" type="checkbox" name="is_active"{if $channel.is_active} checked="checked"{/if}>
													Canal visible et disponible
												</label>
											</div>
											{if $channel.is_system}
												<div class="col-12 small text-white-50">Les canaux système conservent leurs règles d’accès.</div>
											{/if}
											<div class="col-12">
												<div class="d-flex gap-2 flex-wrap">
													<button class="btn btn-outline-light btn-sm" type="submit">Mettre à jour le canal</button>
													{if !$channel.is_system}
														<a class="btn btn-outline-danger btn-sm" href="?page=chat&mode=deleteChannel&channel_key={$channel.channel_key|escape:'url'}" onclick="return confirm('Supprimer ce canal personnalisé ?');">Supprimer le canal</a>
													{/if}
												</div>
											</div>
										</form>
									</div>
								</div>
							</div>
						{/foreach}
					</div>
				</div>
			</section>
		</div>
	</details>
</div>
{/block}
