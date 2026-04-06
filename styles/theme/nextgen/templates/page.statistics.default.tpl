{block name="title" prepend}{$LNG.lm_statistics}{/block}
{block name="content"}
<style>
	.stats-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.stats-hero,
	.stats-panel {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.stats-hero {
		padding: 1.1rem 1.2rem;
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.stats-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.stats-hero p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.55;
	}

	.stats-panel {
		padding: 0.95rem;
	}

	.stats-toolbar {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.7rem;
		align-items: end;
	}

	.stats-field label {
		display: block;
		margin-bottom: 0.35rem;
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.8rem;
	}

	.stats-table-wrap {
		overflow-x: auto;
	}

	.stats-table {
		width: 100%;
		border-collapse: separate;
		border-spacing: 0;
	}

	.stats-table th,
	.stats-table td {
		padding: 0.75rem 0.7rem;
		border-bottom: 1px solid rgba(255, 255, 255, 0.06);
		vertical-align: middle;
	}

	.stats-table th {
		color: rgba(255, 255, 255, 0.6);
		font-size: 0.76rem;
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}

	.stats-name {
		color: #f8fbff;
		font-weight: 700;
		text-decoration: none;
	}

	.stats-name:hover {
		color: #ffd666;
	}

	.stats-rank {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-width: 2rem;
		padding: 0.22rem 0.5rem;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.08);
		color: #dce8ff;
		font-size: 0.76rem;
		font-weight: 700;
	}

	.stats-shift {
		font-size: 0.78rem;
		font-weight: 700;
	}

	.stats-shift.is-up {
		color: #91eb8f;
	}

	.stats-shift.is-down {
		color: #ff9c9c;
	}

	.stats-shift.is-flat {
		color: #87ceeb;
	}

	.stats-action {
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

	.stats-ally {
		color: #8fd6ff;
		text-decoration: none;
	}

	.stats-leader {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.2rem 0.45rem;
		border-radius: 999px;
		margin-left: 0.35rem;
		background: rgba(255, 214, 102, 0.12);
		color: #ffd666;
		font-size: 0.7rem;
		font-weight: 700;
	}

	@media (max-width: 767px) {
		.stats-toolbar {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="stats-shell">
	<section class="stats-hero">
		<h1>{$LNG.st_statistics}</h1>
		<p>Classements actualisés le {$stat_date}. Filtrez l’affichage par type de score, population classée et plage de positions.</p>
	</section>

	<form name="stats" id="stats" method="post" action="" class="stats-panel">
		<div class="stats-toolbar">
			<div class="stats-field">
				<label for="who">{$LNG.st_show}</label>
				<select class="form-select bg-dark text-white border-secondary" name="who" id="who" onchange="document.getElementById('stats').submit();">
					{html_options options=$Selectors.who selected=$who}
				</select>
			</div>
			<div class="stats-field">
				<label for="type">{$LNG.st_per}</label>
				<select class="form-select bg-dark text-white border-secondary" name="type" id="type" onchange="document.getElementById('stats').submit();">
					{html_options options=$Selectors.type selected=$type}
				</select>
			</div>
			<div class="stats-field">
				<label for="range">{$LNG.st_in_the_positions}</label>
				<select class="form-select bg-dark text-white border-secondary" name="range" id="range" onchange="document.getElementById('stats').submit();">
					{html_options options=$Selectors.range selected=$range}
				</select>
			</div>
		</div>
	</form>

	<section class="stats-panel stats-table-wrap">
		<table class="stats-table">
			{if $who == 1}
				{include file="shared.statistics.playerTable.tpl"}
			{elseif $who == 2}
				{include file="shared.statistics.allianceTable.tpl"}
			{/if}
		</table>
	</section>
</div>
{/block}
