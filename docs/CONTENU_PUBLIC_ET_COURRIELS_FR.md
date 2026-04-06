# Contenu public et courriels

## Site public

Le pilotage du site public est centralisé via :

- [`ShowPublicPage.class.php`](../includes/pages/adm/ShowPublicPage.class.php)
- [`PublicContentService.class.php`](../includes/classes/PublicContentService.class.php)

## Éléments administrables

- encart éditorial de la page d'accueil ;
- entrées du menu public ;
- lien Discord ;
- questions secrètes de l'inscription ;
- activation ou désactivation de certaines pages publiques.

## Comportement

Si aucun contenu éditorial personnalisé n'est défini, [`PublicContentService.class.php`](../includes/classes/PublicContentService.class.php) fournit un texte de repli.

## Courriels

Les modèles de courriels modifiables sont gérés par :

- [`ShowMailtemplatesPage.class.php`](../includes/pages/adm/ShowMailtemplatesPage.class.php)
- [`MailTemplateService.class.php`](../includes/classes/MailTemplateService.class.php)

## Modèles pris en charge

- `email_reg_done`
- `email_vaild_reg`
- `email_lost_password_validation`
- `email_lost_password_changed`
- `email_inactive`

## Emplacement physique

Les modèles sont stockés dans :

- [`language/fr/templates/`](../language/fr/templates)

## Variables de prévisualisation

Le service de courriels prend en charge des marqueurs tels que :

- `{USERNAME}`
- `{GAMENAME}`
- `{PASSWORD}`
- `{VALIDURL}`
- `{VERTIFYURL}`
- `{HTTPPATH}`
- `{GAMEMAIL}`
- `{LASTDATE}`

## Recommandations

- conserver un ton cohérent dans tous les courriels ;
- vérifier le rendu après modification ;
- ne pas supprimer un marqueur nécessaire au scénario métier associé.
