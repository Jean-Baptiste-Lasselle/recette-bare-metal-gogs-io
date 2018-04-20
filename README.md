# Recette provision Gogs rapide


Cette recette provisionne un une instance [Gogs](https://gogs.io/)


# Utilisation 

```
MAISON_OPERATIONS=$(pwd)/provision-gogs-io
URI_REPO_RECETTE=https://github.com/Jean-Baptiste-Lasselle/recette-bare-metal-gogs-io
mkdir -p $MAISON_OPERATIONS && cd $MAISON_OPERATIONS && git clone $URI_REPO_RECETTE . && sudo chmod +x ./operations.sh && ./operations.sh
```

# TODOs
* configuration sécurisée et haute dispo 
* opérations standard d'exploitation:
  * gestion des utilisateurs et de leurs droits
  * backup
  * restore
* Test autommatisés:
  * De la limite du nombre de repos avec 2 machines de tailles significativement différente
* Regarder vite fait les possibilités de ustomisation CSS
