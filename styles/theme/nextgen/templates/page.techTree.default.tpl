{block name="title" prepend}{$LNG.lm_technology}{/block}

{block name="content"}
<style>
	.tech-tree-shell {
		display: grid;
		gap: 1rem;
	}

	.tech-tree-hero {
		display: grid;
		grid-template-columns: 1fr auto;
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

	.tech-tree-hero h1 {
		margin: 0 0 0.35rem;
		color: #f8fbff;
		font-size: 1.6rem;
	}

	.tech-tree-hero p {
		margin: 0;
		max-width: 72ch;
		color: rgba(255, 255, 255, 0.74);
		line-height: 1.55;
	}

	.tech-tree-stats {
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
		justify-content: end;
	}

	.tech-tree-stat {
		min-width: 150px;
		padding: 0.8rem 0.95rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.07);
	}

	.tech-tree-stat-label {
		display: block;
		margin-bottom: 0.2rem;
		font-size: 0.74rem;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: rgba(255, 255, 255, 0.56);
	}

	.tech-tree-stat-value {
		display: block;
		font-size: 1.15rem;
		font-weight: 700;
		color: #f8fbff;
	}

	.tech-tree-toolbar {
		display: flex;
		align-items: center;
		flex-wrap: nowrap;
		gap: 0.8rem;
		padding: 0.95rem 1rem;
		border-radius: 1.05rem;
		background: rgba(7, 11, 20, 0.9);
		border: 1px solid rgba(255, 255, 255, 0.07);
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.16);
	}

	.tech-tree-toolbar .form-control,
	.tech-tree-toolbar .form-select {
		border-radius: 0.85rem;
	}

	.tech-tree-toolbar .form-control {
		flex: 1 1 auto;
		min-width: 0;
	}

	.tech-tree-toolbar .form-select {
		flex: 0 0 180px;
		width: 180px;
		max-width: 180px;
	}

	.tech-tree-sections {
		display: grid;
		gap: 0.85rem;
	}

	.tech-tree-section {
		border-radius: 1.1rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
		overflow: hidden;
	}

	.tech-tree-section > summary {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		padding: 0.9rem 1rem;
		cursor: pointer;
		list-style: none;
	}

	.tech-tree-section > summary::-webkit-details-marker {
		display: none;
	}

	.tech-tree-section-title {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.55rem;
	}

	.tech-tree-section-title h2 {
		margin: 0;
		font-size: 1.05rem;
		color: #ffd666;
	}

	.tech-tree-pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.24rem 0.55rem;
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.tech-tree-pill--ready {
		background: rgba(82, 196, 26, 0.14);
		color: #a8ef84;
	}

	.tech-tree-pill--blocked {
		background: rgba(255, 134, 134, 0.12);
		color: #ffb2b2;
	}

	.tech-tree-pill--neutral {
		background: rgba(255, 255, 255, 0.08);
		color: #dce8ff;
	}

	.tech-tree-summary-meta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.6rem;
		color: rgba(255, 255, 255, 0.68);
		font-size: 0.82rem;
	}

	.tech-tree-summary-meta::after {
		content: "▾";
		font-size: 0.95rem;
		transition: transform 0.2s ease;
	}

	.tech-tree-section[open] .tech-tree-summary-meta::after {
		transform: rotate(180deg);
	}

	.tech-tree-list {
		display: grid;
		gap: 0.55rem;
		padding: 0 1rem 1rem;
	}

	.tech-tree-entry {
		border-radius: 0.95rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
		overflow: hidden;
	}

	.tech-tree-entry > summary {
		display: grid;
		grid-template-columns: 70px minmax(0, 1fr) auto;
		gap: 0.8rem;
		align-items: center;
		padding: 0.7rem 0.8rem;
		list-style: none;
		cursor: pointer;
	}

	.tech-tree-entry > summary::-webkit-details-marker {
		display: none;
	}

	.tech-tree-entry[open] {
		border-color: rgba(255, 214, 102, 0.16);
	}

	.tech-tree-thumb {
		width: 70px;
		height: 70px;
		border-radius: 0.9rem;
		border: 1px solid rgba(255, 214, 102, 0.18);
		background: rgba(255, 255, 255, 0.03);
		object-fit: cover;
	}

	.tech-tree-entry-top {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.45rem;
		margin-bottom: 0.3rem;
	}

	.tech-tree-entry-title {
		color: #f8fbff;
		font-size: 0.95rem;
		font-weight: 700;
		text-decoration: none;
	}

	.tech-tree-entry-title:hover {
		color: #ffd666;
	}

	.tech-tree-entry-desc {
		margin: 0;
		color: rgba(255, 255, 255, 0.68);
		font-size: 0.8rem;
		line-height: 1.4;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}

	.tech-tree-entry-meta {
		display: flex;
		flex-wrap: wrap;
		justify-content: end;
		gap: 0.45rem;
	}

	.tech-tree-entry-meta::after {
		content: "▾";
		display: inline-flex;
		align-items: center;
		margin-left: 0.2rem;
		color: rgba(255, 255, 255, 0.6);
	}

	.tech-tree-entry[open] .tech-tree-entry-meta::after {
		transform: rotate(180deg);
	}

	.tech-tree-entry-body {
		display: grid;
		gap: 0.55rem;
		padding: 0 0.8rem 0.8rem 0.8rem;
	}

	.tech-tree-req-list {
		display: grid;
		gap: 0.35rem;
	}

	.tech-tree-req-item {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 0.7rem;
		padding: 0.42rem 0.55rem;
		border-radius: 0.8rem;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.05);
		font-size: 0.78rem;
	}

	.tech-tree-req-item a {
		color: #dce8ff;
		text-decoration: none;
	}

	.tech-tree-req-item a:hover {
		color: #ffd666;
	}

	.tech-tree-req-status {
		font-weight: 700;
	}

	.tech-tree-req-status.is-ready {
		color: #9ce78a;
	}

	.tech-tree-req-status.is-missing {
		color: #ff9c9c;
	}

	.tech-tree-empty {
		padding: 0.9rem 1rem;
		color: rgba(255, 255, 255, 0.62);
		font-size: 0.84rem;
	}

	.tech-tree-section.is-hidden,
	.tech-tree-entry.is-hidden {
		display: none !important;
	}

	@media (max-width: 991px) {
		.tech-tree-hero,
		.tech-tree-toolbar {
			grid-template-columns: 1fr;
		}

		.tech-tree-stats {
			justify-content: start;
		}

		.tech-tree-toolbar {
			display: grid;
			grid-template-columns: 1fr;
		}

		.tech-tree-toolbar .form-select {
			flex: initial;
			width: 100%;
			max-width: none;
		}
	}

	@media (max-width: 767px) {
		.tech-tree-entry > summary {
			grid-template-columns: 1fr;
		}

		.tech-tree-entry-meta {
			justify-content: start;
		}
	}
