# Recette provision Gogs rapide


Cette recette provisionne un une instance [Gogs](https://gogs.io/)


# Utilisation 

```
MAISON_OPERATIONS=$(pwd)/provision-gogs-io
URI_REPO_RECETTE=https://github.com/Jean-Baptiste-Lasselle/recette-bare-metal-gogs-io
mkdir -p $MAISON_OPERATIONS && cd $MAISON_OPERATIONS && git clone $URI_REPO_RECETTE . && sudo chmod +x ./operations.sh && ./operations.sh
```

# POINT REPRISE

* TODO: Création de la BDD `gogs` dans  PostGreSQL, ave cle script `provision-bdd.sh`
* Tester que le unzip se fait bien.
* Ajouter la provision de la BDD, et déterminer comment effectuer une configuration automatisée de Gogs, à la fois sur la configuration du réseau, et de la BDD.
* Installation annexe à faire, dixit la [documentation de Gogs](https://gogs.io/docs/installation) :

```
Prerequisites

    Database (choose one of the following):
        MySQL: Version >= 5.7
        PostgreSQL
        MSSQL
        TiDB (experimental, connect via the MySQL protocol)
        or NOTHING with SQLite3
    Git (bash):
        Version >= 1.7.1 for both server and client sides
        Best to use latest version for Windows
    A functioning SSH server:
        Ignore this if you’re only going to use HTTP/HTTPS
        For using builtin SSH server on Windows, make sure you added ssh-keygen to your %PATH% environment variable.
        For using standalone SSH server, recommend Cygwin OpenSSH or Copssh for Windows.

Install database

Based on your choice, install one of the supported databases (or skip this step):

    MySQL (Engine: INNODB)
    PostgreSQL

REMEMBER Please use scripts/mysql.sql to create a database called gogs (default). If you create it manually, make sure the encoding is utf8mb4.
```

Une contenerisation est dangereusement en vue incessamentttt...

Valider les paramètres d'intégration:
* Adresse IP et numéros de Ports utilisés par le serveur MySQL (MariaDB marchera? Sinon on fera avec PostGreSQL)
* Adresse IP et numéros de Ports utilisés par le serveur Gogs
*  Vérifier s'il faut installer un environnement Go, pour la simple exécution (je ne pense pas la distribution est structurée par version d'OS)

# TODOs

* Développer le healthcheck spécifique à l'orchestration PostGreSQL / Gogs.io :
# --------------------------------------------------------------------------------------------------------------------------------------------
# 			NOUVELLE PORVISIO PAR DES CONTENURS
# --------------------------------------------------------------------------------------------------------------------------------------------

# 1. conteneur BDD
./provision-bdd.sh >> $NOMFICHIERLOG
# => HealthCheck modifié: le helth doit comprendre non pas la disponibilité seule du SGBDR PostGreSQL, mais
#	 un custom Healthcheck qui vva se connecter avec l'utilisateur prévu pour Gogs, sur la BDD de nom "gogs", avec une
#    requête SQL [use gogs; SELECT 1;], voir une script SQL entier qui créée puis détruit uen table, voir un script SQL
#    entier qui vérifie toutes les actiosn nécessitant des droits, pour valider tous les droits les uns après les autres.
#    Non, ce qui doit être vérifié dans le HELTYH CHECK avec de la requête SQL, c'est:
#	 	1./ la disponibilité du SGBDR
#       2./ L'existence de la BDD
#       3./ le succès de l'authentification du (des) user(s) PostGreSQL utilisé(s) par http://gogs.io
# ===================>>>> Vérifier si ce HealthCheck Customisé est bien utilisé par le docker-compose up à partir du docker-compose.yml
# 2. Conteneur Serveur
./provision-srv-gogs.sh >> $NOMFICHIERLOG


* configuration sécurisée et haute dispo 
* opérations standard d'exploitation:
  * gestion des utilisateurs et de leurs droits
  * backup
  * restore
* Test autommatisés:
  * De la limite du nombre de repos avec 2 machines de tailles significativement différentes
* Regarder rapidement les possibilités de customisation CSS



