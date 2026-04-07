{block name="content"}

<script>
$(document).ready(function(){
  var activeSection = $('#server-general').attr('id');

  $('#serverSettings .form-gorup').each(function() {
		if ($(this).hasClass('admin-section-title') && this.id) {
			activeSection = this.id;
		}

		$(this).attr('data-admin-section', activeSection || '');
  });

  function syncServerGroupVisibility() {
		$('#serverSettings .form-gorup').each(function() {
			var isHidden = $(this).hasClass('admin-search-hidden') || $(this).hasClass('admin-section-hidden');
			$(this).prop('hidden', isHidden);
			if (isHidden) {
				this.style.setProperty('display', 'none', 'important');
			} else {
				this.style.removeProperty('display');
			}
		});
  }

  function applyServerSearchFilter() {
		var value = ($('#searchInServerSettings').val() || '').toLowerCase().trim();
		$('#serverSettings .form-gorup').each(function() {
			var text = $(this).text().toLowerCase();
			var hasMatch = value === '' || text.indexOf(value) !== -1;
			$(this).toggleClass('admin-search-hidden', !hasMatch);
		});
  }

  function applyServerSectionFilter() {
		var isMobile = window.matchMedia('(max-width: 991px)').matches;
		var searchValue = ($('#searchInServerSettings').val() || '').trim();
		var currentSection = $('.admin-section-link.is-active').attr('href');
		currentSection = currentSection ? currentSection.replace('#', '') : $('#server-general').attr('id');

		$('#serverSettings .form-gorup').each(function() {
			if (!isMobile || searchValue !== '') {
				$(this).removeClass('admin-section-hidden');
				syncServerGroupVisibility();
				return;
			}

			var section = $(this).attr('data-admin-section');
			$(this).toggleClass('admin-section-hidden', section !== currentSection && !$(this).hasClass('admin-settings-toolbar') && !$(this).hasClass('admin-form-submitbar'));
		});

		syncServerGroupVisibility();
  }

  $("#searchInServerSettings").on("keyup", function() {
		applyServerSearchFilter();
		applyServerSectionFilter();
  });

  $('.admin-section-link').on('click', function(event) {
		$('.admin-section-link').removeClass('is-active');
		$(this).addClass('is-active');
		if (window.matchMedia('(max-width: 991px)').matches) {
			event.preventDefault();
			applyServerSectionFilter();
			window.scrollTo({ top: 0, behavior: 'smooth' });
		}
  });

  $(window).on('resize', applyServerSectionFilter);
  $('.admin-section-link[href="#server-general"]').addClass('is-active');
  applyServerSearchFilter();
  applyServerSectionFilter();
});
</script>

<div class="admin-settings-shell">
	<div class="admin-card">
		<div class="card-body">
			<div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
				<div>
					<h2 class="h4 mb-1">Organisation des paramètres</h2>
					<p class="text-white-50 mb-0">Les réglages sont regroupés par usage réel : identité, exposition publique, protection, diffusion et maintenance.</p>
				</div>
				<div class="admin-hero__meta">
					<div class="admin-hero__chip">Thème <strong>{$server_default_theme|default:'nextgen'}</strong></div>
					<div class="admin-hero__chip">Fuseau <strong>{$timezone}</strong></div>
					<div class="admin-hero__chip">SMTP <strong>{if $mail_active}actif{else}inactif{/if}</strong></div>
				</div>
			</div>
		</div>
	</div>

	<div class="admin-section-nav">
		<a class="admin-section-link" href="#server-general">Général</a>
		<a class="admin-section-link" href="#server-links">Liens publics</a>
		<a class="admin-section-link" href="#server-players">Joueurs</a>
		<a class="admin-section-link" href="#server-recaptcha">Protection</a>
		<a class="admin-section-link" href="#server-smtp">Courriels</a>
		<a class="admin-section-link" href="#server-messages">Messagerie</a>
		<a class="admin-section-link" href="#server-analytics">Mesure</a>
	</div>