</style>

<div class="tech-tree-shell">
	<section class="tech-tree-hero">
		<div>
			<h1>{$LNG.lm_technology}</h1>
			<p>Repérez rapidement ce qui est déjà accessible, ce qui reste bloqué et les prérequis exacts, sans dérouler une longue suite de cartes ouvertes.</p>
		</div>
		<div class="tech-tree-stats">
			<div class="tech-tree-stat">
				<span class="tech-tree-stat-label">Éléments suivis</span>
				<span class="tech-tree-stat-value">{$techTreeTotal|number}</span>
			</div>
			<div class="tech-tree-stat">
				<span class="tech-tree-stat-label">Déjà accessibles</span>
				<span class="tech-tree-stat-value">{$techTreeReady|number}</span>
			</div>
		</div>
	</section>

	<section class="tech-tree-toolbar">
		<input id="techTreeSearch" class="form-control" type="search" placeholder="Rechercher un élément...">
		<select id="techTreeFilter" class="form-select">
			<option value="all">Tous les éléments</option>
			<option value="ready">Uniquement accessibles</option>
			<option value="blocked">Uniquement bloqués</option>
		</select>
	</section>

	<div class="tech-tree-sections" id="techTreeSections">
		{foreach $techTreeSections as $section}
		<details class="tech-tree-section" data-section="{$section.key}"{if $section@first} open{/if}>
			<summary>
				<div class="tech-tree-section-title">
					<h2>{$section.title}</h2>
					<span class="tech-tree-pill tech-tree-pill--neutral">{$section.total|number} élément{if $section.total > 1}s{/if}</span>
					<span class="tech-tree-pill tech-tree-pill--ready">{$section.ready|number} prêt{if $section.ready > 1}s{/if}</span>
					<span class="tech-tree-pill tech-tree-pill--blocked">{$section.total-$section.ready|number} bloqué{if ($section.total-$section.ready) > 1}s{/if}</span>
				</div>
				<div class="tech-tree-summary-meta">Ouvrir la section</div>
			</summary>
			<div class="tech-tree-list">
				{foreach $section.entries as $entry}
				<details class="tech-tree-entry" data-name="{$LNG.tech.{$entry.id}|escape:'html'}" data-ready="{if $entry.ready}1{else}0{/if}" data-description="{$LNG.shortDescription.{$entry.id}|escape:'html'}">
					<summary>
						<a href="#" onclick="return Dialog.info({$entry.id});">
							<img class="tech-tree-thumb" src="{$dpath}gebaeude/{$entry.id}.{$entry.image}" alt="{$LNG.tech.{$entry.id}}">
						</a>
						<div>
							<div class="tech-tree-entry-top">
								<a class="tech-tree-entry-title" href="#" onclick="return Dialog.info({$entry.id});">{$LNG.tech.{$entry.id}}</a>
								<span class="tech-tree-pill {if $entry.ready}tech-tree-pill--ready{else}tech-tree-pill--blocked{/if}">
									{if $entry.ready}Accessible{else}Bloqué{/if}
								</span>
							</div>
							<p class="tech-tree-entry-desc">{$LNG.shortDescription.{$entry.id}}</p>
						</div>
						<div class="tech-tree-entry-meta">
							<span class="tech-tree-pill tech-tree-pill--neutral">{if $entry.requirements}{count($entry.requirements)} prérequis{else}0 prérequis{/if}</span>
						</div>
					</summary>
					<div class="tech-tree-entry-body">
						{if $entry.requirements}
						<div class="tech-tree-req-list">
							{foreach $entry.requirements as $requireId => $requirement}
							<div class="tech-tree-req-item">
								<a href="#" onclick="return Dialog.info({$requireId});">{$LNG.tech.{$requireId}}</a>
								<span class="tech-tree-req-status {if $requirement.ready}is-ready{else}is-missing{/if}">
									{$LNG.tt_lvl}{$requirement.own}/{$requirement.count}
								</span>
							</div>
							{/foreach}
						</div>
						{else}
						<div class="tech-tree-empty">Aucun prérequis supplémentaire.</div>
						{/if}
					</div>
				</details>
				{/foreach}
			</div>
		</details>
		{/foreach}
	</div>
