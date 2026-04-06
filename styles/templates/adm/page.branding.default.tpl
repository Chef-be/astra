{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="row g-4">
		<div class="col-12 col-xl-5">
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h4 mb-3">Logo global</h2>
					<p class="text-white-50 mb-3">Le logo téléversé sera utilisé sur l’accueil public, dans l’interface de jeu et dans l’administration quand il est disponible.</p>
					<form action="?page=branding&mode=save" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-3">
						<div>
							<label class="form-label" for="brand_logo">Téléverser un logo</label>
							<input id="brand_logo" class="form-control bg-dark text-white border-secondary" type="file" name="brand_logo" accept=".png,.jpg,.jpeg,.svg">
							<div class="small text-white-50 mt-2">Formats autorisés : {$allowedExtensions}</div>
						</div>
						<div class="d-flex gap-2 flex-wrap">
							<button type="submit" class="btn btn-primary">Enregistrer le logo</button>
							<label class="form-check-label d-flex align-items-center gap-2">
								<input class="form-check-input" type="checkbox" name="delete_logo">
								Supprimer le logo personnalisé
							</label>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div class="col-12 col-xl-7">
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h4 mb-3">Aperçu</h2>
					<div class="admin-brand-preview">
						{if $brandLogoUrl}
							<img src="{$brandLogoUrl}" alt="Logo de la plateforme" class="admin-brand-preview__image">
						{else}
							<div class="admin-brand-preview__fallback">Aucun logo personnalisé téléversé</div>
						{/if}
					</div>
					<div class="small text-white-50 mt-3">Le nom du jeu reste piloté dans le module “Serveur et identité”. Le logo téléversé vient compléter cette identité visuelle sur l’ensemble des écrans pris en charge.</div>
				</div>
			</div>
		</div>
	</div>
</div>
{/block}
