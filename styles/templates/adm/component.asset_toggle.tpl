<label class="admin-asset-toggle{if $checked} admin-asset-toggle--active{/if}">
	<input class="admin-asset-toggle__input" type="checkbox" name="{$name}"{if isset($value)} value="{$value}"{/if} {if $checked}checked="checked"{/if}>
	<div class="admin-asset-toggle__head">
		{if $tag|default:'' neq ''}<span class="admin-asset-toggle__tag">{$tag}</span>{/if}
		{if $tooltip|default:'' neq ''}
			<span class="admin-asset-toggle__hint" data-bs-toggle="tooltip" data-bs-placement="top" title="{$tooltip|escape:'html'}">?</span>
		{/if}
	</div>
	<div class="admin-asset-toggle__body">
		<div class="admin-asset-toggle__media">
			<img src="{$image}" alt="{$title|escape:'html'}">
		</div>
		<div class="admin-asset-toggle__content">
			<strong>{$title}</strong>
			<span>{if $checked}{$checkedLabel|default:'Activé'}{else}{$uncheckedLabel|default:'Désactivé'}{/if}</span>
		</div>
	</div>
	<div class="admin-asset-toggle__foot">
		<span class="admin-asset-toggle__state">{if $checked}{$checkedLabel|default:'Activé'}{else}{$uncheckedLabel|default:'Désactivé'}{/if}</span>
		<span class="admin-asset-toggle__switch" aria-hidden="true">
			<span class="admin-asset-toggle__knob"></span>
		</span>
	</div>
</label>
