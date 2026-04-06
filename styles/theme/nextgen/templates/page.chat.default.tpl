{block name="title" prepend}{$LNG.lm_chat}{/block}
{block name="content"}
{assign var="chatChannel" value="global"}
{if $smarty.get.channel|default:'' != ''}
	{assign var="chatChannel" value=$smarty.get.channel}
{elseif $smarty.get.action|default:'' == 'alliance'}
	{assign var="chatChannel" value="alliance"}
{/if}
<div class="p-2">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
		<div>
			<h1 class="h3 text-white mb-1">Discussion instantanée</h1>
		</div>
	</div>
	<div id="astra-live-chat"></div>
</div>
<script type="text/javascript">
window.addEventListener('load', function() {
	if (window.AstraRealtime) {
		window.AstraRealtime.mountChat('astra-live-chat', '{$chatChannel}');
	}
});
</script>
{/block}
