#!/bin/bash
# installation de Docker sur centos 7
																						




# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
MAISON_OPERATIONS=$(pwd)
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-gogsy.log"
# -
export DEPENDANCES_GOGS_IO
DEPENDANCES_GOGS_IO=$MAISON_OPERATIONS/dependances
export ADRESSE_IP_BDD_GOGS
export ADRESSE_IP_BDD_GOGS_PAR_DEFAUT
ADRESSE_IP_BDD_GOGS_PAR_DEFAUT=0.0.0.0
export MOTDEPASSEBDDGOGS
export MOTDEPASSEBDDGOGS_PAR_DEFAUT
MOTDEPASSEBDDGOGS_PAR_DEFAUT=punkybrewster


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander interactivement à l'utilisateur du
# script, quelle est l'adresse IP, dans l'hôte Docker, que l'instance de SGBDR pourra utiliser
demander_addrIP_BddGogs () {

	echo "Quelle adresse IP souhaitez-vous que le SGBDR de la BDD Gogs utilise?"
	echo "Cette adresse est à  choisir parmi:"
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read ADRESSE_IP_CHOISIE
	if [ "x$ADRESSE_IP_CHOISIE" = "x" ]; then
       ADRESSE_IP_BDD_GOGS=ADRESSE_IP_BDD_GOGS_PAR_DEFAUT
	else
	ADRESSE_IP_BDD_GOGS=$ADRESSE_IP_CHOISIE
	fi
	echo " Binding Adresse IP choisit pour le SGBDR de la BDD Gogs: $ADRESSE_IP_BDD_GOGS";
}
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander interactivement à l'utilisateur du
# script, quelle est le numéro de port IP, dans l'hôte Docker, que l'instance de SGBDR pourra utiliser
demander_noportIP_BddGogs () {

	echo "Quel numéro de port IP souhaitez-vous que le SGBDR de la BDD Gogs utilise?"
	echo "Le numéro de port par défaut sera: [$NO_PORT_BDD_GOGS_PAR_DEFAUT] "
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read NOPORT_IP_CHOISIT
	if [ "x$NOPORT_IP_CHOISIT" = "x" ]; then
       NO_PORT_BDD_GOGS=$NO_PORT_BDD_GOGS_PAR_DEFAUT
	else
      NO_PORT_BDD_GOGS=$NOPORT_IP_CHOISIT
	fi
	echo " Binding numéro port IP choisit pour le SGBDR de la BDD Gogs: $NO_PORT_BDD_GOGS";
}

# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander interactivement à l'utilisateur du
# script, quelle est le mot de passe initial à utiliser pour la provision de PostGreSQL
demander_mdp_BddGogs () {

	echo "Quel mot de passe souhaitez-vous fixer pour la BDD Gogs?"
	echo "(par défaut, le mot de passe sera [$MOTDEPASSEBDDGOGS_PAR_DEFAUT] )"
	echo " "
	read MDP_CHOISIT
	if [ "x$MDP_CHOISIT" = "x" ]; then
       MOTDEPASSEBDDGOGS=$MOTDEPASSEBDDGOGS_PAR_DEFAUT
	else
		MOTDEPASSEBDDGOGS=$MDP_CHOISIT
	fi
	echo " Mot de passe choisit pour l'installation de la BDD Gogs : $MOTDEPASSEBDDGOGS";
}




# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
# 
# Ce script permet de créer et démarrer un conteneur contenant une instance de SGBDR destiné à être utilisé par Gogs.
# Le SGBDR utilisé est PostGreSQL.
# 
# 
# 
# 
rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG
echo " +++provision+gogsy+bdd  COMMENCEE  - " >> $NOMFICHIERLOG


# PARTIE INTERACTIVE
demander_addrIP_BddGogs
demander_noportIP_BddGogs
demander_mdp_BddGogs



# PARTIE SILENCIEUSE

# update CentOS 7
sudo yum clean all -y && sudo yum update -y

# création des répertoires utilisés par les opérations
# mkdir -p $MAISON_OPERATIONS
cd $MAISON_OPERATIONS

