# Bots

## Vue d'ensemble

Le système bots d'Astra n'est plus limité à une simple création de comptes automatiques. Il s'appuie désormais sur un moteur multi-couches piloté par :

- [`includes/classes/BotEngineService.class.php`](../includes/classes/BotEngineService.class.php) pour l'orchestration globale ;
- des services spécialisés pour présence, mémoire, hiérarchie, campagnes, scoring, exécution et messagerie ;
- le module d'administration bots ;
- le canal temps réel `bots` et sa console de commandement structurée.

L'upstream `ultimateXnova` ne propose qu'un module d'administration bots rudimentaire orienté création de masse. Astra ajoute une architecture dédiée, des tables propres, une intégration chat temps réel et des cronjobs spécialisés.

## Architecture algorithmique

Le moteur suit les couches suivantes :

1. gouvernance globale de population ;
2. construction d'état du monde ;
3. traits, états dynamiques et doctrine ;
4. hiérarchie chefs, escouades et alliances ;
5. planification stratégique ;
6. planification tactique ;
7. génération d'actions candidates ;
8. scoring d'utilité ;
9. exécution réelle des actions ;
10. présence logique et sociale ;
11. mémoire et adaptation ;
12. communication privée et publique ;
13. journalisation analytique ;
14. maintenance et reprise d'anomalies.

Les pondérations centrales sont stockées dans `bot_engine_config.decision_weights_json`. Elles évitent de disperser les coefficients dans l'ensemble du code.

## Capacités réelles branchées

Le moteur privilégie les actions réellement connectées au jeu. Les points d'intégration déjà exploités sont :

- files de construction ;
- files de recherche ;
- files de chantier spatial ;
- envoi réel de sondes d'espionnage ;
- envoi réel de raids ;
- file de messages privés bots ;
- file de messages sociaux chat ;
- présence logique et sociale persistée.

Quand une capacité n'est pas encore branchée de bout en bout, le moteur la journalise comme intention ou action planifiée dans les tables bots afin d'éviter les effets de bord silencieux.

## Modèle de données bots

Les tables structurantes sont :

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

Les comptes bots restent identifiés par `users.is_bot = 1` et conservent `users.bot_profile_id`.

## Profils, doctrines et hiérarchie

Chaque bot combine :

- un profil de comportement ;
- des traits persistants ;
- un état dynamique ;
- une doctrine active ;
- un statut hiérarchique ;
- une appartenance éventuelle à une alliance ou une escouade ;
- une mémoire exploitable.

Les chefs sont signalés par le statut `chef` et peuvent être promus avec le préfixe exact `Général `. La hiérarchie est synchronisée par maintenance afin de rattacher automatiquement des subordonnés cohérents à un chef actif.

## Multi-comptes et conformité

Tous les bots existants et futurs doivent être considérés comme multi-comptes validés. Le socle de conformité repose sur :

- `bot_multiaccount_validation` pour le statut de validation ;
- `bot_account_compliance` pour l'email partagé, la politique de mot de passe et la synchronisation ;
- [`includes/classes/BotAccountProvisioningService.class.php`](../includes/classes/BotAccountProvisioningService.class.php) pour la création, la rotation de mots de passe et la remise en conformité ;
- [`includes/classes/BotMultiAccountService.class.php`](../includes/classes/BotMultiAccountService.class.php) pour l'intégration avec les contrôles multi-comptes.

L'adresse email commune est portée par `bot_engine_config.shared_email`. Les mots de passe des bots sont générés aléatoirement, distincts et hachés avec le mécanisme du projet.

## Canal bots et console de commandement

Le canal `bots` du temps réel sert de console de commandement. Le pipeline complet est :

1. autocomplétion slash ;
2. parsing robuste ;
3. validation ;
4. résolution des cibles ;
5. enregistrement structuré dans `bot_commands` ;
6. dispatch ;
7. exécution ou mise en file ;
8. réponse structurée ;
9. journalisation.

Exemples de familles couvertes :

- `/bots`
- `/bot`
- `/chef`
- `/alliance-bots`
- `/escouade`
- `/system-bots`
- `/galaxy-bots`
- `/profil-bots`
- `/message-prive`
- `/message-chat`
- `/campagne`
- `/harcelement`
- `/rotation-attaque`
- `/vague`
- `/siege`

Le catalogue visible par l'interface est stocké dans `bot_command_catalog`. Le parseur PHP et le parseur Node convergent vers la même structure de commande.

## Cronjobs du moteur

Le moteur est réparti en tâches distinctes :

- `BotPresenceCronjob`
- `BotPlanningCronjob`
- `BotExecutionCronjob`
- `BotMessagingCronjob`
- `BotCampaignCronjob`
- `BotComplianceCronjob`
- `BotMaintenanceCronjob`

Cette séparation permet d'appliquer des limites de charge, des reprises et des verrous fins par phase.

## Administration

Le module bots expose désormais :

- un tableau de bord synthétique ;
- la configuration globale du moteur ;
- les profils ;
- les campagnes ;
- les ordres ;
- les actions à venir ;
- la liste détaillée des bots ;
- des actions de masse ;
- l'état de conformité des comptes bots.

## Procédure de migration des bots existants

1. exécuter la montée de schéma jusqu'à la version courante ;
2. vérifier que `bot_engine_config` existe pour chaque univers ;
3. lancer `botcompliance` puis `botmaintenance` ;
4. contrôler `bot_multiaccount_validation` et `bot_account_compliance` ;
5. vérifier l'email partagé et la rotation des mots de passe si nécessaire ;
6. contrôler l'apparition des snapshots de présence et des premiers runs moteur ;
7. tester le dispatch d'une commande `/bots statut`.

## Procédure de test manuel

1. vérifier que le chat temps réel répond et que le canal `bots` s'affiche ;
2. envoyer `/bots statut` puis `/bots cible-online 12` ;
3. envoyer `/chef "Général Orion" lancer reconnaissance 2:145:7` sur un chef existant ;
4. vérifier l'insertion dans `bot_commands`, `bot_action_queue` et `bot_activity` ;
5. exécuter les cronjobs `botplanning`, `botexecution`, `botcampaigns`, `botmessaging`, `botmaintenance` ;
6. contrôler les tables `bot_engine_runs`, `bot_action_results`, `bot_campaigns` et `bot_presence_snapshots` ;
7. ouvrir le module d'administration bots et contrôler tableau de bord, ordres, campagnes et conformité ;
8. vérifier qu'un bot migré apparaît comme multi-compte validé et qu'il utilise l'email partagé configuré.

## Garde-fous opérationnels

Le moteur intègre :

- des verrous cron ;
- des cooldowns individuels ;
- des budgets par cycle ;
- des sélections par bot éligible ;
- la reprise des actions bloquées ;
- la fermeture ou la relance des campagnes expirées ;
- une journalisation explicable des décisions.
