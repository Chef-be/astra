{block name="title" prepend}{$LNG.lm_options}{/block}
{block name="content"}
<style>
	.settings-vacation-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.settings-vacation-card {
		padding: 1rem;
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.settings-vacation-card h1 {
		margin: 0 0 0.4rem;
		font-size: 1.2rem;
		color: #ffd666;
	}

	.settings-vacation-card p {
		margin: 0 0 1rem;
		color: rgba(255, 255, 255, 0.72);
	}

	.settings-vacation-checks {
		display: grid;
		gap: 0.7rem;
	}

	.settings-vacation-check {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		padding: 0.8rem;
		border-radius: 0.9rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.settings-vacation-actions {
		display: flex;
		justify-content: end;
		margin-top: 1rem;
	}
</style>

<form action="game.php?page=settings&amp;mode=send" method="post" class="settings-vacation-shell">
	<div class="settings-vacation-card">
		<h1>{$LNG.op_vacation_mode_active_message}</h1>
		<p>{$vacationUntil}</p>
		<div class="settings-vacation-checks">
			<label class="settings-vacation-check">
				<span>{$LNG.op_end_vacation_mode}</span>
				<input name="vacation" type="checkbox" value="1" {if !$canVacationDisbaled}disabled{/if}>
			</label>
			<label class="settings-vacation-check">
				<span>{$LNG.op_dlte_account}</span>
				<input name="delete" type="checkbox" value="1" {if $delete > 0}checked="checked"{/if}>
			</label>
		</div>
		<div class="settings-vacation-actions">
			<input class="btn btn-primary" type="submit" value="{$LNG.op_save_changes}">
		</div>
	</div>
</form>
{/block}
