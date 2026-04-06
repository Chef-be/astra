<thead>
	<tr>
		<th style="width:72px;">{$LNG.st_position}</th>
		<th>{$LNG.st_alliance}</th>
		<th>{$LNG.st_members}</th>
		<th class="text-end">{$LNG.st_points}</th>
		<th class="text-end">{$LNG.st_per_member}</th>
	</tr>
</thead>
<tbody>
{foreach name=RangeList item=RangeInfo from=$RangeList}
	<tr>
		<td>
			<span class="stats-rank">{$RangeInfo.rank}</span>
			{if $RangeInfo.ranking == 0}
				<span class="stats-shift is-flat">•</span>
			{elseif $RangeInfo.ranking < 0}
				<span class="stats-shift is-down">{$RangeInfo.ranking}</span>
			{else}
				<span class="stats-shift is-up">+{$RangeInfo.ranking}</span>
			{/if}
		</td>
		<td><a class="stats-name" href="game.php?page=alliance&amp;mode=info&amp;id={$RangeInfo.id}"{if $RangeInfo.id == $CUser_ally} style="color:#91eb8f"{/if}>{$RangeInfo.name}</a></td>
		<td>{$RangeInfo.members}</td>
		<td class="text-end fw-semibold">{$RangeInfo.points}</td>
		<td class="text-end">{$RangeInfo.mppoints}</td>
	</tr>
{/foreach}
</tbody>
