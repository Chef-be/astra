# Astra Dominion

Astra Dominion est une plateforme de jeu spatial par navigateur héritée d'une base legacy PHP, modernisée progressivement autour d'une administration refondue, d'un chat temps réel, d'un système de missions, d'un moteur de bots et d'une stack Docker dédiée.

## Vue d'ensemble

Le projet repose sur :

- PHP 8.x côté application ;
- MariaDB pour les données ;
- Smarty pour le rendu des templates ;
- JavaScript côté client ;
- Node.js pour le relais temps réel WebSocket ;
- Redis pour le cache de la stack Astra ;
- Docker Compose pour l'exploitation locale et serveur.

## Fonctionnalités majeures

- interface publique et interface de jeu ;
- panneau d'administration modernisé ;
- supervision de la stack Astra ;
- chat temps réel avec canaux et modération ;
- notifications séparées de la messagerie joueur ;
- système de missions et récompenses ;
- moteur de bots administrable ;
- édition de contenus publics depuis l'administration.

## Structure du dépôt

- [`index.php`](/var/www/vhosts/astra-dominion.fr/httpdocs/index.php) : front public et authentification.
- [`game.php`](/var/www/vhosts/astra-dominion.fr/httpdocs/game.php) : interface de jeu.
- [`admin.php`](/var/www/vhosts/astra-dominion.fr/httpdocs/admin.php) : interface d'administration.
- [`includes/`](/var/www/vhosts/astra-dominion.fr/httpdocs/includes) : noyau applicatif, services, pages, classes métier.
- [`styles/`](/var/www/vhosts/astra-dominion.fr/httpdocs/styles) : thèmes, templates et ressources visuelles.
- [`scripts/`](/var/www/vhosts/astra-dominion.fr/httpdocs/scripts) : scripts front et outils backend.
- [`ops/astra/`](/var/www/vhosts/astra-dominion.fr/httpdocs/ops/astra) : services opérationnels Astra, dont le temps réel et l'observer.
- [`install/`](/var/www/vhosts/astra-dominion.fr/httpdocs/install) : installateur et schéma SQL.
- [`docs/`](/var/www/vhosts/astra-dominion.fr/httpdocs/docs) : documentation fonctionnelle et technique.

## Démarrage rapide avec Docker

1. Copier [`includes/config.sample.php`](/var/www/vhosts/astra-dominion.fr/httpdocs/includes/config.sample.php) vers `includes/config.php` puis adapter les valeurs.
2. Vérifier les variables et mots de passe présents dans [`docker-compose.astra.yml`](/var/www/vhosts/astra-dominion.fr/httpdocs/docker-compose.astra.yml).
3. Démarrer la stack :

```bash
docker compose -f docker-compose.astra.yml up -d --build
```

4. Ouvrir l'application sur `http://localhost:3848`.
5. Finaliser l'installation via l'installateur si nécessaire, puis retirer `includes/ENABLE_INSTALL_TOOL`.

## Documentation

- [Installation](/var/www/vhosts/astra-dominion.fr/httpdocs/docs/INSTALLATION_FR.md)
- [Architecture](/var/www/vhosts/astra-dominion.fr/httpdocs/docs/ARCHITECTURE_FR.md)
- [Exploitation](/var/www/vhosts/astra-dominion.fr/httpdocs/docs/EXPLOITATION_FR.md)
- [Développement](/var/www/vhosts/astra-dominion.fr/httpdocs/docs/DEVELOPPEMENT_FR.md)
- [Plan de modernisation](/var/www/vhosts/astra-dominion.fr/httpdocs/docs/PLAN_MODERNISATION_FR.md)
- [Protection Nginx](/var/www/vhosts/astra-dominion.fr/httpdocs/nginx.md)

## Sécurité et publication

- Ne pas versionner [`includes/config.php`](/var/www/vhosts/astra-dominion.fr/httpdocs/includes/config.php).
- Ne pas laisser `includes/ENABLE_INSTALL_TOOL` actif en production.
- Restreindre l'accès aux dossiers sensibles décrits dans [`nginx.md`](/var/www/vhosts/astra-dominion.fr/httpdocs/nginx.md).
- Vérifier les mots de passe et secrets avant tout déploiement public.

## Vérifications utiles

```bash
php -l index.php
php -l game.php
php -l admin.php
node --check ops/astra/realtime/server.js
```

## Licence

Le projet conserve la licence présente dans [`LICENSE`](/var/www/vhosts/astra-dominion.fr/httpdocs/LICENSE).