<form id="serverSettings" class="text-white fs-12" action="?page=server&mode=saveSettings" method="post">
<input type="hidden" name="opt_save" value="1">

<div class="form-group d-flex justify-content-between admin-settings-toolbar admin-field--full">
	<div class="admin-form-submitbar__copy">
		<strong>{$LNG.se_server_parameters}</strong>
		<span>Recherche rapide, modifications guidées et sauvegarde globale des paramètres serveur.</span>
	</div>
	<input style="max-width:320px;" class="form-control bg-dark text-white border-secondary" id="searchInServerSettings" type="text" name="" placeholder="Rechercher un paramètre…">
</div>

<div id="server-general" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">Identité et expérience générale</span>
	<small>Nom du jeu, thème par défaut, fuseau horaire et récupération de compte.</small>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="game_name" class="text-start user-select-none my-1 cursor-pointer hover-underline">{$LNG.se_game_name}</label>
	<input id="game_name" class="form-control bg-dark text-white border-secondary" name="game_name" value="{$game_name}" type="text" >
</div>

<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="ttf_file" class="text-start user-select-none my-1 cursor-pointer hover-underline">{$LNG.se_ttf_file}</label>
	<input id="ttf_file" class="form-control bg-dark text-white border-secondary" name="ttf_file" size="40" value="{$ttf_file}" type="text">
</div>

