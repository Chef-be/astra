</div>
<footer class="dark-blur-bg footer-container box-shadow-large">
<span class="fs-6 m-0 rounded px-2 mb-1 text-white d-inline-flex align-items-center gap-2">
{$gameName} | Version : {$VERSION}
</span>
{if $publicPageFlags.disclamer}| <a class="text-white" href="index.php?page=disclamer">{$LNG.menu_disclamer}</a>{/if}
{if $discordEnabled}| <a class="text-white" href="{$discordUrl}" target="_blank" rel="noopener">Discord</a>{/if}

</footer>
</div>
<div id="dialog" style="display:none;"></div>
<script>
var LoginConfig = {
    'isMultiUniverse': {$isMultiUniverse|json},
	'unisWildcast': {$unisWildcast|json},
	'referralEnable' : {$referralEnable|json},
	'basePath' : {$basepath|json}
};
</script>
{if $analyticsEnable}
<script type="text/javascript" src="http://www.google-analytics.com/ga.js"></script>
<script type="text/javascript">
try{
var pageTracker = _gat._getTracker("{$analyticsUID}");
pageTracker._trackPageview();
} catch(err) {}</script>
{/if}
</body>
</html>
