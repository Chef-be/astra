# Cronjobs

## Point d'entrée

L'exécution HTTP des tâches planifiées passe par [`cronjob.php`](../cronjob.php), qui :

- vérifie la session ;
- lit l'identifiant de tâche ;
- vérifie que la tâche doit être exécutée ;
- délègue ensuite à la classe `Cronjob`.

## Classes de tâches présentes

Dans [`includes/classes/cronjob/`](../includes/classes/cronjob), on trouve notamment :

- `BotActivityCronjob`
- `BotPresenceCronjob`
- `BotPlanningCronjob`
- `BotExecutionCronjob`
- `BotMessagingCronjob`
- `BotCampaignCronjob`
- `BotComplianceCronjob`
- `BotMaintenanceCronjob`
- `CleanerCronjob`
- `DailyCronjob`
- `DumpCronjob`
- `InactiveMailCronjob`
- `LiveChatRetentionCronjob`
- `MissionProgressCronjob`
- `ReferralCronjob`
- `StatisticCronjob`
- `TrackingCronjob`

## Élément legacy désactivé

La classe `TeamSpeakCronjob` existe encore dans l'arborescence, mais elle est explicitement exclue de l'administration par [`ShowCronjobPage.class.php`](../includes/pages/adm/ShowCronjobPage.class.php) et ne doit plus être utilisée.

## Chaîne d'orchestration bots

Le moteur bots n'est pas exécuté par une seule tâche monolithique. Les phases recommandées sont :

- `botpresence` : ajuste la population logique et sociale ;
- `botplanning` : calcule les intentions, objectifs et actions candidates ;
- `botexecution` : exécute la file d'actions réelles ;
- `botmessaging` : diffuse messages privés et messages sociaux ;
- `botcampaigns` : entretient les campagnes offensives continues ;
- `botcompliance` : remet en conformité les comptes bots ;
- `botmaintenance` : resynchronise hiérarchie, campagnes, mémoire et actions bloquées.

Cette découpe permet :

- l'idempotence par phase ;
- une reprise sélective ;
- une meilleure lecture des charges ;
- une journalisation plus exploitable ;
- des garde-fous de performance.

## Journalisation

Les tables de suivi principales sont :

- `cronjobs_log` pour l'exécution des tâches ;
- `bot_engine_runs` pour les runs moteur ;
- `bot_action_results` pour les exécutions d'actions ;
- `bot_activity` pour la timeline synthétique ;
- `bot_presence_snapshots` pour les changements de présence.

## Administration

Le module `Tâches planifiées` permet :

- d'afficher la liste des tâches ;
- d'activer ou désactiver une tâche ;
- de verrouiller ou déverrouiller une tâche ;
- de créer ou modifier une tâche ;
- de consulter son journal.

## Bonnes pratiques

- éviter d'activer des tâches obsolètes ;
- surveiller les verrous persistants ;
- contrôler les journaux après ajout de nouvelles tâches ;
- documenter toute tâche personnalisée ajoutée au projet ;
- conserver un décalage raisonnable entre planification, exécution et maintenance ;
- exécuter `botmaintenance` au moins deux fois par heure ;
- contrôler les verrous et erreurs après chaque montée de schéma bots.
