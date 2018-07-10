    #!/bin/bash

    DEBUG=true
    if [[ $DEBUG ]]; then
        DEBUG_PATH=($PWD)
        echo DEBUG MODE: $DEBUG
        echo "DEBUG PATH: $DEBUG_PATH"
    fi


    if [[ $# -ne 2 ]];
    then
    echo "Usage: ./machine_fstab <full_path_to_directory> <list_of_machines.txt>"
    exit 1
    fi


    function fstab_append {

        #titan:/home       /mnt-homes/titan     nfs     defaults        0       2
        local search="/mnt-homes/$1"
        #if ! grep -q $search "$DEBUG_PATH/fstab";
        if ! grep -q $search /etc/fstab;
        then
            local append="$1:/home  /mnt-homes/$1   nfs defaults    0   2"
            if  $DEBUG; then
                echo $append >> $DEBUG_PATH/fstab
            else
                echo $append >> /etc/fstab
            fi
            echo "Mount added to fstab: "
            echo "\t $append"
        else
            echo "Mount already exists for $1"
        fi
    }

    function create_directory {
        if [[ -d $1 ]]; then
            echo "Directory already exist: $1"
        else
            echo "Directory $1 created"
            mkdir $1
        fi
    }

    function mount_directory {
        local directory="$1/$2"
        fstab_append $2
        create_directory $directory
        if $DEBUG; then
            echo "mount $directory"
        else
            mount $directory
        fi
    }
    MACHINES=`cat $2 | paste -sd " " -`

    # Create base path directory
    base_directory=$1
    create_directory $base_directory

    echo "\n"
    # Check machines exported directories on fstab
    for maquina in $MACHINES
    do
        echo "Mounting $1"
        mount_directory $base_directory $maquina
        echo "\n"
    done
