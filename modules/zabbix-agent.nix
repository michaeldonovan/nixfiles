{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 10050 ];
  };
  services.zabbixAgent = {
    enable = true;
    server = "zabbix.localdomain";
    settings = {
      Hostname = "${config.networking.hostName}";
      ServerActive = "zabbix.localdomain";


      UserParameter = [
        # ZFS discovery and configuration
        # original template from pbergbolt (source = https://www.zabbix.com/forum/showthread.php?t=43347), modified by Slash <slash@aceslash.net>

        # pool discovery
        "zfs.pool.discovery,/run/current-system/sw/bin/zpool list -H -o name | /run/current-system/sw/bin/sed -e '$ ! s/\\(.*\\)/{\"{#POOLNAME}\":\"\\1\"},/' | /run/current-system/sw/bin/sed -e '$  s/\\(.*\\)/{\"{#POOLNAME}\":\"\\1\"}]}/' | /run/current-system/sw/bin/sed -e '1  s/\\(.*\\)/{ \\\"data\\\":[\\1/'"
        # dataset discovery, called "fileset" in the zabbix template for legacy reasons
        "zfs.fileset.discovery,/run/current-system/sw/bin/zfs list -H -o name | /run/current-system/sw/bin/sed -e '$ ! s/\\(.*\\)/{\"{#FILESETNAME}\":\"\\1\"},/' | /run/current-system/sw/bin/sed -e '$  s/\\(.*\\)/{\"{#FILESETNAME}\":\"\\1\"}]}/' | /run/current-system/sw/bin/sed -e '1  s/\\(.*\\)/{ \\\"data\\\":[\\1/'"
        # vdev discovery
        "zfs.vdev.discovery,/run/current-system/sw/bin/zpool list -Hv | grep '^[[:blank:]]' | egrep -v 'mirror|raidz' | /run/current-system/sw/bin/awk '{print $1}' | /run/current-system/sw/bin/sed -e '$ ! s/\\(.*\\)/{\"{#VDEV}\":\"\\1\"},/' | /run/current-system/sw/bin/sed -e '$  s/\\(.*\\)/{\"{#VDEV}\":\"\\1\"}]}/' | /run/current-system/sw/bin/sed -e '1  s/\\(.*\\)/{ \\\"data\\\":[\\1/'"


        # pool health
        "zfs.zpool.health[*],/run/current-system/sw/bin/zpool list -H -o health $1"

        # get any fs option
        "zfs.get.fsinfo[*],/run/current-system/sw/bin/zfs get -o value -Hp $2 $1"

        # compressratio need special treatment because of the "x" at the end of the number
        "zfs.get.compressratio[*],/run/current-system/sw/bin/zfs get -o value -Hp compressratio $1 | /run/current-system/sw/bin/sed \"s/x//\""

        # memory used by ZFS: sum of the SPL slab allocator's statistics
        # "There are a few things not included in that, like the page cache used by mmap(). But you can expect it to be relatively accurate."
        "zfs.memory.used,echo $(( `cat /proc/spl/kmem/slab | tail -n +3 | /run/current-system/sw/bin/awk '{ print $3 }' | tr \"\\n\" \"+\" | /run/current-system/sw/bin/sed \"s/$/0/\"` ))"

        # get any global zfs parameters
        "zfs.get.param[*],cat /sys/module/zfs/parameters/$1"

        # ARC stats from /proc/spl/kstat/zfs/arcstats
        "zfs.arcstats[*],/run/current-system/sw/bin/awk '/^$1/ {printf $$3;}' /proc/spl/kstat/zfs/arcstats"

        # detect if a scrub is in progress, 0 = in progress, 1 = not in progress
        "zfs.zpool.scrub[*],/run/current-system/sw/bin/zpool status $1 | grep \"scrub in progress\" > /dev/null ; echo $?"

        # vdev state
        "zfs.vdev.state[*],/run/current-system/sw/bin/zpool status | grep \"$1\" | /run/current-system/sw/bin/awk '{ print $$2 }'"
        # vdev READ error counter
        "zfs.vdev.error_counter.read[*],/run/current-system/sw/bin/zpool status | grep \"$1\" | /run/current-system/sw/bin/awk '{ print $$3 }' | numfmt --from=si"
        # vdev WRITE error counter
        "zfs.vdev.error_counter.write[*],/run/current-system/sw/bin/zpool status | grep \"$1\" | /run/current-system/sw/bin/awk '{ print $$4 }' | numfmt --from=si"
        # vdev CHECKSUM error counter
        "zfs.vdev.error_counter.cksum[*],/run/current-system/sw/bin/zpool status | grep \"$1\" | /run/current-system/sw/bin/awk '{ print $$5 }' | numfmt --from=si"
      ];
    };
  };
}
