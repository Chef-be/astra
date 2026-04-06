{block name="title" prepend}{$LNG.lm_alliance}{/block}
{block name="content"}
<form action="game.php?page=alliance&amp;mode=apply&amp;id={$allyid}" method="post">
<table class="table569">
	<tr>
		<th colspan="2">{$al_write_request}</th>
	</tr>
	<tr>
		<td width="40%"><label for="message">{$LNG.al_message}</label></td>
		<td>
			<textarea name="text" cols="40" rows="10" class="rich-editor bg-dark text-white" id="message">{$applytext|escape:'html'}</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input class="btn btn-block text-white btn-primary w-100 my-2" type="submit" value="{$LNG.al_applyform_send}">
		</td>
	</tr>
</table>
</form>
{/block}
