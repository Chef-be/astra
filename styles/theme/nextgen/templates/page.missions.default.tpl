{block name="content"}
<div class="container py-4 text-white">
	<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		<div>
			<h1 class="h3 mb-1">Missions</h1>
		</div>
		<div class="d-flex gap-2 flex-wrap">
			<span class="badge bg-secondary">En cours : {$missionsSnapshot.inProgress}</span>
			<span class="badge bg-warning text-dark">À réclamer : {$missionsSnapshot.claimable}</span>
			<span class="badge bg-success">Réclamées : {$missionsSnapshot.claimed}</span>
		</div>
	</div>

	<div class="row g-3">
		{foreach from=$missionsSnapshot.missions item=mission}
			<div class="col-12 col-lg-6">
				<div class="card bg-dark border-secondary h-100">
					<div class="card-body d-flex flex-column gap-3">
						<div class="d-flex justify-content-between align-items-start gap-3">
							<div>
								<div class="small text-uppercase text-white-50">{$mission.frequency_label}</div>
								<h2 class="h5 mb-1">{$mission.title}</h2>
								<p class="text-white-50 mb-0">{$mission.description}</p>
							</div>
							<span class="badge {if $mission.status == 'claimable'}bg-warning text-dark{elseif $mission.status == 'claimed'}bg-success{else}bg-secondary{/if}">
								{$mission.status_label}
							</span>
						</div>

						<div>
							<div class="d-flex justify-content-between small mb-1">
								<span>Progression</span>
								<span>{$mission.progress_value} / {$mission.target_value}</span>
							</div>
							<div class="progress" style="height:10px;">
								<div class="progress-bar {if $mission.status == 'claimable' || $mission.status == 'claimed'}bg-success{else}bg-info{/if}" style="width:{math equation='min((progress / target) * 100, 100)' progress=$mission.progress_value target=$mission.target_value}%;"></div>
							</div>
						</div>

						<div class="d-flex align-items-center gap-3 p-3 rounded border border-secondary bg-black bg-opacity-25">
							{if $mission.reward_type == 'resource'}
								<img src="styles/theme/nextgen/img/resources/{$mission.reward_key}.webp" alt="{$mission.reward_key}" style="width:48px;height:48px;object-fit:contain;">
							{elseif $mission.reward_type == 'darkmatter'}
								<img src="styles/theme/nextgen/img/resources/darkmatter.webp" alt="Matière noire" style="width:48px;height:48px;object-fit:contain;">
							{else}
								<img src="styles/theme/nextgen/gebaeude/{$mission.reward_key}.gif" alt="Récompense" style="width:48px;height:48px;object-fit:contain;border-radius:10px;">
							{/if}
							<div>
								<div class="small text-white-50">Récompense</div>
								<div class="fw-bold">
									{$mission.reward_value|number_format:0:',':' '} {$mission.reward_label}
								</div>
							</div>
						</div>

						<div class="mt-auto">
							{if $mission.status == 'claimable'}
								<a class="btn btn-success" href="game.php?page=missions&amp;mode=claim&amp;id={$mission.id}">Réclamer la récompense</a>
							{elseif $mission.status == 'claimed'}
								<span class="btn btn-outline-light disabled">Récompense déjà récupérée</span>
							{else}
								<span class="btn btn-outline-info disabled">Mission en progression</span>
							{/if}
						</div>
					</div>
				</div>
			</div>
		{/foreach}
	</div>
</div>
{/block}
