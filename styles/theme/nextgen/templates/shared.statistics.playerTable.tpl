<thead>
	<tr>
		<th style="width:72px;">{$LNG.st_position}</th>
		<th>{$LNG.st_player}</th>
		<th style="width:72px;">Contact</th>
		<th class="text-center">{$LNG.st_alliance}</th>
		<th class="text-end">{$LNG.st_points}</th>
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
		<td>
			<a class="stats-name {if $RangeInfo.id != $CUser_id && !empty($RangeInfo.class)}{foreach $RangeInfo.class as $class}{break}galaxy-short-{$class}{/foreach}{/if}" href="#" onclick="return Dialog.Playercard({$RangeInfo.id}, '{$RangeInfo.name}');"{if $RangeInfo.id == $CUser_id} style="color:#91eb8f"{/if}>{$RangeInfo.name}</a>
			{if $RangeInfo.is_leader}
				<span class="stats-leader">Chef</span>
			{/if}
			{if $RangeInfo.id != $CUser_id && !empty($RangeInfo.class)}
				<span class="small text-white-50 d-block mt-1">{foreach $RangeInfo.class as $class}{if !$class@first}, {/if}{$ShortStatus.$class}{/foreach}</span>
			{/if}
		</td>
		<td class="text-center">
			{if $RangeInfo.id != $CUser_id}
				<a class="stats-action" href="#" onclick="return Dialog.PM({$RangeInfo.id});" title="{$LNG.st_write_message}">✉</a>
			{else}
				<span class="text-white-50">-</span>
			{/if}
		</td>
		<td class="text-center">
			{if $RangeInfo.allyid != 0}
				<a class="stats-ally" href="game.php?page=alliance&amp;mode=info&amp;id={$RangeInfo.allyid}">{$RangeInfo.allyname}</a>
			{else}
				-
			{/if}
		</td>
		<td class="text-end fw-semibold">{$RangeInfo.points}</td>
	</tr>
{/foreach}
</tbody>
