{block name="title" prepend}Notifications{/block}
{block name="content"}
<div class="container py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Centre des notifications</h1>
			<p class="text-white-50 mb-0">Consultez vos notifications en temps réel, lues ou non lues, depuis une interface dédiée.</p>
		</div>
		<div class="d-flex gap-2 flex-wrap">
			<a class="btn btn-outline-light btn-sm" href="game.php?page=messages">Messagerie joueur</a>
			<a class="btn btn-warning btn-sm" href="game.php?page=notifications&mode=markAllRead">Marquer toutes comme lues</a>
		</div>
	</div>

	<div class="row g-3">
		{if $notificationItems|@count > 0}
			{foreach from=$notificationItems item=item}
				<div class="col-12">
					<div class="card bg-dark border-secondary {if !$item.is_read}border-warning{/if}">
						<div class="card-body">
							<div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-2">
								<div>
									<div class="small text-uppercase text-white-50">{$item.notification_type}</div>
									<h2 class="h5 mb-1">{$item.title|escape:'html'}</h2>
								</div>
								<div class="d-flex gap-2 align-items-center">
									<span class="badge {if $item.is_read}bg-secondary{else}bg-warning text-dark{/if}">
										{if $item.is_read}Lue{else}Non lue{/if}
									</span>
									<span class="small text-white-50">{$item.created_at|date_format:'%d/%m/%Y %H:%M'}</span>
								</div>
							</div>
							<div class="small text-white" style="white-space:pre-wrap;">{$item.body|escape:'html'}</div>
							<div class="d-flex gap-2 flex-wrap mt-3">
								{if !$item.is_read}
									<a class="btn btn-outline-light btn-sm" href="game.php?page=notifications&mode=markRead&id={$item.id}">Marquer comme lue</a>
								{/if}
								{if !empty($item.link_url)}
									<a class="btn btn-primary btn-sm" href="{$item.link_url|escape:'html'}">Ouvrir</a>
								{/if}
							</div>
						</div>
					</div>
				</div>
			{/foreach}
		{else}
			<div class="col-12">
				<div class="alert alert-secondary mb-0">Aucune notification n’a encore été enregistrée pour ce compte.</div>
			</div>
		{/if}
	</div>
</div>
{/block}
