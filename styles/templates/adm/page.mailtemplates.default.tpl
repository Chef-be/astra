{block name="content"}
<div class="admin-settings-shell admin-stack admin-mailtemplates-page">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Communication</span>
			<h2>Modèles d’e-mails</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">{$mailTemplates|@count} modèles</span>
		</div>
	</section>
	<div class="row g-4">
		<div class="col-12 col-xl-3">
			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
						<div>
							<h2 class="h5 mb-1">Modèles et variables</h2>
						</div>
						<span class="admin-pill">{$mailTemplates|@count} modèle(s)</span>
					</div>
				</summary>
				<div class="admin-fold__body">
					<div class="admin-card h-100">
						<div class="admin-card__body">
							<h2 class="h5 mb-3">Modèles disponibles</h2>
							<div class="d-flex flex-column gap-2">
								{foreach from=$mailTemplates key=templateKey item=templateMeta}
									<a class="admin-template-link {if $mailTemplateName == $templateKey}is-active{/if}" href="?page=mailtemplates&template={$templateKey|escape:'url'}">
										<span class="fw-semibold">{$templateMeta.label}</span>
										<span class="small text-white-50">{$templateMeta.description}</span>
									</a>
								{/foreach}
							</div>
							<div class="mt-4">
								<h3 class="h6 mb-2">Variables disponibles</h3>
								<div class="d-flex flex-wrap gap-2">
									{foreach from=$mailTemplateVariables item=placeholder}
										<span class="badge bg-secondary">{$placeholder}</span>
									{/foreach}
								</div>
							</div>
						</div>
					</div>
				</div>
			</details>
		</div>
		<div class="col-12 col-xl-5">
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h5 mb-1">{$mailTemplateMeta.label}</h2>
					<form action="?page=mailtemplates&mode=save" method="post" class="d-flex flex-column gap-3">
						<input type="hidden" name="template" value="{$mailTemplateName|escape:'html'}">
						<textarea name="content" class="form-control admin-code-editor" rows="20">{$mailTemplateContent|escape:'html'}</textarea>
						<div class="d-flex justify-content-end">
							<button type="submit" class="btn btn-primary">Enregistrer le modèle</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div class="col-12 col-xl-4">
			<details class="admin-fold admin-fold--compact">
				<summary class="admin-fold__summary">
					<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
						<div>
							<h2 class="h5 mb-1">Aperçu</h2>
						</div>
						<span class="admin-pill">Prévisualisation</span>
					</div>
				</summary>
				<div class="admin-fold__body">
					<div class="admin-card h-100">
						<div class="admin-card__body">
							<pre class="admin-mail-preview">{$mailTemplatePreview|escape:'html'}</pre>
						</div>
					</div>
				</div>
			</details>
		</div>
	</div>
</div>
{/block}
