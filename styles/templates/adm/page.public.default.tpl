{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="row g-3">
		<div class="col-12">
			<div class="bg-black border border-secondary rounded-3 p-3 p-lg-4">
				<div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-2 mb-3">
					<div>
						<h1 class="h3 mb-1">Site public</h1>
						<p class="text-secondary mb-0">Pilotez la navigation de l’accueil, le contenu éditorial et les questions secrètes depuis un seul écran.</p>
					</div>
					<a class="btn btn-outline-light" href="index.php" target="_blank" rel="noopener">Voir le site public</a>
				</div>

				<form action="?page=public&mode=saveSettings" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-4">
					<div class="row g-3">
						<div class="col-12 col-xl-7">
							<div class="bg-dark border border-secondary rounded-3 p-3 h-100">
								<label class="form-label fw-bold" for="homepage_intro_html">Encart éditorial de l’accueil</label>
								<p class="text-secondary small">Ce contenu apparaît sur la page d’accueil, au-dessus du bouton d’inscription. Il accepte la mise en forme enrichie.</p>
								<textarea id="homepage_intro_html" name="homepage_intro_html" class="form-control bg-black text-white border-secondary rich-editor" rows="10">{$homepage_intro_html|escape:'html'}</textarea>
							</div>
						</div>
						<div class="col-12 col-xl-5">
							<div class="bg-dark border border-secondary rounded-3 p-3 mb-3">
								<h2 class="h5 mb-3">Navigation publique</h2>
								<div class="d-flex flex-column gap-2">
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_register" {if $public_menu_register}checked{/if}>Inscription</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_news" {if $public_menu_news}checked{/if}>Actualités</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_rules" {if $public_menu_rules}checked{/if}>Règles</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_screens" {if $public_menu_screens}checked{/if}>Captures d’écran</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_banlist" {if $public_menu_banlist}checked{/if}>Bannis</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_battlehall" {if $public_menu_battlehall}checked{/if}>Temple de la renommée</label>
									<label class="form-check-label"><input class="form-check-input me-2" type="checkbox" name="public_menu_disclamer" {if $public_menu_disclamer}checked{/if}>Contact administrateur</label>
								</div>
							</div>

							<div class="bg-dark border border-secondary rounded-3 p-3">
								<h2 class="h5 mb-3">Discord</h2>
								<label class="form-check-label d-block mb-2"><input class="form-check-input me-2" type="checkbox" name="discord_active" {if $discord_active}checked{/if}>Afficher Discord dans le menu et le pied de page</label>
								<label class="form-label mt-3" for="discord_url">Lien Discord</label>
								<input id="discord_url" name="discord_url" type="url" class="form-control bg-black text-white border-secondary" value="{$discord_url|escape:'html'}" placeholder="https://discord.gg/...">
							</div>
						</div>
					</div>

					<div class="bg-dark border border-secondary rounded-3 p-3">
						<label class="form-label fw-bold" for="public_rules_html">Page des règles</label>
						<p class="text-secondary small">Si ce champ est vide, le texte de règles issu du fichier de langue reste utilisé.</p>
						<textarea id="public_rules_html" name="public_rules_html" class="form-control bg-black text-white border-secondary rich-editor" rows="10">{$public_rules_html|escape:'html'}</textarea>
					</div>

					<div class="bg-dark border border-secondary rounded-3 p-3">
						<div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-2 mb-3">
							<div>
								<h2 class="h5 mb-1">Captures d’écran</h2>
								<p class="text-secondary small mb-0">Téléversez des visuels pour la galerie publique et supprimez ceux qui ne doivent plus être affichés.</p>
							</div>
							<input type="file" name="public_screens_upload[]" multiple accept=".png,.jpg,.jpeg,.gif,.webp" class="form-control bg-black text-white border-secondary" style="max-width:360px;">
						</div>
						{if $public_screenshots|@count > 0}
						<div class="row g-3">
							{foreach $public_screenshots as $screen}
							<div class="col-12 col-md-6 col-xl-4">
								<div class="border border-secondary rounded-3 overflow-hidden bg-black h-100">
									<div style="height:180px;background:#111 url('{$screen.path}') center center / cover no-repeat;"></div>
									<div class="p-3">
										<input type="hidden" name="public_screens_path[]" value="{$screen.path|escape:'html'}">
										<label class="form-label small mb-1">Titre</label>
										<input type="text" name="public_screens_title[]" class="form-control bg-dark text-white border-secondary mb-2" value="{$screen.title|default:$screen.label|escape:'html'}">
										<label class="form-label small mb-1">Texte</label>
										<textarea name="public_screens_description[]" class="form-control bg-dark text-white border-secondary mb-3" rows="3">{$screen.description|escape:'html'}</textarea>
										<label class="form-check-label small text-secondary">
											<input class="form-check-input me-2" type="checkbox" name="delete_public_screens[]" value="{$screen.path|escape:'html'}">Supprimer cette capture
										</label>
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{else}
						<div class="text-secondary small">Aucune capture personnalisée n’est enregistrée. La galerie utilise encore les visuels par défaut.</div>
						{/if}
					</div>

					<div class="bg-dark border border-secondary rounded-3 p-3">
						<label class="form-label fw-bold" for="secret_question_options">Questions secrètes de l’inscription</label>
						<p class="text-secondary small">Une question par ligne. La liste est utilisée sur la page d’inscription et pour la validation serveur.</p>
						<textarea id="secret_question_options" name="secret_question_options" class="form-control bg-black text-white border-secondary" rows="8">{$secret_question_options|escape:'html'}</textarea>
					</div>

					<div class="bg-dark border border-secondary rounded-3 p-3">
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

					<div class="d-flex justify-content-end">
						<button type="submit" class="btn btn-primary px-4">Enregistrer</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
{/block}
