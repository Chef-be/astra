<?php

define('MODE', 'CRON');
define('ROOT_PATH', str_replace('\\', '/', dirname(__DIR__, 2)).'/');
set_include_path(ROOT_PATH);

require ROOT_PATH.'includes/common.php';
require ROOT_PATH.'includes/classes/Cronjob.class.php';

$cronjobsTodo = Cronjob::getNeedTodoExecutedJobs();
$results = array();

foreach ($cronjobsTodo as $cronjobId) {
	try {
		Cronjob::execute((int) $cronjobId);
		$results[] = array(
			'cronjob_id' => (int) $cronjobId,
			'status' => 'done',
		);
	} catch (Exception $exception) {
		$results[] = array(
			'cronjob_id' => (int) $cronjobId,
			'status' => 'failed',
			'error' => $exception->getMessage(),
		);
	}
}

echo json_encode(array(
	'now' => TIMESTAMP,
	'executed' => $results,
), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES).PHP_EOL;
