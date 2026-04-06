# Temps réel, chat et notifications

## Composants

Le temps réel repose sur :

- [`ops/astra/realtime/server.js`](../ops/astra/realtime/server.js) ;
- [`ops/astra/realtime/package.json`](../ops/astra/realtime/package.json) ;
- [`scripts/game/realtime.js`](../scripts/game/realtime.js) ;
- [`LiveChatService.class.php`](../includes/classes/LiveChatService.class.php) ;
- [`NotificationService.class.php`](../includes/classes/NotificationService.class.php).

## Chat temps réel

Le chat utilise un relais WebSocket Node.js et un stockage persistant en base.

### Canaux système par défaut

- `global` ;
- `alliance` ;
- `admin` ;
- `bots`.

Ces canaux sont garantis par [`LiveChatService.class.php`](../includes/classes/LiveChatService.class.php), qui peut aussi créer des canaux supplémentaires.

### Fonctions prises en charge

- historique persistant ;
- modération ;
- bannissement temporaire ;
- suppression de messages ;
- canaux réservés aux administrateurs ;
- canal bots avec consignes ;
- mentions et badge de mention ;
- bibliothèque d'émojis ;
- autocomplétion des pseudos connectés.

## Notifications

Les notifications sont découplées de la messagerie joueur et stockées dans la table `notifications`.

### Fonctions principales

- compteur non lu ;
- cloche temps réel ;
- détail d'une notification ;
- marquage individuel en lu ;
- marquage global en lu ;
- redirection contextuelle, notamment pour le support.

### Support

Les notifications de support utilisent [`NotificationService::createSupportTicketNotification()`](../includes/classes/NotificationService.class.php) afin de résoudre automatiquement le bon lien :

- fil joueur si le destinataire est le propriétaire du ticket ;
- vue admin si le destinataire est un administrateur tiers.

## Vérification

Le relais temps réel expose un point de santé :

```text
/realtime-health
```

Une réponse JSON avec `status: ok` indique que le service répond.

## Tables concernées

- `live_chat_messages`
- `live_chat_mutes`
- `live_chat_channels`
- `notifications`
- `bot_commands`
- `bot_activity`

## Points d'attention

- le relais WebSocket dépend d'un secret partagé ;
- les droits d'accès aux canaux doivent rester cohérents avec les niveaux d'authentification ;
- les historiques du chat sont soumis à une politique de rétention configurable.
