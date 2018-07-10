#!/usr/bin/python3
import argparse
import getpass
import os
import socket
import sys
import re

import paramgmt

""" 
    if {HOME_MACHINE} ==  ?HOST:
        ln -s /home/{USER} {DEST}/{USER}
    else:
        ln -s {MOUNT_STORAGE}/?HOST/{USER} {DEST}/{USER}
    translate to bash
"""

SCRIPT = """
if [[ "{home_machine}" == "?HOST" ]];
then
    echo "{password}" | sudo -S ln -s /home/{user} {dest}/{user}
else
    echo "{password}" | sudo -S ln -s {mount_storage}/{home_machine}/{user} {dest}/
fi
"""
def parse_stream(stream):
    hosts = {}
    hosts['all'] = set()

    _group = None
    for line in stream: 
        idx = line.find("#")
        line = line[:idx] if idx >= 0 else line.strip()
        if not line:
            continue
        host_group = re.search('\[([\w-]+)\]', line)
        if host_group:
            _group = host_group.group(1)
            continue
        if not hosts.get(_group) and _group: 
            hosts[_group] = [line]
        elif _group:
            hosts[_group].append(line)
        hosts['all'].add(line)
    hosts['all'] = list(hosts['all'])
    return hosts

def create_link_script(user, destination_folder, mount_homes, home_machine, password):
    script_name = "tmp_link_script.sh"
    _script = SCRIPT.format(
        user=user,
        dest=destination_folder,
        mount_storage=mount_homes,
        home_machine=home_machine,
        password=password
    )
    with open(script_name, "w") as fd:
        fd.write(_script)
    return script_name


def main(args, passwd):
    hosts = []
    groups = {}
    if args.hostfile is not None:
        groups.update(parse_stream(args.hostfile))
        args.hostfile.close()
    if not groups and args.group in groups :
        print("no hosts specified")
        return 0

    hosts.extend(groups[args.group])
    parallel = not args.sequential
    color = not args.no_color
    pmgmt = paramgmt.Controller(
        hosts=hosts,
        user=paramgmt.USER_DEFAULT,
        parallel=parallel,
        quiet=False,
        color=color,
        attempts=args.attempts,
    )

    scripts = []
    script_name = create_link_script(
        args.user, args.destination, args.storage, args.origin, passwd
    )
    scripts.append(script_name)
    ret = pmgmt.remote_script(scripts)
    os.remove(script_name)
    return 0 if paramgmt.all_success(ret) else -1


def check_attempts(value):
    ivalue = int(value)
    if ivalue < 1:
        msg = "attempts must be greater than 0"
        raise argparse.ArgumentTypeError(msg)
    return ivalue


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="link",
        description="remote link",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("-u", "--user", required=True, help="Username for SSH commands")
    parser.add_argument(
        "-f",
        "--hostfile",
        type=argparse.FileType("r"),
        help="A file containing hostnames",
    )
    parser.add_argument(
        "-g", "--group", default="all", help="Group of machines to link home folder "
    )
    parser.add_argument("-o", "--origin", required=True, help="Origin home folder ")
    parser.add_argument(
        "-d", "--destination", default="/allusers", help="Destination to link folder "
    )
    parser.add_argument(
        "-s", "--storage", default="/mnt-homes", help="Where the homes are mounted"
    )
    parser.add_argument(
        "--sequential", action="store_true", help="Run commands sequentially"
    )
    parser.add_argument(
        "-c", "--no_color", action="store_true", help="Disable coloring of output"
    )
    parser.add_argument(
        "-a",
        "--attempts",
        type=check_attempts,
        default=paramgmt.ATTEMPTS_DEFAULT,
        help="Maximum number of SSH attempts",
    )
    passwd = getpass.getpass()
    print(parser.parse_args())
    sys.exit(main(parser.parse_args(), passwd))
