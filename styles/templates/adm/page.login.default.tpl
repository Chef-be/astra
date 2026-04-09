{block name="content"}

<script type="text/javascript">
// this is the id of the form
function loginSubmit(activeRecaptcha,use_recaptcha_on_admin_login){
			var recaptchaResponse = false;

			if (activeRecaptcha == 1 && use_recaptcha_on_admin_login == 1) {
				recaptchaResponse = grecaptcha.getResponse();
			}

	    $.ajax({
	        type: "POST",
	        url: 'admin.php?page=login&mode=validate&ajax=1',
	        data: {
						password: $("#password").val(),
						g_recaptcha_response: recaptchaResponse,
					},
	        success: function(data)
	        {
						var dataParsed = jQuery.parseJSON(data);
						$('.alert').remove();

						if (dataParsed.status == 'fail') {
							if (activeRecaptcha == 1 && use_recaptcha_on_admin_login == 1) {
								grecaptcha.reset();
							}

							$.each( dataParsed, function( typeError, errorText ) {

								if (typeError == 'status') {
									return;
								}
								$('#loginButton').before("<span class='alert alert-danger fs-6 py-1 my-2'>"+ errorText +"</span>")

							});

		        }else if (dataParsed.status == 'redirect') {
							location.href = "admin.php?page=overview";
		        }

					}

	    });


}
</script>

<div class="admin-auth-shell">
	<section class="admin-auth-layout">
		<aside class="admin-auth-aside">
			<div class="admin-auth-visual">
				<div class="admin-auth-visual__media" style="background-image:linear-gradient(180deg, rgba(8, 12, 20, 0.18), rgba(8, 12, 20, 0.82)), url('./{$currentPageMeta.illustration|default:'styles/theme/nextgen/img/space.avif'}');"></div>
				<div class="admin-auth-visual__overlay">
					<div class="admin-auth-brand">
						<div class="admin-auth-logo">
							{if $brandLogoUrl}
								<img src="{$brandLogoUrl}" alt="{$gameName|default:'Astra Dominion'}">
							{else}
								<span>{$gameName|default:'Astra Dominion'}</span>
							{/if}
						</div>
						<span class="admin-auth-eyebrow">Administration sécurisée</span>
						<h1 class="admin-auth-title">Accès premium au poste de commande.</h1>
						<p class="admin-auth-copy">Compact, sombre, rapide.</p>
					</div>
				</div>
			</div>

			<div class="admin-auth-highlights">
				<article class="admin-auth-highlight">
					<span class="admin-auth-highlight__label">Usage</span>
					<strong class="admin-auth-highlight__value">Supervision, réglages, support</strong>
				</article>
				<article class="admin-auth-highlight">
					<span class="admin-auth-highlight__label">Sécurité</span>
					<strong class="admin-auth-highlight__value">{if $recaptchaEnable && $use_recaptcha_on_admin_login}reCAPTCHA actif{else}Validation locale{/if}</strong>
				</article>
				<article class="admin-auth-highlight">
					<span class="admin-auth-highlight__label">Compte</span>
					<strong class="admin-auth-highlight__value">{$username}</strong>
				</article>
			</div>
		</aside>

		<form action="?page=login&mode=validate" method="post" class="admin-auth-card" onsubmit="loginSubmit({$recaptchaEnable},{$use_recaptcha_on_admin_login}); return false;">
			<div class="admin-auth-card__header">
				<span class="admin-auth-card__eyebrow">{$LNG.adm_login}</span>
				<h2 class="admin-auth-card__title">Déverrouiller l’administration</h2>
				<p class="admin-auth-card__copy">Clé d’accès du compte courant.</p>
			</div>

			<div class="admin-auth-field">
				<label for="username">{$LNG.adm_username}</label>
				<input id="username" class="form-control user-select-none" type="text" readonly value="{$username}">
			</div>

			<div class="admin-auth-field">
				<label for="password">{$LNG.adm_password}</label>
				<input id="password" class="form-control" type="password" name="admin_pw" autocomplete="current-password">
			</div>

			{if $recaptchaEnable && $use_recaptcha_on_admin_login}
				<div class="admin-auth-recaptcha">
					<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey}"></div>
				</div>
			{/if}

			<div class="admin-auth-actions">
				<input id="loginButton" onclick="loginSubmit({$recaptchaEnable},{$use_recaptcha_on_admin_login});" class="btn btn-primary w-100" type="button" value="{$LNG.adm_absenden}">
			</div>

			<p class="admin-auth-note">Interface alignée sur le panneau principal, mobile inclus.</p>
		</form>
	</section>
</div>


	{if $recaptchaEnable && $use_recaptcha_on_admin_login}
		{block name="script" append}
			<script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl={$lang}"></script>
		{/block}
	{/if}

{/block}
