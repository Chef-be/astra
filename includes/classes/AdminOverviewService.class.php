<?php

class AdminOverviewService
{
    public function getSnapshot()
    {
        return array(
            'generatedAt' => date('d/m/Y H:i:s', TIMESTAMP),
            'game'        => $this->getGameMetrics(),
            'system'      => $this->getSystemMetrics(),
            'docker'      => $this->getDockerMetrics(),
            'alerts'      => $this->getAlerts(),
        );
    }

    private function getGameMetrics()
    {
        $db         = Database::get();
        $universe   = Universe::getEmulated();
        $activeTime = TIMESTAMP - (15 * 60);

        $metrics = array(
            'universe'        => $universe,
            'universesTotal'  => count(Universe::availableUniverses()),
            'usersTotal'      => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe;', array(':universe' => $universe)),
            'botsTotal'       => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1;', array(':universe' => $universe)),
            'activePlayers'   => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 0 AND onlinetime >= :activeTime;', array(':universe' => $universe, ':activeTime' => $activeTime)),
            'activeBots'      => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND is_bot = 1 AND onlinetime >= :activeTime;', array(':universe' => $universe, ':activeTime' => $activeTime)),
            'sessionsActive'  => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%SESSION%% WHERE lastonline >= :activeTime;', array(':activeTime' => $activeTime)),
            'planetsTotal'    => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%PLANETS%% WHERE universe = :universe;', array(':universe' => $universe)),
            'fleetsFlying'    => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%FLEETS%% WHERE fleet_universe = :universe AND fleet_mess = 0;', array(':universe' => $universe)),
            'ticketsOpen'     => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%TICKETS%% WHERE universe = :universe AND status = 0;', array(':universe' => $universe)),
            'newsTotal'       => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%NEWS%%;', array()),
            'registrations24' => (int) $this->selectCount($db, 'SELECT COUNT(*) AS count FROM %%USERS%% WHERE universe = :universe AND register_time >= :registerTime;', array(':universe' => $universe, ':registerTime' => TIMESTAMP - 86400)),
        );

        $humanUsers = max(0, $metrics['usersTotal'] - $metrics['botsTotal']);
        $metrics['humanUsers'] = $humanUsers;
        $metrics['activePlayersPercent'] = $humanUsers > 0 ? min(100, round(($metrics['activePlayers'] / $humanUsers) * 100)) : 0;
        $metrics['activeBotsPercent']    = $metrics['botsTotal'] > 0 ? min(100, round(($metrics['activeBots'] / $metrics['botsTotal']) * 100)) : 0;

        return $metrics;
    }

    private function getSystemMetrics()
    {
        require_once ROOT_PATH.'includes/classes/RedisAdminService.class.php';

        $loadAverages = $this->getLoadAverages();
        $memory       = $this->getMemoryMetrics();
        $disk         = $this->getDiskMetrics(ROOT_PATH);
        $cache        = $this->getDirectoryMetrics(ROOT_PATH.'cache');
        $redisService = new RedisAdminService();

        return array(
            'hostName'       => php_uname('n'),
            'phpVersion'     => PHP_VERSION,
            'appVersion'     => Config::get(Universe::getEmulated())->VERSION,
            'loadAverage'    => $loadAverages,
            'memory'         => $memory,
            'disk'           => $disk,
            'cacheFiles'     => $cache['files'],
            'cacheSizeBytes' => $cache['bytes'],
            'cacheSizeHuman' => $this->formatBytes($cache['bytes']),
            'redis'          => $redisService->getSnapshot(),
        );
    }

