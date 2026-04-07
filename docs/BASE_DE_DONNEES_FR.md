# Base de données

## Vue d'ensemble

Le schéma principal est initialisé par [`install/install.sql`](../install/install.sql). Le projet combine :

- des tables legacy de jeu ;
- des tables d'administration et de support ;
- des tables ajoutées pour les modules modernes.

## Tables modernes importantes

### Bots

- `bot_profiles`
- `bot_engine_config`
- `bot_state`
- `bot_traits`
- `bot_dynamic_state`
- `bot_memory`
- `bot_relationships`
- `bot_squads`
- `bot_squad_members`
- `bot_alliance_meta`
- `bot_bonus_rules`
- `bot_bonus_assignments`
- `bot_action_queue`
- `bot_action_results`
- `bot_engine_runs`
- `bot_presence_snapshots`
- `bot_campaigns`
- `bot_campaign_members`
- `bot_private_messages`
- `bot_social_messages`
- `bot_multiaccount_validation`
- `bot_account_compliance`
- `bot_command_catalog`
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
- `alliance`
- `alliance_request`
- `buddy`
- `buddy_request`
- `fleets`
- `fleet_event`
- `messages`
- `tickets`
- `ticket_reply`
- `news`
- `notes`
- `multi`

## Préfixe

Le projet est conçu pour fonctionner avec un préfixe de tables configurable, défini dans [`includes/config.php`](../includes/config.php) ou son exemple [`includes/config.sample.php`](../includes/config.sample.php).

## Tables utiles à l'analyse bots

Pour analyser le comportement réel des bots, les zones les plus importantes sont :

- `users` pour l'identité, le flag bot, l'email et le profil ;
- `planets` pour l'ancrage territorial et les ressources ;
- `fleets` et `fleet_event` pour les possibilités d'action réelles ;
- `messages` pour la messagerie privée ;
- `alliance` et `alliance_request` pour les alliances ;
- `multi` pour la compatibilité avec la détection de multi-comptes ;
- `live_chat_messages` et `notifications` pour la couche sociale ;
- l'ensemble des tables `bot_*` pour la gouvernance, la mémoire, les ordres, la conformité et les campagnes.

## Bonnes pratiques

- sauvegarder la base avant toute opération destructive ;
- éviter les manipulations manuelles sans contrôle des univers ;
- documenter les migrations fonctionnelles ajoutées hors installateur ;
- ne pas publier d'exports SQL dans le dépôt public.
