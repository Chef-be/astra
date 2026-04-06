{block name="title" prepend}{$LNG.lm_logout}{/block}
{block name="content"}
<div class="container py-5">
	<div class="row justify-content-center">
		<div class="col-12 col-lg-7 col-xl-5">
			<div class="dark-blur-bg box-border box-shadow-large text-center p-4">
				<h1 class="h3 mb-3">Déconnexion effectuée</h1>
				<p class="mb-3">Votre session a été fermée proprement. Vous allez être redirigé vers l’accueil dans <span id="seconds">{$redirectDelay}</span> seconde(s).</p>
				<div class="d-flex justify-content-center gap-2 flex-wrap">
					<a class="btn btn-light" href="{$redirectUrl}">Retourner à l’accueil</a>
					<a class="btn btn-outline-light" href="./index.php?page=register">Créer un compte</a>
				</div>
			</div>
		</div>
	</div>
</div>
{block name="script" append}
<script type="text/javascript">
    var second = {$redirectDelay};
	function Countdown(){
		if(second == 0)
			return;

		second--;
		$('#seconds').text(second);
	}
	window.setTimeout(function() {
		window.location.href = '{$redirectUrl|escape:'javascript'}';
	}, {$redirectDelay} * 1000);
	window.setInterval("Countdown()", 1000);
</script>
{/block}
{/block}
