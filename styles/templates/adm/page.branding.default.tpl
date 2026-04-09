{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Identité visuelle</span>
			<h2>Logo global</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">Extensions {$allowedExtensions}</span>
		</div>
	</section>

	<div class="row g-4">
		<div class="col-12 col-xl-5">
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h5 mb-3">Logo global</h2>
					<form action="?page=branding&mode=save" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-3">
						<div class="admin-field-card">
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
					<h2 class="h5 mb-3">Aperçu</h2>
					<div class="admin-brand-preview">
						{if $brandLogoUrl}
							<img src="{$brandLogoUrl}" alt="Logo de la plateforme" class="admin-brand-preview__image">
						{else}
							<div class="admin-brand-preview__fallback">Aucun logo personnalisé téléversé</div>
						{/if}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
{/block}
