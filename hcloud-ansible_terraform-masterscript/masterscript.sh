#!/bin/bash
# Script Name:  masterscript.sh
# Beschreibung: Führt Ansible und Terraform Script aus
# Aufruf:       masterscript.sh Anzahl-Server Aktion  
#               Die Anzahl an Cloudservern
#               Wähle Aktion zwischen install und del
#               
# Autor:        Marc
# Version:      1
# Datum:        16.02.2022

if [ $# -ne 2 ]
then
    echo "die Anzahl Parameter stimmt nicht"
    echo "Bitte Anzahl Cloud-Server eingeben"
    exit 1
fi
if [ $2 = "install" ]
then
cd ../hcloud-terraform
terraform apply -auto-approve -var="advancedautomation_server_count=$1"
echo "h-cloud installation succesfully"
echo "that was exhausting i am tired i'm going to sleep for 1 min"
sleep 1m 


cd ../hcloud-ansible
ansible-playbook  automate_apache_git_acmesh.yml -i ../hcloud-terraform/terraform-hosts
echo "everything done!"
echo "Good Bye"
fi

if [ $2 = "del" ]
then
cd ../hcloud-terraform
terraform destroy -auto-approve
fi
