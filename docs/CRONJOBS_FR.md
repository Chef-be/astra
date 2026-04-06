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

## Journalisation

La table `cronjobs_log` conserve les traces d'exécution des tâches.

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
- documenter toute tâche personnalisée ajoutée au projet.
