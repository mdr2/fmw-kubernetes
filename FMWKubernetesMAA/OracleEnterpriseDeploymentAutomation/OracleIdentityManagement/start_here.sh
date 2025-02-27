#!/bin/bash
# Copyright (c) 2021, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# This is an example script to populate the responsefile
# 
#
# Dependencies: ./common/functions.sh
#               ./responsefile/idm.rsp
#
# Usage: start_here.sh
#
RSPFILE=responsefile/idm.rsp
. $RSPFILE
. common/functions.sh

echo "Checking Pre-requisites"
echo "-----------------------"

echo -n "Have you downloaded and staged the docker images (y/n) :"
read ANS
if ! check_yes $ANS
then
    echo "Download the docker images referring to support note (2723908.1)"
    exit 1
fi

echo -n "Have you a running Kubernetes Cluster (y/n) :"
read ANS
if ! check_yes $ANS
then
    echo "You must first build a kubernetes cluster"
    exit 1
fi

echo -n "Have you set up SSH equivalence to each Kubernetes node (y/n) :"
read ANS
if ! check_yes $ANS
then
    echo "It is recommended that you set up SSH equivalence for the duration of the setup"
    exit 1
fi

echo "Products to Install and Configure"
echo "---------------------------------"
echo " "
echo -n  "  Do you wish to install/config OUD (y/n) : "
read ANS

if check_yes $ANS 
then
    INSTALL_OUD=true
else
    INSTALL_OUD=false
fi

echo 
echo -n  "  Do you wish to install/config OUDSM (y/n) : "
read ANS

if check_yes $ANS 
then
    INSTALL_OUDSM=true
else
    INSTALL_OUDSM=false
fi


echo " "
echo -n  "  Do you wish to install/config Oracle Access Manager (y/n) : "
read ANS

if check_yes $ANS 
then
    INSTALL_OAM=true
else
    INSTALL_OAM=false
fi

echo " "
echo -n  "  Do you wish to install/config Oracle Identity Governance (y/n) : "
read ANS

if check_yes $ANS 
then
    INSTALL_OIG=true
else
    INSTALL_OIG=false
fi

replace_value INSTALL_OUD $INSTALL_OUD $RSPFILE
replace_value INSTALL_OUDSM $INSTALL_OUDSM $RSPFILE
replace_value INSTALL_OAM $INSTALL_OAM $RSPFILE
replace_value INSTALL_OIG $INSTALL_OIG $RSPFILE

echo " "
echo "File Locations"
echo "--------------"
echo 

echo -n "Enter location of docker images [$IMAGE_DIR]:"
read ANS

if ! [ "$ANS" = "" ]
then
     replace_value IMAGE_DIR $ANS $RSPFILE
fi


echo -n "Enter location of local working directory [$LOCAL_WORKDIR]:"
read ANS

if ! [ "$ANS" = "" ]
then
     replace_value LOCAL_WORKDIR $ANS $RSPFILE
fi


echo " "
echo "NFS Locations"
echo "--------------"

echo -n "Enter IP of NFS Server [$PVSERVER]:"
read ANS

if ! [ "$ANS" = "" ]
then
     replace_value PVSERVER $ANS $RSPFILE
fi

