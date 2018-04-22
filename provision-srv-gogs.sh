#!/bin/bash
# Hôte Docker sur centos 7

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
#  		+ Variables d'environnement héritées de [operations.sh]
#  		
#  		
#  		
export MAISON_OPERATIONS
MAISON_OPERATIONS=$(pwd)
# -
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-gogsy.log"
# -
export ADRESSE_IP_SRV_GOGS
export ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
ADRESSE_IP_SRV_GOGS_PAR_DEFAUT=0.0.0.0
# - 
export NO_PORT_BDD_GOGS
export NO_PORT_BDD_GOGS_PAR_DEFAUT
NO_PORT_BDD_GOGS_PAR_DEFAUT=0.0.0.0
# -
# export MOTDEPASSEBDDGOGS
# export MOTDEPASSEBDDGOGS_PAR_DEFAUT
# MOTDEPASSEBDDGOGS_PAR_DEFAUT=punkybrewster

export NOM_IMAGE_GOGS_IO
NOM_IMAGE_GOGS_IO=kytes-gogs-io:v0

export CONTEXTE_BUILD_DOCKER
CONTEXTE_BUILD_DOCKER=$MAISON_OPERATIONS

export DOCKERFILE_GOGSIO_APPLIANCE
DOCKERFILE_GOGSIO_APPLIANCE=./serveur-gogs.dockerfile

export NOM_CONTNEUR_SRV_GOGS
NOM_CONTNEUR_SRV_GOGS=gogsy-lady

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander interactivement à l'utilisateur du
# script, quelle est l'adresse IP, dans l'hôte Docker, que l'instance de SGBDR pourra utiliser
demander_addrIP_ServeurGogs () {

	echo "Quelle adresse IP souhaitez-vous que le SGBDR de la BDD Gogs utilise?"
	echo "Cette adresse est à  choisir parmi:"
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read ADRESSE_IP_CHOISIE
	if [ "x$ADRESSE_IP_CHOISIE" = "x" ]; then
       ADRESSE_IP_SRV_GOGS=ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
	else
	ADRESSE_IP_SRV_GOGS=$ADRESSE_IP_CHOISIE
	fi
	echo " Binding Adresse IP choisit pour le SGBDR de la BDD Gogs: $ADRESSE_IP_SRV_GOGS";
}
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander interactivement à l'utilisateur du
# script, quelle est le numéro de port IP, dans l'hôte Docker, que l'instance de SGBDR pourra utiliser
demander_noportIP_ServeurGogs () {

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
# demander_mdp_BddGogs () {

	# echo "Quel mot de passe souhaitez-vous fixer pour la BDD Gogs?"
	# echo "(par défaut, le mot de passe sera [$MOTDEPASSEBDDGOGS_PAR_DEFAUT] )"
	# echo " "
	# read MDP_CHOISIT
	# if [ "x$MDP_CHOISIT" = "x" ]; then
       # MOTDEPASSEBDDGOGS=$MOTDEPASSEBDDGOGS_PAR_DEFAUT
	# else
		# MOTDEPASSEBDDGOGS=$MDP_CHOISIT
	# fi
	# echo " Mot de passe choisit pour l'installation de la BDD Gogs : $MOTDEPASSEBDDGOGS";
# }




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
cd $MAISON_OPERATIONS

rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG
echo " +++provision+gogsy+serveur  COMMENCEE  - " >> $NOMFICHIERLOG

# PARTIE INTERACTIVE
demander_addrIP_ServeurGogs
demander_noportIP_ServeurGogs



# --------------------------------------------------------------------------------------------------------------------------------------------
# 			Créer l'image Docker de l'instance Gogs 
# --------------------------------------------------------------------------------------------------------------------------------------------
#  À partir du dockerfile

clear

echo "------"
echo "------"
echo "------"
echo "------"
echo "DEBUG  Juste avant docker build gogs.io "
echo " "
echo " -- images docker: "
sudo docker images
echo " "
echo " "
echo " "
echo " --  [NOM_IMAGE_GOGS_IO=$NOM_IMAGE_GOGS_IO]  "
echo " --  [CONTEXTE_BUILD_DOCKER=$CONTEXTE_BUILD_DOCKER]  "
echo " "
echo " --  Contenu de [$CONTEXTE_BUILD_DOCKER]:  "
echo " -- "
echo " "
ls -all $CONTEXTE_BUILD_DOCKER
echo " "
echo " -- "
echo " --  Contenu du Dockerfile [$DOCKERFILE_GOGSIO_APPLIANCE]  "
echo " -- "
echo " "
cat $DOCKERFILE_GOGSIO_APPLIANCE
echo " "
echo " -- "
echo "---	Pressez une touche pour poursuivre les opérations "
read deboggue

sudo docker build -f $DOCKERFILE_GOGSIO_APPLIANCE  -t $NOM_IMAGE_GOGS_IO $CONTEXTE_BUILD_DOCKER


clear

echo "------"
echo "------"
echo "------"
echo "------"
echo "DEBUG  Juste avant docker run gogs.io "
echo " "
echo " -- images docker: "
sudo docker images
echo " "
echo " -- conteneurs docker: "
sudo docker ps -a
echo " "
echo " "
echo " "
echo " --  [ADRESSE_IP_SRV_GOGS=$ADRESSE_IP_SRV_GOGS]  "
echo " --  [NO_PORT_BDD_GOGS=$NO_PORT_BDD_GOGS]  "
echo " --  [NOM_IMAGE_GOGS_IO=$NOM_IMAGE_GOGS_IO]  "
echo " --  [NOM_CONTNEUR_SRV_GOGS=$NOM_CONTNEUR_SRV_GOGS]  "
echo " "
echo "------"
echo "---	Pressez une touche pour poursuivre les opérations "
read deboggue

LISTE_OPTION_RESEAU=" -e $ADRESSE_IP_SRV_GOGS:$NO_PORT_BDD_GOGS"
sudo docker run --name $NOM_CONTNEUR_SRV_GOGS --restart=always $NOM_IMAGE_GOGS_IO

###############################
# TODO: Création de la BDD gogs
# une fois le conteneur lancé, 
# il faut créer la BDD "gogs",
# et vérifier l'accès et droits
# de l'utilisateur sur la BDD
# gogs
# -
# 



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
																					# echo " +++provision+gogsy+serveur+ Le backup Girafle a été cofniguré pour  " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+serveur+ s'exécuter automatiquent de la manière suivante: " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+serveur+  " >> $NOMFICHIERLOG
																					# crontab -l >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+serveur+  TERMINEE - " >> $NOMFICHIERLOG
#    ANNEXE crontab quickies
# => pour une fois par nuit: [* 1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 2 heures: [* */2 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 4 heures: [* */4 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une fois par nuit: [*/5 */1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => Toutes les 15 minutes après 7 heures: [5 7 * * * "$(pwd)/operations-std/serveur/backup.sh" ]
# => Toutes les 3 minutes: ["3 * * * * $(pwd)/operations-std/serveur/backup.sh" ]








