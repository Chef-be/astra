<?php

define('MODE', 'CRON');
define('ROOT_PATH', str_replace('\\', '/', dirname(__DIR__, 2)).'/');
set_include_path(ROOT_PATH);

require ROOT_PATH.'includes/common.php';
require ROOT_PATH.'includes/classes/BotEngineService.class.php';

$phase = isset($argv[1]) ? (string) $argv[1] : 'cycle';
$limits = array(
	'cycle' => 18,
	'presence' => 24,
	'planning' => 18,
	'execution' => 24,
	'messaging' => 20,
	'campaigns' => 12,
	'compliance' => 50,
	'maintenance' => 40,
	'strategic' => 30,
	'long' => 36,
);

if (!isset($limits[$phase])) {
	fwrite(STDERR, 'Unknown bot phase: '.$phase.PHP_EOL);
	exit(1);
}

$staleThreshold = TIMESTAMP - 240;
Database::get()->update('UPDATE %%BOT_ENGINE_RUNS%% SET
	status = :status,
	finished_at = :finishedAt,
	error_summary = :errorSummary
	WHERE phase = :phase
	  AND status = \'running\'
	  AND started_at <= :staleThreshold;', array(
	':status' => 'failed',
	':finishedAt' => TIMESTAMP,
	':errorSummary' => 'Run interrompu automatiquement par le lanceur CLI.',
	':phase' => $phase,
	':staleThreshold' => $staleThreshold,
));

$results = array();
foreach (Universe::availableUniverses() as $universeId) {
	Universe::setEmulated($universeId);
	$service = new BotEngineService();
	$results[] = array(
		'universe' => (int) $universeId,
		'result' => $service->runCycle($phase, $limits[$phase]),
	);
}

echo json_encode(array(
	'now' => TIMESTAMP,
	'phase' => $phase,
	'results' => $results,
), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES).PHP_EOL;
