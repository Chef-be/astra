# Missions

## Vue d'ensemble

Le système de missions est séparé des missions de flotte. Il repose sur :

- [`MissionAdminService.class.php`](../includes/classes/MissionAdminService.class.php) pour l'administration ;
- [`UserMissionService.class.php`](../includes/classes/UserMissionService.class.php) pour l'attribution, la progression et la réclamation.

## Cycle d'une mission

1. définition de mission active ;
2. affectation automatique au joueur ;
3. calcul périodique de la progression ;
4. passage à l'état réclamable ;
5. crédit de la récompense ;
6. notification associée.

## Types d'objectifs

Le moteur gère notamment :

- niveau de bâtiment ;
- total de vaisseaux ;
- total de ressources.

## Types de récompenses

- ressources ;
- matière noire ;
- certains ajouts sur planète selon la clé de récompense.

## Exemples de missions par défaut

- développer la mine de métal ;
- armer la flotte légère ;
- réserve stratégique.

## Tables concernées

- `mission_definitions`
- `mission_rewards`
- `user_missions`
- `notifications`

## Administration

Le module missions permet :

- de visualiser les définitions ;
- de suivre les missions en cours ;
- de voir les missions réclamables ;
- de mesurer le volume de missions créditées ;
- d'affecter les missions aux joueurs.

## Interface joueur

La page `game.php?page=missions` expose :

- la liste des missions ;
- la progression courante ;
- le type de mission ;
- la récompense ;
- l'action de réclamation si disponible.
