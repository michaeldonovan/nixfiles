{ ... }:
let
  influxdbUrl = "http://influxdb.localdomain:8181";
  influxdbOrganization = "default";
  influxdbBucket = "telegraf";
  tokenEnvFile = "/secrets/telegraf.env";
in
{
  services.telegraf = {
    enable = true;
    # Expected format: INFLUX_TOKEN=...
    environmentFiles = [ tokenEnvFile ];
    extraConfig = {
      agent = {
        interval = "10s";
        round_interval = true;
        metric_batch_size = 1000;
        metric_buffer_limit = 10000;
        collection_jitter = "2s";
        flush_interval = "10s";
        flush_jitter = "2s";
      };

      inputs = {
        cpu = {
          percpu = true;
          totalcpu = true;
          collect_cpu_time = false;
          report_active = true;
        };
        disk = {
          ignore_fs = [
            "autofs"
            "binfmt_misc"
            "bpf"
            "configfs"
            "debugfs"
            "devtmpfs"
            "devfs"
            "fusectl"
            "hugetlbfs"
            "iso9660"
            "mqueue"
            "nsfs"
            "overlay"
            "proc"
            "pstore"
            "rpc_pipefs"
            "securityfs"
            "squashfs"
            "sysfs"
            "tmpfs"
            "tracefs"
          ];
        };
        diskio = { };
        internal = {
          collect_memstats = false;
        };
        kernel = { };
        mem = { };
        net = { };
        processes = { };
        swap = { };
        system = { };
      };

      outputs.influxdb_v2 = {
        urls = [ influxdbUrl ];
        token = "$INFLUX_TOKEN";
        organization = influxdbOrganization;
        bucket = influxdbBucket;
      };
    };
  };
}
