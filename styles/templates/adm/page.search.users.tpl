{block name="content"}
<div class="container-fluid py-3 text-white">
	<div class="admin-mini-hero mb-4">
		<h2 class="h3">Gestion rapide des rôles</h2>
		<p>Version ciblée de l’affectation des niveaux d’accès, utile pour les recherches internes et les corrections rapides.</p>
	</div>

	<div class="admin-card">
		<div class="admin-card__body">
			<form action="?page=rights&mode=usersSend" method="post">
				<div class="admin-actions mb-3">
					<a class="btn btn-outline-light btn-sm" href="?page=rights&mode=users&sid={$sid}&type=adm">{$ad_authlevel_aa}</a>
					<a class="btn btn-outline-light btn-sm" href="?page=rights&mode=users&sid={$sid}&type=ope">{$ad_authlevel_oo}</a>
					<a class="btn btn-outline-light btn-sm" href="?page=rights&mode=users&sid={$sid}&type=mod">{$ad_authlevel_mm}</a>
					<a class="btn btn-outline-light btn-sm" href="?page=rights&mode=users&sid={$sid}&type=pla">{$ad_authlevel_jj}</a>
					<a class="btn btn-outline-info btn-sm" href="?page=rights&mode=users&sid={$sid}">{$ad_authlevel_tt}</a>
				</div>
				<div class="admin-split">
					<div>
						<select name="id_1" size="20" class="admin-select-list">{$UserList}</select>
						<script type="text/javascript">
							var UserList = new filterlist(document.getElementsByName('id_1')[0]);
						</script>
						<div class="admin-filter-letters mt-3">
							<a href="javascript:UserList.set('^A')">A</a><a href="javascript:UserList.set('^B')">B</a><a href="javascript:UserList.set('^C')">C</a><a href="javascript:UserList.set('^D')">D</a><a href="javascript:UserList.set('^E')">E</a><a href="javascript:UserList.set('^F')">F</a><a href="javascript:UserList.set('^G')">G</a><a href="javascript:UserList.set('^H')">H</a><a href="javascript:UserList.set('^I')">I</a><a href="javascript:UserList.set('^J')">J</a><a href="javascript:UserList.set('^K')">K</a><a href="javascript:UserList.set('^L')">L</a><a href="javascript:UserList.set('^M')">M</a><a href="javascript:UserList.set('^N')">N</a><a href="javascript:UserList.set('^O')">O</a><a href="javascript:UserList.set('^P')">P</a><a href="javascript:UserList.set('^Q')">Q</a><a href="javascript:UserList.set('^R')">R</a><a href="javascript:UserList.set('^S')">S</a><a href="javascript:UserList.set('^T')">T</a><a href="javascript:UserList.set('^U')">U</a><a href="javascript:UserList.set('^V')">V</a><a href="javascript:UserList.set('^W')">W</a><a href="javascript:UserList.set('^X')">X</a><a href="javascript:UserList.set('^Y')">Y</a><a href="javascript:UserList.set('^Z')">Z</a>
						</div>
					</div>
					<div class="admin-form-grid">
						<div class="admin-field-card admin-field--full">
							<label for="regexp">Filtrer la liste</label>
							<div class="admin-actions">
								<input id="regexp" name="regexp" onkeyup="UserList.set(this.value)" class="form-control bg-dark text-white border-secondary" placeholder="Nom ou expression">
								<input type="button" onClick="UserList.set(this.form.regexp.value)" value="{$button_filter}" class="btn btn-outline-light">
								<input type="button" onClick="UserList.reset();this.form.regexp.value=''" value="{$button_deselect}" class="btn btn-outline-secondary">
							</div>
						</div>
						<div class="admin-field-card">
							<label for="id_2">{$ad_authlevel_insert_id}</label>
							<input id="id_2" name="id_2" type="text" class="form-control bg-dark text-white border-secondary">
						</div>
						<div class="admin-field-card">
							<label for="authlevel">{$ad_authlevel_auth}</label>
							{html_options class="form-select bg-dark text-white border-secondary" name=authlevel id="authlevel" options=$Selector}
						</div>
						<div class="admin-field-card admin-field--full">
							<input type="submit" value="{$button_submit}" class="btn btn-primary">
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
{/block}
