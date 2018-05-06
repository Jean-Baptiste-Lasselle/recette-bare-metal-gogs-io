FROM centos:7
# -------------------------------------------
# -------------------------------------------
# -------------------------------------------
# 						ENV
# -------------------------------------------
# -------------------------------------------
# -------------------------------------------
# 
# -------------------------------------------
# L'adresse IP que le serveur Gogs utilisera.
# -------------------------------------------
# 		=> à modifier éventuellement au docker build [docker build --build-arg ADRESSE_IP_SERV_GOGS=127.0.0.1]
# 		=> et si l'argument [--build-arg ADRESSE_IP_SERV_GOGS=...] n'est pas utilisé au build de l'image, alors
# 		   la variable d'environnement [$ADRESSE_IP_SRV_GOGS] prend la valeur par défaut de l'argument [$ADRESSE_IP_SERV_GOGS], ce
# 		   qui garantit une valeur par défaut pour la variable d'environnement [$ADRESSE_IP_SRV_GOGS].
ARG ADRESSE_IP_SERV_GOGS=0.0.0.0
# La valeur par défaut de la variable d'environnement [$ADRESSE_IP_SRV_GOGS] est 0.0.0.0
# 		=> Au [docker run ], on pourra redéfinir la valeur de cette variable d'environnement avec la syntaxe:
# 		docker run --name monpetitconteneur -e ADRESSE_IP_SRV_GOGS=192.168.1.32 -d $NOMIMAGE
ENV ADRESSE_IP_SRV_GOGS=$ADRESSE_IP_SERV_GOGS
# -------------------------------------------
# Le répertorie d'isntallation de GOGS
# -------------------------------------------
# 		=> à modifier éventuellement au docker build [docker build $NOMIMAGE --build-arg REP_GOGS=127.0.0.1]
ARG REP_GOGS=/opt/gogs
# La valeur par défaut de la variable d'environnement [$REPERTOIRE_GOGS] est "/opt/gogs"
# 		=> Au [docker run ], on pourra redéfinir la valeur de cette variable d'environnement avec la syntaxe:
# 		docker run --name monpetitconteneur -e REPERTOIRE_GOGS=192.168.1.32 -d $NOMIMAGE
ENV REPERTOIRE_GOGS=$REP_GOGS


ARG REP_OPERATIONS=$(pwd)
ENV MAISON_OPERATIONS=$REP_OPERATIONS

ARG REP_DEPENDANCES_GOGS_IO=$REP_OPERATIONS/dependances
ENV DEPENDANCES_GOGS_IO=$REP_DEPENDANCES_GOGS_IO

ARG NOMDUFICHIERLOG="$(pwd)/provision-gogsy.log"
ENV NOMFICHIERLOG=$NOMDUFICHIERLOG


# TODO: retirer cette référence d'URL pour qu'elle soit gérée par le système d'exploitation de l'infratructure. Un hôte Docker n'est en rien destiné à une gestion d'infrastructure.
ARG WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY=https://cdn.gogs.io/0.11.43/gogs_0.11.43_linux_386.zip
ENV WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY=$WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY


# -------------------------------------------
# -------------------------------------------
# -------------------------------------------
# 						ops
# -------------------------------------------
# -------------------------------------------
# -------------------------------------------

#####################
# Updates centos
# -
RUN yum clean all -y && sudo yum update -y

#####################
# création
# envionnement de
# provision
# -
RUN rm -f $NOMFICHIERLOG
RUN touch $NOMFICHIERLOG
RUN echo " +++provision+gogsy+  COMMENCEE  - " >> $NOMFICHIERLOG
# mkdir -p $MAISON_OPERATIONS
RUN mkdir -p $DEPENDANCES_GOGS_IO
RUN mkdir -p $REPERTOIRE_GOGS
RUN chown -R $PROVISIONING_USER:$PROVISIONING_USERGROUP $REPERTOIRE_GOGS
RUN cd $MAISON_OPERATIONS


#####################
# openssh-server
# -
RUN yum install -y openssh-server

#####################
# Git
# -
RUN echo " +++provision+gogsy+ Installation de Git"
RUN echo " +++provision+gogsy+ Installation de Git" >> $NOMFICHIERLOG
RUN yum install -y git >> $NOMFICHIERLOG
RUN echo " +++provision+gogsy+ Fin Installation de Git"
RUN echo " +++provision+gogsy+ Installation de Git" >> $NOMFICHIERLOG

