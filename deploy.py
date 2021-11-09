#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import platform
import argparse
import subprocess
import json
from termcolor import colored
from tabulate import tabulate
from paramiko import SSHConfig


def get_hostname(ssh_config, host):
    if host == platform.node():
        return 'localhost'

    host_config = ssh_config.lookup(host)
    if host_config:
        return host_config['hostname']
    else:
        return None


def format_result(result):
    if result:
        return colored('OK', 'green')
    else:
        return colored('ERR', 'red')


def list_hosts_in_flake(flake):
    flake_json = json.loads(subprocess.check_output(
        ['nix', 'flake', 'show', flake, '--json']))
    hosts = [host for host in flake_json['nixosConfigurations']]
    return hosts


def ping(hostname):
    return os.system(f"ping -c 1 {hostname} >/dev/null 2>&1") == 0


def deploy(hosts, flake):
    flake = os.path.abspath(flake)
    if not hosts:
        hosts = list_hosts_in_flake(flake)

    ssh_config = SSHConfig()
    ssh_config_path = os.path.join(os.path.expanduser('~'), '.ssh', 'config')
    ssh_config.parse(open(ssh_config_path))

    results = {}
    for host in hosts:
        hostname = get_hostname(ssh_config, host)
        print(
            colored(
                f'------ Building for {host} ({hostname}) ------\n',
                attrs=['reverse']))
        if ping(hostname):
            results[host] = os.system(
                f'sudo nixos-rebuild switch -j $(nproc) --flake {flake}#{host} --target-host {hostname} --build-host localhost') == 0
        else:
            print(colored('error:','red') +
                  ' host at \'' +
                  colored(f'{hostname}', 'magenta') +
                  '\' is unreachable ')
            results[host] = False
        print()

    print(tabulate([[host, format_result(result)]
          for host, result in results.items()]))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('hosts', nargs='*', help='hosts to deploy')
    parser.add_argument("--flake", default='.', help='path to flake')
    args = parser.parse_args()
    try:
        deploy(hosts=args.hosts, flake=args.flake)
    except Exception as err:
        print(err)
