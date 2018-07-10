# README 

Estos scripts tienen como funcionalidad exportar los homes de las maquinas elegidas, montar en un siguiente grupo de maquinas elegidas y por ultimo linkear estos mount a una carpeta elegida para poder acceder a ellos de una forma transparente para el usuario.


## Exportar, montar y link simbolico. 

```bash
./run.sh <path_to_mount> <export_hosts.txt> <link_hosts.txt> <all_homes_path>" 

```

## Explicación de los parametros

* **path_to_mount**: Directorio donde se van a montar los homes exportados
* **export_hosts**: lista de hosts que van a exportar su home
* **link_hosts**: lista de hosts que van a montar y linkear estos homes *(esto se encuentra desabilitado por un segundo script)*
* **all_homes_path**: directorio donde se va a realizar toda la operación.


## Linkear usuarios especiales

```
./link.py -u <user> -f <host.txt> -o <host_home> -d <path_to_link>


./link.py --help
Password:
usage: unlink [-h] -u USER [-f HOSTFILE] [-g GROUP] [-d DESTINATION]
            [--sequential] [-c] [-a ATTEMPTS]
remote link

optional arguments:
  -h, --help            show this help message and exit
  -u USER, --user USER  Username for SSH commands (default: None)
  -f HOSTFILE, --hostfile HOSTFILE
                        A file containing hostnames (default: None)
  -g GROUP, --group GROUP
                        Group of machines to link home folder (default: all)
  -o ORIGIN, --origin ORIGIN
                        Origin home folder (default: None)
  -d DESTINATION, --destination DESTINATION
                        Destination to link folder (default: /allusers)
  -s STORAGE, --storage STORAGE
                        Where the homes are mounted (default: /mnt-homes)
  --sequential          Run commands sequentially (default: False)
  -c, --no_color        Disable coloring of output (default: False)
  -a ATTEMPTS, --attempts ATTEMPTS
                        Maximum number of SSH attempts (default: 3)
```

## Unlink user

```
./unlink.py -u <user> -d <directory> -f <hosts>


./unlink.py --help
Password:
usage: unlink [-h] -u USER [-f HOSTFILE] [-g GROUP] [-d DESTINATION]
            [--sequential] [-c] [-a ATTEMPTS]

remote link

optional arguments:
  -h, --help            show this help message and exit
  -u USER, --user USER  Username for SSH commands (default: None)
  -f HOSTFILE, --hostfile HOSTFILE
                        A file containing hostnames (default: None)
  -g GROUP, --group GROUP
                        Group of machines to link home folder (default: all)
  -d DESTINATION, --destination DESTINATION
                        Destination to link folder (default: /allusers)
  --sequential          Run commands sequentially (default: False)
  -c, --no_color        Disable coloring of output (default: False)
  -a ATTEMPTS, --attempts ATTEMPTS
                        Maximum number of SSH attempts (default: 3)
```

