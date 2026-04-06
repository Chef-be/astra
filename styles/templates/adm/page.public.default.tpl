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

				<form action="?page=public&mode=saveSettings" method="post" class="d-flex flex-column gap-4">
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
						<label class="form-label fw-bold" for="secret_question_options">Questions secrètes de l’inscription</label>
						<p class="text-secondary small">Une question par ligne. La liste est utilisée sur la page d’inscription et pour la validation serveur.</p>
						<textarea id="secret_question_options" name="secret_question_options" class="form-control bg-black text-white border-secondary" rows="8">{$secret_question_options|escape:'html'}</textarea>
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