if [ "$INSTALL_OUD" = "true" ]
then
      echo " "
      echo "Oracle Unified Directory"
      echo "------------------------"
      
      echo -n "Enter OUD Share [$OUD_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_SHARE $ANS $RSPFILE
      fi

      echo -n "Enter OUD Config Share [$OUD_CONFIG_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_CONFIG_SHARE $ANS $RSPFILE
      fi

      echo -n "Enter OUD Config Share Local Mount Point [$OUD_LOCAL_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_LOCAL_SHARE $ANS $RSPFILE
      fi

      echo -n "Enter Kubernetes Namespace for OUD [$OUDNS]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUDNS $ANS $RSPFILE
      fi

      echo -n "Enter Name of OUD Admin User to be used [$OUD_ADMIN_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_ADMIN_USER $ANS $RSPFILE
      fi

      echo -n "Enter Password of OUD Admin User :"
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of OUD Admin User :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OUD_ADMIN_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Enter Kubernetes OUD POD Prefix [$OUD_POD_PREFIX]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_POD_PREFIX $ANS $RSPFILE
      fi

      echo -n "Enter Number of OUD Replicas required (In addition to Primary) [$OUD_REPLICAS]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_REPLICAS $ANS $RSPFILE
      fi
      
      echo -n "Create OUD Node Port Service (true/false) [$OUD_CREATE_NODEPORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_CREATE_NODEPORT $ANS $RSPFILE
      fi

      if [ "$OUD_CREATE_NODEPORT" = "true" ] || [ "$OUD_CREATE_NODEPORT" = "TRUE" ]
      then
          echo -n "Enter Kubernetes LDAP Service port  [$OUD_LDAP_K8]:"
          read ANS

          if ! [ "$ANS" = "" ]
          then
               replace_value OUD_LDAP_K8 $ANS $RSPFILE
          fi

          echo -n "Enter Kubernetes LDAPS Service port  [$OUD_LDAPS_K8]:"
          read ANS

          if ! [ "$ANS" = "" ]
          then
               replace_value OUD_LDAPS_K8 $ANS $RSPFILE
          fi
      fi

      OLD_SEARCHBASE=$OUD_SEARCHBASE
      echo -n "OUD Base DN [$OUD_SEARCHBASE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           global_replace_value $OLD_SEARCHBASE $ANS $RSPFILE
           OUD_REGION=`echo $ANS | cut -f1 -d, | cut -f2 -d=`
           replace_value OUD_REGION $OUD_REGION $RSPFILE
           OAM_COOKIE_DOMAIN=`echo $OUD_SEARCHBASE | sed 's/dc=/./g;s/,//g'`
           replace_value OAM_COOKIE_DOMAIN $OAM_COOKIE_DOMAIN $RSPFILE
      fi

      echo -n "Container to store systems IDS  [$OUD_SYSTEMIDS]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_SYSTEMIDS $ANS $RSPFILE
      fi

      echo -n "OAM Administrator User [$OUD_OAMADMIN_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_OAMADMIN_USER $ANS $RSPFILE
      fi

      echo -n "OAM LDAP Connection User [$OUD_OAMLDAP_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_OAMLDAP_USER $ANS $RSPFILE
      fi

      echo -n "OIG LDAP Connection User [$OUD_OIGLDAP_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_OIGLDAP_USER $ANS $RSPFILE
      fi

      echo -n "LDAP Weblogic Administration User [$OUD_WLSADMIN_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_WLSADMIN_USER $ANS $RSPFILE
      fi

      echo -n "LDAP OIG Administration User [$OUD_XELSYSADM_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_XELSYSADM_USER $ANS $RSPFILE
      fi

      echo -n "Enter Password of OUD Users :"
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of OUD Users :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OUD_USER_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "LDAP User Expiry Date (YYYY-MM-DD) [$OUD_PWD_EXPIRY]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_PWD_EXPIRY $ANS $RSPFILE
      fi

      echo -n "LDAP OAM Administration Group [$OUD_OAMADMIN_GRP]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_OAMADMIN_GRP $ANS $RSPFILE
      fi

      echo -n "LDAP OIG Administration Group [$OUD_OIGADMIN_GRP]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_OIGADMIN_GRP $ANS $RSPFILE
      fi

      echo -n "LDAP Weblogic Administration Group [$OUD_WLSADMIN_GRP]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUD_WLSADMIN_GRP $ANS $RSPFILE
      fi
fi


if [ "$INSTALL_OUDSM" = "true" ]
then
      echo
      echo "OUDSM Paramters"
      echo "---------------"
      echo
      echo -n "Enter OUDSM Share [$OUDSM_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUDSM_SHARE $ANS $RSPFILE
      fi
      echo -n "Enter OUDSM Admin User [$OUDSM_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OUDSM_USER $ANS $RSPFILE
      fi

      echo -n "Enter Password of OUDSM Admin User :"
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of OUDSM Admin User :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OUDSM_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi
fi

