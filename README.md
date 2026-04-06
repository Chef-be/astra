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

- [`index.php`](./index.php) : front public et authentification.
- [`game.php`](./game.php) : interface de jeu.
- [`admin.php`](./admin.php) : interface d'administration.
- [`includes/`](./includes) : noyau applicatif, services, pages, classes métier.
- [`styles/`](./styles) : thèmes, templates et ressources visuelles.
- [`scripts/`](./scripts) : scripts front et outils backend.
- [`ops/astra/`](./ops/astra) : services opérationnels Astra, dont le temps réel et l'observer.
- [`install/`](./install) : installateur et schéma SQL.
- [`docs/`](./docs) : documentation fonctionnelle et technique.

## Démarrage rapide avec Docker

1. Copier [`includes/config.sample.php`](./includes/config.sample.php) vers `includes/config.php` puis adapter les valeurs.
2. Vérifier les variables et mots de passe présents dans [`docker-compose.astra.yml`](./docker-compose.astra.yml).
3. Démarrer la stack :

```bash
docker compose -f docker-compose.astra.yml up -d --build
```

4. Ouvrir l'application sur `http://localhost:3848`.
5. Finaliser l'installation via l'installateur si nécessaire, puis retirer `includes/ENABLE_INSTALL_TOOL`.

## Documentation

- [Installation](./docs/INSTALLATION_FR.md)
- [Architecture](./docs/ARCHITECTURE_FR.md)
- [Exploitation](./docs/EXPLOITATION_FR.md)
- [Développement](./docs/DEVELOPPEMENT_FR.md)
- [Administration](./docs/ADMINISTRATION_FR.md)
- [Temps réel, chat et notifications](./docs/TEMPS_REEL_FR.md)
- [Bots](./docs/BOTS_FR.md)
- [Missions](./docs/MISSIONS_FR.md)
- [Contenu public et courriels](./docs/CONTENU_PUBLIC_ET_COURRIELS_FR.md)
- [Base de données](./docs/BASE_DE_DONNEES_FR.md)
- [Cronjobs](./docs/CRONJOBS_FR.md)
- [Sauvegarde et restauration](./docs/SAUVEGARDE_RESTAURATION_FR.md)
- [Déploiement Plesk](./docs/DEPLOIEMENT_PLESK_FR.md)
- [Plan de modernisation](./docs/PLAN_MODERNISATION_FR.md)
- [Protection Nginx](./nginx.md)

## Sécurité et publication

- Ne pas versionner [`includes/config.php`](./includes/config.php).
- Ne pas laisser `includes/ENABLE_INSTALL_TOOL` actif en production.
- Restreindre l'accès aux dossiers sensibles décrits dans [`nginx.md`](./nginx.md).
- Vérifier les mots de passe et secrets avant tout déploiement public.

## Vérifications utiles

```bash
php -l index.php
php -l game.php
php -l admin.php
node --check ops/astra/realtime/server.js
```

## Licence

Le projet conserve la licence présente dans [`LICENSE`](./LICENSE).
