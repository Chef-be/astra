{block name="title" prepend}{$LNG.lm_notes}{/block}
{block name="content"}
<style>
	.note-detail-shell {
		padding: 0.8rem;
		color: #f3f7ff;
	}

	.note-detail-card {
		padding: 1rem;
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.note-detail-card h1 {
		margin: 0 0 0.8rem;
		font-size: 1.05rem;
		color: #ffd666;
	}

	.note-detail-grid {
		display: grid;
		gap: 0.8rem;
	}

	.note-detail-field label {
		display: block;
		margin-bottom: 0.35rem;
		color: rgba(255, 255, 255, 0.64);
		font-size: 0.82rem;
	}

	.note-detail-actions {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 0.8rem;
		margin-top: 0.9rem;
	}
</style>

<form action="?page=notes&amp;mode=insert" method="post" class="note-detail-shell">
	<input type="hidden" name="id" value="{$noteDetail.id}">
	<div class="note-detail-card">
		<h1>{if $noteDetail.id == 0}{$LNG.nt_create_note}{else}{$LNG.nt_edit_note}{/if}</h1>
		<div class="note-detail-grid">
			<div class="note-detail-field">
				<label for="priority">{$LNG.nt_priority}</label>
				{html_options id=priority name=priority options=$PriorityList selected=$noteDetail.priority class="form-select bg-dark text-white border-secondary"}
			</div>
			<div class="note-detail-field">
				<label for="title">{$LNG.nt_subject_note}</label>
				<input class="form-control bg-dark text-white border-secondary" type="text" id="title" name="title" maxlength="30" value="{$noteDetail.title}">
			</div>
			<div class="note-detail-field">
				<label for="text">{$LNG.nt_note} (<span id="cntChars">0</span> / 10.000 {$LNG.nt_characters})</label>
				<textarea class="form-control bg-dark text-white border-secondary" name="text" id="text" rows="10" maxlength="10000" onkeyup="$('#cntChars').text($(this).val().length);">{$noteDetail.text}</textarea>
			</div>
		</div>
		<div class="note-detail-actions">
			<a class="btn btn-outline-light btn-sm" href="game.php?page=notes">{$LNG.nt_back}</a>
			<div class="d-flex gap-2">
				<input class="btn btn-outline-secondary btn-sm" type="reset" value="{$LNG.nt_reset}">
				<input class="btn btn-primary btn-sm" type="submit" value="{$LNG.nt_save}">
			</div>
		</div>
	</div>
</form>
{/block}
