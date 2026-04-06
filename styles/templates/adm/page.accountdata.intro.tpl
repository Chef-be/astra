{block name="content"}
<div class="admin-settings-shell">
	<section class="admin-hero">
		<div>
			<span class="admin-hero__eyebrow">Exploration de compte</span>
			<h1 class="admin-hero__title">Choisir un joueur à inspecter</h1>
			<p class="admin-hero__subtitle">Sélectionnez un compte dans la liste filtrable ou saisissez directement son identifiant numérique.</p>
		</div>
	</section>

	<form action="" method="post" name="users" class="admin-table-shell admin-stack">
		<div>
			<h2 class="h5 mb-1">{$ac_enter_user_id}</h2>
			<p class="text-white-50 mb-0">Le filtre alphabétique reste disponible pour parcourir rapidement de longues listes.</p>
		</div>

		<div class="admin-field-card">
			<select name="id_u" size="20" class="form-select bg-dark text-white border-secondary" style="min-height: 22rem;">
				{$Userlist}
			</select>
		</div>

		<div class="admin-filter-letters">
			<a href="javascript:UserList.set('^A')" title="{$bo_select_title} A">A</a>
			<a href="javascript:UserList.set('^B')" title="{$bo_select_title} B">B</a>
			<a href="javascript:UserList.set('^C')" title="{$bo_select_title} C">C</a>
			<a href="javascript:UserList.set('^D')" title="{$bo_select_title} D">D</a>
			<a href="javascript:UserList.set('^E')" title="{$bo_select_title} E">E</a>
			<a href="javascript:UserList.set('^F')" title="{$bo_select_title} F">F</a>
			<a href="javascript:UserList.set('^G')" title="{$bo_select_title} G">G</a>
			<a href="javascript:UserList.set('^H')" title="{$bo_select_title} H">H</a>
			<a href="javascript:UserList.set('^I')" title="{$bo_select_title} I">I</a>
			<a href="javascript:UserList.set('^J')" title="{$bo_select_title} J">J</a>
			<a href="javascript:UserList.set('^K')" title="{$bo_select_title} K">K</a>
			<a href="javascript:UserList.set('^L')" title="{$bo_select_title} L">L</a>
			<a href="javascript:UserList.set('^M')" title="{$bo_select_title} M">M</a>
			<a href="javascript:UserList.set('^N')" title="{$bo_select_title} N">N</a>
			<a href="javascript:UserList.set('^O')" title="{$bo_select_title} O">O</a>
			<a href="javascript:UserList.set('^P')" title="{$bo_select_title} P">P</a>
			<a href="javascript:UserList.set('^Q')" title="{$bo_select_title} Q">Q</a>
			<a href="javascript:UserList.set('^R')" title="{$bo_select_title} R">R</a>
			<a href="javascript:UserList.set('^S')" title="{$bo_select_title} S">S</a>
			<a href="javascript:UserList.set('^T')" title="{$bo_select_title} T">T</a>
			<a href="javascript:UserList.set('^U')" title="{$bo_select_title} U">U</a>
			<a href="javascript:UserList.set('^V')" title="{$bo_select_title} V">V</a>
			<a href="javascript:UserList.set('^W')" title="{$bo_select_title} W">W</a>
			<a href="javascript:UserList.set('^X')" title="{$bo_select_title} X">X</a>
			<a href="javascript:UserList.set('^Y')" title="{$bo_select_title} Y">Y</a>
			<a href="javascript:UserList.set('^Z')" title="{$bo_select_title} Z">Z</a>
		</div>

		<div class="admin-form-row">
			<label class="admin-field-card">
				<span>Filtre libre</span>
				<input class="form-control bg-dark text-white border-secondary" name="regexp" onkeyup="UserList.set(this.value)">
			</label>
			<label class="admin-field-card">
				<span>{$ac_select_id_num}</span>
				<input class="form-control bg-dark text-white border-secondary" type="text" name="id_u2" size="4">
			</label>
		</div>

		<div class="admin-actions">
			<button type="button" class="btn btn-outline-light" onclick="UserList.set(this.form.regexp.value)">{$button_filter}</button>
			<button type="button" class="btn btn-outline-light" onclick="UserList.reset();this.form.regexp.value=''">{$button_deselect}</button>
			<button type="submit" class="btn btn-primary">{$button_submit}</button>
		</div>
	</form>
</div>

<script>
var UserList = new filterlist(document.users.id_u);
</script>
{/block}
