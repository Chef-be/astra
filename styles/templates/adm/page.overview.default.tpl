{block name="content"}

<div class="helm-shell">
	<section class="helm-band">
		{foreach from=$overviewMetricStrip item=metric}
			<article class="helm-token">
				<span>{$metric.label}</span>
				<strong>{$metric.value}</strong>
			</article>
		{/foreach}
	</section>

	<section class="helm-grid">
		<article class="helm-panel helm-panel--signals">
			<div class="helm-panel__head">
				<div>
					<span class="helm-kicker">signaux</span>
					<h2>État direct</h2>
				</div>
				<span class="admin-pill">{$dashboard.generatedAt}</span>
			</div>

			<div class="helm-alertstack">
				{foreach from=$dashboard.alerts item=alert}
					<div class="helm-alert helm-alert--{$alert.level}">{$alert.message}</div>
				{/foreach}
			</div>

			<div class="helm-meterstack">
				{foreach from=$systemRail item=signal}
					<div class="helm-meter">
						<div class="helm-meter__top">
							<span>{$signal.label}</span>
							<strong>{$signal.value}</strong>
						</div>
						<div class="helm-meter__track">
							<span style="width: {$signal.ratio|default:0}%"></span>
						</div>
						<small>{$signal.detail}</small>
					</div>
				{/foreach}
			</div>
		</article>

		<article class="helm-panel helm-panel--commands">
			<div class="helm-panel__head">
				<div>
					<span class="helm-kicker">accès</span>
					<h2>Postes d’action</h2>
				</div>
			</div>

			<div class="helm-commanddeck">
				{foreach from=$commandDeck item=command}
					<a class="helm-command" href="{$command.url}">
						<i class="bi {$command.icon|default:'bi-dot'}"></i>
						<div class="helm-command__body">
							<strong>{$command.title}</strong>
							<span>{$command.subtitle}</span>
						</div>
						<em>{$command.metric}</em>
					</a>
				{/foreach}
			</div>
		</article>

		<article class="helm-panel helm-panel--control">
			<div class="helm-panel__head">
				<div>
					<span class="helm-kicker">contrôle</span>
					<h2>Nœuds techniques</h2>
				</div>
			</div>

			<div class="helm-controlgrid">
				{foreach from=$controlMatrix item=cell}
					<div class="helm-control">
						<span>{$cell.label}</span>
						<strong>{$cell.value}</strong>
						<small>{$cell.meta}</small>
					</div>
				{/foreach}
			</div>

			<div class="helm-docker">
				<span>Docker</span>
				<strong>{$dashboard.docker.statusMessage}</strong>
			</div>
		</article>

	</section>
</div>

{/block}
