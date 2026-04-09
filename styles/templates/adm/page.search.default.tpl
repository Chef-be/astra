{block name="content"}
<div class="admin-settings-shell admin-stack">
	<section class="admin-headerline admin-headerline--compact">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Recherche</span>
			<h2>Recherche admin</h2>
		</div>
		<div class="admin-headerline__actions">
			<span class="admin-pill">Limite {$limit}</span>
			<span class="admin-pill">Tri {$OrderBY|default:'DESC'}</span>
		</div>
	</section>

	<form action="" method="post" class="admin-card">
		<div class="admin-card__body admin-stack">
			<div class="admin-form-grid--three">
				<div class="admin-field-card">
					<label for="key_user">{$se_intro}</label>
					<input id="key_user" class="form-control bg-dark text-white border-secondary" type="text" name="key_user" value="{$search}">
				</div>
				<div class="admin-field-card">
					<label for="search">{$se_type_typee}</label>
					{html_options class="form-select bg-dark text-white border-secondary" id="search" name=search options=$Selector.list selected=$SearchFile}
				</div>
				<div class="admin-field-card">
					<label for="search_in">{$se_search_in}</label>
					{html_options class="form-select bg-dark text-white border-secondary" id="search_in" name=search_in options=$Selector.search selected=$SearchFor}
				</div>
				<div class="admin-field-card">
					<label for="fuki">{$se_filter_title}</label>
					{html_options class="form-select bg-dark text-white border-secondary" id="fuki" name=fuki options=$Selector.filter selected=$SearchMethod}
				</div>
				<div class="admin-field-card">
					<label for="limit">{$se_limit}</label>
					{html_options class="form-select bg-dark text-white border-secondary" id="limit" name=limit options=$Selector.limit selected=$limit}
				</div>
				<div class="admin-field-card">
					<label for="key_acc">{$se_asc_desc}</label>
					{html_options class="form-select bg-dark text-white border-secondary" id="key_acc" name=key_acc options=$Selector.order selected=$OrderBY}
				</div>
				{if isset($OrderBYParse)}
					<div class="admin-field-card">
						<label for="key_order">{$se_search_order}</label>
						{html_options class="form-select bg-dark text-white border-secondary" id="key_order" name=key_order options=$OrderBYParse selected=$Order}
					</div>
				{/if}
				<div class="admin-field-card d-flex align-items-center">
					<div class="form-check mt-2">
						<input class="form-check-input" type="checkbox" {if isset($minimize)}{$minimize}{/if} name="minimize" id="minimize">
						<label class="form-check-label" for="minimize">{$se_contrac}</label>
					</div>
				</div>
			</div>
			{if !empty($error)}
				<div class="alert alert-danger mb-0">{$error}</div>
			{/if}
			<div class="admin-actions">
				<input type="submit" value="{$se_search}" class="btn btn-primary">
			</div>
		</div>
	</form>

	{if !empty($LIST)}
		<div class="admin-table-shell">
			<div class="admin-table-toolbar">
				<div class="admin-table-toolbar__meta">
					<span class="admin-pill">Résultats filtrés</span>
					<span class="admin-pill">Tri {$OrderBY|default:'DESC'}</span>
					<span class="admin-pill">Limite {$limit}</span>
				</div>
				<div>{$PAGES}</div>
			</div>
			<div class="admin-soft-separator mb-3"></div>
			<div>{$LIST}</div>
			{if !empty($PAGES)}
				<div class="admin-soft-separator mt-3 mb-3"></div>
				<div>{$PAGES}</div>
			{/if}
		</div>
	{else}
		<div class="admin-empty-state">
			Lance une recherche pour afficher les résultats ici.
		</div>
	{/if}
</div>
{/block}