</div>
{/block}

{block name="script" append}
<script>
document.addEventListener('DOMContentLoaded', function() {
	const searchInput = document.getElementById('techTreeSearch');
	const filterSelect = document.getElementById('techTreeFilter');
	const sections = Array.from(document.querySelectorAll('.tech-tree-section'));

	function applyTechTreeFilters() {
		const query = (searchInput.value || '').trim().toLowerCase();
		const filter = filterSelect.value;

		sections.forEach((section) => {
			let visibleCount = 0;
			const entries = Array.from(section.querySelectorAll('.tech-tree-entry'));

			entries.forEach((entry) => {
				const name = (entry.dataset.name || '').toLowerCase();
				const description = (entry.dataset.description || '').toLowerCase();
				const isReady = entry.dataset.ready === '1';

				const queryMatch = query === '' || name.includes(query) || description.includes(query);
				const filterMatch = filter === 'all' || (filter === 'ready' && isReady) || (filter === 'blocked' && !isReady);
				const visible = queryMatch && filterMatch;

				entry.classList.toggle('is-hidden', !visible);
				if (visible) {
					visibleCount++;
				}
			});

			section.classList.toggle('is-hidden', visibleCount === 0);
		});
	}

	searchInput.addEventListener('input', applyTechTreeFilters);
	filterSelect.addEventListener('change', applyTechTreeFilters);
});
</script>
{/block}
