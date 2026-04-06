# Base de données

## Vue d'ensemble

Le schéma principal est initialisé par [`install/install.sql`](../install/install.sql). Le projet combine :

- des tables legacy de jeu ;
- des tables d'administration et de support ;
- des tables ajoutées pour les modules modernes.

## Tables modernes importantes

### Bots

- `bot_profiles`
- `bot_activity`
- `bot_commands`

### Chat temps réel

- `live_chat_messages`
- `live_chat_mutes`
- `live_chat_channels`

### Notifications

- `notifications`

### Missions

- `mission_definitions`
- `mission_rewards`
- `user_missions`

### Exploitation

- `cronjobs`
- `cronjobs_log`

## Tables legacy encore utilisées

- `users`
- `planets`
- `messages`
- `tickets`
- `ticket_reply`
- `news`
- `notes`
- `buddy`
- `buddy_request`

## Préfixe

Le projet est conçu pour fonctionner avec un préfixe de tables configurable, défini dans [`includes/config.php`](../includes/config.php) ou son exemple [`includes/config.sample.php`](../includes/config.sample.php).

## Bonnes pratiques

- sauvegarder la base avant toute opération destructive ;
- éviter les manipulations manuelles sans contrôle des univers ;
- documenter les migrations fonctionnelles ajoutées hors installateur ;
- ne pas publier d'exports SQL dans le dépôt public.
