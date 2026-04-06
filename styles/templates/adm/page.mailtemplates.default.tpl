{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="row g-4">
		<div class="col-12 col-xl-3">
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
		<div class="col-12 col-xl-5">
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h4 mb-1">{$mailTemplateMeta.label}</h2>
					<p class="text-white-50 mb-3">{$mailTemplateMeta.description}</p>
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
			<div class="admin-card h-100">
				<div class="admin-card__body">
					<h2 class="h4 mb-3">Aperçu</h2>
					<pre class="admin-mail-preview">{$mailTemplatePreview|escape:'html'}</pre>
				</div>
			</div>
		</div>
	</div>
</div>
{/block}
