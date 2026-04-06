{block name="content"}

<div class="admin-settings-shell">
<div class="admin-mini-hero">
	<h2 class="h4 mb-1">Champs planétaires par position</h2>
	<p>Définissez les valeurs minimales et maximales de champs pour chaque position orbitale.</p>
</div>
<form class="bg-black w-75 text-white p-3 my-3 mx-auto fs-12 admin-compact-form" action="?page=planetFields&mode=send" method="post">
<input type="hidden" name="opt_save" value="1">

<span class="fs-12 text-start d-flex fw-bold">Position 1 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_1_field_min">Minimum :</label>
  	<input id="planet_1_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_1_field_min" maxlength="5" size="10" value="{$planet_1_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_1_field_max">Maximum :</label>
  	<input id="planet_1_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_1_field_max" maxlength="5" size="10" value="{$planet_1_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 2 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_2_field_min">Minimum :</label>
  	<input id="planet_2_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_2_field_min" maxlength="5" size="10" value="{$planet_2_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_1_field_max">Maximum :</label>
  	<input id="planet_2_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_2_field_max" maxlength="5" size="10" value="{$planet_2_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 3 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_3_field_min">Minimum :</label>
  	<input id="planet_3_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_3_field_min" maxlength="5" size="10" value="{$planet_3_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_3_field_max">Maximum :</label>
  	<input id="planet_3_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_3_field_max" maxlength="5" size="10" value="{$planet_3_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 4 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_4_field_min">Minimum :</label>
  	<input id="planet_4_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_4_field_min" maxlength="5" size="10" value="{$planet_4_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_4_field_max">Maximum :</label>
  	<input id="planet_4_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_4_field_max" maxlength="5" size="10" value="{$planet_4_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 5 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_5_field_min">Minimum :</label>
  	<input id="planet_5_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_5_field_min" maxlength="5" size="10" value="{$planet_5_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_5_field_max">Maximum :</label>
  	<input id="planet_5_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_5_field_max" maxlength="5" size="10" value="{$planet_5_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 6 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_6_field_min">Minimum :</label>
  	<input id="planet_6_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_6_field_min" maxlength="5" size="10" value="{$planet_6_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_6_field_max">Maximum :</label>
  	<input id="planet_6_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_6_field_max" maxlength="5" size="10" value="{$planet_6_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 7 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_7_field_min">Minimum :</label>
  	<input id="planet_7_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_7_field_min" maxlength="5" size="10" value="{$planet_7_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_7_field_max">Maximum :</label>
  	<input id="planet_7_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_7_field_max" maxlength="5" size="10" value="{$planet_7_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 8 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_8_field_min">Minimum :</label>
  	<input id="planet_8_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_8_field_min" maxlength="5" size="10" value="{$planet_8_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_8_field_max">Maximum :</label>
  	<input id="planet_8_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_8_field_max" maxlength="5" size="10" value="{$planet_8_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 9 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_9_field_min">Minimum :</label>
  	<input id="planet_9_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_9_field_min" maxlength="5" size="10" value="{$planet_9_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_9_field_max">Maximum :</label>
  	<input id="planet_9_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_9_field_max" maxlength="5" size="10" value="{$planet_9_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 10 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_10_field_min">Minimum :</label>
  	<input id="planet_10_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_10_field_min" maxlength="5" size="10" value="{$planet_10_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_10_field_max">Maximum :</label>
  	<input id="planet_10_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_10_field_max" maxlength="5" size="10" value="{$planet_10_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 11 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_11_field_min">Minimum :</label>
  	<input id="planet_11_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_11_field_min" maxlength="5" size="10" value="{$planet_11_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_11_field_max">Maximum :</label>
  	<input id="planet_11_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_11_field_max" maxlength="5" size="10" value="{$planet_11_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 12 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_12_field_min">Minimum :</label>
  	<input id="planet_12_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_12_field_min" maxlength="5" size="10" value="{$planet_12_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_12_field_max">Maximum :</label>
  	<input id="planet_12_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_12_field_max" maxlength="5" size="10" value="{$planet_12_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 13 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_13_field_min">Minimum :</label>
  	<input id="planet_13_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_13_field_min" maxlength="5" size="10" value="{$planet_13_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_13_field_max">Maximum :</label>
  	<input id="planet_13_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_13_field_max" maxlength="5" size="10" value="{$planet_13_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 14 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_14_field_min">Minimum :</label>
  	<input id="planet_14_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_14_field_min" maxlength="5" size="10" value="{$planet_14_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_14_field_max">Maximum :</label>
  	<input id="planet_14_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_14_field_max" maxlength="5" size="10" value="{$planet_14_field_max}" type="text">
  </div>
</div>
<span class="fs-12 text-start d-flex fw-bold">Position 15 :</span>
<div class="form-gorup d-flex align-items-center my-1 p-2 border border-1 border-danger">
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_15_field_min">Minimum :</label>
  	<input id="planet_15_field_min" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_15_field_min" maxlength="5" size="10" value="{$planet_15_field_min}" type="text">
  </div>
  <div class="w-50 px-2">
    <label class="text-start my-1 cursor-pointer hover-underline" for="planet_15_field_max">Maximum :</label>
  	<input id="planet_15_field_max" class="form-control py-1 bg-dark text-white text-center my-1 border border-secondary" name="planet_15_field_max" maxlength="5" size="10" value="{$planet_15_field_max}" type="text">
  </div>
</div>


<div class="form-gorup d-flex flex-column my-1 p-2 ">
	<input  class="btn btn-primary text-white" value="{$LNG.se_save_parameters}" type="submit">
</div>
</form>

<form class="bg-black w-75 text-white p-3 my-3 mx-auto fs-12 admin-compact-form" action="?page=planetFields&mode=default" method="post">
  <div class="form-gorup d-flex flex-column my-1 p-2 ">
  	<input  class="btn btn-outline-light text-white" value="Rétablir les valeurs par défaut" type="submit">
  </div>
</form>
</div>

{/block}
