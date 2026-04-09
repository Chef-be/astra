<div class="admin-asset-range">
	<div class="admin-asset-range__head">
		{if $tag|default:'' neq ''}<span class="admin-asset-toggle__tag">{$tag}</span>{/if}
		{if $tooltip|default:'' neq ''}
			<span class="admin-asset-toggle__hint" data-bs-toggle="tooltip" data-bs-placement="top" title="{$tooltip|escape:'html'}">?</span>
		{/if}
	</div>
	<div class="admin-asset-range__hero">
		<div class="admin-asset-range__media">
			<img src="{$image}" alt="{$title|escape:'html'}">
		</div>
		<strong>{$title}</strong>
	</div>
	<div class="admin-asset-range__inputs">
		<label>
			<span>Min</span>
			<input class="form-control bg-dark text-white border-secondary" name="{$min_name}" value="{$min_value}" type="text">
		</label>
		<label>
			<span>Max</span>
			<input class="form-control bg-dark text-white border-secondary" name="{$max_name}" value="{$max_value}" type="text">
		</label>
	</div>
</div>