<script>
$(document).ready(function(){
  $("#searchTimezone").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#timezone option").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
</script>

<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="timezone" class="text-start my-1 cursor-pointer hover-underline user-select-none">{$LNG.se_timzone}</label>
	<input class="form-control bg-dark text-white border-secondary my-1" id="searchTimezone" type="text" placeholder="Rechercher un fuseau horaire…" autocomplete="off">
	<select style="height:200px;" id="timezone" class="form-select bg-dark text-white border-secondary" name="timezone" size="10">
		{foreach $Selector.timezone as $field => $currentTimezone}
			{foreach $currentTimezone as $key => $cTimeZone}
			<option class="p-0" value="{$key}" {if $key == $timezone}selected{/if}>{$field} / {$cTimeZone}</option>
			{/foreach}
		{/foreach}
	</select>

</div>

<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="theme" class="text-start my-1 cursor-pointer hover-underline user-select-none">Thème par défaut</label>
	<select id="theme" class="form-select bg-dark text-white border-secondary" name="server_default_theme">
		<option {if $server_default_theme == 'nextgen'}selected{/if} value="nextgen">NeXt Generation</option>
		<option {if $server_default_theme == 'nova'}selected{/if} value="nova">Nova</option>
		<option {if $server_default_theme == 'gow'}selected{/if} value="gow">Gow</option>
		<option {if $server_default_theme == 'EpicBlueXIII'}selected{/if} value="EpicBlueXIII">EpicBlueXIII</option>
		<option {if $server_default_theme == 'office'}selected{/if} value="office">Office</option>
	</select>
</div>

<div class="form-gorup d-flex my-1 p-2 ">
	<label for="let_users_change_theme" class="text-start my-1 cursor-pointer hover-underline user-select-none">Autoriser les joueurs à changer de thème</label>
	<input id="let_users_change_theme" class="mx-2" name="let_users_change_theme"{if $let_users_change_theme} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="password_recover_type" class="text-start my-1 cursor-pointer hover-underline user-select-none">Type de récupération du mot de passe</label>
	<select id="password_recover_type" class="form-select bg-dark text-white border-secondary" name="password_recover_type">
		<option {if $password_recover_type == '1'}selected{/if} value="1">Par e-mail</option>
		<option {if $password_recover_type == '2'}selected{/if} value="2">Par question secrète</option>
	</select>
</div>
<div id="server-links" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">Liens publics</span>
	<small>Activation et paramétrage des liens visibles depuis l’accueil.</small>
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="discord_active" class="text-start my-1 cursor-pointer hover-underline user-select-none">Activer le lien Discord public</label>
	<input id="discord_active" class="mx-2" name="discord_active"{if $discord_active} checked="checked"{/if} type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="discord_url" class="text-start my-1 cursor-pointer hover-underline user-select-none">URL Discord</label>
	<input id="discord_url" class="form-control bg-dark text-white border-secondary" name="discord_url" value="{$discord_url}" type="url" placeholder="https://discord.gg/...">
</div>
<div id="server-players" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">{$LNG.se_player_settings}</span>
	<small>Suppression, conservation et règles liées aux comptes inactifs.</small>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="del_oldstuff" class="text-start my-1 cursor-pointer hover-underline user-select-none">{$LNG.se_del_oldstuff}</label>
	<input id="del_oldstuff" class="form-control bg-dark text-white border-secondary" name="del_oldstuff" maxlength="3" size="2" value="{$del_oldstuff}" type="text">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="del_user_manually" class="text-start my-1 cursor-pointer hover-underline user-select-none">{$LNG.se_del_user_manually}</label>
	<input id="del_user_manually" class="form-control bg-dark text-white border-secondary" name="del_user_manually" maxlength="3" size="2" value="{$del_user_manually}" type="text">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="del_user_automatic" class="text-start my-1 cursor-pointer hover-underline user-select-none">{$LNG.se_del_user_automatic}</label>
	<input id="del_user_automatic" class="form-control bg-dark text-white border-secondary" name="del_user_automatic" maxlength="3" size="2" value="{$del_user_automatic}" type="text">
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="sendmail_inactive" class="text-start my-1 cursor-pointer hover-underline user-select-none">{$LNG.se_sendmail_inactive}</label>
	<input id="sendmail_inactive" class="mx-2" name="sendmail_inactive"{if $sendmail_inactive} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="del_user_sendmail" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_del_user_sendmail}</label>
	<input id="del_user_sendmail" class="form-control bg-dark text-white border-secondary" name="del_user_sendmail" maxlength="3" size="2" value="{$del_user_sendmail}" type="text">
</div>
<div id="server-recaptcha" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">{$LNG.se_recaptcha_head}</span>
	<small>Protection des formulaires publics, d’inscription et d’administration.</small>
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="capaktiv" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_recaptcha_active}</label>
	<input id="capaktiv" class="mx-2" name="capaktiv"{if $capaktiv} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="cappublic" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_recaptcha_public}</label>
	<input id="cappublic" class="form-control bg-dark text-white border-secondary" name="cappublic" maxlength="40" size="60" value="{$cappublic}" type="text">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="capprivate" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_recaptcha_private}</label>
	<input id="capprivate" class="form-control bg-dark text-white border-secondary" name="capprivate" maxlength="40" size="60" value="{$capprivate}" type="text">
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="use_recaptcha_on_login" class="text-start my-1 cursor-pointer hover-underline">Activer reCAPTCHA sur la connexion</label>
	<input id="use_recaptcha_on_login" class="mx-2" name="use_recaptcha_on_login"{if $use_recaptcha_on_login} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="use_recaptcha_on_register" class="text-start my-1 cursor-pointer hover-underline">Activer reCAPTCHA sur l’inscription</label>
	<input id="use_recaptcha_on_register" class="mx-2" name="use_recaptcha_on_register"{if $use_recaptcha_on_register} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="use_recaptcha_on_admin_login" class="text-start my-1 cursor-pointer hover-underline">Activer reCAPTCHA sur la connexion admin</label>
	<input id="use_recaptcha_on_admin_login" class="mx-2" name="use_recaptcha_on_admin_login"{if $use_recaptcha_on_admin_login} checked="checked"{/if}  type="checkbox">
