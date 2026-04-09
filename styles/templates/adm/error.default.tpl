{block name="title" prepend}{$LNG.fcm_info}{/block}
{block name="content"}
{assign var="adminRedirectTarget" value=""}
{if !empty($goto)}
	{assign var="adminRedirectTarget" value=$goto}
{elseif !empty($redirectButtons) && isset($redirectButtons[0].url)}
	{assign var="adminRedirectTarget" value=$redirectButtons[0].url}
{/if}
<section class="admin-message-shell">
	<article class="admin-message-card">
		<div class="admin-message-card__header">
			<span class="admin-pill">{$LNG.fcm_info}</span>
			<h2 class="admin-message-card__title">{$LNG.fcm_info}</h2>
		</div>

		<div class="admin-message-card__body">{$message}</div>

		<p class="admin-message-card__hint">
			Retour automatique dans
			<strong data-admin-redirect-count>{$gotoinsec|default:3}</strong>
			s
		</p>

		{if !empty($redirectButtons)}
			<div class="admin-message-card__actions">
				{foreach $redirectButtons as $button}
					{if isset($button.url) && $button.label}
						<a href="{$button.url}" class="admin-shell-action admin-shell-action--accent">{$button.label}</a>
					{/if}
				{/foreach}
			</div>
		{/if}

		<div class="admin-message-card__actions">
			<a href="#" class="admin-shell-action" data-admin-history-back>{$LNG.uvs_back|default:'Retour'}</a>
		</div>
	</article>
</section>

<script>
document.addEventListener('DOMContentLoaded', function() {
	var counter = document.querySelector('[data-admin-redirect-count]');
	var backLink = document.querySelector('[data-admin-history-back]');
	var redirectTarget = '{$adminRedirectTarget|escape:"javascript"}';
	var fallbackTarget = 'admin.php?page=overview';

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