if [ "$INSTALL_OAM" = "true" ] || [ "$INSTALL_OIG" = "true" ]
then
      echo
      echo "WebLogic Operator Paramters"
      echo "---------------------------"
      echo

      echo -n "Enter Operator Namespace [$OPERNS]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OPERNS $ANS $RSPFILE
      fi

      echo -n "Enter Operator Service Account [$OPER_ACT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OPER_ACT $ANS $RSPFILE
      fi

fi

if [ "$INSTALL_OAM" = "true" ] 
then
      echo
      echo "Oracle Access Manager Paramters"
      echo "-------------------------------"
      echo

      echo -n "Enter OAM Namespace [$OAMNS]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAMNS $ANS $RSPFILE
      fi

      echo -n "Enter OAM Share [$OAM_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_SHARE $ANS $RSPFILE
      fi

      echo -n "Enter Number of OAM Servers to configure (More than you will ever need) [$OAM_SERVER_COUNT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_SERVER_COUNT $ANS $RSPFILE
      fi

      echo -n "Enter Number of OAM Servers to start (Number you normally use) [$OAM_SERVER_INITIAL]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_SERVER_INITIAL $ANS $RSPFILE
      fi

      echo ""

      echo -n "Enter Admin Server Port for OAM [$OAM_ADMIN_PORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_ADMIN_PORT $ANS $RSPFILE
      fi
       
      echo -n "Enter Kubernetes Service Port for Admin Server [$OAM_ADMIN_K8]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_ADMIN_K8 $ANS $RSPFILE
      fi
       
      echo -n "Enter Kubernetes Service Port for OAM Server [$OAM_OAM_K8]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_OAM_K8 $ANS $RSPFILE
      fi

      echo -n "Enter Kubernetes Service Port for OAM Policy Server [$OAM_POLICY_K8]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_POLICY_K8 $ANS $RSPFILE
      fi

      echo -n "Enter Database Scan Address (Use Hostname for non-RAC)  [$OAM_DB_SCAN]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_DB_SCAN $ANS $RSPFILE
      fi

      echo -n "Enter Database Listener Port[$OAM_DB_LISTENER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_DB_LISTENER $ANS $RSPFILE
      fi

      echo -n "Enter OAM Database Service Name[$OAM_DB_SERVICE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_DB_SERVICE $ANS $RSPFILE
      fi

      echo -n "Enter SYS Password :"
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of SYS Users :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OAM_DB_SYS_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Enter RCU Prefix [$OAM_RCU_PREFIX]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_RCU_PREFIX $ANS $RSPFILE
      fi

      echo -n "Enter Password for OAM Schemas: "
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of OAM Schemas :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OAM_SCHEMA_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Enter Weblogic Domain Name [$OAM_DOMAIN_NAME]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_DOMAIN_NAME $ANS $RSPFILE
      fi

      echo -n "Enter OAM Login Loadbalancer Host [$OAM_LOGIN_LBR_HOST]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_LOGIN_LBR_HOST $ANS $RSPFILE
      fi

      echo -n "Enter OAM Login Loadbalancer Port [$OAM_LOGIN_LBR_PORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_LOGIN_LBR_PORT $ANS $RSPFILE
      fi

      echo -n "Enter OAM Login Loadbalancer Protocol [$OAM_LOGIN_LBR_PROTOCOL]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_LOGIN_LBR_PROTOCOL $ANS $RSPFILE
      fi

      echo -n "Enter OAM Admin Loadbalancer Host [$OAM_ADMIN_LBR_HOST]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_ADMIN_LBR_HOST $ANS $RSPFILE
      fi

      echo -n "Enter OAM Admin Loadbalancer Port [$OAM_ADMIN_LBR_PORT]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_ADMIN_LBR_PORT $ANS $RSPFILE
      fi


      echo -n "Enter Weblogic Domain Administrator [$OAM_WEBLOGIC_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OAM_WEBLOGIC_USER $ANS $RSPFILE
      fi

      echo -n "Enter Password for $OAM_WEBLOGIC_USER account: "
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OAM_WEBLOGIC_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo OAM_COOKIE_DOMAIN=`echo $OUD_SEARCHBASE | sed 's/dc=/./g;s/,//g'`
      replace_value OAM_COOKIE_DOMAIN $OAM_COOKIE_DOMAIN $RSPFILE

