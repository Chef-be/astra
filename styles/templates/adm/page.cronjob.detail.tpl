{block name="content"}
<div class="container-fluid py-3 text-white">
	<section class="admin-headerline admin-headerline--compact mb-3">
		<div class="admin-headerline__copy">
			<span class="admin-pill">Planification</span>
			<h2>{if $cronjobID == 0}{$LNG.cronjob_new}{else}{$LNG.cronjob_headline}{$cronjobID}{/if}</h2>
		</div>
		<div class="admin-headerline__actions">
			<a class="admin-shell-action admin-shell-action--light" href="admin.php?page=cronjob">Retour aux tâches</a>
		</div>
	</section>

	<form method="post" action="?page=cronjob&mode=edit" class="admin-card">
		<input type="hidden" name="id" value="{$cronjobID}">
		<div class="admin-card__body">
			{if !empty($error_msg)}
				<div class="alert alert-danger">
					{foreach from=$error_msg item=error}{$error}<br>{/foreach}
				</div>
			{/if}
			<div class="admin-form-grid">
				<div class="admin-field-card admin-field--full">
					<label for="name">{$LNG.cronjob_name}</label>
					<input id="name" type="text" name="name" value="{$name}" class="form-control bg-dark text-white border-secondary">
				</div>
				<div class="admin-field-card">
					<label>{$LNG.cronjob_min}</label>
					<select style="height:160px;" class="form-select bg-dark text-white border-secondary" name="min[]" multiple="multiple">{html_options values=range(0, 59) output=range(0, 59) selected=$min}</select>
					<div class="form-check mt-2"><input name="min_all" id="min_all" class="form-check-input" type="checkbox" value="1" {if $min.0 === "*" }checked{/if}><label for="min_all" class="form-check-label">{$LNG.cronjob_selectall}</label></div>
				</div>
				<div class="admin-field-card">
					<label>{$LNG.cronjob_hours}</label>
					<select style="height:160px;" class="form-select bg-dark text-white border-secondary" name="hours[]" multiple="multiple">{html_options values=range(0, 23) output=range(0, 23) selected=$hours}</select>
					<div class="form-check mt-2"><input name="hours_all" id="hours_all" class="form-check-input" type="checkbox" value="1" {if $hours.0==="*"}checked{/if}><label for="hours_all" class="form-check-label">{$LNG.cronjob_selectall}</label></div>
				</div>
				<div class="admin-field-card">
					<label>{$LNG.cronjob_dom}</label>
					<select style="height:160px;" class="form-select bg-dark text-white border-secondary" name="dom[]" multiple="multiple">{html_options values=range(1, 31) output=range(1, 31) selected=$dom}</select>
					<div class="form-check mt-2"><input name="dom_all" id="dom_all" class="form-check-input" type="checkbox" value="1" {if $dom.0==="*"}checked{/if}><label for="dom_all" class="form-check-label">{$LNG.cronjob_selectall}</label></div>
				</div>
				<div class="admin-field-card">
					<label>{$LNG.cronjob_month}</label>
					<select style="height:160px;" class="form-select bg-dark text-white border-secondary" name="month[]" multiple="multiple">{html_options values=range(1, 12) output=$LNG.months selected=$month}</select>
					<div class="form-check mt-2"><input name="month_all" id="month_all" class="form-check-input" type="checkbox" value="1" {if $month.0==="*"}checked{/if}><label for="month_all" class="form-check-label">{$LNG.cronjob_selectall}</label></div>
				</div>
				<div class="admin-field-card">
					<label>{$LNG.cronjob_dow}</label>
					<select style="height:160px;" class="form-select bg-dark text-white border-secondary" name="dow[]" multiple="multiple">{html_options values=range(0, 6) output=$LNG.week_day selected=$dow}</select>
					<div class="form-check mt-2"><input name="dow_all" id="dow_all" class="form-check-input" type="checkbox" value="1" {if $dow.0==="*"}checked{/if}><label for="dow_all" class="form-check-label">{$LNG.cronjob_selectall}</label></div>
				</div>
				<div class="admin-field-card admin-field--full">
					<label for="class">{$LNG.cronjob_class}</label>
					{html_options class="form-select bg-dark text-white border-secondary" name="class" id="class" output=$avalibleCrons values=$avalibleCrons selected=$class}
				</div>
			</div>
			<div class="admin-actions mt-4">
				<input type="submit" value="Enregistrer" class="btn btn-primary">
			</div>
		</div>
	</form>
</div>
{/block}
