{block name="content"}
<div class="admin-settings-shell admin-stack admin-banned-page">
	<section class="admin-card">
		<div class="admin-card__body d-flex flex-wrap justify-content-between align-items-center gap-2">
			<div class="admin-cluster">
				<span class="admin-pill">Utilisateurs {$usercount}</span>
				<span class="admin-pill">Bannis {$bancount}</span>
			</div>
		</div>
	</section>

	<div class="admin-split">
		<details class="admin-fold admin-fold--compact" open>
			<summary class="admin-fold__summary">
				<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
					<div>
						<h3 class="h5 mb-1">Sélection d’un joueur</h3>
					</div>
					<div class="admin-stat-pill">{$LNG.bo_total_users} {$usercount}</div>
				</div>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-card">
					<div class="admin-card__body">
						<form action="?page=banned&mode=userDetail" method="post" name="users">
							<select name="target_id" size="20" class="admin-select-list">{$UserSelect.List}</select>
							<div class="admin-actions mt-3">
								<a class="btn btn-outline-light btn-sm" href="?page=banned&order=username">Nom</a>
								<a class="btn btn-outline-light btn-sm" href="?page=banned&order=id">ID</a>
								<a class="btn btn-outline-warning btn-sm" href="?page=banned&view=banned">Déjà bannis</a>
							</div>
							<script type="text/javascript">
								var UserList = new filterlist(document.getElementsByName('target_id')[0]);
							</script>
							<div class="admin-filter-letters mt-3">
								<a href="javascript:UserList.set('^A')">A</a><a href="javascript:UserList.set('^B')">B</a><a href="javascript:UserList.set('^C')">C</a><a href="javascript:UserList.set('^D')">D</a><a href="javascript:UserList.set('^E')">E</a><a href="javascript:UserList.set('^F')">F</a><a href="javascript:UserList.set('^G')">G</a><a href="javascript:UserList.set('^H')">H</a><a href="javascript:UserList.set('^I')">I</a><a href="javascript:UserList.set('^J')">J</a><a href="javascript:UserList.set('^K')">K</a><a href="javascript:UserList.set('^L')">L</a><a href="javascript:UserList.set('^M')">M</a><a href="javascript:UserList.set('^N')">N</a><a href="javascript:UserList.set('^O')">O</a><a href="javascript:UserList.set('^P')">P</a><a href="javascript:UserList.set('^Q')">Q</a><a href="javascript:UserList.set('^R')">R</a><a href="javascript:UserList.set('^S')">S</a><a href="javascript:UserList.set('^T')">T</a><a href="javascript:UserList.set('^U')">U</a><a href="javascript:UserList.set('^V')">V</a><a href="javascript:UserList.set('^W')">W</a><a href="javascript:UserList.set('^X')">X</a><a href="javascript:UserList.set('^Y')">Y</a><a href="javascript:UserList.set('^Z')">Z</a>
							</div>
							<div class="admin-actions mt-3">
								<input class="form-control bg-dark text-white border-secondary" name="regexp" onkeyup="UserList.set(this.value)" placeholder="Filtrer par expression">
								<input class="btn btn-outline-light" type="button" onclick="UserList.set(this.form.regexp.value)" value="{$LNG.button_filter}">
								<input class="btn btn-outline-secondary" type="button" onclick="UserList.reset();this.form.regexp.value=''" value="{$LNG.button_reset}">
							</div>
							<div class="admin-actions mt-4">
								<input type="submit" value="{$LNG.bo_ban}" name="panel" class="btn btn-warning">
							</div>
						</form>
					</div>
				</div>
			</div>
		</details>

		<details class="admin-fold admin-fold--compact">
			<summary class="admin-fold__summary">
				<div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
					<div>
						<h3 class="h5 mb-1">Levée de bannissement</h3>
					</div>
					<div class="admin-stat-pill">{$LNG.bo_total_banneds} {$bancount}</div>
				</div>
			</summary>
			<div class="admin-fold__body">
				<div class="admin-card">
					<div class="admin-card__body">
						<form action="?page=banned&mode=unbanUser" method="post">
							<select name="unban_name" size="20" class="admin-select-list">{$UserSelect.ListBan}</select>
							<div class="admin-actions mt-3">
								<a class="btn btn-outline-light btn-sm" href="?page=banned">Nom</a>
								<a class="btn btn-outline-light btn-sm" href="?page=banned&order2=id">ID</a>
							</div>
							<script type="text/javascript">
								var UsersBan = new filterlist(document.getElementsByName('unban_name')[0]);
							</script>
							<div class="admin-filter-letters mt-3">
								<a href="javascript:UsersBan.set('^A')">A</a><a href="javascript:UsersBan.set('^B')">B</a><a href="javascript:UsersBan.set('^C')">C</a><a href="javascript:UsersBan.set('^D')">D</a><a href="javascript:UsersBan.set('^E')">E</a><a href="javascript:UsersBan.set('^F')">F</a><a href="javascript:UsersBan.set('^G')">G</a><a href="javascript:UsersBan.set('^H')">H</a><a href="javascript:UsersBan.set('^I')">I</a><a href="javascript:UsersBan.set('^J')">J</a><a href="javascript:UsersBan.set('^K')">K</a><a href="javascript:UsersBan.set('^L')">L</a><a href="javascript:UsersBan.set('^M')">M</a><a href="javascript:UsersBan.set('^N')">N</a><a href="javascript:UsersBan.set('^O')">O</a><a href="javascript:UsersBan.set('^P')">P</a><a href="javascript:UsersBan.set('^Q')">Q</a><a href="javascript:UsersBan.set('^R')">R</a><a href="javascript:UsersBan.set('^S')">S</a><a href="javascript:UsersBan.set('^T')">T</a><a href="javascript:UsersBan.set('^U')">U</a><a href="javascript:UsersBan.set('^V')">V</a><a href="javascript:UsersBan.set('^W')">W</a><a href="javascript:UsersBan.set('^X')">X</a><a href="javascript:UsersBan.set('^Y')">Y</a><a href="javascript:UsersBan.set('^Z')">Z</a>
							</div>
							<div class="admin-actions mt-3">
								<input class="form-control bg-dark text-white border-secondary" name="regexp" onkeyup="UsersBan.set(this.value)" placeholder="Filtrer par expression">
								<input class="btn btn-outline-light" type="button" onclick="UsersBan.set(this.form.regexp.value)" value="{$LNG.button_filter}">
								<input class="btn btn-outline-secondary" type="button" onclick="UsersBan.reset();this.form.regexp.value=''" value="{$LNG.button_reset}">
							</div>
							<div class="admin-actions mt-4">
								<input value="{$LNG.bo_unban}" type="submit" class="btn btn-success">
							</div>
						</form>
					</div>
				</div>
			</div>
		</details>
	</div>
</div>
{/block}