#####################
# Autres
# -
# Je résouds les dépendances, pour terminer l'installation de Gogs.
# Téléchargement de la distribution officielle Gogs
# TODO: remplacer le télécvhargement non-sécurisé par un téléchargement Sécurisé
#       en déterminant si gogs propose un canal utilisable de manière sécurisée.
#       Si Ggogs ne fournit pas de canal complaint avec l politique de sécurité
#       de l'organisation, une procédure de validation continue de Gogs doit être
#       mise en place, comme pour tous les produits développés à l'extérieur de
#       l'organisation.
#       Cette procédure peut être automatisée par un pipeline équipés de tests automatisés.
#       
#  ===>>    HOP LA pas du tout, en fait le problème qui m'a forcé à faire un
#           téléchargement "insecure", c'est certainement le fait que l'heure système 
#           de mon hôte docker est complètement décalée par raport à la date de début
#           de validité du certificat SSL: il faut donc simplement synchroniser l'hôte
#           docker sur un serveur NTP
# RUN curl --insecure $WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY --output linux_amd64.zip
RUN curl $WHERE_TO_FIND_MAIN_DISTRIBUTED_BINARY --output linux_amd64.zip
RUN mv ./linux_amd64.zip $DEPENDANCES_GOGS_IO
RUN yum install -y unzip >> $NOMFICHIERLOG

#####################
# Logs...
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "DEBUG  Juste avant unzip " >> $NOMFICHIERLOG
RUN echo " " >> $NOMFICHIERLOG
RUN echo " -- Contenu de [DEPENDANCES_GOGS_IO=$DEPENDANCES_GOGS_IO] ( doit contenir \"linux_amd64.zip\"): " >> $NOMFICHIERLOG
RUN ls -all $DEPENDANCES_GOGS_IO >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo " " >> $NOMFICHIERLOG
RUN echo " -- Répertoire [REPERTOIRE_GOGS=$REPERTOIRE_GOGS]: " >> $NOMFICHIERLOG
RUN ls -all $REPERTOIRE_GOGS/.. >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo " " >> $NOMFICHIERLOG
RUN echo " -- Contenu Répertoire [REPERTOIRE_GOGS=$REPERTOIRE_GOGS]: " >> $NOMFICHIERLOG
RUN ls -all $REPERTOIRE_GOGS >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "-----	  Commande droits sur répertoire : " >> $NOMFICHIERLOG
RUN echo "-----	[ PROVISIONING_USER=$PROVISIONING_USER] " >> $NOMFICHIERLOG
RUN echo "-----	[ PROVISIONING_USERGROUP=$PROVISIONING_USERGROUP] " >> $NOMFICHIERLOG
RUN echo "-----	[ chown -R $PROVISIONING_USER:$PROVISIONING_USERGROUP $REPERTOIRE_GOGS ] " >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "------" >> $NOMFICHIERLOG
RUN echo "---	Pressez une touche pour poursuivre les opérations " >> $NOMFICHIERLOG
RUN unzip $DEPENDANCES_GOGS_IO/linux_amd64.zip -d $REPERTOIRE_GOGS >> $NOMFICHIERLOG
RUN chown -R $PROVISIONING_USER:$PROVISIONING_USERGROUP $REPERTOIRE_GOGS
RUN cd $REPERTOIRE_GOGS/gogs


#####################
# Je sais pas
# pourquoi, j'ai juste
# testé / vérifié en
# suivant les tickets Gogs
# -
# J'ai testé:
#   + que sans installer toutes ces dépendances, le serveur gogs ne démarre pas.
#   + qu'après avoir installé touters ces dépedances, le serveur Gogs démarre et
#     demande la configurationde la bdd et la configuration réseau du serveur (ports et interfaces réseau utilisées)
#  
# - 
RUN yum install -y glibc.i686 libstdc++.so.6 pam.i686 ksh

#####################
# TODO:
# -
# reconfiguration de
# Gogs avec l'adresse
# IP et le numéro de
# port paramétrant
# ce Dockerfile.
# -

#####################
# HEALTH_CHECK gogs
HEALTHCHECK  --interval=1s --timeout=3s --retries=30 CMD curl --fail http://localhost:3000/ || exit 1
#####################
# ENRYPOINT
CMD ["./gogs", "web"]