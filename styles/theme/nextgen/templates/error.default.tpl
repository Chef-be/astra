{block name="title" prepend}{$LNG.fcm_info}{/block}
{block name="content"}
{assign var="messageRedirectTarget" value=""}
{if !empty($goto)}
	{assign var="messageRedirectTarget" value=$goto}
{elseif !empty($redirectButtons) && isset($redirectButtons[0].url)}
	{assign var="messageRedirectTarget" value=$redirectButtons[0].url}
{/if}
<table class="table table-gow fs-12 w-100">
	<tr>
		<th>{$LNG.fcm_info}</th>
	</tr>
	<tr>
		<td>
			<p>{$message}</p>
			<p class="mb-3">
				{$LNG.sys_back} automatique dans
				<strong data-game-message-count>{$gotoinsec|default:3}</strong>
				s
			</p>
			{if !empty($redirectButtons)}
			<p>
				{foreach $redirectButtons as $button}
				{if isset($button.url) && $button.label}
					<a href="{$button.url}">
						<button class="text-yellow fs-12">{$button.label}</button>
					</a>
				{/if}
				{/foreach}
			</p>
			{/if}
			<p class="mb-0">
				<a href="#" data-game-message-back>{$LNG.sys_back}</a>
			</p>
		</td>
	</tr>
</table>
<script>
document.addEventListener('DOMContentLoaded', function() {
	var counter = document.querySelector('[data-game-message-count]');
	var backLink = document.querySelector('[data-game-message-back]');
	var redirectTarget = '{$messageRedirectTarget|escape:"javascript"}';
	var fallbackTarget = 'game.php?page=overview';

	function hasSameOriginReferrer() {
		if (!document.referrer) {
			return false;
		}

		try {
			return new URL(document.referrer, window.location.href).origin === window.location.origin;
		} catch (error) {
			return false;
		}
	}

	function goBack() {
		if (hasSameOriginReferrer() && document.referrer !== window.location.href) {
			window.history.back();
			return;
		}

		window.location.href = redirectTarget || fallbackTarget;
	}

	if (backLink) {
		backLink.addEventListener('click', function(event) {
			event.preventDefault();
			goBack();
		});
	}

	if (!counter) {
		return;
	}

	var remaining = parseInt(counter.textContent, 10);
	if (isNaN(remaining) || remaining <= 0) {
		remaining = 3;
		counter.textContent = remaining;
	}

	var timer = window.setInterval(function() {
		remaining -= 1;
		if (remaining >= 0) {
			counter.textContent = remaining;
		}

		if (remaining <= 0) {
			window.clearInterval(timer);
			if (redirectTarget) {
				window.location.href = redirectTarget;
				return;
			}
			goBack();
		}
	}, 1000);
});
</script>
{/block}
