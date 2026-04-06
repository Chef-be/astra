# Sauvegarde et restauration

## Sauvegarde base de données

Plusieurs voies existent :

- module `Sauvegarde SQL` de l'administration ;
- `mariadb-dump` ou `mysqldump` côté système ;
- sauvegarde du volume `astra_dbdata` si Docker est utilisé.

## Sauvegarde fichiers

À sauvegarder au minimum :

- l'arborescence applicative ;
- les modèles de courriels modifiés ;
- les médias téléversés ;
- les fichiers de configuration hors dépôt ;
- les éventuels exports nécessaires à l'exploitation.

## Restauration

### Base

1. arrêter les écritures si possible ;
2. restaurer le dump dans la base cible ;
3. vérifier le préfixe de tables ;
4. contrôler la cohérence des univers et comptes administrateurs.

### Fichiers

1. restaurer les fichiers applicatifs ;
2. remettre le bon `includes/config.php` ;
3. vérifier les droits ;
4. purger les caches si nécessaire.

## Docker

Dans la stack Astra, les volumes critiques sont notamment :

- `httpdocs_astra_dbdata`
- `httpdocs_astra_cachedata`

## Recommandations

- tester régulièrement une restauration complète ;
- ne pas dépendre uniquement des exports générés manuellement ;
- conserver des sauvegardes hors de la machine principale ;
- documenter la date et le contenu de chaque sauvegarde majeure.
