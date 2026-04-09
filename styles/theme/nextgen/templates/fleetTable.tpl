<div class="fleetWrapper d-flex flex-column dark-blur-bg box-border" style="margin:8px 0 14px;padding:12px 14px;border-radius:22px;border:1px solid rgba(255,255,255,0.12);background:linear-gradient(180deg, rgba(9,14,24,0.82) 0%, rgba(6,10,18,0.88) 100%);backdrop-filter:blur(14px);box-shadow:0 18px 42px rgba(0,0,0,0.26);">
  <div class="position-relative w-100 d-flex align-items-center">
    {if empty($fleets)}
      <span class="text-center fs-11 fw-bold w-100" style="color:#d7e8ff;letter-spacing:0.04em;text-transform:uppercase;">{$LNG.fm_no_fleet_movements}</span>
    {else}
      <span class="fs-14 text-center w-100" style="color:#d7e8ff;font-weight:700;letter-spacing:0.04em;text-transform:uppercase;">{$LNG.fm_fleets}</span>
    {/if}
    {if !empty($fleets)}
    <button style="height:28px;width:28px;border-radius:999px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);" onclick="showHideFleets();" class="btn btn-sm d-flex align-items-center justify-content-center p-0 m-0 position-absolute hover-pointer end-0 top-0" type="button" name="button">
      <i style="color:#d7e8ff;" class="bi bi-caret-down-square-fill"></i>
    </button>
    {/if}
  </div>

  {if !empty($activeTemporaryBonuses)}
    <div class="temporary-bonus-panel mt-3 px-3 py-3" style="border-radius:16px;background:linear-gradient(180deg, rgba(255,214,102,0.10) 0%, rgba(255,214,102,0.05) 100%);border:1px solid rgba(255,214,102,0.16);box-shadow:inset 0 1px 0 rgba(255,255,255,0.03);">
      <div class="d-flex align-items-center justify-content-between gap-2 mb-2">
        <span class="fs-11 fw-bold" style="color:#ffe29c;">Bonus temporaires actifs</span>
        <span class="temporary-bonus-count fs-11" style="color:rgba(255,255,255,0.72);">{$activeTemporaryBonusCount} actif{if $activeTemporaryBonusCount > 1}s{/if}</span>
      </div>
      <div class="d-flex flex-column gap-1">
        {foreach from=$activeTemporaryBonuses item=bonus}
          <div class="temporary-bonus-entry d-flex justify-content-between align-items-start gap-2 fs-11">
            <div class="d-flex flex-column">
              <span style="color:#f8fbff;font-weight:700;">{$bonus.name}</span>
              {if $bonus.bonus_summary ne ''}
                <span style="color:rgba(255,255,255,0.7);">{$bonus.bonus_summary}</span>
              {/if}
            </div>
            <div class="text-end">
              <span class="temporary-bonus-timer" data-time="{$bonus.time_left}" style="color:#9ee37d;font-weight:700;">{$bonus.time_left_formatted}</span>
              <div style="color:rgba(255,255,255,0.55);">restant</div>
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  {/if}

    {foreach $fleets as $index => $fleet}
    <div class="fs-11 fleetRow {if $show_fleets_active}d-none{/if}" style="margin-top:7px;padding:7px 9px;border-radius:12px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);color:#e6edf7;">
      <span id="fleettime_{$index}" class="fleets fleetRow__timer" data-fleet-end-time="{$fleet.returntime}" data-fleet-time="{$fleet.resttime}">
        {pretty_fly_time({$fleet.resttime})}
      </span>
      <span class="fleetRow__body">{$fleet.text}</span>
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
