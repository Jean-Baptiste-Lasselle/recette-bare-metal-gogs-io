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
# export MAISON_OPERATIONS
# MAISON_OPERATIONS=$(pwd)
# -
# export NOMFICHIERLOG
# NOMFICHIERLOG="$(pwd)/provision-gogsy.log"
# -
# export ADRESSE_IP_SRV_GOGS
# export ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
# ADRESSE_IP_SRV_GOGS_PAR_DEFAUT=0.0.0.0
# - 
# export NO_PORT_SRV_GOGS
# export NO_PORT_SRV_GOGS_PAR_DEFAUT
# NO_PORT_SRV_GOGS_PAR_DEFAUT=4000
# - 
# export NO_PORT_SSH_SRV_GOGS
# export NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT
# NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT=23

# -
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

# rm -f $NOMFICHIERLOG
# touch $NOMFICHIERLOG
echo " +++provision+gogsy+serveur  COMMENCEE  - "

# PARTIE INTERACTIVE
# demander_addrIP_ServeurGogs
# demander_noportIP_ServeurGogs



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
echo " --  [NO_PORT_SRV_GOGS=$NO_PORT_SRV_GOGS]  "
echo " --  [NOM_IMAGE_GOGS_IO=$NOM_IMAGE_GOGS_IO]  "
echo " --  [NOM_CONTNEUR_SRV_GOGS=$NOM_CONTNEUR_SRV_GOGS]  "
echo " "
echo "------"
echo "---	Pressez une touche pour poursuivre les opérations "
read deboggue
# 2 numéros de ports sont utilisés par Gogs.io  :   HTTP 3000   SSH 22
LISTE_OPTION_RESEAU=" -e $ADRESSE_IP_SRV_GOGS:$NO_PORT_SRV_GOGS:3000"
LISTE_OPTION_RESEAU="$LISTE_OPTION_RESEAU -e $ADRESSE_IP_SRV_GOGS:$NO_PORT_SSH_SRV_GOGS:22"

sudo docker run --name $NOM_CONTNEUR_SRV_GOGS $LISTE_OPTION_RESEAU --restart=always $NOM_IMAGE_GOGS_IO

# Attention!: à cet instant précis, les heathcheck n'ont pas encore été faits.
echo " +++provision+gogsy+serveur  COMMENCEE  - "
