{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Intégration</span>
			<h2>Connexion Facebook</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">cURL {if $fb_curl == 1}Disponible{else}Indisponible{/if}</span>
		</div>
	</section>

	<form class="admin-settings-form admin-legacy-form admin-stack text-white fs-12" action="?page=facebook&mode=saveSettings" method="post">
		<div class="admin-note-card">
			<span class="admin-note-card__eyebrow">Statut</span>
			<h2 class="admin-note-card__title">{$LNG.fb_settings}</h2>
			<p>{$fb_info}</p>
			<p class="mb-0">{$fb_curl_info}</p>
		</div>
		<div class="form-group d-flex justify-content-start">
			<label for="fb_on" class="text-start my-1 cursor-pointer hover-underline text-white">{$LNG.fb_active}</label>
			<input id="fb_on" class="mx-2" name="fb_on"{if $fb_on == 1 && $fb_curl == 1} checked="checked"{/if} type="checkbox" {if $fb_curl == 0}disabled{/if}>
		</div>
		<div class="form-group d-flex flex-column">
			<label for="fb_apikey" class="text-start my-1 cursor-pointer hover-underline text-white">{$LNG.fb_api_key}</label>
			<input id="fb_apikey" class="form-control py-1 bg-dark text-white my-1 border border-secondary" name="fb_apikey" size="40" value="{$fb_apikey}" type="text" {if $fb_curl == 0}disabled{/if}>
		</div>
		<div class="form-group d-flex flex-column">
			<label for="fb_skey" class="text-start my-1 cursor-pointer hover-underline text-white">{$LNG.fb_secrectkey}</label>
			<input id="fb_skey" class="form-control py-1 bg-dark text-white my-1 border border-secondary" name="fb_skey" size="40" value="{$fb_skey}" type="text" {if $fb_curl == 0}disabled{/if}>
		</div>
		<div class="admin-form-submitbar">
			<div class="admin-form-submitbar__copy"><strong>{$LNG.se_save_parameters}</strong></div>
			<input class="btn btn-primary text-white my-1" value="{$LNG.se_save_parameters}" type="submit" {if $fb_curl == 0}disabled{/if}>
		</div>
	</form>
</div>

{/block}
