# Administration d'Astra Dominion

## Vue générale

L'administration est servie par [`admin.php`](../admin.php) et structurée autour de contrôleurs dans [`includes/pages/adm/`](../includes/pages/adm). La navigation et les métadonnées d'interface sont centralisées dans [`AdminUiService.class.php`](../includes/classes/AdminUiService.class.php).

## Modules principaux

### Pilotage

- tableau de bord ;
- supervision ;
- support ;
- chat temps réel ;
- journaux.

### Contenu

- site public ;
- actualités ;
- missions ;
- bots ;
- campagnes de messages.

### Joueurs

- comptes ;
- recherche ;
- flottes en vol ;
- bannissements ;
- création manuelle.

### Paramètres

- serveur et identité ;
- univers ;
- identité visuelle ;
- modèles de courriels ;
- statistiques ;
- colonies ;
- champs planétaires ;
- expéditions ;
- relocalisation ;
- modules ;
- mentions légales ;
- cache.

### Outils avancés

- activations en attente ;
- historique des messages ;
- multi-comptes et IP ;
- données de compte ;
- droits ;
- tâches planifiées ;
- sauvegarde SQL ;
- informations techniques.

## Contrôleurs importants

- [`ShowOverviewPage.class.php`](../includes/pages/adm/ShowOverviewPage.class.php)
- [`ShowSupervisionPage.class.php`](../includes/pages/adm/ShowSupervisionPage.class.php)
- [`ShowSupportPage.class.php`](../includes/pages/adm/ShowSupportPage.class.php)
- [`ShowChatPage.class.php`](../includes/pages/adm/ShowChatPage.class.php)
- [`ShowPublicPage.class.php`](../includes/pages/adm/ShowPublicPage.class.php)
- [`ShowMailtemplatesPage.class.php`](../includes/pages/adm/ShowMailtemplatesPage.class.php)
- [`ShowBotsPage.class.php`](../includes/pages/adm/ShowBotsPage.class.php)
- [`ShowMissionsPage.class.php`](../includes/pages/adm/ShowMissionsPage.class.php)
- [`ShowCronjobPage.class.php`](../includes/pages/adm/ShowCronjobPage.class.php)

## Principes de fonctionnement

- chaque page d'administration correspond à une classe `Show...Page` ;
- le rendu passe par Smarty et les templates de [`styles/templates/adm/`](../styles/templates/adm) ;
- les nouveaux modules s'appuient sur des services dédiés dans [`includes/classes/`](../includes/classes) ;
- l'administration modernisée cohabite encore avec du legacy sur certaines zones.

## Zones particulièrement personnalisées

### Support

Le module support permet :

- la consultation des tickets ;
- les actions rapides ;
- les actions de masse ;
- la suppression complète des tickets ;
- la remise à zéro du compteur de tickets.

### Site public

Le module public permet :

- d'éditer l'encart éditorial de l'accueil ;
- de piloter les entrées du menu public ;
- d'activer ou non Discord ;
- de configurer les questions secrètes d'inscription.

### Courriels

Le module des modèles de courriels édite directement les fichiers de [`language/fr/templates/`](../language/fr/templates) via [`MailTemplateService.class.php`](../includes/classes/MailTemplateService.class.php).

## Recommandations d'exploitation

- valider les changements sur une session admin de test avant production ;
- purger les caches si une vue Smarty reste sur un ancien rendu ;
- contrôler les journaux après chaque modification structurelle ;
- éviter les suppressions massives sans sauvegarde préalable.
