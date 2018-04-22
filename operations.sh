#!/bin/bash
# Hôte Docker sur centos 7
																						

# DOCKER BARE-METAL-INSTALL - CentOS 7
# sudo systemctl stop docker
# sudo systemctl start docker


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
MAISON_OPERATIONS=$(pwd)
# -
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-gogsy.log"



######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
# -
export ADRESSE_IP_SRV_GOGS
export ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
ADRESSE_IP_SRV_GOGS_PAR_DEFAUT=0.0.0.0
# - 
export NO_PORT_SRV_GOGS
export NO_PORT_SRV_GOGS_PAR_DEFAUT
NO_PORT_SRV_GOGS_PAR_DEFAUT=4000
# - 
export NO_PORT_SSH_SRV_GOGS
export NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT
NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT=23
# - 
export ADRESSE_IP_BDD_GOGS
export ADRESSE_IP_BDD_GOGS_PAR_DEFAUT
ADRESSE_IP_BDD_GOGS_PAR_DEFAUT=0.0.0.0
# -
export NO_PORT_BDD_GOGS
export NO_PORT_BDD_GOGS_PAR_DEFAUT
NO_PORT_BDD_GOGS_PAR_DEFAUT=8564
# -
export MOTDEPASSEBDDGOGS
export MOTDEPASSEBDDGOGS_PAR_DEFAUT
MOTDEPASSEBDDGOGS_PAR_DEFAUT=punkybrewster
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -


export ADRESSE_IP_SRV_GOGS
export REPERTOIRE_GOGS
export REPERTOIRE_GOGS_PAR_DEFAUT
REPERTOIRE_GOGS_PAR_DEFAUT=/opt/gogs

export NOM_CONTENEUR_BDD_GOGS
export NOM_CONTENEUR_BDD_GOGS_PAR_DEFAUT
NOM_CONTENEUR_BDD_GOGS_PAR_DEFAUT=bdd-gogs.punky
# Pas de question interactive, ou de paramètre
# permettant de redéfinir le nom du conteneur docker
# pour ma distrib.
NOM_CONTENEUR_BDD_GOGS=$NOM_CONTENEUR_BDD_GOGS_PAR_DEFAUT
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

	echo "Quel numéro de port IP souhaitez-vous que le serveur Gogs utilise?"
	echo "Le numéro de port par défaut sera: [$NO_PORT_BDD_GOGS_PAR_DEFAUT] "
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
# script, quelle est le numéro de port IP, dans l'hôte Docker, utilisable
# pour se conencter en SSH à l'instance de Gogs
demander_noportIP_ServeurSSHGogs () {

	echo "Quel numéro de port IP souhaitez-vous que le SGBDR de la BDD Gogs utilise?"
	echo "Le numéro de port par défaut sera: [$NO_PORT_BDD_GOGS_PAR_DEFAUT] "
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read NOPORTSSH_IP_CHOISIT
	if [ "x$NOPORTSSH_IP_CHOISIT" = "x" ]; then
       NO_PORT_SSH_SRV_GOGS=$NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT
	else
      NO_PORT_SSH_SRV_GOGS=$NOPORTSSH_IP_CHOISIT
	fi
	echo " Binding numéro port IP choisit pour le SGBDR de la BDD Gogs: $NO_PORT_SSH_SRV_GOGS";
}


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
# 
# Cette fonction permet d'attendre que le conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire sinon une erreur est générée (TODO: à implémenter avec exit code)
checkHealth () {
	export ETATCOURANTCONTENEUR=starting
	export ETATCONTENEURPRET=healthy
	export NOM_DU_CONTENEUR_INSPECTE=$1
	
	while  $(echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG); do
	
	ETATCOURANTCONTENEUR=$(sudo docker inspect -f '{{json .State.Health.Status}}' $NOM_DU_CONTENEUR_INSPECTE)
	if [ $ETATCOURANTCONTENEUR == "\"healthy\"" ]
	then
		echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE est prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG
		break;
	else
		echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE n'est pas prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR] - attente d'une seconde avant prochain HealthCheck - ">> $NOMFICHIERLOG
		sleep 1s
	fi
	done
	
	# DEBUG LOGS
	echo " provision-girofle-  ------------------------------------------------------------------------------ " >> $NOMFICHIERLOG
	echo " provision-girofle-  - Contenu du répertoire [/etc/gitlab] dans le conteneur [$NOM_DU_CONTENEUR_INSPECTE]:" >> $NOMFICHIERLOG
	echo " provision-girofle-  - " >> $NOMFICHIERLOG
	sudo docker exec -it $NOM_DU_CONTENEUR_INSPECTE /bin/bash -c "ls -all /etc/gitlab" >> $NOMFICHIERLOG
	echo " provision-girofle-  ------------------------------------------------------------------------------ " >> $NOMFICHIERLOG
	echo " provision-girofle-  - Existence du fichier [/etc/gitlab/gitlab.rb] dans le conteneur  [$NOM_DU_CONTENEUR_INSPECTE]:" >> $NOMFICHIERLOG
	echo " provision-girofle-  - " >> $NOMFICHIERLOG
	sudo docker exec -it $NOM_DU_CONTENEUR_INSPECTE /bin/bash -c "ls -all /etc/gitlab/gitlab.rb" >> $NOMFICHIERLOG
	echo " provision-girofle-  - " >> $NOMFICHIERLOG
	echo " provision-girofle-  ------------------------------------------------------------------------------ " >> $NOMFICHIERLOG
}

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
cd $MAISON_OPERATIONS

rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG

echo " +++provision+gogsy+  COMMENCEE  - " >> $NOMFICHIERLOG


# PARTIE INTERACTIVE
demander_addrIP_BddGogs
demander_noportIP_BddGogs
demander_mdp_BddGogs
demander_addrIP_ServeurGogs
demander_noportIP_ServeurGogs
demander_noportIP_ServeurSSHGogs

# PARTIE SILENCIEUSE


# on rend les scripts à exécuter, exécutables.
sudo chmod +x ./provision-bdd.sh >> $NOMFICHIERLOG
sudo chmod +x ./provision-srv-gogs.sh >> $NOMFICHIERLOG
sudo chmod +x ./provision-hote-docker.sh >> $NOMFICHIERLOG

# provision hôte docker
./provision-hote-docker.sh >> $NOMFICHIERLOG

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
checkHealth $NOM_CONTENEUR_BDD_GOGS

./provision-srv-gogs.sh >> $NOMFICHIERLOG



