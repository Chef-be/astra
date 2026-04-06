{block name="content"}
<div id="resulttable" class="search-result-shell">
	<style>
		.search-result-shell {
			display: grid;
			gap: 0.7rem;
		}

		.search-result-head {
			display: flex;
			flex-wrap: wrap;
			align-items: center;
			justify-content: space-between;
			gap: 0.75rem;
			padding: 0.2rem 0.1rem 0.4rem;
		}

		.search-result-head h2 {
			margin: 0;
			font-size: 1rem;
			color: #ffd666;
		}

		.search-result-count {
			color: rgba(255, 255, 255, 0.62);
			font-size: 0.82rem;
		}

		.search-result-list {
			display: grid;
			gap: 0.6rem;
		}

		.search-result-card {
			padding: 0.9rem 0.95rem;
			border-radius: 1rem;
			background: rgba(255, 255, 255, 0.03);
			border: 1px solid rgba(255, 255, 255, 0.06);
		}

		.search-result-top {
			display: flex;
			flex-wrap: wrap;
			align-items: center;
			gap: 0.55rem;
			margin-bottom: 0.3rem;
		}

		.search-result-name {
			color: #f8fbff;
			font-size: 0.96rem;
			font-weight: 700;
			text-decoration: none;
		}

		.search-result-name:hover {
			color: #ffd666;
		}

		.search-result-tag {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			padding: 0.22rem 0.52rem;
			border-radius: 999px;
			font-size: 0.72rem;
			font-weight: 700;
			background: rgba(77, 208, 225, 0.12);
			color: #c7f7ff;
		}

		.search-result-meta {
			display: flex;
			flex-wrap: wrap;
			gap: 0.8rem;
			font-size: 0.82rem;
			color: rgba(255, 255, 255, 0.64);
		}

		.search-result-empty {
			padding: 1rem;
			border-radius: 1rem;
			background: rgba(255, 255, 255, 0.03);
			border: 1px dashed rgba(255, 255, 255, 0.14);
			color: rgba(255, 255, 255, 0.66);
		}
	</style>
	<div class="search-result-head">
		<h2>Alliances trouvées</h2>
		<div class="search-result-count">{$searchList|@count} résultat{if $searchList|@count > 1}s{/if}</div>
	</div>
	{if $searchList}
	<div class="search-result-list">
		{foreach $searchList as $searchRow}
		<article class="search-result-card">
			<div class="search-result-top">
				<a class="search-result-name" href="game.php?page=alliance&amp;mode=info&amp;tag={$searchRow.allytag}">{$searchRow.allyname}</a>
				<span class="search-result-tag">{$searchRow.allytag}</span>
			</div>
			<div class="search-result-meta">
				<span>Membres : {$searchRow.allymembers}</span>
				<span>Points : {$searchRow.allypoints}</span>
			</div>
		</article>
		{/foreach}
	</div>
	{else}
	<div class="search-result-empty">Aucune alliance ne correspond à cette recherche.</div>
	{/if}
</div>
{/block}
