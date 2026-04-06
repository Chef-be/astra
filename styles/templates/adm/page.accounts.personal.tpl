{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Éditeur de compte</span>
			<h1 class="admin-hero__title">{$personalHero.title}</h1>
			<p class="admin-hero__subtitle">{$personalHero.subtitle}</p>
		</div>
	</section>

	<form action="admin.php?page=accounts&amp;mode=personalSend" method="post" autocomplete="off" class="admin-table-shell admin-stack">
		<div class="admin-table-toolbar">
			<a class="btn btn-outline-light" href="admin.php?page=accounts">{$LNG.ad_back_to_menu}</a>
		</div>
		<div class="admin-form-grid">
			<label class="admin-field-card">
				<span>{$LNG.input_id_user}</span>
				<input class="form-control bg-dark text-white border-secondary" name="id" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_personal_name}</span>
				<input class="form-control bg-dark text-white border-secondary" name="username" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_personal_pass}</span>
				<input class="form-control bg-dark text-white border-secondary" name="password" type="password" autocomplete="new-password">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_personal_email}</span>
				<input class="form-control bg-dark text-white border-secondary" name="email" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_personal_email2}</span>
				<input class="form-control bg-dark text-white border-secondary" name="email_2" type="text">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.ad_personal_vacat}</span>
				{html_options class="form-select bg-dark text-white border-secondary" name=vacation options=$Selector}
			</label>
		</div>

		<div class="admin-form-row">
			<label class="admin-field-card">
				<span>{$LNG.time_days}</span>
				<input class="form-control bg-dark text-white border-secondary" name="d" type="text" size="5" maxlength="5">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.time_hours}</span>
				<input class="form-control bg-dark text-white border-secondary" name="h" type="text" size="5" maxlength="10">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.time_minutes}</span>
				<input class="form-control bg-dark text-white border-secondary" name="m" type="text" size="5" maxlength="10">
			</label>
			<label class="admin-field-card">
				<span>{$LNG.time_seconds}</span>
				<input class="form-control bg-dark text-white border-secondary" name="s" type="text" size="5" maxlength="10">
			</label>
		</div>

		<div class="admin-actions">
			<button type="submit" class="btn btn-primary">{$LNG.button_submit}</button>
		</div>
	</form>
</div>
{/block}
