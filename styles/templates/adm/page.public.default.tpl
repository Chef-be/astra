{block name="content"}
<div class="container-fluid py-4 text-white admin-stack">
	<section class="admin-kpi-grid">
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Captures personnalisées</span>
			<strong class="admin-kpi-card__value">{$public_screenshots|@count}</strong>
			<span class="admin-kpi-card__meta">galerie publique éditable</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Discord public</span>
			<strong class="admin-kpi-card__value">{if $discord_active}Actif{else}Inactif{/if}</strong>
			<span class="admin-kpi-card__meta">menu et pied de page</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">SEO titre</span>
			<strong class="admin-kpi-card__value">{if $seo_meta_title|trim neq ''}Renseigné{else}À compléter{/if}</strong>
			<span class="admin-kpi-card__meta">métadonnées publiques</span>
		</article>
		<article class="admin-kpi-card">
			<span class="admin-kpi-card__label">Page des règles</span>
			<strong class="admin-kpi-card__value">{if $public_rules_html|trim neq ''}Personnalisée{else}Langue par défaut{/if}</strong>
			<span class="admin-kpi-card__meta">texte joueur</span>
		</article>
	</section>

	<section class="admin-card">
		<div class="card-body admin-stack">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Pilotage du site public</h2>
					<p class="text-white-50 mb-0">Centralisez contenu éditorial, navigation, galerie, questions secrètes et métadonnées depuis une seule vue d’administration.</p>
				</div>
				<div class="admin-cluster">
					<a class="admin-shell-action admin-shell-action--light" href="index.php" target="_blank" rel="noopener">Voir le site public</a>
					<a class="admin-shell-action admin-shell-action--accent" href="admin.php?page=news">Actualités</a>
				</div>
			</div>
		</div>
	</section>

	<form action="?page=public&mode=saveSettings" method="post" enctype="multipart/form-data" class="admin-stack">
		<section class="admin-panel-grid">
			<div class="admin-panel-grid__wide admin-stack">
				<div class="admin-card">
					<div class="card-body">
						<label class="form-label fw-bold" for="homepage_intro_html">Encart éditorial de l’accueil</label>
						<p class="text-white-50 small">Ce contenu apparaît sur la page d’accueil, au-dessus du bouton d’inscription. Il accepte la mise en forme enrichie.</p>
						<textarea id="homepage_intro_html" name="homepage_intro_html" class="form-control bg-black text-white border-secondary rich-editor" rows="10">{$homepage_intro_html|escape:'html'}</textarea>
					</div>
				</div>

				<div class="admin-card">
					<div class="card-body">
						<label class="form-label fw-bold" for="public_rules_html">Page des règles</label>
						<p class="text-white-50 small">Si ce champ est vide, le texte de règles issu du fichier de langue reste utilisé.</p>
						<textarea id="public_rules_html" name="public_rules_html" class="form-control bg-black text-white border-secondary rich-editor" rows="10">{$public_rules_html|escape:'html'}</textarea>
					</div>
				</div>
			</div>

			<div class="admin-panel-grid__side admin-stack">
				<div class="admin-card">
					<div class="card-body">
						<h2 class="h5 mb-3">Navigation publique</h2>
						<div class="admin-toggle-list">
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_register" {if $public_menu_register}checked{/if}>Inscription</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_news" {if $public_menu_news}checked{/if}>Actualités</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_rules" {if $public_menu_rules}checked{/if}>Règles</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_screens" {if $public_menu_screens}checked{/if}>Captures d’écran</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_banlist" {if $public_menu_banlist}checked{/if}>Bannis</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_battlehall" {if $public_menu_battlehall}checked{/if}>Temple de la renommée</label>
							<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_disclamer" {if $public_menu_disclamer}checked{/if}>Contact administrateur</label>
						</div>
					</div>
				</div>

				<div class="admin-card">
					<div class="card-body">
						<h2 class="h5 mb-3">Discord</h2>
						<label class="form-check-label d-block mb-2"><input class="form-check-input me-2" type="checkbox" name="discord_active" {if $discord_active}checked{/if}>Afficher Discord dans le menu et le pied de page</label>
						<label class="form-label mt-3" for="discord_url">Lien Discord</label>
						<input id="discord_url" name="discord_url" type="url" class="form-control bg-black text-white border-secondary" value="{$discord_url|escape:'html'}" placeholder="https://discord.gg/...">
					</div>
				</div>
			</div>
		</section>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">Captures d’écran</h2>
					<p class="text-white-50 small mb-0">Gestion de la galerie publique, repliée par défaut pour garder la page éditoriale lisible sur mobile.</p>
				</div>
				<span class="admin-pill">{$public_screenshots|@count} visuel(x)</span>
			</summary>
			<div class="admin-fold__body">
				<section class="admin-card">
					<div class="card-body admin-stack">
						<div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
							<div>
								<h2 class="h5 mb-1">Captures d’écran</h2>
								<p class="text-white-50 small mb-0">Réorganisez l’ordre par glisser-déposer, choisissez la capture mise en avant et enrichissez chaque description.</p>
							</div>
							<input type="file" name="public_screens_upload[]" multiple accept=".png,.jpg,.jpeg,.gif,.webp" class="form-control bg-black text-white border-secondary" style="max-width:360px;">
						</div>
						{if $public_screenshots|@count > 0}
							<div class="row g-3" id="publicScreensAdminGrid">
								{foreach $public_screenshots as $screen name=publicScreensLoop}
									<div class="col-12 col-md-6 col-xl-4 public-screen-admin-column" draggable="true" data-path="{$screen.path|escape:'html'}">
										<div class="admin-card admin-screen-card h-100">
											<div class="admin-screen-card__preview" style="background:#111 url('{$screen.path}') center center / cover no-repeat;"></div>
											<div class="card-body">
												<input type="hidden" name="public_screens_path[]" value="{$screen.path|escape:'html'}">
												<div class="d-flex justify-content-between align-items-center gap-3 mb-3">
													<span class="admin-pill">Déplacer</span>
													<label class="form-check-label small text-warning">
														<input class="form-check-input me-2" type="radio" name="public_screens_featured_path" value="{$screen.path|escape:'html'}" {if $smarty.foreach.publicScreensLoop.first}checked{/if}>Mise en avant
													</label>
												</div>
												<label class="form-label small mb-1">Titre</label>
												<input type="text" name="public_screens_title[]" class="form-control bg-dark text-white border-secondary mb-2" value="{$screen.title|default:$screen.label|escape:'html'}">
												<label class="form-label small mb-1">Texte</label>
												<textarea name="public_screens_description[]" class="form-control bg-dark text-white border-secondary mb-3 rich-editor" rows="6">{$screen.description|escape:'html'}</textarea>
												<label class="form-check-label small text-white-50">
													<input class="form-check-input me-2" type="checkbox" name="delete_public_screens[]" value="{$screen.path|escape:'html'}">Supprimer cette capture
												</label>
											</div>
										</div>
									</div>
								{/foreach}
							</div>
						{else}
							<div class="admin-empty-state">Aucune capture personnalisée n’est enregistrée. La galerie utilise encore les visuels par défaut.</div>
						{/if}
					</div>
				</section>
			</div>
		</details>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div>
					<h2 class="h5 mb-1">SEO, métadonnées et sécurité d’inscription</h2>
					<p class="text-white-50 small mb-0">Bloc secondaire replié par défaut pour laisser la priorité au contenu éditorial principal.</p>
				</div>
				<span class="admin-pill">Secondaire</span>
			</summary>
			<div class="admin-fold__body">
				<section class="admin-panel-grid">
					<div class="admin-panel-grid__side">
						<div class="admin-card h-100">
							<div class="card-body">
								<label class="form-label fw-bold" for="secret_question_options">Questions secrètes de l’inscription</label>
								<p class="text-white-50 small">Une question par ligne. Cette liste sert à l’inscription et à la validation serveur.</p>
								<textarea id="secret_question_options" name="secret_question_options" class="form-control bg-black text-white border-secondary" rows="8">{$secret_question_options|escape:'html'}</textarea>
							</div>
						</div>
					</div>

					<div class="admin-panel-grid__wide">
						<div class="admin-card h-100">
							<div class="card-body">
								<h2 class="h5 mb-3">SEO et métadonnées</h2>
								<div class="row g-3">
									<div class="col-12">
										<label class="form-label" for="seo_meta_title">Titre SEO</label>
										<input id="seo_meta_title" name="seo_meta_title" type="text" class="form-control bg-black text-white border-secondary" value="{$seo_meta_title|escape:'html'}" maxlength="255">
									</div>
									<div class="col-12">
										<label class="form-label" for="seo_meta_description">Description</label>
										<textarea id="seo_meta_description" name="seo_meta_description" class="form-control bg-black text-white border-secondary" rows="4">{$seo_meta_description|escape:'html'}</textarea>
									</div>
									<div class="col-12">
										<label class="form-label" for="seo_meta_keywords">Mots-clés</label>
										<input id="seo_meta_keywords" name="seo_meta_keywords" type="text" class="form-control bg-black text-white border-secondary" value="{$seo_meta_keywords|escape:'html'}">
									</div>
									<div class="col-12">
										<label class="form-label" for="seo_og_image_url">Image Open Graph</label>
										<input id="seo_og_image_url" name="seo_og_image_url" type="text" class="form-control bg-black text-white border-secondary" value="{$seo_og_image_url|escape:'html'}" placeholder="styles/resource/images/meta.png ou https://...">
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>
			</div>
		</details>

		<section class="admin-form-submitbar">
			<div class="admin-form-submitbar__copy">
				<strong>Enregistrer le site public</strong>
				<span>La sauvegarde applique les textes, menus, captures, questions secrètes et métadonnées visibles sur cette page.</span>
			</div>
			<div class="d-flex justify-content-end">
				<button type="submit" class="btn btn-primary px-4">Enregistrer</button>
			</div>
		</section>
	</form>
</div>
{/block}
{block name="script" append}
<script>
document.addEventListener('DOMContentLoaded', function() {
	var grid = document.getElementById('publicScreensAdminGrid');
	if (!grid) {
		return;
	}

	var dragged = null;

	grid.querySelectorAll('.public-screen-admin-column').forEach(function(column) {
		column.addEventListener('dragstart', function(event) {
			dragged = column;
			column.classList.add('opacity-50');
			if (event.dataTransfer) {
				event.dataTransfer.effectAllowed = 'move';
			}
		});

		column.addEventListener('dragend', function() {
			column.classList.remove('opacity-50');
			dragged = null;
		});

		column.addEventListener('dragover', function(event) {
			event.preventDefault();
		});

		column.addEventListener('drop', function(event) {
			event.preventDefault();
			if (!dragged || dragged === column) {
				return;
			}

			var columns = Array.prototype.slice.call(grid.children);
			var draggedIndex = columns.indexOf(dragged);
			var targetIndex = columns.indexOf(column);

			if (draggedIndex < targetIndex) {
				grid.insertBefore(dragged, column.nextSibling);
			} else {
				grid.insertBefore(dragged, column);
			}
		});
	});
});
</script>
{/block}
