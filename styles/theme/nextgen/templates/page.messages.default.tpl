{block name="title" prepend}{$LNG.lm_messages}{/block}
{block name="content"}
<style>
	.messages-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.messages-hero {
		display: grid;
		grid-template-columns: 1fr;
		gap: 1rem;
		padding: 1.1rem 1.2rem;
		border-radius: 1.2rem;
		border: 1px solid rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.18), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
		box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.24);
		align-items: end;
	}

	.messages-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.messages-hero p {
		margin: 0;
		max-width: none;
		color: rgba(255, 255, 255, 0.74);
		line-height: 1.55;
	}

	.messages-hero-stats {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.7rem;
	}

	.messages-stat {
		padding: 0.75rem 0.8rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.messages-stat-label {
		display: block;
		margin-bottom: 0.18rem;
		font-size: 0.72rem;
		color: rgba(255, 255, 255, 0.58);
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}

	.messages-stat-value {
		display: block;
		font-size: 1.15rem;
		font-weight: 700;
		color: #f8fbff;
	}

	.messages-layout {
		display: grid;
		grid-template-columns: 1fr;
		gap: 0.9rem;
		align-items: start;
	}

	.messages-panel {
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.messages-sidebar {
		padding: 0.95rem;
	}

	.messages-sidebar h2,
	.messages-main-head h2 {
		margin: 0;
		color: #ffd666;
		font-size: 1rem;
	}

	.messages-sidebar-note {
		margin: 0.25rem 0 0.9rem;
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.82rem;
	}

	.messages-folder-list {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.6rem;
	}

	.messages-folder {
		display: block;
		padding: 0.8rem 0.85rem;
		border-radius: 0.95rem;
		text-decoration: none;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
		transition: border-color 0.15s ease, background 0.15s ease;
	}

	.messages-folder:hover,
	.messages-folder.is-active {
		border-color: rgba(255, 214, 102, 0.2);
		background: rgba(255, 214, 102, 0.06);
	}

	.messages-folder-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		margin-bottom: 0.28rem;
	}

	.messages-folder-title {
		font-size: 0.92rem;
		font-weight: 700;
	}

	.messages-folder-note {
		color: rgba(255, 255, 255, 0.58);
		font-size: 0.78rem;
		line-height: 1.4;
	}

	.messages-count {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-width: 28px;
		height: 28px;
		padding: 0 0.5rem;
		border-radius: 999px;
		font-size: 0.75rem;
		font-weight: 700;
		background: rgba(255, 255, 255, 0.08);
		color: #f3f7ff;
	}

	.messages-count.is-unread {
		background: rgba(255, 92, 92, 0.18);
		color: #ffbcbc;
	}

	.messages-main {
		display: grid;
		gap: 0.85rem;
		padding: 0.95rem;
	}

	.messages-main-head {
		display: flex;
		flex-wrap: wrap;
		align-items: end;
		justify-content: space-between;
		gap: 0.8rem;
	}

	.messages-main-meta {
		margin-top: 0.2rem;
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.82rem;
	}

	.messages-pagination {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
	}

	.messages-toolbar {
		display: grid;
		grid-template-columns: minmax(0, 1fr) 150px;
		gap: 0.7rem;
		padding: 0.8rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.messages-toolbar .form-select {
		border-radius: 0.85rem;
	}

	.messages-list {
		display: grid;
		gap: 0.7rem;
	}

	.message-card {
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: rgba(255, 255, 255, 0.03);
		overflow: hidden;
	}

	.message-card.is-unread {
		border-color: rgba(255, 214, 102, 0.22);
		box-shadow: inset 0 0 0 1px rgba(255, 214, 102, 0.08);
	}

	.message-card-head {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		gap: 0.8rem;
		align-items: start;
		padding: 0.85rem 0.9rem 0.4rem;
	}

	.message-card-body {
		padding: 0 0.9rem 0.9rem 0.9rem;
	}

	.message-check {
		padding-top: 0.25rem;
	}

	.message-subject {
		font-size: 0.98rem;
		font-weight: 700;
		color: #f8fbff;
	}

	.message-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.7rem;
		margin-top: 0.28rem;
		font-size: 0.8rem;
		color: rgba(255, 255, 255, 0.6);
	}

	.message-badges {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
		justify-content: end;
	}

	.message-pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.24rem 0.55rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
		background: rgba(255, 255, 255, 0.08);
		color: #dce8ff;
	}

	.message-pill.is-unread {
		background: rgba(255, 214, 102, 0.14);
		color: #ffd666;
	}

	.message-actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin-bottom: 0.7rem;
	}

	.message-text {
		color: #f2f6ff;
		line-height: 1.55;
	}

	.messages-empty {
		padding: 1.3rem 1rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px dashed rgba(255, 255, 255, 0.14);
		color: rgba(255, 255, 255, 0.68);
	}

	@media (max-width: 1199px) {
		.messages-folder-list {
			grid-template-columns: 1fr;
		}
	}

	@media (max-width: 767px) {
		.messages-hero-stats,
		.messages-toolbar,
		.message-card-head {
			grid-template-columns: 1fr;
		}

		.message-badges {
			justify-content: start;
		}

		.messages-folder-list {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="messages-shell">
	<section class="messages-hero">
		<div>
			<h1>Messagerie joueur</h1>
		</div>
		<div class="messages-hero-stats">
			<div class="messages-stat">
				<span class="messages-stat-label">Privés non lus</span>
				<span class="messages-stat-value">{$CategoryList.1.unread|default:0}</span>
			</div>
			<div class="messages-stat">
				<span class="messages-stat-label">Alliance non lus</span>
				<span class="messages-stat-value">{$CategoryList.2.unread|default:0}</span>
			</div>
			<div class="messages-stat">
				<span class="messages-stat-label">Envoyés</span>
				<span class="messages-stat-value">{$CategoryList.999.total|default:0}</span>
			</div>
		</div>
	</section>

	<div class="messages-layout">
		<aside class="messages-panel messages-sidebar">
			<h2>Dossiers</h2>
			<div class="messages-folder-list">
				{foreach $CategoryList as $CategoryID => $CategoryRow}
					<a class="messages-folder{if $MessID == $CategoryID} is-active{/if}" href="game.php?page=messages&category={$CategoryID}">
						<div class="messages-folder-top">
							<div class="messages-folder-title" style="color:{$CategoryRow.color};">
								{if $CategoryID == 1}Messages privés{elseif $CategoryID == 2}Alliance{elseif $CategoryID == 999}Messages envoyés{else}{$LNG.mg_type.{$CategoryID}}{/if}
							</div>
							<span class="messages-count{if $CategoryRow.unread > 0} is-unread{/if}">
								{if $CategoryID == 999}{$CategoryRow.total}{elseif $CategoryRow.unread > 0}{$CategoryRow.unread}{else}{$CategoryRow.total}{/if}
							</span>
						</div>
						<div class="messages-folder-note">
							{if $CategoryID == 1}Conversations directes entre joueurs.
							{elseif $CategoryID == 2}Organisation et annonces de l’alliance.
							{elseif $CategoryID == 999}Historique des messages envoyés.
							{else}{$CategoryRow.total} message(s).{/if}
						</div>
					</a>
				{/foreach}
			</div>
		</aside>

		<section class="messages-panel messages-main">
			<form action="game.php?page=messages" method="post">
				<input type="hidden" name="mode" value="action">
				<input type="hidden" name="ajax" value="1">
				<input type="hidden" name="messcat" value="{$MessID}">
				<input type="hidden" name="side" value="{$messagePage}">

				<div class="messages-main-head">
					<div>
						<h2>{if $MessID == 1}Messages privés{elseif $MessID == 2}Alliance{elseif $MessID == 999}Messages envoyés{else}{$LNG.mg_type.{$MessID}}{/if}</h2>
						<div class="messages-main-meta">Page {$messagePage} sur {$maxPage} • {$MessageCount} message{if $MessageCount > 1}s{/if}</div>
					</div>
					<div class="messages-pagination">
						{if $messagePage > 1}
							<a class="btn btn-outline-light btn-sm" href="game.php?page=messages&category={$MessID}&side=1">Début</a>
							<a class="btn btn-outline-light btn-sm" href="game.php?page=messages&category={$MessID}&side={$messagePage-1}">Précédent</a>
						{/if}
						{if $messagePage < $maxPage}
							<a class="btn btn-outline-light btn-sm" href="game.php?page=messages&category={$MessID}&side={$messagePage+1}">Suivant</a>
							<a class="btn btn-outline-light btn-sm" href="game.php?page=messages&category={$MessID}&side={$maxPage}">Fin</a>
						{/if}
					</div>
				</div>

				{if $MessID != 999 && $MessageList|@count > 0}
					<div class="messages-toolbar">
						<select class="form-select bg-dark text-white border-secondary" name="actionTop">
							<option value="readmarked">{$LNG.mg_read_marked}</option>
							<option value="readtypeall">{$LNG.mg_read_type_all}</option>
							<option value="readall">{$LNG.mg_read_all}</option>
							<option value="deletemarked">{$LNG.mg_delete_marked}</option>
							<option value="deleteunmarked">{$LNG.mg_delete_unmarked}</option>
							<option value="deletetypeall">{$LNG.mg_delete_type_all}</option>
							<option value="deleteall">{$LNG.mg_delete_all}</option>
						</select>
						<button class="btn btn-primary" type="submit" name="submitTop">{$LNG.mg_confirm}</button>
					</div>
				{/if}

				{if $MessageList|@count > 0}
					<div class="messages-list">
						{foreach from=$MessageList item=Message}
							<article id="message_{$Message.id}" class="message-card message_{$Message.id}{if $MessID != 999 && $Message.unread == 1} is-unread{/if}">
								<div class="message-card-head">
									<div class="message-check">
										{if $MessID != 999}
											<input name="messageID[{$Message.id}]" value="1" type="checkbox">
										{/if}
									</div>
									<div>
										<div class="message-subject">{$Message.subject}</div>
										<div class="message-meta">
											<span>{$Message.time}</span>
											<span>{if $MessID != 999}{$LNG.mg_from}{else}{$LNG.mg_to}{/if} : {$Message.from}</span>
										</div>
									</div>
									<div class="message-badges">
										{if $MessID != 999 && $Message.unread == 1}
											<span class="message-pill is-unread">Non lu</span>
										{/if}
										<span class="message-pill">{if $Message.type == 1}Privé{elseif $Message.type == 2}Alliance{else}Message{/if}</span>
									</div>
								</div>
								<div class="message-card-body">
									<div class="message-actions">
										{if $Message.type == 1 && $MessID != 999}
											<a class="btn btn-outline-light btn-sm" href="#" onclick="return Dialog.PM({$Message.sender}, Message.CreateAnswer('{$Message.subject}'));">Répondre</a>
										{/if}
										{if $MessID != 999}
											<a class="btn btn-outline-danger btn-sm" href="#" onclick="Message.deleteMessage({$Message.id}, {$Message.type});return false;">Supprimer</a>
										{/if}
									</div>
									<div class="message-text rich-content message_{$Message.id}">{$Message.text nofilter}</div>
								</div>
							</article>
						{/foreach}
					</div>
				{else}
					<div class="messages-empty">Aucun message n’est disponible dans ce dossier pour le moment.</div>
				{/if}

				{if $MessID != 999 && $MessageList|@count > 0}
					<div class="messages-toolbar">
						<select class="form-select bg-dark text-white border-secondary" name="actionBottom">
							<option value="readmarked">{$LNG.mg_read_marked}</option>
							<option value="readtypeall">{$LNG.mg_read_type_all}</option>
							<option value="readall">{$LNG.mg_read_all}</option>
							<option value="deletemarked">{$LNG.mg_delete_marked}</option>
							<option value="deleteunmarked">{$LNG.mg_delete_unmarked}</option>
							<option value="deletetypeall">{$LNG.mg_delete_type_all}</option>
							<option value="deleteall">{$LNG.mg_delete_all}</option>
						</select>
						<button class="btn btn-primary" type="submit" name="submitBottom">{$LNG.mg_confirm}</button>
					</div>
				{/if}
			</form>
		</section>
	</div>
</div>
{/block}