sudo docker run --name some-postgres -e POSTGRES_PASSWORD=$MOTDEPASSEBDDGOGS -d postgres

###############################
# TODO: Création de la BDD gogs
# une fois le conteneur lancé, 
# il faut créer la BDD "gogs",
# et vérifier l'accès et droits
# de l'utilisateur sur la BDD
# gogs
# -
# 
clear

echo "------"
echo "------"
echo "------"
echo "------"
echo "DEBUG  Juste avant docker run BDD "
echo " "
echo " -- images docker: "
sudo docker images
echo " "
echo " -- conteneurs docker: "
sudo docker images
echo " "
echo " "
echo " "
echo " --  [ADRESSE_IP_BDD_GOGS=$ADRESSE_IP_BDD_GOGS]  "
echo " --  [NO_PORT_BDD_GOGS=$NO_PORT_BDD_GOGS]  "
echo " --  [MOTDEPASSEBDDGOGS=$MOTDEPASSEBDDGOGS]  "
echo " "
echo "------"
echo "---	Pressez une touche pour poursuivre les opérations "
read deboggue

sudo unzip $DEPENDANCES_GOGS_IO/linux_amd64.zip -d $REPERTOIRE_GOGS

sudo chown -R $PROVISIONING_USER:$PROVISIONING_USERGROUP $REPERTOIRE_GOGS

cd $REPERTOIRE_GOGS/gogs


# Je sais pas pourquoi, j'ai juste testé / vérifié en suivant les tickets Gogs
# J'ai testé:
#   - que sans installer toutes ces dépendances, le serveur gogs ne démarre pas.
#   - qu'après avoir installé touters ces dépedances, le serveur Gogs démarre et
#     demande la configurationde la bdd et la configuration réseau du serveur (ports et interfaces réseau utilisées)
#   
sudo yum install -y glibc.i686 libstdc++.so.6 pam.i686 ksh

./gogs web


# --------------------------------------------------------------------------------------------------------------------------------------------
# 			CONFIGURATION DU SYSTEME POUR BACKUP AUTYOMATISES		==>> CRONTAB 
# --------------------------------------------------------------------------------------------------------------------------------------------

# 1./ il faut ajouter la ligne:
# => pour une toutes les 4 heures: [* */4 * * * "$(pwd)/operations-std/serveur/backup.sh"]
#     Ainsi, il suffit de laisser le serveur en service pendant 4 heures pour être sûr qu'il y ait eu un backup.
# => pour une fois par nuit: [*/5 */1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => Toutes les 15 minutes après 7 heures: [5 7 * * * "$(pwd)/operations-std/serveur/backup.sh" ]
# 
# Au fichier crontab:
# 
# Mode manuel: sudo crontab -e

# export PLANIFICATION_DES_BCKUPS="* */4 * * *   $(pwd)/operations-std/serveur/backup.sh"
																					# une fois toutes les 3 minutes, pour les tests crontab
																					# export PLANIFICATION_DES_BCKUPS="3 * * * * $(pwd)/operations-std/serveur/backup.sh"


																					# rm -f doc-pms/operations-std/serveur/bckup.kytes
																					# echo "$PLANIFICATION_DES_BCKUPS" >> ./operations-std/serveur/bckup.kytes
																					# crontab ./operations-std/serveur/bckup.kytes
																					# rm -f ./operations-std/serveur/bckup.kytes
																					# echo " +++provision+gogsy+bdd+ Le backup Girafle a été cofniguré pour  " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+bdd+ s'exécuter automatiquent de la manière suivante: " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+bdd+  " >> $NOMFICHIERLOG
																					# crontab -l >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+bdd+  TERMINEE - " >> $NOMFICHIERLOG
#    ANNEXE crontab quickies
# => pour une fois par nuit: [* 1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 2 heures: [* */2 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 4 heures: [* */4 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une fois par nuit: [*/5 */1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => Toutes les 15 minutes après 7 heures: [5 7 * * * "$(pwd)/operations-std/serveur/backup.sh" ]
# => Toutes les 3 minutes: ["3 * * * * $(pwd)/operations-std/serveur/backup.sh" ]








