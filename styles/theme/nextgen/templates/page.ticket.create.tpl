{block name="title" prepend}{$LNG.ti_create_head} - {$LNG.lm_support}{/block}
{block name="content"}
<div class="container-fluid py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<div>
			<h1 class="h3 text-white mb-1">{$LNG.ti_create_head}</h1>
		</div>
		<a class="btn btn-outline-light btn-sm" href="game.php?page=ticket">Retour à la liste</a>
	</div>

	<form action="game.php?page=ticket&mode=send" method="post" id="form">
		<input type="hidden" name="id" value="0">
		<div class="card bg-dark border-secondary">
			<div class="card-body">
				<div class="mb-3">
					<label class="form-label text-white" for="category">{$LNG.ti_category}</label>
					<select id="category" name="category" class="form-select bg-dark text-white border-secondary">{html_options options=$categoryList}</select>
				</div>
				<div class="mb-3">
					<label class="form-label text-white" for="subject">{$LNG.ti_subject}</label>
					<input class="validate[required] form-control bg-dark text-white border-secondary" type="text" id="subject" name="subject" maxlength="255">
				</div>
				<div class="mb-3">
					<label class="form-label text-white" for="message">{$LNG.ti_message}</label>
					<textarea class="validate[required] form-control bg-dark text-white border-secondary rich-editor" id="message" name="message" rows="6"></textarea>
				</div>
				<button class="btn btn-primary" type="submit">{$LNG.ti_submit}</button>
			</div>
		</div>
	</form>
</div>
{/block}
{block name="script" append}
<script>
$(document).ready(function() {
$("#form").validationEngine('attach');
});
</script>
{/block}
