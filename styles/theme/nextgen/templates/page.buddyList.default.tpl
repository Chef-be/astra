{block name="title" prepend}{$LNG.lm_buddylist}{/block}
{block name="content"}
<style>
	.buddy-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.buddy-hero,
	.buddy-panel {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.buddy-hero {
		padding: 1.1rem 1.2rem;
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.buddy-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.buddy-hero p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.55;
	}

	.buddy-stats {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.7rem;
	}

	.buddy-stat,
	.buddy-panel {
		padding: 0.95rem;
	}

	.buddy-stat {
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.buddy-stat-label {
		display: block;
		margin-bottom: 0.18rem;
		font-size: 0.72rem;
		color: rgba(255, 255, 255, 0.58);
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}

	.buddy-stat-value {
		display: block;
		font-size: 1.15rem;
		font-weight: 700;
		color: #f8fbff;
	}

	.buddy-section-head {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.7rem;
		margin-bottom: 0.8rem;
	}

	.buddy-section-head h2 {
		margin: 0;
		font-size: 1rem;
		color: #ffd666;
	}

	.buddy-list {
		display: grid;
		gap: 0.65rem;
	}

	.buddy-card {
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		gap: 0.8rem;
		padding: 0.85rem 0.9rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.buddy-top {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.5rem;
		margin-bottom: 0.28rem;
	}

	.buddy-name {
		color: #f8fbff;
		font-weight: 700;
		text-decoration: none;
	}

	.buddy-name:hover {
		color: #ffd666;
	}

	.buddy-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.7rem;
		font-size: 0.82rem;
		color: rgba(255, 255, 255, 0.62);
	}

	.buddy-meta a {
		color: #8fd6ff;
		text-decoration: none;
	}

	.buddy-request-text {
		margin-top: 0.5rem;
		color: rgba(255, 255, 255, 0.75);
		font-size: 0.84rem;
		line-height: 1.5;
	}

	.buddy-pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.22rem 0.52rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
		background: rgba(255, 214, 102, 0.12);
		color: #ffd666;
	}

	.buddy-actions {
		display: flex;
		align-items: center;
		gap: 0.45rem;
	}

	.buddy-action {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: 999px;
		border: 1px solid rgba(255, 214, 102, 0.22);
		background: rgba(8, 14, 28, 0.92);
		color: #ffd666;
		text-decoration: none;
	}

	.buddy-status-online { color: #91eb8f; font-weight: 700; }
	.buddy-status-idle { color: #ffe38f; font-weight: 700; }
	.buddy-status-offline { color: #ff9c9c; font-weight: 700; }

	.buddy-empty {
		padding: 1rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px dashed rgba(255, 255, 255, 0.14);
		color: rgba(255, 255, 255, 0.66);
	}

	@media (max-width: 767px) {
		.buddy-stats {
			grid-template-columns: 1fr;
		}

		.buddy-card {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="buddy-shell">
	<section class="buddy-hero">
		<h1>Liste d’amis</h1>
		<p>Suivez vos demandes en cours, vos invitations reçues et vos contacts validés depuis une vue unique plus claire.</p>
	</section>

	<div class="buddy-stats">
		<div class="buddy-stat">
			<span class="buddy-stat-label">Demandes reçues</span>
			<span class="buddy-stat-value">{$otherRequestList|@count}</span>
		</div>
		<div class="buddy-stat">
			<span class="buddy-stat-label">Demandes envoyées</span>
			<span class="buddy-stat-value">{$myRequestList|@count}</span>
		</div>
		<div class="buddy-stat">
			<span class="buddy-stat-label">Contacts validés</span>
			<span class="buddy-stat-value">{$myBuddyList|@count}</span>
		</div>
	</div>

	<section class="buddy-panel">
		<div class="buddy-section-head">
			<h2>{$LNG.bu_requests}</h2>
		</div>
		{if !empty($otherRequestList)}
			<div class="buddy-list">
				{foreach $otherRequestList as $otherRequestID => $otherRequestRow}
				<article class="buddy-card">
					<div>
						<div class="buddy-top">
							<a class="buddy-name" href="#" onclick="return Dialog.PM({$otherRequestRow.id});">{$otherRequestRow.username}</a>
							<span class="buddy-pill">Reçue</span>
						</div>
						<div class="buddy-meta">
							<span>Alliance : {if $otherRequestRow.ally_name}<a href="game.php?page=alliance&amp;mode=info&amp;id={$otherRequestRow.ally_id}">{$otherRequestRow.ally_name}</a>{else}-{/if}</span>
							<span><a href="game.php?page=galaxy&amp;galaxy={$otherRequestRow.galaxy}&amp;system={$otherRequestRow.system}">[{$otherRequestRow.galaxy}:{$otherRequestRow.system}:{$otherRequestRow.planet}]</a></span>
						</div>
						<div class="buddy-request-text">{$otherRequestRow.text}</div>
					</div>
					<div class="buddy-actions">
						<a class="buddy-action" href="game.php?page=buddyList&amp;mode=accept&amp;id={$otherRequestID}" title="{$LNG.bu_accept}">✓</a>
						<a class="buddy-action" href="game.php?page=buddyList&amp;mode=delete&amp;id={$otherRequestID}" title="{$LNG.bu_decline}">✕</a>
					</div>
				</article>
				{/foreach}
			</div>
		{else}
			<div class="buddy-empty">{$LNG.bu_no_request}</div>
		{/if}
	</section>

	<section class="buddy-panel">
		<div class="buddy-section-head">
			<h2>{$LNG.bu_my_requests}</h2>
		</div>
		{if !empty($myRequestList)}
			<div class="buddy-list">
				{foreach $myRequestList as $myRequestID => $myRequestRow}
				<article class="buddy-card">
					<div>
						<div class="buddy-top">
							<a class="buddy-name" href="#" onclick="return Dialog.PM({$myRequestRow.id});">{$myRequestRow.username}</a>
							<span class="buddy-pill">En attente</span>
						</div>
						<div class="buddy-meta">
							<span>Alliance : {if $myRequestRow.ally_name}<a href="game.php?page=alliance&amp;mode=info&amp;id={$myRequestRow.ally_id}">{$myRequestRow.ally_name}</a>{else}-{/if}</span>
							<span><a href="game.php?page=galaxy&amp;galaxy={$myRequestRow.galaxy}&amp;system={$myRequestRow.system}">[{$myRequestRow.galaxy}:{$myRequestRow.system}:{$myRequestRow.planet}]</a></span>
						</div>
						<div class="buddy-request-text">{$myRequestRow.text}</div>
					</div>
					<div class="buddy-actions">
						<a class="buddy-action" href="game.php?page=buddyList&amp;mode=delete&amp;id={$myRequestID}" title="{$LNG.bu_cancel_request}">✕</a>
					</div>
				</article>
				{/foreach}
			</div>
		{else}
			<div class="buddy-empty">{$LNG.bu_no_request}</div>
		{/if}
	</section>

	<section class="buddy-panel">
		<div class="buddy-section-head">
			<h2>{$LNG.bu_partners}</h2>
		</div>
		{if !empty($myBuddyList)}
			<div class="buddy-list">
				{foreach $myBuddyList as $myBuddyID => $myBuddyRow}
				<article class="buddy-card">
					<div>
						<div class="buddy-top">
							<a class="buddy-name" href="#" onclick="return Dialog.PM({$myBuddyRow.id});">{$myBuddyRow.username}</a>
							{if $myBuddyRow.onlinetime < 4}
								<span class="buddy-status-online">{$LNG.bu_connected}</span>
							{elseif $myBuddyRow.onlinetime >= 4 && $myBuddyRow.onlinetime <= 15}
								<span class="buddy-status-idle">{$myBuddyRow.onlinetime} {$LNG.bu_minutes}</span>
							{else}
								<span class="buddy-status-offline">{$LNG.bu_disconnected}</span>
							{/if}
						</div>
						<div class="buddy-meta">
							<span>Alliance : {if $myBuddyRow.ally_name}<a href="game.php?page=alliance&amp;mode=info&amp;id={$myBuddyRow.ally_id}">{$myBuddyRow.ally_name}</a>{else}-{/if}</span>
							<span><a href="game.php?page=galaxy&amp;galaxy={$myBuddyRow.galaxy}&amp;system={$myBuddyRow.system}">[{$myBuddyRow.galaxy}:{$myBuddyRow.system}:{$myBuddyRow.planet}]</a></span>
						</div>
					</div>
					<div class="buddy-actions">
						<a class="buddy-action" href="game.php?page=buddyList&amp;mode=delete&amp;id={$myBuddyID}" title="{$LNG.bu_delete}">✕</a>
					</div>
				</article>
				{/foreach}
			</div>
		{else}
			<div class="buddy-empty">{$LNG.bu_no_buddys}</div>
		{/if}
	</section>
</div>
{/block}
