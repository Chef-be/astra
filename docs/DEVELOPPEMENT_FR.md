# Développement d'Astra Dominion

## Principes

Le projet repose sur une base legacy. Les évolutions doivent donc privilégier :

- les changements incrémentaux ;
- les nouveaux services dédiés plutôt que l'empilement de logique dans les templates ;
- la compatibilité avec l'existant pendant les migrations ;
- la francisation visible de l'interface.

## Cycle recommandé

1. localiser la page ou le service concerné ;
2. modifier le contrôleur ou le service avant le template si possible ;
3. purger les templates compilés impactés si le rendu ne change pas ;
4. valider en réel dans le navigateur ;
5. vérifier les journaux d'erreur ;
6. versionner uniquement les changements utiles.

## Vérifications minimales

### PHP

```bash
php -l admin.php
php -l game.php
php -l index.php
php -l includes/pages/adm/ShowOverviewPage.class.php
```

### Node.js

```bash
node --check ops/astra/realtime/server.js
node --check scripts/game/realtime.js
```

## Cache Smarty

Si une chaîne corrigée reste visible dans l'interface, il faut parfois purger le cache compilé concerné dans :

- `cache/templates/`

La purge doit rester ciblée quand c'est possible.

## Captures et validation visuelle

Pour les refontes d'interface, il est recommandé de :

- prendre une capture avant ;
- implémenter ;
- reprendre une capture après ;
- vérifier les débordements, hauteurs excessives, retours à la ligne et collisions visuelles.

## Git

Le dépôt GitHub de référence est :

- `Chef-be/astra`

Avant un push :

- vérifier que les secrets ne sont pas suivis ;
- contrôler `.gitignore` ;
- confirmer l'état avec `git status -sb`.
