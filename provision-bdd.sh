#!/bin/bash
# Hôte Docker sur centos 7
																						




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

echo " +++provision+gogsy+bdd  COMMENCEE  - " >> $NOMFICHIERLOG




# création des répertoires utilisés par les opérations
# mkdir -p $MAISON_OPERATIONS
cd $MAISON_OPERATIONS


# 1 numéro de port est sont utilisé par PostGreSQL  :   5432
LISTE_OPTION_RESEAU="-e $ADRESSE_IP_BDD_GOGS:$NO_PORT_BDD_GOGS:5432"
# LISTE_OPTION_RESEAU="$LISTE_OPTION_RESEAU -e ....."
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
echo " --  [LISTE_OPTION_RESEAU=$LISTE_OPTION_RESEAU]  "
echo " "
echo "------"
echo "---	Pressez une touche pour poursuivre les opérations "
read deboggue

sudo docker run --name $NOM_CONTENEUR_BDD_GOGS $LISTE_OPTION_RESEAU -d postgres

###############################
# TODO: Création de la BDD gogs
# une fois le conteneur lancé, 
# il faut créer la BDD "gogs",
# et vérifier l'accès et droits
# de l'utilisateur sur la BDD
# gogs
# -
# 




echo " +++provision+gogsy+bdd  TERMINEE  - " >> $NOMFICHIERLOG