fi
if [ "$INSTALL_OIG" = "true" ] 
then
      echo
      echo "Oracle Identity Governance Paramters"
      echo "------------------------------------"
      echo

      echo -n "Enter OIG Namespace [$OIGNS] :"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIGNS $ANS $RSPFILE
      fi

      echo -n "Enter OIG Share [$OIG_SHARE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_SHARE $ANS $RSPFILE
      fi

      echo -n "Enter Number of OIG Servers to configure (More than you will ever need) [$OIG_SERVER_COUNT] :"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_SERVER_COUNT $ANS $RSPFILE
      fi

      echo -n "Enter Number of OIG Servers to start (Number you normally use) [$OIG_SERVER_INITIAL]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_SERVER_INITIAL $ANS $RSPFILE
      fi

      echo ""

       
      echo -n "Enter Database Scan Address (Use Hostname for non-RAC)  [$OIG_DB_SCAN]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_DB_SCAN $ANS $RSPFILE
      fi

      echo -n "Enter Database Listener Port[$OIG_DB_LISTENER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_DB_LISTENER $ANS $RSPFILE
      fi

      echo -n "Enter OIG Database Service Name[$OIG_DB_SERVICE]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_DB_SERVICE $ANS $RSPFILE
      fi

      echo -n "Enter SYS Password :"
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of SYS Users :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OIG_DB_SYS_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Enter RCU Prefix [$OIG_RCU_PREFIX]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_RCU_PREFIX $ANS $RSPFILE
      fi

      echo -n "Enter Password for OIG Schemas "
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password of OIG Schemas :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OIG_SCHEMA_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Enter Weblogic Domain Name [$OIG_DOMAIN_NAME]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_DOMAIN_NAME $ANS $RSPFILE
      fi

      echo -n "Enter OIG Loadbalancer Host [$OIG_LBR_HOST]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_HOST $ANS $RSPFILE
      fi

      echo -n "Enter OIG Loadbalancer Port [$OIG_LBR_PORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_PORT $ANS $RSPFILE
      fi

      echo -n "Enter OIG Loadbalancer Protocol [$OIG_LBR_PROTOCOL]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_PROTOCOL $ANS $RSPFILE
      fi

      echo -n "Enter OIG Admin Loadbalancer Host [$OIG_ADMIN_LBR_HOST]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_ADMIN_LBR_HOST $ANS $RSPFILE
      fi

      echo -n "Enter OIG Admin Loadbalancer Port [$OIG_ADMIN_LBR_PORT]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_ADMIN_LBR_PORT $ANS $RSPFILE
      fi

      echo -n "Enter Admin Server Port for OIG [$OIG_ADMIN_PORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_ADMIN_PORT $ANS $RSPFILE
      fi
       
      echo -n "Enter OIG Internal Loadbalancer Host [$OIG_LBR_INT_HOST]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_INT_HOST $ANS $RSPFILE
      fi

      echo -n "Enter OIG Internal Loadbalancer Port [$OIG_LBR_INT_PORT]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_PORT $ANS $RSPFILE
      fi

      echo -n "Enter OIG Internal Loadbalancer Protocol [$OIG_LBR_INT_PROTOCOL]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_INT_PROTOCOL $ANS $RSPFILE
      fi

      echo -n "Enter Kubernetes Service Port for Admin Server [$OIG_ADMIN_K8]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_LBR_INT_PROTOCOL $ANS $RSPFILE
      fi

      echo -n "Enter Kubernetes Service Port for OIM Servers [$OIG_OIM_PORT_K8]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_OIM_PORT_K8 $ANS $RSPFILE
      fi

      echo -n "Enter Kubernetes Service Port for SOA Servers [$OIG_SOA_PORT_K8]:"
      read ANS
      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_SOA_PORT_K8 $ANS $RSPFILE
      fi

      echo -n "Enter Weblogic Domain Administrator [$OIG_WEBLOGIC_USER]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_WEBLOGIC_USER $ANS $RSPFILE
      fi

      echo -n "Enter Password for $OIG_WEBLOGIC_USER account: "
      read -s ANS

      if ! [ "$ANS" = "" ]
      then
           echo
           echo -n "Confirm Password :"
           read -s ACHECK
           if ! [ "$ANS" = "$ACHECK" ]
           then
              echo "Passwords do not match!"
              exit
           else
               echo
               replace_value OIG_WEBLOGIC_PWD $ANS $RSPFILE
           fi
      else
         echo "Leaving value as previously defined"
      fi

      echo -n "Integrate with BI Publisher (true/false) [$OIG_BI_INTEG]:"
      read ANS

      if ! [ "$ANS" = "" ]
      then
           replace_value OIG_BI_INTEG $ANS $RSPFILE
      fi
      
      OIG_BI_INTEG=$ANS

      if [ "$OIG_BI_INTEG" = "true" ]
      then
         echo -n "Enter BI Host can be a loadbalancer [$OIG_BI_HOST]:"
         read ANS

         if ! [ "$ANS" = "" ]
         then
              replace_value OIG_BI_HOST $ANS $RSPFILE
         fi

         echo -n "Enter BI Port can be a loadbalancer [$OIG_BI_PORT]:"
         read ANS

         if ! [ "$ANS" = "" ]
         then
              replace_value OIG_BI_PORT $ANS $RSPFILE
         fi

         echo -n "Enter BI Prototol can be a loadbalancer [$OIG_BI_PROTOCOL]:"
         read ANS

         if ! [ "$ANS" = "" ]
         then
              replace_value OIG_BI_PROTOCOL $ANS $RSPFILE
         fi

         echo -n "Enter BI Report User [$OIG_BI_USER]:"
         read ANS

         if ! [ "$ANS" = "" ]
         then
              replace_value OIG_BI_USER $ANS $RSPFILE
         fi

         echo -n "Enter Password for $OIG_BI_USER account "
         read -s ANS

         if ! [ "$ANS" = "" ]
         then
              echo
              echo -n "Confirm Password :"
              read -s ACHECK
              if ! [ "$ANS" = "$ACHECK" ]
              then
                 echo "Passwords do not match!"
                 exit
              else
                  echo
                  replace_value OIG_BI_USER_PWD $ANS $RSPFILE
              fi
         else
             echo "Leaving value as previously defined"
         fi
     fi

