#!/bin/bash

# Parameters 

if [[ $# -ne 3 ]];
then
  echo "Usage: ./run.sh <path_to_mount> <export_hosts.txt> <link_hosts.txt> <all_homes_path>" 
  exit 1
fi

MOUNT_PATH=$1
EXPORT_HOST_FILE=$2
LINKED_HOST_FILE=$3
ALL_HOMES_PATH=$4

read -r -p "Press any key to begin" -n 1
# Prompt password
read -s -p "Enter Password: " PASSWORD

echo "\n"
# Push necesary files to hosts
rpush -f $LINKED_HOST_FILE -d /tmp -- $LINKED_HOST_FILE 
rpush -f $LINKED_HOST_FILE -d /tmp -- $EXPORT_HOST_FILE

# Export home in all hosts /etc/exportfs
rpush -f $EXPORT_HOST_FILE -d /tmp -- machine_export.sh
rcmd -f $EXPORT_HOST_FILE -- "echo $PASSWORD | sudo -S /tmp/machine_export.sh"
#rscript -f maquinas.txt -- machine_export.sh
read -r -p "Press any key to continue" -n 1

# Append and mount /etc/fstab
rpush -f $LINKED_HOST_FILE -d /tmp -- machine_fstab.sh
rcmd -f $LINKED_HOST_FILE -- "echo $PASSWORD | sudo -S /tmp/machine_fstab.sh $MOUNT_PATH /tmp/$EXPORT_HOST_FILE"

read -r -p "Press any key to continue" -n 1

# Link all mounted
rpush -f $LINKED_HOST_FILE -d /tmp -- machine_link.sh
rcmd -f $LINKED_HOST_FILE -- "echo $PASSWORD | sudo -S /tmp/machine_link.sh $EXPORT_HOST_FILE $ALL_HOMES_PATH"

#read -r -p "Press any key to continue" -n 1

# Clean up
read -r -p "Press any key to continue" -n 1
rcmd -f $HOST_FILE -- rm /tmp/$HOST_FILE
rcmd -f $EXPORT_HOST_FILE -- rm /tmp/$EXPORT_HOST_FILE