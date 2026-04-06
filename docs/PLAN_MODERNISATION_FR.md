# Plan De Modernisation Astra Dominion

## Objectif

Faire evoluer la base legacy actuelle vers une plateforme plus maintenable, plus rapide et administrable depuis une interface moderne, sans rupture brutale avec l existant.

## Principes

- Migrer par domaines fonctionnels, pas par re ecriture globale.
- Garder l administration legacy disponible tant que les nouveaux modules ne couvrent pas le besoin.
- Franciser l interface, la documentation et les nouveaux modules sans renommer massivement tout le noyau legacy.
- Introduire un socle technique moderne autour du coeur existant: services, supervision, cache, modules d administration.

## Chantiers

### 1. Socle Et Securisation

- Retirer les sorties de debug et les comportements de dev exposes en production.
- Nettoyer les textes en dur et les incoherences de langue.
- Ajouter des controles syntaxiques et un minimum de verification automatisee.
- Centraliser les nouvelles logiques dans des services dedies.

### 2. Nouvelle Administration

- Refaire l accueil admin autour d un tableau de bord de supervision.
- Reorganiser la navigation par domaines:
  - supervision
  - contenu
  - joueurs
  - univers
  - bots
  - missions
  - systeme
- Uniformiser les formulaires, tableaux, actions rapides et retours visuels.

### 3. Supervision Technique

- Afficher les indicateurs du jeu: comptes, bots, activite, tickets, flottes.
- Afficher les ressources serveur: charge, memoire, disque.
- Integrer l etat des conteneurs Docker de la future stack Astra.
- Permettre des actions de maintenance depuis l admin:
  - purge cache
  - verification services
  - etat applicatif

### 4. Cache Et Performance

- Ajouter Redis ou Valkey dans la stack Astra.
- Introduire un cache pilotable depuis l administration.
- Mesurer taille, etat, disponibilite et actions de purge.
- Optimiser les pages les plus lentes et les requetes les plus couteuses.

### 5. CMS De La Page D Accueil

- Creer un module de contenu avec editeur riche.
- Gerer les captures d ecran et medias via televersement.
- Permettre l edition des blocs de l accueil sans modifier les fichiers.
- Ajouter previsualisation, ordre d affichage et contenus localises.

### 6. Moteur De Bots

- Introduire des profils de bots configurables:
  - economique
  - agressif
  - colonisateur
  - opportuniste
  - animateur
- Gerer un scheduler d actions et une cible de bots connectes en permanence.
- Journaliser les actions passees et futures.
- Exposer une console d administration complete pour les bots.

### 7. Missions Et Recompenses

- Ajouter un systeme de quetes distinct des missions de flotte.
- Prevoir des missions journalieres, hebdomadaires et evenementielles.
- Permettre la configuration des objectifs, recompenses et regles anti abus.

## Stack Cible

### Application

- PHP existant modernise progressivement.
- Services applicatifs dedies pour la supervision, le contenu, les bots et les missions.
- Templates admin migrés vers une interface plus claire et plus modulaire.

### Infra Astra

- `web`
- `db`
- `cache`
- `phpmyadmin` ou equivalent d exploitation
- `observer`
- `docker-socket-proxy`

### Supervision

- Collecte locale des ressources serveur.
- Lecture de l etat Docker via proxy securise.
- Vue de synthese et vues detaillees dans l administration.

## Ordre D Execution Recommande

1. Stabiliser le socle admin et la supervision de base.
2. Ajouter le pilotage du cache et la couche de performance.
3. Refaire le module contenu et la page d accueil editable.
4. Construire le moteur de bots et son administration.
5. Ajouter les missions et recompenses.
6. Finaliser la francisation et retirer les ecrans legacy remplaces.

## Etat Actuel

### Deja engage

- Premier tableau de bord admin modernise.
- Premiere couche de supervision serveur et Docker.
- Tendances d activite sur 7 jours.
- Purge de cache mieux integree.
- Premieres corrections de textes et de templates.

### Prochain lot

- Ajouter une vraie page de supervision dediee.
- Preparer la stack Astra cible avec cache Redis ou Valkey.
- Poser le socle du module contenu pour la page d accueil editable.