fi

echo
echo "Oracle HTTP Server Paramters"
echo "----------------------------"
echo

echo -n "Enter OHS1 Hostname [$OHS_HOST1]:"
read ANS

if ! [ "$ANS" = "" ]
then
    replace_value OHS_HOST1 $ANS $RSPFILE
fi


echo -n "Enter OHS2 Hostname [$OHS_HOST2]:"
read ANS

if ! [ "$ANS" = "" ]
then
    replace_value OHS_HOST2 $ANS $RSPFILE
fi

echo -n "Enter OHS Listen Port [$OHS_PORT]:"
read ANS

if ! [ "$ANS" = "" ]
then
    replace_value OHS_PORT $ANS $RSPFILE
fi


WORKER_NODES=`kubectl get nodes | grep -v NAME | grep Ready | head -2 | awk '{ print $1 }'`
K8_WORKER_HOST1=`echo $WORKER_NODES | cut -f1 -d' '`
K8_WORKER_HOST2=`echo $WORKER_NODES | cut -f2 -d' '`
if ! [[ $K8_WORKER_HOST1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] 
then
  echo "fail"
   DOMAIN=`domainname`
   K8_WORKER_HOST1=$K8_WORKER_HOST1.$DOMAIN
   K8_WORKER_HOST2=$K8_WORKER_HOST2.$DOMAIN
fi

replace_value K8_WORKER_HOST1 $K8_WORKER_HOST1 $RSPFILE
replace_value K8_WORKER_HOST2 $K8_WORKER_HOST2 $RSPFILE
replace_value OAM_OAP_HOST $K8_WORKER_HOST1 $RSPFILE
