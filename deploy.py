#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import platform
import argparse
import subprocess
import json
from multiprocessing import cpu_count
from typing import List
from termcolor import colored
from tabulate import tabulate
from paramiko import SSHConfig


def format_result(result):
    if result:
        return colored('OK', 'green', attrs=['bold'])
    else:
        return colored('ERR', 'red', attrs=['bold'])


def list_hosts_in_flake(flake: str) -> List[str]:
    """Get a list of hosts with nixosConfigurations provided by a given flake

    Args:
        flake (str): Path to a nix flake

    Returns:
        List[str]: List of hosts in flake
    """
    flake_output = subprocess.check_output(
        ['nix', 'flake', 'show', flake, '--json'], stderr=subprocess.DEVNULL)
    flake_json = json.loads(flake_output)
    hosts = [host for host in flake_json['nixosConfigurations']]
    return hosts


def ping(hostname: str) -> bool:
    """Attempts to ping a given host

    Args:
        hostname (str): Hostname of the host to ping

    Returns:
        bool: True if host was able to be pinged, False otherwise
    """
    return os.system(f"ping -c 1 {hostname} >/dev/null 2>&1") == 0


def get_ssh_config() -> SSHConfig:
    """Builds an SSHConfig object based on the contents of ~/.ssh/config

    Returns:
        SSHConfig: 
    """
    ssh_config = SSHConfig()
    ssh_config_path = os.path.join(os.path.expanduser('~'), '.ssh', 'config')
    ssh_config.parse(open(ssh_config_path))
    return ssh_config


def get_hostname(ssh_config: SSHConfig, host: str) -> str:
    """Attempts to get the hostname of a given host from an ssh config

    Args:
        ssh_config (SSHConfig): The ssh config object
        host (str): The name of the host as listed in the ssh config

    Returns:
        str: The hostname or None
    """
    if host == platform.node():
        return 'localhost'

    host_config = ssh_config.lookup(host)
    if host_config:
        return host_config['hostname']
    else:
        return None


def deploy_host(flake: str, host: str, hostname: str) -> bool:
    """Builds and deploys the configuration for a given host

    Args:
        flake (str): Path to a nix flake to build
        host (str): Name of the host as listed in the flake
        hostname (str): Hostname or IP address of the host

    Returns:
        bool: 
    """
    command = f'sudo nixos-rebuild switch \
                -j {cpu_count()} \
                --flake {flake}#{host} \
                --target-host {hostname} \
                --build-host localhost'
    return os.system(command) == 0


def deploy(hosts: str, flake: str):
    """Runs nixos-rebuild on a given and deploys configuration to hosts

    Args:
        hosts (str): List of hosts to be deployed. Hosts must be listed in flake
        flake (str): Path to the nix flake to build
    """
    flake = os.path.abspath(flake)
    if not hosts:
        hosts = list_hosts_in_flake(flake)

    ssh_config = get_ssh_config()

    results = {}
    for host in hosts:
        hostname = get_hostname(ssh_config, host)
        print(
            colored(
                f'\n------ Building for {host} ({hostname}) ------\n',
                attrs=['reverse']))

        if ping(hostname):
            results[host] = deploy_host(flake, host, hostname)
        else:
            print(colored('error:', 'red', attrs=['bold']) + ' host at \'' + colored(
                f'{hostname}', 'magenta', attrs=['bold']) + '\' is unreachable ')
            results[host] = False

        print()

    print(tabulate([[host, format_result(result)]
          for host, result in results.items()]))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Builds and deploys NixOS configuration in a Nix flake')
    parser.add_argument(
        'hosts', nargs='*', help='hosts to deploy. If none are provided all hosts in flake will be deployed')
    parser.add_argument("--flake", default='.',
                        help='path to flake. Will default to current directory if not provided')
    args = parser.parse_args()
    try:
        deploy(hosts=args.hosts, flake=args.flake)
    except Exception as err:
        print(err)
