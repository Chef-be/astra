{block name="title" prepend}{$LNG.lm_notes}{/block}
{block name="content"}
<style>
	.notes-shell {
		padding: 0.8rem;
		color: #f3f7ff;
	}

	.notes-card {
		padding: 1rem;
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.notes-head {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		margin-bottom: 0.9rem;
	}

	.notes-head h1 {
		margin: 0;
		font-size: 1.05rem;
		color: #ffd666;
	}

	.notes-list {
		display: grid;
		gap: 0.6rem;
	}

	.note-row {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto auto;
		gap: 0.7rem;
		align-items: center;
		padding: 0.75rem 0.8rem;
		border-radius: 0.95rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.note-title {
		color: #f8fbff;
		font-weight: 700;
		text-decoration: none;
	}

	.note-title:hover {
		color: #ffd666;
	}

	.note-meta {
		font-size: 0.8rem;
		color: rgba(255, 255, 255, 0.62);
	}

	.note-size {
		color: rgba(255, 255, 255, 0.72);
		font-size: 0.82rem;
	}

	.note-priority {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.22rem 0.52rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.note-priority.is-low { background: rgba(82, 196, 26, 0.14); color: #9ce78a; }
	.note-priority.is-mid { background: rgba(255, 214, 102, 0.14); color: #ffd666; }
	.note-priority.is-high { background: rgba(255, 134, 134, 0.14); color: #ffb2b2; }

	.notes-actions {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 0.8rem;
		margin-top: 0.9rem;
	}

	.notes-empty {
		padding: 1rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px dashed rgba(255, 255, 255, 0.14);
		color: rgba(255, 255, 255, 0.66);
	}

	@media (max-width: 767px) {
		.note-row {
			grid-template-columns: auto 1fr;
		}
	}
</style>

<form action="game.php?page=notes&amp;mode=delete" method="post" class="notes-shell">
	<div class="notes-card">
		<div class="notes-head">
			<h1>{$LNG.nt_notes}</h1>
			<a class="btn btn-warning fw-semibold text-dark btn-sm" href="game.php?page=notes&amp;mode=detail">{$LNG.nt_create_new_note}</a>
		</div>

		{if $notesList}
		<div class="notes-list">
			{foreach $notesList as $notesID => $notesRow}
			<div class="note-row">
				<div><input name="delmes[{$notesID}]" type="checkbox"></div>
				<div>
					<a class="note-title" href="game.php?page=notes&amp;mode=detail&amp;id={$notesID}">{$notesRow.title}</a>
					<div class="note-meta">{$notesRow.time}</div>
				</div>
				<div class="note-size">{$notesRow.size|number} car.</div>
				<div>
					<span class="note-priority {if $notesRow.priority == 0}is-low{elseif $notesRow.priority == 2}is-high{else}is-mid{/if}">
						{if $notesRow.priority == 0}{$LNG.nt_unimportant}{elseif $notesRow.priority == 2}{$LNG.nt_important}{else}{$LNG.nt_normal}{/if}
					</span>
				</div>
			</div>
			{/foreach}
		</div>
		<div class="notes-actions">
			<span class="text-white-50">Sélectionnez une ou plusieurs notes pour les supprimer.</span>
			<input class="btn btn-outline-danger btn-sm" value="{$LNG.nt_dlte_note}" type="submit">
		</div>
		{else}
		<div class="notes-empty">{$LNG.nt_you_dont_have_notes}</div>
		{/if}
	</div>
</form>
{/block}
