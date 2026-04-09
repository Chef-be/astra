{block name="title" prepend}Notifications{/block}
{block name="content"}
<div class="notifications-page notifications-page--compact">
	<section class="notifications-strip">
		<h1>Notifications</h1>
		<div class="notifications-strip__actions">
			<a class="btn btn-outline-light btn-sm" href="game.php?page=messages">Messages</a>
			<a class="btn btn-warning btn-sm" href="game.php?page=notifications&mode=markAllRead">Tout lire</a>
		</div>
	</section>

	<section class="notifications-list notifications-list--compact">
		{if $notificationItems|@count > 0}
			{foreach from=$notificationItems item=item}
			<article class="notification-card notification-card--compact {if !$item.is_read}is-unread{/if}">
				<div class="notification-card__header notification-card__header--compact">
					<div class="notification-card__heading">
						<div class="notification-card__type">{$item.notification_type|replace:'_':' '}</div>
						<h2>{$item.title|escape:'html'}</h2>
					</div>
					<div class="notification-card__meta notification-card__meta--compact">
						<span class="notification-card__date">{$item.created_at|date_format:'%d/%m/%Y %H:%M'}</span>
						<span class="badge {if $item.is_read}bg-secondary{else}bg-warning text-dark{/if}">
							{if $item.is_read}Lue{else}Non lue{/if}
						</span>
					</div>
				</div>
				<div class="notification-card__body notification-card__body--compact">{$item.body|escape:'html'}</div>
				<div class="notification-card__actions notification-card__actions--compact">
					{if !$item.is_read}
					<a class="btn btn-outline-light btn-sm" href="game.php?page=notifications&mode=markRead&id={$item.id}">Lire</a>
					{/if}
					{if !empty($item.link_url)}
					<a class="btn btn-primary btn-sm" href="{$item.link_url|escape:'html'}">Ouvrir</a>
					{/if}
				</div>
			</article>
			{/foreach}
		{else}
			<div class="notifications-empty-state notifications-empty-state--compact">
				<strong>Aucune notification</strong>
			</div>
		{/if}
	</section>
</div>
{/block}