    private function getDockerMetrics()
    {
        $services = $this->fetchDockerContainers();

        if ($services === null) {
            $cliServices = $this->fetchDockerContainersFromCli();
            if ($cliServices !== null) {
                $services = $cliServices;
            }
        }

        if ($services === null) {
            return array(
                'available'      => false,
                'astraDetected'  => false,
                'servicesTotal'  => 0,
                'astraServices'  => array(),
                'hostServices'   => array(),
                'statusMessage'  => 'La supervision Docker n’est pas encore joignable depuis l’administration.',
            );
        }

        $astraServices = $this->filterAstraServices($services);

        return array(
            'available'      => true,
            'astraDetected'  => !empty($astraServices),
            'servicesTotal'  => count($astraServices),
            'astraServices'  => $astraServices,
            'hostServices'   => array(),
            'statusMessage'  => !empty($astraServices)
                ? 'Les services du stack Astra sont bien détectés.'
                : 'Docker répond, mais aucun service Astra n’a été détecté pour le moment.',
        );
    }

    private function getAlerts()
    {
        $alerts = array();

        if (file_exists(ROOT_PATH.'update.php')) {
            $alerts[] = array('level' => 'warning', 'message' => 'Le fichier update.php est présent à la racine.');
        }

        if (file_exists(ROOT_PATH.'webinstall.php')) {
            $alerts[] = array('level' => 'warning', 'message' => 'Le fichier webinstall.php est présent à la racine.');
        }

        if (file_exists(ROOT_PATH.'includes/ENABLE_INSTALL_TOOL')) {
            $alerts[] = array('level' => 'danger', 'message' => 'L’installateur reste actif via includes/ENABLE_INSTALL_TOOL.');
        }

        if (defined('DB_UPGRADE_REQUIRED') && DB_UPGRADE_REQUIRED) {
            $alerts[] = array('level' => 'danger', 'message' => 'Le schéma de base est en retard. Le web-upgrader est désactivé : appliquer les migrations SQL localement.');
        }

        if (!is_writable(ROOT_PATH.'cache')) {
            $alerts[] = array('level' => 'danger', 'message' => 'Le dossier cache/ n’est pas accessible en écriture.');
        }

        require_once ROOT_PATH.'includes/classes/RedisAdminService.class.php';
        $redisStatus = new RedisAdminService();
        $redisSnapshot = $redisStatus->getSnapshot();
        if (!$redisSnapshot['available']) {
            $alerts[] = array('level' => 'warning', 'message' => 'Redis n’est pas joignable depuis l’administration.');
        }

        if (count($alerts) === 0) {
            $alerts[] = array('level' => 'success', 'message' => 'Aucune alerte bloquante n’a été détectée sur les contrôles de base.');
        }

        return $alerts;
    }

    private function getLoadAverages()
    {
        $loads = function_exists('sys_getloadavg') ? sys_getloadavg() : false;
        if ($loads === false || count($loads) < 3) {
            $raw = @file_get_contents('/proc/loadavg');
            if ($raw !== false) {
                $parts = preg_split('/\s+/', trim($raw));
                $loads = array_slice($parts, 0, 3);
            } else {
                $loads = array(0, 0, 0);
            }
        }

        return array(
            'one'     => (float) $loads[0],
            'five'    => (float) $loads[1],
            'fifteen' => (float) $loads[2],
        );
    }

