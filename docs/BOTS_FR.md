# Bots

## Vue d'ensemble

Le moteur de bots est piloté côté PHP par [`BotAdminService.class.php`](../includes/classes/BotAdminService.class.php) et côté exploitation par des cronjobs dédiés.

## Profils

Les profils définissent le comportement général des bots :

- cible de présence connectée ;
- agressivité ;
- orientation économique ;
- orientation expansion.

Des profils par défaut sont créés automatiquement, par exemple :

- Éclaireur ;
- Colonisateur ;
- Prédateur.

## Fonctions du moteur

- attribution automatique d'un profil aux bots sans profil ;
- maintien d'une population en ligne ;
- exécution d'actions économiques, offensives ou d'expansion ;
- journalisation des actions ;
- traitement de consignes administratives ;
- rafraîchissement des missions des joueurs non bots.

## Canal bots

Le canal `bots` du chat temps réel sert à :

- visualiser l'historique des actions ;
- voir les prochaines actions remontées par les bots ;
- envoyer des consignes via le chat.

Les commandes textuelles prises en charge passent notamment par :

- `/bot NomDuBot ...`
- `/bots ...`

## Tables concernées

- `bot_profiles`
- `bot_activity`
- `bot_commands`
- champ `is_bot` dans `users`
- champ `bot_profile_id` dans `users`

## Administration

Le module bots permet :

- de visualiser les profils ;
- d'afficher les bots actifs ;
- de suivre les actions récentes ;
- d'afficher les prochaines actions ;
- de lancer le moteur ;
- de créer des bots ;
- d'ajuster les profils et réglages disponibles.

## Limitations actuelles

- le moteur reste piloté par des heuristiques, pas par une IA autonome externe ;
- les profils sont configurables mais encore limités à un noyau de paramètres ;
- certains comportements avancés peuvent encore être enrichis par de futurs lots.