</div>
<div id="server-smtp" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">{$LNG.se_smtp}</span>
	<small>Canal d’envoi des courriels automatiques et système.</small>
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="mail_active" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_mail_active}</label>
	<input id="mail_active" class="mx-2" name="mail_active"{if $mail_active} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="mail_use" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_mail_use}</label>
	<select id="mail_use" class="form-select bg-dark text-white border-secondary" name="mail_use">
		{foreach $Selector.mail as $key => $currentMail}
		<option value="{$key}" {if $mail_use == $currentMail}selected{/if}>{$currentMail}</option>
		{/foreach}
	</select>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_sendmail" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_sendmail}</label>
	<input id="smtp_sendmail" class="form-control bg-dark text-white border-secondary" name="smtp_sendmail" size="20" value="{$smtp_sendmail}" type="text" autocomplete="off">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smail_path" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smail_path}</label>
	<input id="smail_path" class="form-control bg-dark text-white border-secondary" name="smail_path" size="20" value="{$smail_path}" type="text">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_host" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_host}</label>
	<input id="smtp_host" class="form-control bg-dark text-white border-secondary" name="smtp_host" size="20" value="{$smtp_host}" type="text" autocomplete="off">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_ssl" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_ssl}</label>
	<select id="smtp_ssl" class="form-select bg-dark text-white border-secondary" name="smtp_ssl">
		{foreach $Selector.encry as $key => $currentEncry}
			<option value="{$key}" {if $key == $smtp_ssl}selected{/if}>{$currentEncry}</option>
		{/foreach}
	</select>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_port" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_port}</label>
	<input id="smtp_port" class="form-control bg-dark text-white border-secondary" name="smtp_port" size="20" value="{$smtp_port}" type="text" autocomplete="off">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_user" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_user}</label>
	<input id="smtp_user" class="form-control bg-dark text-white border-secondary" name="smtp_user" size="20" value="{$smtp_user}" type="text" autocomplete="new-password">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="smtp_pass" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_smtp_pass}</label>
	<input id="smtp_pass" class="form-control bg-dark text-white border-secondary" name="smtp_pass" size="20" value="{$smtp_pass}" type="password" autocomplete="new-password">
</div>
<div id="server-messages" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">{$LNG.se_messages}</span>
	<small>Politique de conservation de la messagerie et nettoyage automatique.</small>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="message_delete_behavior" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_message_delete_behavior}</label>
	<select id="message_delete_behavior" class="form-select bg-dark text-white border-secondary" name="message_delete_behavior">
		{foreach $Selector.message_delete_behavior as $key => $currentBehaviour}
			<option value="{$key}" {if $key == $message_delete_behavior}selected{/if}>{$currentBehaviour}</option>
		{/foreach}
	</select>
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="message_delete_days" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_message_delete_days}</label>
	<input id="message_delete_days" class="form-control bg-dark text-white border-secondary" name="message_delete_days" size="20" value="{$message_delete_days}" type="number">
</div>
<div id="server-analytics" class="form-gorup d-flex flex-column my-1 p-2 admin-section-title">
	<span class="text-yellow fw-bold fs-14">{$LNG.se_google}</span>
	<small>Mesure d’audience et intégration analytique si utilisée.</small>
</div>
<div class="form-gorup d-flex my-1 p-2 ">
	<label for="ga_active" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_google_active}</label>
	<input id="ga_active" class="mx-2" name="ga_active"{if $ga_active} checked="checked"{/if}  type="checkbox">
</div>
<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<label for="ga_key" class="text-start my-1 cursor-pointer hover-underline">{$LNG.se_google_key}</label>
	<input id="ga_key" class="form-control bg-dark text-white border-secondary" name="ga_key" size="20" maxlength="15" value="{$ga_key}" type="text">
</div>
<div class="form-gorup admin-form-submitbar">
	<div class="admin-form-submitbar__copy">
		<strong>Enregistrer la configuration serveur</strong>
		<span>La sauvegarde applique l’ensemble des modifications visibles sur cette page.</span>
	</div>
	<div class="d-flex flex-wrap gap-2">
		<a class="admin-shell-action" href="admin.php?page=overview">Retour au tableau de bord</a>
		<a class="admin-shell-action admin-shell-action--warning" href="admin.php?page=clearCache">Ouvrir le cache</a>
		<input class="btn btn-primary text-white" value="{$LNG.se_save_parameters}" type="submit">
	</div>
</div>

</form>
</div>

{/block}