    private function getMemoryMetrics()
    {
        $memory = array(
            'total'        => 0,
            'available'    => 0,
            'used'         => 0,
            'percent'      => 0,
            'totalHuman'   => '0 B',
            'usedHuman'    => '0 B',
            'availableHuman' => '0 B',
        );

        $raw = @file('/proc/meminfo', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        if ($raw === false) {
            return $memory;
        }

        $memInfo = array();
        foreach ($raw as $line) {
            if (preg_match('/^([A-Za-z_]+):\s+(\d+)/', $line, $matches)) {
                $memInfo[$matches[1]] = (int) $matches[2] * 1024;
            }
        }

        $memory['total']     = isset($memInfo['MemTotal']) ? $memInfo['MemTotal'] : 0;
        $memory['available'] = isset($memInfo['MemAvailable']) ? $memInfo['MemAvailable'] : 0;
        $memory['used']      = max(0, $memory['total'] - $memory['available']);
        $memory['percent']   = $memory['total'] > 0 ? min(100, round(($memory['used'] / $memory['total']) * 100)) : 0;
        $memory['totalHuman']     = $this->formatBytes($memory['total']);
        $memory['usedHuman']      = $this->formatBytes($memory['used']);
        $memory['availableHuman'] = $this->formatBytes($memory['available']);

        return $memory;
    }

    private function getDiskMetrics($path)
    {
        $total = @disk_total_space($path);
        $free  = @disk_free_space($path);
        $used  = ($total !== false && $free !== false) ? max(0, $total - $free) : 0;

        return array(
            'path'          => $path,
            'total'         => $total !== false ? $total : 0,
            'free'          => $free !== false ? $free : 0,
            'used'          => $used,
            'percent'       => ($total !== false && $total > 0) ? min(100, round(($used / $total) * 100)) : 0,
            'totalHuman'    => $this->formatBytes($total !== false ? $total : 0),
            'freeHuman'     => $this->formatBytes($free !== false ? $free : 0),
            'usedHuman'     => $this->formatBytes($used),
        );
    }

    private function getDirectoryMetrics($directory)
    {
        $result = array('files' => 0, 'bytes' => 0);

        if (!is_dir($directory)) {
            return $result;
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($directory, FilesystemIterator::SKIP_DOTS)
        );

        foreach ($iterator as $item) {
            if (!$item->isFile()) {
                continue;
            }

            $result['files']++;
            $result['bytes'] += $item->getSize();
        }

        return $result;
    }

    private function formatBytes($bytes)
    {
        $bytes = (float) $bytes;
        $units = array('B', 'KB', 'MB', 'GB', 'TB', 'PB');
        $power = 0;

        while ($bytes >= 1024 && $power < count($units) - 1) {
            $bytes /= 1024;
            $power++;
        }

        return number_format($bytes, $power === 0 ? 0 : 2, '.', ' ').' '.$units[$power];
    }

    private function selectCount(Database $db, $sql, array $params)
    {
        $count = $db->selectSingle($sql, $params, 'count');
        return $count === null ? 0 : $count;
    }

    private function fetchDockerContainers()
    {
        $payload = $this->fetchJson('http://astra-docker-socket-proxy:2375/containers/json?all=1');
        if (!is_array($payload)) {
            return null;
        }

        $services = array();
        foreach ($payload as $container) {
            $name = '';
            if (!empty($container['Names'][0])) {
                $name = ltrim($container['Names'][0], '/');
            }

            if ($name === '') {
                continue;
            }

            $status = isset($container['Status']) ? trim($container['Status']) : '';
            $image  = isset($container['Image']) ? trim($container['Image']) : '';

            $services[] = array(
                'name'    => $name,
                'status'  => $this->translateDockerStatus($status),
                'image'   => $image,
                'labels'  => isset($container['Labels']) && is_array($container['Labels']) ? $container['Labels'] : array(),
                'healthy' => stripos($status, 'healthy') !== false,
                'running' => stripos($status, 'up') === 0,
            );
        }

        return $services;
    }

    private function fetchDockerContainersFromCli()
    {
        $dockerBinary = $this->runCommand('command -v docker 2>/dev/null');
        if (empty($dockerBinary)) {
            return null;
        }

        $rawOutput = $this->runCommand($dockerBinary.' ps --format "{{.Names}}|{{.Status}}|{{.Image}}" 2>/dev/null');
        if (empty($rawOutput)) {
            return array();
        }

        $services = array();
        $lines = preg_split('/\r\n|\r|\n/', trim($rawOutput));
        foreach ($lines as $line) {
            if ($line === '') {
                continue;
            }

            $parts  = explode('|', $line);
            $name   = isset($parts[0]) ? trim($parts[0]) : '';
            $status = isset($parts[1]) ? trim($parts[1]) : '';
            $image  = isset($parts[2]) ? trim($parts[2]) : '';

            if ($name === '') {
                continue;
            }

            $services[] = array(
                'name'    => $name,
                'status'  => $this->translateDockerStatus($status),
                'image'   => $image,
                'labels'  => array(),
                'healthy' => stripos($status, 'healthy') !== false,
                'running' => stripos($status, 'up') === 0,
            );
        }

        return $services;
    }

    private function filterAstraServices(array $services)
    {
        $astraServices = array();

        foreach ($services as $service) {
            $labels = isset($service['labels']) && is_array($service['labels']) ? $service['labels'] : array();
            $project = isset($labels['com.docker.compose.project']) ? (string) $labels['com.docker.compose.project'] : '';
            $composeService = isset($labels['com.docker.compose.service']) ? (string) $labels['com.docker.compose.service'] : '';
            $name = isset($service['name']) ? (string) $service['name'] : '';
            $image = isset($service['image']) ? (string) $service['image'] : '';

            if (
                $project === 'astra'
                || strpos($name, 'astra-') === 0
                || strpos($composeService, 'astra-') === 0
                || strpos($image, 'astra-') !== false
            ) {
                $astraServices[] = $service;
            }
        }

        return $astraServices;
    }

    private function translateDockerStatus($status)
    {
        $status = trim((string) $status);
        if ($status === '') {
            return 'Statut inconnu';
        }

        $translated = $status;
        $replacements = array(
            '/\bUp\b/i' => 'En ligne',
            '/\bExited\b/i' => 'Arrêté',
            '/\bRestarting\b/i' => 'Redémarrage',
            '/\bPaused\b/i' => 'En pause',
            '/\bCreated\b/i' => 'Créé',
            '/\bDead\b/i' => 'En échec',
            '/\bAbout an hour\b/i' => 'environ une heure',
            '/\bAbout a minute\b/i' => 'environ une minute',
            '/\bLess than a second\b/i' => 'moins d’une seconde',
            '/\bseconds\b/i' => 'secondes',
            '/\bsecond\b/i' => 'seconde',
            '/\bminutes\b/i' => 'minutes',
            '/\bminute\b/i' => 'minute',
            '/\bhours\b/i' => 'heures',
            '/\bhour\b/i' => 'heure',
            '/\bdays\b/i' => 'jours',
            '/\bday\b/i' => 'jour',
            '/\bweeks\b/i' => 'semaines',
            '/\bweek\b/i' => 'semaine',
            '/\bmonths\b/i' => 'mois',
            '/\bmonth\b/i' => 'mois',
            '/\byears\b/i' => 'ans',
            '/\byear\b/i' => 'an',
            '/\bago\b/i' => '',
            '/\bSince\b/i' => 'depuis',
            '/\bstarting\b/i' => 'démarrage',
            '/\bhealth: starting\b/i' => 'vérification de santé : démarrage',
            '/\bhealthy\b/i' => 'sain',
            '/\bunhealthy\b/i' => 'dégradé',
        );

        foreach ($replacements as $pattern => $replacement) {
            $translated = preg_replace($pattern, $replacement, $translated);
        }

        $translated = preg_replace('/\s+/', ' ', trim($translated));
        $translated = preg_replace('/\(\s+/', '(', $translated);
        $translated = preg_replace('/\s+\)/', ')', $translated);

        return $translated;
    }

    private function fetchJson($url)
    {
        $context = stream_context_create(array(
            'http' => array(
                'method'  => 'GET',
                'timeout' => 2,
            ),
        ));

        $payload = @file_get_contents($url, false, $context);
        if (!is_string($payload) || $payload === '') {
            return null;
        }

        $decoded = json_decode($payload, true);
        return json_last_error() === JSON_ERROR_NONE ? $decoded : null;
    }

    private function runCommand($command)
    {
        if (!$this->canUseShellExec()) {
            return null;
        }

        $output = @shell_exec($command);
        if (!is_string($output)) {
            return null;
        }

        return trim($output);
    }

    private function canUseShellExec()
    {
        if (!function_exists('shell_exec')) {
            return false;
        }

        $disabledFunctions = array_map('trim', explode(',', (string) ini_get('disable_functions')));
        return !in_array('shell_exec', $disabledFunctions, true);
    }
}
