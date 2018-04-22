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
# export MAISON_OPERATIONS
# MAISON_OPERATIONS=$(pwd)
# -
# export NOMFICHIERLOG
# NOMFICHIERLOG="$(pwd)/provision-gogsy.log"



######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
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
# export ADRESSE_IP_BDD_GOGS
# export ADRESSE_IP_BDD_GOGS_PAR_DEFAUT
# ADRESSE_IP_BDD_GOGS_PAR_DEFAUT=0.0.0.0
# -
# export NO_PORT_BDD_GOGS
# export NO_PORT_BDD_GOGS_PAR_DEFAUT
# NO_PORT_BDD_GOGS_PAR_DEFAUT=8564
# -
# export MOTDEPASSEBDDGOGS
# export MOTDEPASSEBDDGOGS_PAR_DEFAUT
# MOTDEPASSEBDDGOGS_PAR_DEFAUT=punkybrewster
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -


# export ADRESSE_IP_SRV_GOGS
# export REPERTOIRE_GOGS
# export REPERTOIRE_GOGS_PAR_DEFAUT
# REPERTOIRE_GOGS_PAR_DEFAUT=/opt/gogs

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

# PARTIE SILENCIEUSE

# update CentOS 7
sudo yum clean all -y && sudo yum update -y


######################
# Installation Docker
# Pour la création du conteneur docker pour la BDD Gogs, cf. provision-bdd.sh
sudo chmod +x ./docker-BARE-METAL-SETUP.sh

./docker-BARE-METAL-SETUP.sh
