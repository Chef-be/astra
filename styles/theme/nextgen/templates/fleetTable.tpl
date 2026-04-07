<div class="fleetWrapper d-flex flex-column">
  <div class="position-relative w-100 d-flex align-items-center">
    {if empty($fleets)}
      <span class="text-center color-blue fs-11 fw-bold w-100">{$LNG.fm_no_fleet_movements}</span>
    {else}
      <span class="fs-14 color-gray text-center">{$LNG.fm_fleets}</span>
    {/if}
    {if !empty($fleets)}
    <button style="height:18px;width:18px;" onclick="showHideFleets();" class="btn btn-sm d-flex align-items-center justify-content-center p-0 m-0 position-absolute hover-pointer end-0 top-0" type="button" name="button">
      <i style="color:#ddd;" class="bi bi-caret-down-square-fill"></i>
    </button>
    {/if}
  </div>

  {if !empty($activeTemporaryBonuses)}
    <div class="mt-2 px-2 py-2" style="border-radius:12px;background:rgba(255,214,102,0.08);border:1px solid rgba(255,214,102,0.14);">
      <div class="d-flex align-items-center justify-content-between gap-2 mb-2">
        <span class="fs-11 fw-bold" style="color:#ffe29c;">Bonus temporaires actifs</span>
        <span class="fs-11" style="color:rgba(255,255,255,0.72);">{$activeTemporaryBonusCount} actif{if $activeTemporaryBonusCount > 1}s{/if}</span>
      </div>
      <div class="d-flex flex-column gap-1">
        {foreach from=$activeTemporaryBonuses item=bonus}
          <div class="d-flex justify-content-between align-items-start gap-2 fs-11">
            <div class="d-flex flex-column">
              <span style="color:#f8fbff;font-weight:700;">{$bonus.name}</span>
              {if $bonus.bonus_summary ne ''}
                <span style="color:rgba(255,255,255,0.7);">{$bonus.bonus_summary}</span>
              {/if}
            </div>
            <div class="text-end">
              <span style="color:#9ee37d;font-weight:700;">{$bonus.time_left_formatted}</span>
              <div style="color:rgba(255,255,255,0.55);">restant</div>
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  {/if}

    {foreach $fleets as $index => $fleet}
    <div class="fs-11 fleetRow {if $show_fleets_active}d-none{/if}">
      <span id="fleettime_{$index}" class="fleets" data-fleet-end-time="{$fleet.returntime}" data-fleet-time="{$fleet.resttime}">
        {pretty_fly_time({$fleet.resttime})}
      </span>
      <span id="fleettime_{$index}">{$fleet.text}</span>
    </div>
    {/foreach}

</div>


<script>
  function showHideFleets(){

    $.ajax({
        type: "POST",
        url: 'game.php?page=fleetTableSettings&mode=changeVisibility&ajax=1',
        success: function(data)
        {

          if ($('.fleetRow').hasClass('d-none')) {
            $('.fleetRow').removeClass('d-none')
          }else {
            $('.fleetRow').addClass('d-none')
          }

        }

    });

  }
</script>
