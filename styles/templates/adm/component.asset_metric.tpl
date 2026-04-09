<label class="admin-asset-metric">
	<div class="admin-asset-metric__head">
		{if $tag|default:'' neq ''}<span class="admin-asset-toggle__tag">{$tag}</span>{/if}
		{if $tooltip|default:'' neq ''}
			<span class="admin-asset-toggle__hint" data-bs-toggle="tooltip" data-bs-placement="top" title="{$tooltip|escape:'html'}">?</span>
		{/if}
	</div>
	<div class="admin-asset-metric__body">
		<div class="admin-asset-metric__media">
			<img src="{$image}" alt="{$title|escape:'html'}">
		</div>
		<div class="admin-asset-metric__content">
			<strong>{$title}</strong>
			<input class="form-control bg-dark text-white border-secondary" name="{$name}" value="{$value}" type="number" min="{$min|default:'0'}" {if $max|default:'' neq ''}max="{$max}"{/if} {if $step|default:'' neq ''}step="{$step}"{/if}>
		</div>
	</div>
</label>
