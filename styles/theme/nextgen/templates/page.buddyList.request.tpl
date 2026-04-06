{block name="title" prepend}{$LNG.lm_buddylist}{/block}
{block name="content"}
<style>
	.buddy-request-shell {
		padding: 0.8rem;
		color: #f3f7ff;
	}

	.buddy-request-card {
		padding: 1rem;
		border-radius: 1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.buddy-request-card h1 {
		margin: 0 0 0.7rem;
		font-size: 1.05rem;
		color: #ffd666;
	}

	.buddy-request-grid {
		display: grid;
		gap: 0.75rem;
	}

	.buddy-request-field label {
		display: block;
		margin-bottom: 0.35rem;
		color: rgba(255, 255, 255, 0.64);
		font-size: 0.82rem;
	}

	.buddy-request-actions {
		display: flex;
		justify-content: end;
		margin-top: 0.9rem;
	}
</style>

<form name="buddy" id="buddy" action="game.php?page=buddyList&amp;mode=send&amp;ajax=1" method="post" class="buddy-request-shell">
	<input type="hidden" name="id" value="{$id}">
	<div class="buddy-request-card">
		<h1>{$LNG.bu_request_message}</h1>
		<div class="buddy-request-grid">
			<div class="buddy-request-field">
				<label>{$LNG.bu_player}</label>
				<input class="form-control bg-black border-secondary text-white" type="text" value="{$username} [{$galaxy}:{$system}:{$planet}]" readonly>
			</div>
			<div class="buddy-request-field">
				<label>{$LNG.bu_request_text} (<span id="cntChars">0</span> / 5000 {$LNG.bu_characters})</label>
				<textarea class="form-control bg-black border-secondary text-white" name="text" id="text" cols="40" rows="8" maxlength="5000" onkeyup="$('#cntChars').text($(this).val().length);"></textarea>
			</div>
		</div>
		<div class="buddy-request-actions">
			<input class="btn btn-primary text-white" type="submit" value="{$LNG.bu_send}">
		</div>
	</div>
</form>
{/block}
