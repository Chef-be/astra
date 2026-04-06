# Protection Nginx recommandée

Nginx n'interprète pas les fichiers `.htaccess`. Sans règles dédiées, certains dossiers internes peuvent être exposés publiquement.

Insérer les blocs suivants dans la configuration Nginx du site :

```nginx
location /cache/ {
    deny all;
}

location /includes/ {
    deny all;
}

location /includes/backups/ {
    deny all;
}

location /styles/templates/ {
    deny all;
}

location /tests/ {
    deny all;
}

location /language/ {
    deny all;
}

location /install/ {
    deny all;
}

location /.git/ {
    deny all;
}

location ~ /external/ {
    deny all;
}
```

## Objectif

Ces règles empêchent l'accès direct à :

- des caches applicatifs ;
- des fichiers d'installation ;
- des templates ;
- des fichiers de langue ;
- le dépôt Git ;
- certains répertoires techniques.
