# Architecture d'Astra Dominion

## Entrées principales

- [`index.php`](../index.php) : pages publiques, connexion, inscription, actualités.
- [`game.php`](../game.php) : interface joueur.
- [`admin.php`](../admin.php) : administration.
- [`cronjob.php`](../cronjob.php) : exécution des tâches planifiées.

## Noyau applicatif

Le bootstrap central se trouve dans [`includes/common.php`](../includes/common.php). Il prépare notamment :

- la connexion base de données ;
- la configuration ;
- la session ;
- l'univers courant ;
- l'utilisateur courant ;
- les constantes et variables métier ;
- le moteur de templates.

## Organisation des dossiers

### `includes/`

Contient le cœur métier :

- `classes/` : services, utilitaires, accès DB, cache, notifications, bots, missions ;
- `pages/` : contrôleurs par zone (`login`, `game`, `adm`) ;
- `libs/` : bibliothèques tierces ;
- `vars.php` : variables métier globales ;
- `common.php` : bootstrap.

### `styles/`

Contient les thèmes et templates :

- `theme/nextgen/` : thème de jeu principal modernisé ;
- `templates/adm/` : administration ;
- `resource/` : CSS, images, polices et JS mutualisés.

### `scripts/`

Contient :

- les scripts front du jeu ;
- les scripts d'administration ;
- les utilitaires backend.

### `ops/astra/`

Contient les composants opérationnels de la stack :

- `realtime/` : serveur Node.js du chat et des notifications temps réel ;
- `gatus/` : observer de supervision.

## Stack Astra

La stack Docker de référence est définie dans [`docker-compose.astra.yml`](../docker-compose.astra.yml).

Services principaux :

- `astra-web`
- `astra-db`
- `astra-cache`
- `astra-adminer`
- `astra-docker-socket-proxy`
- `astra-observer`
- `astra-realtime`

## Zones fonctionnelles

### Administration

L'administration est organisée autour de modules :

- supervision ;
- contenu ;
- joueurs ;
- paramètres ;
- bots ;
- missions ;
- outils avancés.

### Temps réel

Le temps réel repose sur :

- [`ops/astra/realtime/server.js`](../ops/astra/realtime/server.js)
- [`scripts/game/realtime.js`](../scripts/game/realtime.js)

### Moteur bots

Le moteur bots est réparti entre :

- des services PHP dans `includes/classes/` ;
- des pages d'administration dans `includes/pages/adm/` ;
- des templates Smarty dans `styles/templates/adm/` ;
- le relais Node.js du chat pour la saisie temps réel des ordres ;
- des cronjobs spécialisés dans `includes/classes/cronjob/`.

Les services cœur incluent notamment :

- orchestration moteur ;
- gouvernance de présence ;
- mémoire et traits ;
- hiérarchie chefs, alliances et escouades ;
- génération et scoring d'actions ;
- exécution réelle ;
- messagerie privée et sociale ;
- conformité multi-comptes.

### Contenu public

Le contenu public et certains réglages éditoriaux sont pilotés côté administration via des services dédiés, notamment pour :

- la page d'accueil ;
- les liens publics ;
- certaines options d'inscription ;
- les actualités.
