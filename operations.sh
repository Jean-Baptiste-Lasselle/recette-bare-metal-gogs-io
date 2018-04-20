#!/bin/bash
# installation de Docker sur centos 7
																						

# DOCKER EASE BARE-METAL-INSTALL - CentOS 7
# sudo systemctl stop docker
# sudo systemctl start docker


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
MAISON_OPERATIONS=$(pwd)/provision-gogs-io
export DEPENDANCES_GOGS_IO
DEPENDANCES_GOGS_IO=$MAISON_OPERATIONS/dependances
export ADRESSE_IP_SRV_GOGS
export REPERTOIRE_GOGS
export REPERTOIRE_GOGS_PAR_DEFAUT
REPERTOIRE_GOGS_PAR_DEFAUT=/opt/gogs
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-gogsy.log"
rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG
# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander iteractivement à l'utilisateur du
# script, quelle est l'adresse IP, dans l'hôte Docker, que l'instance Gitlab pourra utiliser
demander_addrIP () {

	echo "Quelle adresse IP souhaitez-vous que l'instance https://gogs.io utilise?"
	echo "Cette adresse est à  choisir parmi:"
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read ADRESSE_IP_CHOISIE
	if [ "x$ADRESSE_IP_CHOISIE" = "x" ]; then
       ADRESSE_IP_CHOISIE=0.0.0.0
	fi
	
	ADRESSE_IP_SRV_GOGS=$ADRESSE_IP_CHOISIE
	echo " Binding Adresse IP choisit pour le serveur gitlab: $ADRESSE_IP_CHOISIE";
}

# --------------------------------------------------------------------------------------------------------------------------------------------

demander_repertoireInstall () {

	echo "Dans quel répertoire souhaitez-vous installer Gogs?"
	echo "(par défaut, il sera installé dans [/opt/gogs] )"
	echo " "
	read REP_CHOISIT
	if [ "x$REP_CHOISIT" = "x" ]; then
       REPERTOIRE_GOGS=$REPERTOIRE_GOGS_PAR_DEFAUT
	fi
	
	REPERTOIRE_GOGS=$REP_CHOISIT
	echo " Répertoire choisit pour l'installation https://gogs.io : $REP_CHOISIT";
}
# --------------------------------------------------------------------------------------------------------------------------------------------
export WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY
# WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY=https://github.com/gogits/gogs/releases/download/v0.11.43/linux_amd64.zip
# WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY=https://dl.gogs.io/0.11.43/gogs_0.11.43_linux_amd64.zip
WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY=https://cdn.gogs.io/0.11.43/gogs_0.11.43_linux_386.zip
resoudreDependances () {
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SECURITY ==>> Attention, curl indique que le certifcat de sécurité est expiré ou non valide:
	# - J'ai vérifié sur le https://cdn.gogs.io , le certificat SSL est valide, l'autorité de 
	#   Certification est Let's Encrypt, donc le problème est probablement que l'instance curl ne
	#	reconnaît pas l'autorité de certifcation Let's Encrypt. Il faut donc soit reconnaître cette
	#	autorité dans le système d'exploitation de l'infrastructure, soit metttre ne place un canal
	#	pour intégrer / scanner les releases émises par gogs, et les aspirer dans le ssytème d'exploitation de l'infrastructure.
	curl --insecure $WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY --output linux_amd64.zip
	mv ./linux_amd64.zip $DEPENDANCES_GOGS_IO

}


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

echo " +++provision+gogsy+  COMMENCEE  - " >> $NOMFICHIERLOG


# PARTIE INTERACTIVE
demander_repertoireInstall
demander_addrIP


# PARTIE SILENCIEUSE

# update CentOS 7
sudo yum clean all -y && sudo yum update -y

# création des répertoires utilisés par les opérations
mkdir -p $MAISON_OPERATIONS
mkdir -p $DEPENDANCES_GOGS_IO

cd $MAISON_OPERATIONS

# Pour l'instant, je skip Docker, je n'en veux pas, je verrai après pour une isntallation dans un conteneur docker.
# sudo chmod +x ./docker-EASE-SPACE-BARE-METAL-SETUP.sh >> $NOMFICHIERLOG
# Installation de Git si nécessaire
echo " +++provision+gogsy+ Installation de Git"
echo " +++provision+gogsy+ Installation de Git" >> $NOMFICHIERLOG
sudo yum install -y git >> $NOMFICHIERLOG
echo " +++provision+gogsy+ Fin Installation de Git"
echo " +++provision+gogsy+ Installation de Git" >> $NOMFICHIERLOG

# Je résouds les dépendances, pour termienr l'installation de Gogs. 
# J'écrirai un script séparé pour procéder à la configuration de l'isntance Gogs.
resoudreDependances



sudo yum install -y unzip >> $NOMFICHIERLOG

clear

echo "------"
echo "------"
echo "------"
echo "------"
echo "DEBUG  Juste avant unzip "
echo " "
echo " -- Contenu de [DEPENDANCES_GOGS_IO=$DEPENDANCES_GOGS_IO] ( doit contenir \"linux_amd64.zip\"): "
sudo ls -all $DEPENDANCES_GOGS_IO
echo "------"
echo " "
echo " -- Répertoire [REPERTOIRE_GOGS=$REPERTOIRE_GOGS]: "
sudo ls -all $REPERTOIRE_GOGS
echo "------"
echo "------"
echo "------"
echo "------"
echo "---	Pressez une touche pour poursuivre les opérations"
read deboggue

unzip $DEPENDANCES_GOGS_IO/linux_amd64.zip -d $REPERTOIRE_GOGS

cd $REPERTOIRE_GOGS/gogs

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
																					# echo " +++provision+gogsy+ Le backup Girafle a été cofniguré pour  " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+ s'exécuter automatiquent de la manière suivante: " >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+  " >> $NOMFICHIERLOG
																					# crontab -l >> $NOMFICHIERLOG
																					# echo " +++provision+gogsy+  TERMINEE - " >> $NOMFICHIERLOG
#    ANNEXE crontab quickies
# => pour une fois par nuit: [* 1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 2 heures: [* */2 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une toutes les 4 heures: [* */4 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => pour une fois par nuit: [*/5 */1 * * * "$(pwd)/operations-std/serveur/backup.sh"]
# => Toutes les 15 minutes après 7 heures: [5 7 * * * "$(pwd)/operations-std/serveur/backup.sh" ]
# => Toutes les 3 minutes: ["3 * * * * $(pwd)/operations-std/serveur/backup.sh" ]








