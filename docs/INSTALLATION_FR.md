# Installation d'Astra Dominion

## Prérequis

- PHP 8.2 ou 8.3 avec extensions usuelles pour MariaDB et JSON ;
- MariaDB ou MySQL compatible ;
- serveur web Apache ou Nginx ;
- Node.js pour le relais temps réel ;
- Docker et Docker Compose si vous utilisez la stack Astra ;
- serveur SMTP si vous souhaitez l'envoi de courriels.

## Installation rapide avec Docker

Le dépôt fournit une stack Docker dédiée dans [`docker-compose.astra.yml`](../docker-compose.astra.yml).

### Étapes

1. Copier [`includes/config.sample.php`](../includes/config.sample.php) vers `includes/config.php`.
2. Adapter les identifiants de base et le préfixe de tables.
3. Vérifier les ports exposés :
   - application : `3848`
   - base : `3408`
   - Adminer : `3849`
   - observer : `3850`
   - temps réel : `3851` en local
4. Démarrer la stack :

```bash
docker compose -f docker-compose.astra.yml up -d --build
```

5. Ouvrir `http://localhost:3848`.
6. Suivre l'installation web si elle n'a pas déjà été réalisée.
7. Supprimer `includes/ENABLE_INSTALL_TOOL` en fin d'installation.

## Installation manuelle

### 1. Déployer les fichiers

Copier l'intégralité du dépôt sur l'hébergement cible.

### 2. Configurer la base

Créer une base MariaDB, un utilisateur dédié et un mot de passe fort.

### 3. Préparer la configuration

Créer `includes/config.php` à partir de [`includes/config.sample.php`](../includes/config.sample.php).

### 4. Installer la base

Lancer l'installateur web via :

```text
https://votre-domaine/install
```

ou importer le SQL initial fourni dans [`install/install.sql`](../install/install.sql) si vous gérez l'initialisation manuellement.

### 5. Finaliser

- désactiver l'installateur ;
- vérifier les droits des dossiers `cache/` et `includes/` ;
- configurer le cron applicatif si nécessaire ;
- configurer le relais WebSocket si le chat temps réel est activé.

## Comptes d'administration

La création d'un administrateur peut être automatisée par :

- [`scripts/backend/provision_admin.php`](../scripts/backend/provision_admin.php)

## Points d'attention

- ne jamais publier `includes/config.php` ;
- changer tous les mots de passe d'exemple avant exposition publique ;
- vérifier les restrictions Nginx décrites dans [`nginx.md`](../nginx.md) ;
- si Docker est utilisé, éviter d'exposer inutilement la base au public.
