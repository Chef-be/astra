{block name="title" prepend}{$LNG.lm_search}{/block}
{block name="content"}
<style>
	.search-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.search-hero,
	.search-panel {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.search-hero {
		padding: 1.1rem 1.2rem;
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.search-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.search-hero p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.55;
	}

	.search-panel {
		padding: 0.95rem;
	}

	.search-form {
		display: grid;
		grid-template-columns: 220px minmax(0, 1fr) 130px;
		gap: 0.7rem;
		align-items: center;
	}

	.search-results-placeholder {
		padding: 1rem 1.05rem;
		color: rgba(255, 255, 255, 0.64);
		font-size: 0.85rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px dashed rgba(255, 255, 255, 0.12);
	}

	@media (max-width: 767px) {
		.search-form {
			grid-template-columns: 1fr;
		}
	}
</style>

<div class="search-shell">
	<section class="search-hero">
		<h1>Recherche</h1>
	</section>

	<section class="search-panel">
		<div class="search-form">
			{html_options options=$modeSelector name="type" id="type" class="form-select bg-dark text-white border-secondary"}
			<input class="form-control bg-dark text-white border-secondary" type="text" name="searchtext" id="searchtext" placeholder="Nom de joueur, planète ou alliance">
			<button class="btn btn-warning fw-semibold text-dark" type="button" id="searchButton">{$LNG.sh_search} <span id="loading" style="display:none;">• {$LNG.sh_loading}</span></button>
		</div>
	</section>

	<div id="searchResults" class="search-panel">
		<div class="search-results-placeholder">Saisissez au moins quelques caractères pour lancer une recherche dans l’univers.</div>
	</div>
</div>
{/block}
