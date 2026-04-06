# Déploiement Plesk

## Contexte

Le projet peut être servi derrière Plesk avec :

- un domaine principal ;
- une IP dédiée ou partagée ;
- un proxy Docker Plesk vers le conteneur `astra-web` ;
- une terminaison TLS gérée par le frontal web.

## Points clés

### Domaine

Vérifier :

- `astra-dominion.fr`
- `www.astra-dominion.fr`

Les deux doivent pointer vers la bonne IP publique.

### Proxy Docker

Le domaine doit pointer vers le service `astra-web` exposé par la stack Astra.

### TLS

Le certificat doit couvrir :

- `astra-dominion.fr`
- `www.astra-dominion.fr`

## Changement d'IP

Lors d'un changement d'IP :

1. réduire le TTL DNS à l'avance ;
2. basculer l'abonnement Plesk sur la bonne IP ;
3. vérifier les enregistrements `@` et `www` ;
4. contrôler le proxy Docker ;
5. tester les deux hôtes publiquement ;
6. conserver un éventuel fallback temporaire si nécessaire pendant la propagation.

## WebSocket

Le temps réel nécessite que le frontal laisse passer le proxy `wss://` vers le relais `astra-realtime`.

## Vérifications post-déploiement

- `https://www.astra-dominion.fr/`
- `https://www.astra-dominion.fr/admin.php`
- `https://www.astra-dominion.fr/realtime-health`

## Risques classiques

- `www` résolu vers une ancienne IP ;
- routage vers la page de connexion Plesk au lieu du site ;
- certificat attaché au mauvais site ;
- proxy Docker non raccordé au bon conteneur ;
- cache DNS local encore ancien.
