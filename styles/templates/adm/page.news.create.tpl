{block name="content"}
{nocache}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Nouvelle publication</span>
			<h1 class="admin-hero__title">Créer une actualité</h1>
			<p class="admin-hero__subtitle">Préparez un article complet avec l’éditeur riche et publiez-le immédiatement.</p>
		</div>
	</section>

	<form method="post" action="admin.php?page=news&amp;mode=createSend" class="admin-table-shell admin-stack">
		{if isset($news_id)}<input name="id" type="hidden" value="{$news_id}">{/if}
		<label class="admin-field-card">
			<span>{$LNG.nws_title}</span>
			<input class="form-control bg-dark text-white border-secondary" type="text" name="title" value="{if isset($news_title)}{$news_title}{/if}">
		</label>
		<label class="admin-field-card">
			<span>{$LNG.nws_content}</span>
			<textarea class="form-control bg-dark text-white border-secondary rich-editor" rows="12" name="text">{if isset($news_text)}{$news_text|escape:'html'}{/if}</textarea>
		</label>
		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.button_submit}</button>
			<a class="btn btn-outline-light" href="admin.php?page=news">Retour aux actualités</a>
		</div>
	</form>
</div>
{/nocache}
{/block}
