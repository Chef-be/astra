{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Communication globale</span>
			<h1 class="admin-hero__title">Campagnes de messages</h1>
			<p class="admin-hero__subtitle">Diffusez un message global ingame, par courriel ou sur les deux canaux selon la configuration active du serveur.</p>
		</div>
	</section>

	<form action="admin.php?page=sendMessages&amp;mode=send" method="post" class="admin-table-shell admin-stack">
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.ma_mode}</span>
				{html_options class="form-select bg-dark text-white border-secondary" name=type options=$modes}
			</label>
			<label class="admin-field-card">
				<span>{$LNG.se_lang}</span>
				{html_options class="form-select bg-dark text-white border-secondary" name=globalmessagelang options=$langSelector}
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ma_subject}</span>
				<input class="form-control bg-dark text-white border-secondary" name="subject" id="subject" maxlength="40" value="{$LNG.ma_none}" type="text">
			</label>
		</div>

		<label class="admin-field-card">
			<span>{$LNG.ma_message} (<span id="cntChars">0</span> / 5000 {$LNG.ma_characters})</span>
			<textarea class="form-control bg-dark text-white border-secondary rich-editor" name="text" id="text" rows="12" onkeyup="$('#cntChars').text($('#text').val().length);"></textarea>
		</label>

		<div class="admin-actions">
			<button class="btn btn-primary" type="submit">{$LNG.button_submit}</button>
		</div>
	</form>
</div>
{/block}
