<?php

define('ROOT_PATH', str_replace('\\', '/', dirname(__DIR__, 2)).'/');
chdir(ROOT_PATH);

if (!isset($_SERVER['PHP_SELF'])) {
    $_SERVER['PHP_SELF'] = '/index.php';
}
if (!isset($_SERVER['SCRIPT_NAME'])) {
    $_SERVER['SCRIPT_NAME'] = '/index.php';
}
if (!isset($_SERVER['SCRIPT_FILENAME'])) {
    $_SERVER['SCRIPT_FILENAME'] = ROOT_PATH.'index.php';
}

define('MODE', 'LOGIN');
define('TIMESTAMP', time());

date_default_timezone_set('UTC');

require ROOT_PATH.'includes/constants.php';
require ROOT_PATH.'includes/classes/HTTP.class.php';
require ROOT_PATH.'includes/classes/Database.class.php';
require ROOT_PATH.'includes/classes/Config.class.php';
require ROOT_PATH.'includes/classes/Universe.class.php';
require ROOT_PATH.'includes/classes/PlayerUtil.class.php';

function ensureAdminAccount($universe, $username, $email, $password, $planetPosition, $planetName)
{
    $db = Database::get();
    $hashedPassword = PlayerUtil::cryptPassword($password);

    $sql = "SELECT id, username, email FROM %%USERS%% WHERE universe = :universe AND (email = :email OR username = :username) LIMIT 1;";
    $existing = $db->selectSingle($sql, array(
        ':universe' => $universe,
        ':email'    => $email,
        ':username' => $username,
    ));

    if (!empty($existing)) {
        $planetCount = (int) $db->selectSingle(
            "SELECT COUNT(*) AS count FROM %%PLANETS%% WHERE id_owner = :userId AND universe = :universe;",
            array(
                ':userId'   => $existing['id'],
                ':universe' => $universe,
            ),
            'count'
        );
        $pointsCount = (int) $db->selectSingle(
            "SELECT COUNT(*) AS count FROM %%USER_POINTS%% WHERE id_owner = :userId AND universe = :universe;",
            array(
                ':userId'   => $existing['id'],
                ':universe' => $universe,
            ),
            'count'
        );

        if ($planetCount === 0 || $pointsCount === 0) {
            $db->delete("DELETE FROM %%SESSION%% WHERE userID = :userId;", array(':userId' => $existing['id']));
            $db->delete("DELETE FROM %%USER_POINTS%% WHERE id_owner = :userId AND universe = :universe;", array(':userId' => $existing['id'], ':universe' => $universe));
            $db->delete("DELETE FROM %%PLANETS%% WHERE id_owner = :userId AND universe = :universe;", array(':userId' => $existing['id'], ':universe' => $universe));
            $db->delete("DELETE FROM %%USERS%% WHERE id = :userId;", array(':userId' => $existing['id']));
            $existing = null;
        }
    }

    if (!empty($existing)) {
        $db->update(
            "UPDATE %%USERS%% SET username = :username, email = :email, email_2 = :email, password = :password, authlevel = :authlevel, authattack = :authlevel WHERE id = :id;",
            array(
                ':username'  => $username,
                ':email'     => $email,
                ':password'  => $hashedPassword,
                ':authlevel' => AUTH_ADM,
                ':id'        => $existing['id'],
            )
        );

        return array(
            'id'      => (int) $existing['id'],
            'created' => false,
        );
    }

    $position = $planetPosition;
    while (!PlayerUtil::isPositionFree($universe, 1, 1, $position)) {
        $position++;
    }

    list($userId,) = PlayerUtil::createPlayer(
        $universe,
        $username,
        $hashedPassword,
        $email,
        'fr',
        1,
        1,
        $position,
        $planetName,
        AUTH_ADM,
        '127.0.0.1'
    );

    $db->update(
        "UPDATE %%USERS%% SET authattack = :authlevel WHERE id = :id;",
        array(
            ':authlevel' => AUTH_ADM,
            ':id'        => $userId,
        )
    );

    return array(
        'id'      => (int) $userId,
        'created' => true,
    );
}

$config = Config::get(ROOT_UNI);
$config->timezone = 'Europe/Paris';
$config->lang = 'fr';
$config->save();

$universeReflection = new ReflectionClass('Universe');
$currentUniverseProperty = $universeReflection->getProperty('currentUniverse');
$currentUniverseProperty->setAccessible(true);
$currentUniverseProperty->setValue(null, ROOT_UNI);

$emulatedUniverseProperty = $universeReflection->getProperty('emulatedUniverse');
$emulatedUniverseProperty->setAccessible(true);
$emulatedUniverseProperty->setValue(null, ROOT_UNI);

$accounts = array(
    array(
        'username'   => 'admin',
        'email'      => 'admin@lbh-economiste.com',
        'password'   => '@Sharingan06200',
        'planet'     => 2,
        'planetName' => 'Dominion Prime',
    ),
    array(
        'username'   => 'codex-admin-test',
        'email'      => 'codex-admin-test@lbh-economiste.com',
        'password'   => '@Sharingan06200',
        'planet'     => 3,
        'planetName' => 'Atelier Test',
    ),
);

$results = array();
foreach ($accounts as $account) {
    $results[] = array_merge(
        array(
            'username' => $account['username'],
            'email'    => $account['email'],
        ),
        ensureAdminAccount(
            ROOT_UNI,
            $account['username'],
            $account['email'],
            $account['password'],
            $account['planet'],
            $account['planetName']
        )
    );
}

echo json_encode($results, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES).PHP_EOL;
