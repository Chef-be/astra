{block name="content"}

<div class="container-fluid py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Chat en temps réel</h1>
			<p class="text-white-50 mb-0">Configuration, modération et supervision du chat WebSocket.</p>
		</div>
		<div class="d-flex gap-2">
			<a class="btn btn-outline-light btn-sm" href="game.php?page=chat" target="_blank">Ouvrir le chat joueur</a>
			<a class="btn btn-outline-light btn-sm" href="{$realtimeStatus.healthUrl}" target="_blank">Santé du relais</a>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-xl-6">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<h2 class="h5 mb-0">État du relais</h2>
						<span class="badge {if $realtimeStatus.available}bg-success{else}bg-danger{/if}">
							{if $realtimeStatus.available}Disponible{else}Indisponible{/if}
						</span>
					</div>
					<div class="small text-white-50 mb-2">Point d’entrée WebSocket</div>
					<div class="border border-secondary rounded px-3 py-2 mb-3">{$realtimeStatus.endpoint}</div>
					<div class="small text-white-50 mb-2">Point de contrôle</div>
					<div class="border border-secondary rounded px-3 py-2">{$realtimeStatus.healthUrl}</div>
				</div>
			</div>
		</div>
		<div class="col-12 col-xl-6">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Modération rapide</h2>
					<form action="?page=chat&mode=mute" method="post" class="row g-3">
						<div class="col-12">
							<label class="form-label" for="target_user">Joueur ciblé</label>
							<input id="target_user" class="form-control bg-dark text-white border-secondary" name="target_user" type="text" placeholder="Pseudo, e-mail ou identifiant">
						</div>
						<div class="col-md-4">
							<label class="form-label" for="duration_minutes">Durée</label>
							<input id="duration_minutes" class="form-control bg-dark text-white border-secondary" name="duration_minutes" type="number" min="0" value="30">
							<div class="small text-white-50 mt-1">`0` pour un bannissement jusqu’à levée manuelle.</div>
						</div>
						<div class="col-md-8">
							<label class="form-label" for="reason">Motif</label>
							<input id="reason" class="form-control bg-dark text-white border-secondary" name="reason" type="text" placeholder="Ex. spam, insultes, flood">
						</div>
						<div class="col-12">
							<button class="btn btn-warning" type="submit">Appliquer la restriction</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-12 col-xl-5">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<h2 class="h5 mb-3">Paramètres</h2>
					<form action="?page=chat&mode=saveSettings" method="post" class="d-flex flex-column gap-3">
						<input type="hidden" name="opt_save" value="1">
						<div>
							<label class="form-label" for="chat_channelname">{$ch_channelname}</label>
							<input id="chat_channelname" class="form-control bg-dark text-white border-secondary" name="chat_channelname" value="{$chat_channelname}" type="text">
						</div>
						<div>
							<label class="form-label" for="chat_botname">{$ch_botname}</label>
							<input id="chat_botname" class="form-control bg-dark text-white border-secondary" name="chat_botname" value="{$chat_botname}" type="text">
						</div>
						<div class="row g-3">
							<div class="col-md-6">
								<label class="form-label" for="chat_history_limit">Historique chargé par canal</label>
								<input id="chat_history_limit" class="form-control bg-dark text-white border-secondary" name="chat_history_limit" value="{$chat_history_limit}" type="number" min="20" max="300">
							</div>
							<div class="col-md-6">
								<label class="form-label" for="chat_retention_days">Durée de conservation</label>
								<div class="input-group">
									<input id="chat_retention_days" class="form-control bg-dark text-white border-secondary" name="chat_retention_days" value="{$chat_retention_days}" type="number" min="1">
									<span class="input-group-text bg-secondary text-white border-secondary">jours</span>
								</div>
							</div>
						</div>
						<div class="form-check">
							<input id="chat_nickchange" class="form-check-input" name="chat_nickchange"{if $chat_nickchange == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_nickchange">Changement de pseudo autorisé</label>
						</div>
						<div class="form-check">
							<input id="chat_logmessage" class="form-check-input" name="chat_logmessage"{if $chat_logmessage == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_logmessage">Journaliser les messages</label>
						</div>
						<div class="form-check">
							<input id="chat_allowmes" class="form-check-input" name="chat_allowmes"{if $chat_allowmes == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_allowmes">Messages privés autorisés</label>
						</div>
						<div class="form-check">
							<input id="chat_allowdelmes" class="form-check-input" name="chat_allowdelmes"{if $chat_allowdelmes == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_allowdelmes">Suppression des messages par la modération</label>
						</div>
						<div class="form-check">
							<input id="chat_allowchan" class="form-check-input" name="chat_allowchan"{if $chat_allowchan == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_allowchan">Canaux personnalisés autorisés</label>
						</div>
						<div class="form-check">
							<input id="chat_closed" class="form-check-input" name="chat_closed"{if $chat_closed == '1'} checked="checked"{/if} type="checkbox">
							<label class="form-check-label" for="chat_closed">Fermer le chat pour les joueurs</label>
						</div>
						<div class="d-flex gap-2 flex-wrap">
							<button class="btn btn-primary" type="submit">Enregistrer</button>
							<a class="btn btn-outline-warning" href="?page=chat&mode=runRetention">Purger selon la rétention</a>
						</div>
						<div class="small text-white-50">Les échanges sont conservés en base et rechargés automatiquement lors de la reconnexion, selon la durée de conservation et le volume d’historique définis ci-dessus.</div>
					</form>
				</div>
			</div>
		</div>
		<div class="col-12 col-xl-7">
			<div class="card bg-dark border-secondary h-100">
				<div class="card-body">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<h2 class="h5 mb-0">Restrictions actives</h2>
						<span class="badge bg-secondary">{$activeMutes|@count}</span>
					</div>
					{if $activeMutes|@count > 0}
						<div class="table-responsive">
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
					{else}
						<div class="alert alert-secondary mb-0">Aucune restriction active sur le chat.</div>
					{/if}
				</div>
			</div>
		</div>
	</div>

	<div class="card bg-dark border-secondary mb-4">
		<div class="card-body">
			<div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
				<div>
					<h2 class="h5 mb-0">Canaux structurés</h2>
					<div class="small text-white-50">Le canal administrateur et le canal bots restent réservés aux administrateurs.</div>
				</div>
				<span class="badge bg-secondary">{$channelSettings|@count}</span>
			</div>
			<div class="border border-secondary rounded-3 p-3 mb-4">
				<h3 class="h6 mb-3">Créer un nouveau canal</h3>
				<form action="?page=chat&mode=createChannel" method="post" class="row g-3">
					<div class="col-md-4">
						<label class="form-label">Clé technique</label>
						<input class="form-control bg-dark text-white border-secondary" type="text" name="channel_key_new" placeholder="ex. commerce-galactique">
					</div>
					<div class="col-md-4">
						<label class="form-label">Libellé</label>
						<input class="form-control bg-dark text-white border-secondary" type="text" name="label_new" placeholder="ex. Commerce galactique">
					</div>
					<div class="col-md-4">
						<label class="form-label">Modérateur référent</label>
						<input class="form-control bg-dark text-white border-secondary" type="text" name="moderator_user_new" placeholder="Pseudo, e-mail ou identifiant">
					</div>
					<div class="col-12">
						<label class="form-label">Description</label>
						<input class="form-control bg-dark text-white border-secondary" type="text" name="description_new" placeholder="Ce canal sert à…">
					</div>
					<div class="col-12">
						<div class="form-check">
							<input id="requires_admin_new" class="form-check-input" type="checkbox" name="requires_admin_new">
							<label class="form-check-label" for="requires_admin_new">Canal réservé aux administrateurs</label>
						</div>
					</div>
					<div class="col-12">
						<button class="btn btn-outline-light btn-sm" type="submit">Créer le canal</button>
					</div>
				</form>
			</div>
			<div class="row g-3">
				{foreach from=$channelSettings item=channel}
					<div class="col-12 col-xl-6">
						<div class="border border-secondary rounded-3 p-3 h-100">
							<div class="d-flex justify-content-between align-items-start gap-3 mb-3">
								<div>
									<div class="fw-bold">{$channel.label}</div>
									<div class="small text-white-50">{$channel.description}</div>
								</div>
								<span class="badge {if $channel.is_active}bg-success{else}bg-secondary{/if}">{if $channel.is_active}Actif{else}Masqué{/if}</span>
							</div>
							<form action="?page=chat&mode=saveChannel" method="post" class="row g-3">
								<input type="hidden" name="channel_key" value="{$channel.channel_key}">
								<div class="col-md-6">
									<label class="form-label">Libellé</label>
									<input class="form-control bg-dark text-white border-secondary" type="text" name="label" value="{$channel.label|escape:'html'}">
								</div>
								<div class="col-md-6">
									<label class="form-label">Modérateur référent</label>
									<input class="form-control bg-dark text-white border-secondary" type="text" name="moderator_user" value="{$channel.moderator_name|default:''|escape:'html'}" placeholder="Pseudo, e-mail ou identifiant">
								</div>
								<div class="col-12">
									<label class="form-label">Description</label>
									<input class="form-control bg-dark text-white border-secondary" type="text" name="description" value="{$channel.description|escape:'html'}">
								</div>
								<div class="col-12">
									<div class="form-check">
										<input id="channel_access_{$channel.channel_key}" class="form-check-input" type="checkbox" name="requires_admin"{if $channel.requires_admin} checked="checked"{/if}{if $channel.is_system} disabled="disabled"{/if}>
										<label class="form-check-label" for="channel_access_{$channel.channel_key}">Canal réservé aux administrateurs</label>
									</div>
									{if $channel.is_system}
										<div class="small text-white-50 mt-1">Les canaux système conservent leurs règles d’accès.</div>
									{/if}
								</div>
								<div class="col-12">
									<div class="form-check">
										<input id="channel_{$channel.channel_key}" class="form-check-input" type="checkbox" name="is_active"{if $channel.is_active} checked="checked"{/if}>
										<label class="form-check-label" for="channel_{$channel.channel_key}">Canal visible et disponible</label>
									</div>
								</div>
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
				{/foreach}
			</div>
		</div>
	</div>

	<div class="card bg-dark border-secondary">
		<div class="card-body">
			<div class="d-flex justify-content-between align-items-center mb-3">
				<h2 class="h5 mb-0">Messages récents</h2>
				<span class="badge bg-secondary">{$recentMessages|@count}</span>
			</div>
			<div class="table-responsive">
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
								<td>
									<span class="badge {if $message.is_deleted}bg-secondary{else}bg-success{/if}">{$message.status_label}</span>
								</td>
								<td class="text-end">
									{if !$message.is_deleted}
										<form action="?page=chat&mode=deleteMessage" method="post">
											<input type="hidden" name="message_id" value="{$message.id}">
											<button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
										</form>
									{/if}
								</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

{/block}
