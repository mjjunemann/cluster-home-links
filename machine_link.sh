#!/bin/bash

# Usage
if [[ $# -ne 2 ]];
then
  echo "Usage: ./machine_link <machines.txt> <folder_name>"
  exit 1
fi

HOST=$(hostname)

# Folder where all the user's home will be linked
FOLDER_NAME=$2


# Read the array of that exported machines and will be linked in this machine
MAQUINAS=`cat $1 | paste -sd " " -`

sudo mkdir $FOLDER_NAME

#Link self-machine

#sudo ln -s /home/* $FOLDER_NAME


#Link other machines
#for maquina in $MAQUINAS
#do
#	echo "$HOST $maquina"
#	if [[ $maquina != $HOST ]];
#	then
#		MACHINE_MOUNTED_FOLDER="/mnt-homes/$maquina/*"
#		echo $MACHINE_MOUNTED_FOLDER
#		sudo ln -s $MACHINE_MOUNTED_FOLDER $FOLDER_NAME
#	fi
#done


function link_machines {
	local maquinas=$1
	
}