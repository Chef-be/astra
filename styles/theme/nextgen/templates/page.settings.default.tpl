{block name="title" prepend}{$LNG.lm_options}{/block}
{block name="content"}
<style>
	.settings-shell {
		display: grid;
		gap: 1rem;
		padding: 1rem 0;
		color: #f3f7ff;
	}

	.settings-hero,
	.settings-section {
		border-radius: 1.15rem;
		border: 1px solid rgba(255, 255, 255, 0.07);
		background: linear-gradient(180deg, rgba(10, 15, 28, 0.96), rgba(7, 11, 20, 0.98));
		box-shadow: 0 0.8rem 1.8rem rgba(0, 0, 0, 0.2);
	}

	.settings-hero {
		padding: 1.1rem 1.2rem;
		border-color: rgba(255, 214, 102, 0.16);
		background:
			radial-gradient(circle at top right, rgba(255, 214, 102, 0.16), transparent 36%),
			linear-gradient(145deg, rgba(11, 17, 32, 0.98), rgba(7, 12, 24, 0.98));
	}

	.settings-hero h1 {
		margin: 0 0 0.35rem;
		font-size: 1.55rem;
		color: #f8fbff;
	}

	.settings-hero p {
		margin: 0;
		color: rgba(255, 255, 255, 0.72);
		line-height: 1.55;
	}

	.settings-section {
		padding: 1rem;
	}

	.settings-section-head {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		margin-bottom: 0.85rem;
	}

	.settings-section-head h2 {
		margin: 0;
		font-size: 1.02rem;
		color: #ffd666;
	}

	.settings-grid {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 0.8rem 1rem;
	}

	.settings-grid--single {
		grid-template-columns: 1fr;
	}

	.settings-field label {
		display: block;
		margin-bottom: 0.35rem;
		color: rgba(255, 255, 255, 0.64);
		font-size: 0.82rem;
	}

	.settings-field small {
		display: block;
		margin-top: 0.25rem;
		color: rgba(255, 255, 255, 0.5);
	}

	.settings-static {
		padding: 0.65rem 0.8rem;
		border-radius: 0.85rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
		min-height: 42px;
		display: flex;
		align-items: center;
	}

	.settings-checklist {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 0.65rem;
	}

	.settings-check {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.8rem;
		padding: 0.7rem 0.8rem;
		border-radius: 0.9rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
	}

	.settings-check span {
		color: rgba(255, 255, 255, 0.78);
		font-size: 0.84rem;
	}

	.settings-check-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.55rem;
		margin-right: 0.35rem;
		font-size: 1rem;
	}

	.settings-backgrounds {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.75rem;
	}

	.settings-background {
		display: block;
		padding: 0.5rem;
		border-radius: 1rem;
		background: rgba(255, 255, 255, 0.03);
		border: 1px solid rgba(255, 255, 255, 0.06);
		cursor: pointer;
	}

	.settings-background input {
		margin-bottom: 0.45rem;
	}

	.settings-background img {
		display: block;
		width: 100%;
		height: 80px;
		object-fit: cover;
		border-radius: 0.8rem;
		border: 1px solid rgba(255, 214, 102, 0.14);
	}

	.settings-background span {
		display: block;
		margin-top: 0.45rem;
		color: rgba(255, 255, 255, 0.7);
		font-size: 0.8rem;
	}

	.settings-actions {
		display: flex;
		justify-content: end;
	}

	.settings-multi-links {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	.settings-banner {
		display: grid;
		gap: 0.8rem;
	}

	.settings-banner img {
		max-width: 100%;
		height: auto;
		border-radius: 0.9rem;
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	@media (max-width: 991px) {
		.settings-grid,
		.settings-checklist,
		.settings-backgrounds {
			grid-template-columns: 1fr;
		}
	}
</style>

<form action="game.php?page=settings" method="post">
<input type="hidden" name="mode" value="send">
<div class="settings-shell">
	<section class="settings-hero">
		<h1>{$LNG.lm_options}</h1>
		<p>Personnalisez votre compte, vos préférences d’affichage, vos raccourcis galaxie et votre mode de jeu depuis une page plus claire.</p>
	</section>

	{if $userAuthlevel > 0}
	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_admin_title_options}</h2></div>
		<div class="settings-checklist">
			<label class="settings-check">
				<span>{$LNG.op_admin_planets_protection}</span>
				<input name="adminprotection" type="checkbox" value="1" {if $adminProtection > 0}checked="checked"{/if}>
			</label>
		</div>
	</section>
	{/if}

	{if $isMultiUniverse}
	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.multiUniverse}</h2></div>
		<div class="settings-grid settings-grid--single">
			<div class="settings-static">{$newUniMsg|default:$LNG.multiUniverseDescription}</div>
			<div class="settings-multi-links">
				{foreach $availableUniverses as $universeID => $universeName}
					<a href="game.php?page=settings&startinuni={$universeID}" class="btn btn-outline-light btn-sm">{$LNG.startInMultiUniverse} {$universeName}</a>
				{/foreach}
			</div>
		</div>
	</section>
	{/if}

	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_user_data}</h2></div>
		<div class="settings-grid">
			<div class="settings-field">
				<label>{$LNG.op_username}</label>
				{if $changeNickTime < 0}
					<input class="form-control bg-dark text-white border-secondary" name="username" value="{$username}" type="text">
				{else}
					<div class="settings-static">{$username}</div>
				{/if}
			</div>
			<div class="settings-field">
				<label>{$LNG.op_permanent_email_adress}</label>
				<div class="settings-static">{$permaEmail}</div>
			</div>
			<div class="settings-field">
				<label>{$LNG.op_old_pass}</label>
				<input class="form-control bg-dark text-white border-secondary" name="password" type="password" autocomplete="new-password">
			</div>
			<div class="settings-field">
				<label>{$LNG.op_email_adress}</label>
				<input class="form-control bg-dark text-white border-secondary" name="email" maxlength="64" value="{$email}" type="text">
			</div>
			<div class="settings-field">
				<label>{$LNG.op_new_pass}</label>
				<input class="form-control bg-dark text-white border-secondary" name="newpassword" maxlength="40" type="password" autocomplete="new-password">
			</div>
			<div class="settings-field">
				<label>{$LNG.op_repeat_new_pass}</label>
				<input class="form-control bg-dark text-white border-secondary" name="newpassword2" maxlength="40" type="password" autocomplete="new-password">
			</div>
		</div>
	</section>

	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_general_settings}</h2></div>
		<div class="settings-grid">
			<div class="settings-field">
				<label>{$LNG.op_timezone}</label>
				{html_options class="form-select bg-dark text-white border-secondary" name=timezone options=$Selectors.timezones selected=$timezone}
			</div>
			{if count($Selectors.lang) > 1}
			<div class="settings-field">
				<label>{$LNG.op_lang}</label>
				{html_options class="form-select bg-dark text-white border-secondary" name=language options=$Selectors.lang selected=$userLang}
			</div>
			{/if}
			<div class="settings-field">
				<label>{$LNG.op_sort_planets_by}</label>
				{html_options class="form-select bg-dark text-white border-secondary" name=planetSort options=$Selectors.Sort selected=$planetSort}
			</div>
			<div class="settings-field">
				<label>{$LNG.op_sort_kind}</label>
				{html_options class="form-select bg-dark text-white border-secondary" name=planetOrder options=$Selectors.SortUpDown selected=$planetOrder}
			</div>
			{if $let_users_change_theme}
			<div class="settings-field">
				<label>{$LNG.op_skin_example}</label>
				<select class="form-select bg-dark text-white border-secondary" name="user_theme">
					<option {if $theme == 'nextgen'}selected{/if} value="nextgen">NextGen</option>
					<option {if $theme == 'nova'}selected{/if} value="nova">Nova</option>
					<option {if $theme == 'gow'}selected{/if} value="gow">Galaxy of Wars</option>
					<option {if $theme == 'EpicBlueXIII'}selected{/if} value="EpicBlueXIII">Epic Blue</option>
					<option {if $theme == 'office'}selected{/if} value="office">Office</option>
				</select>
			</div>
			{/if}
		</div>
	</section>

	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_background_image}</h2></div>
		<div class="settings-backgrounds">
			<label class="settings-background" for="mars"><input id="mars" type="radio" name="user_background_image" value="mars" {if $bg_img == 'mars'}checked{/if}><img src="styles/theme/nextgen/img/background/mars.webp" alt="Orange Mars"><span>Orange Mars</span></label>
			<label class="settings-background" for="light_green"><input id="light_green" type="radio" name="user_background_image" value="light_green" {if $bg_img == 'light_green'}checked{/if}><img src="styles/theme/nextgen/img/background/light_green.webp" alt="Green Canyon"><span>Green Canyon</span></label>
			<label class="settings-background" for="intense_blue"><input id="intense_blue" type="radio" name="user_background_image" value="intense_blue" {if $bg_img == 'intense_blue'}checked{/if}><img src="styles/theme/nextgen/img/background/intense_blue.webp" alt="Blue Nightsky"><span>Blue Nightsky</span></label>
			<label class="settings-background" for="dark_blue"><input id="dark_blue" type="radio" name="user_background_image" value="dark_blue" {if $bg_img == 'dark_blue'}checked{/if}><img src="styles/theme/nextgen/img/background/dark_blue.webp" alt="Dark Horizon"><span>Dark Horizon</span></label>
			<label class="settings-background" for="mountains"><input id="mountains" type="radio" name="user_background_image" value="mountains" {if $bg_img == 'mountains'}checked{/if}><img src="styles/theme/nextgen/img/background/mountains.webp" alt="Foggy Mountains"><span>Foggy Mountains</span></label>
			<label class="settings-background" for="orbit"><input id="orbit" type="radio" name="user_background_image" value="orbit" {if $bg_img == 'orbit'}checked{/if}><img src="styles/theme/nextgen/img/background/orbit.webp" alt="Orbit"><span>Orbit</span></label>
			<label class="settings-background" for="supernova"><input id="supernova" type="radio" name="user_background_image" value="supernova" {if $bg_img == 'supernova'}checked{/if}><img src="styles/theme/nextgen/img/background/supernova.webp" alt="Supernova"><span>Supernova</span></label>
			<label class="settings-background" for="spaceport"><input id="spaceport" type="radio" name="user_background_image" value="spaceport" {if $bg_img == 'spaceport'}checked{/if}><img src="styles/theme/nextgen/img/background/spaceport.webp" alt="Spaceport"><span>Spaceport</span></label>
		</div>
	</section>

	<section class="settings-section">
		<div class="settings-section-head"><h2>Messages et confidentialité</h2></div>
		<div class="settings-checklist">
			<label class="settings-check"><span>{$LNG.op_active_build_messages}</span><input name="queueMessages" type="checkbox" value="1" {if $queueMessages == 1}checked="checked"{/if}></label>
			<label class="settings-check"><span>{$LNG.op_active_spy_messages_mode}</span><input name="spyMessagesMode" type="checkbox" value="1" {if $spyMessagesMode == 1}checked="checked"{/if}></label>
			<label class="settings-check"><span>{$LNG.op_block_pm}</span><input name="blockPM" type="checkbox" value="1" {if $blockPM == 1}checked="checked"{/if}></label>
		</div>
	</section>

	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_galaxy_settings}</h2></div>
		<div class="settings-grid">
			<div class="settings-field">
				<label>{$LNG.op_spy_probes_number}</label>
				<input class="form-control bg-dark text-white border-secondary" name="spycount" value="{$spycount}" type="number" min="1">
			</div>
			<div class="settings-field">
				<label>{$LNG.op_max_fleets_messages}</label>
				<input class="form-control bg-dark text-white border-secondary" name="fleetactions" maxlength="2" value="{$fleetActions}" type="number" min="1">
			</div>
		</div>
		<div class="settings-checklist" style="margin-top:0.9rem;">
			<label class="settings-check"><span><span class="settings-check-icon">🔭</span>{$LNG.op_spy}</span><input name="galaxySpy" type="checkbox" value="1" {if $galaxySpy == 1}checked="checked"{/if}></label>
			<label class="settings-check"><span><span class="settings-check-icon">✉</span>{$LNG.op_write_message}</span><input name="galaxyMessage" type="checkbox" value="1" {if $galaxyMessage == 1}checked="checked"{/if}></label>
			<label class="settings-check"><span><span class="settings-check-icon">🤝</span>{$LNG.op_add_to_buddy_list}</span><input name="galaxyBuddyList" type="checkbox" value="1" {if $galaxyBuddyList == 1}checked="checked"{/if}></label>
			<label class="settings-check"><span><span class="settings-check-icon">🚀</span>{$LNG.op_missile_attack}</span><input name="galaxyMissle" type="checkbox" value="1" {if $galaxyMissle == 1}checked="checked"{/if}></label>
		</div>
	</section>

	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.op_vacation_delete_mode}</h2></div>
		<div class="settings-checklist">
			<label class="settings-check"><span>{$LNG.op_activate_vacation_mode}</span><input name="vacation" type="checkbox" value="1"></label>
			<label class="settings-check"><span>{$LNG.op_dlte_account}</span><input name="delete" type="checkbox" value="1" {if $delete > 0}checked="checked"{/if}></label>
		</div>
	</section>

	{if isModuleAvailable($smarty.const.MODULE_BANNER)}
	<section class="settings-section">
		<div class="settings-section-head"><h2>{$LNG.ov_userbanner}</h2></div>
		<div class="settings-banner">
			<img src="userpic.php?id={$userid}" alt="" width="590" height="95" id="userpic">
			<div class="settings-grid settings-grid--single">
				<div class="settings-field">
					<label>HTML</label>
					<input class="form-control bg-dark text-white border-secondary" type="text" value='<a href="{$SELF_URL}{if $ref_active}index.php?ref={$userid}{/if}"><img src="{$SELF_URL}userpic.php?id={$userid}"></a>' readonly>
				</div>
				<div class="settings-field">
					<label>BBCode</label>
					<input class="form-control bg-dark text-white border-secondary" type="text" value="[url={$SELF_URL}{if $ref_active}index.php?ref={$userid}{/if}][img]{$SELF_URL}userpic.php?id={$userid}[/img][/url]" readonly>
				</div>
			</div>
		</div>
	</section>
	{/if}

	<div class="settings-actions">
		<input class="btn btn-primary px-4" value="{$LNG.op_save_changes}" type="submit">
	</div>
</div>
</form>
{/block}
