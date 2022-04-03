# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./reverse-proxy.nix
  ];

  boot.kernel.sysctl = {
    # Enable automatic reboot after kernel panic after 60s
    "kernel.panic" = 60;

    # Ignore ICMP broadcasts / DoS protection
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Protect from SYN flood
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_max_syn_backlog" = 2048;
    "net.ipv4.tcp_synack_retries" = 3;

    # Enable forwarding
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.enp3s0f1.accept_ra" = 2;
    "net.ipv6.conf.enp3s0f1.autoconf" = 1;

    # Update kernel buffer to 64M
    "net.core.wmem_max" = 67108864;
    "net.core.rmem_max" = 67108864;

    # Set TCP buffer limit to 32M
    "net.ipv4.tcp_wmem" = "10240 87380 33554432";
    "net.ipv4.tcp_rmem" = "10240 87380 33554432";

    # Enable window scaling
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv6.tcp_window_scaling" = 1;

    # Enable timestamps
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv6.tcp_timestamps" = 1;

    # Enable select acknowledgements
    "net.ipv4.tcp_sack" = 1;

    # Set input backlog size
    "net.core.netdev_max_backlog" = 5000;

    # Set congestion control to htcp
    "net.ipv4.tcp_congestion_control" = "htcp";

    # Enable fair queueing
    "net.core.default_qdisc" = "fq";

    # Enable MTU probing for jumbo frames
    "net.ipv4.tcp_mtu_probing" = 1;
  };

  networking.hostName = "router"; 
  networking.wireless.enable = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = false;
  networking.interfaces.enp4s0f0.useDHCP = false;
  networking.interfaces.enp4s0f1.useDHCP = false;
  networking.interfaces.eno1.useDHCP = false;

  # WAN Connection
  networking.interfaces.enp3s0f1 = {
    useDHCP = true;
    mtu = 9000;
  };

  # LAN Connection
  networking.interfaces.enp3s0f0 = {
    mtu = 9000; # jumbo frames
    ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };

  networking.firewall.enable = false;
  networking.nat.enable = false;
  networking.nameservers = [ "10.0.0.1" ];
  networking.dhcpcd.persistent = true;

  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip filter {
      # enable flow offloading for better throughput
        flowtable f {
          hook ingress priority 0;
          devices = { enp3s0f0, enp3s0f1 };
        }

        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain input {
          type filter hook input priority filter; policy drop;

          # allow trusted networks to talk to the router
          iifname "enp3s0f0" counter accept

          # Allow returning traffic from wan and drop everything else
          iifname "enp3s0f1" ct state { established, related } counter accept

          iifname "enp3s0f1" tcp dport {ssh,http,https} accept

          iifname "enp3s0f1" drop
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # allow dnat traffic
          ct status dnat accept

          # enable flow offloading for better throughput
          ip protocol { tcp, udp } flow offload @f

          # allow trusted network wan access
          iifname "enp3s0f0" oifname "enp3s0f1" counter accept comment "allow trusted LAN to WAN"

          # allow established WAN to return
          iifname "enp3s0f1" oifname "enp3s0f0" ct state established,related counter accept comment "allow established back to LAN"
          iifname "enp3s0f1" oifname "wg0" ct state established,related counter accept comment "allow established wireguard back to LAN"
        }
      }
      table ip nat {

        chain nat-out {
          type nat hook output priority filter; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority filter; policy accept;
          #oifname "enp3s0f1" masquerade
          masquerade
        }
      }
    '';
  };
  systemd.services.nftablesRestart = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Restart nftables";
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sleep 30s && systemctl restart nftables.service";
    };
  };

  # set up DNS
  services.coredns = {
    enable = true;
    config = ''
      . {
        # Cloudflare
        forward . 1.1.1.1 1.0.0.1
        cache
      }

      sunrise.nheath.com {
        template IN A {
          answer "{{ .Name }} 0 IN A 10.0.0.1"
        }
      }

      hs.nheath.com {
        template IN A {
          answer "{{ .Name }} 0 IN A 10.0.0.1"
        }
      }

      nc.nheath.com {
        template IN A {
          answer "{{ .Name }} 0 IN A 10.0.0.1"
        }
      }

      brother-printer.local {
        template IN A {
          answer "{{ .Name }} 0 IN A 10.0.0.30"
        }
      }

      facebook.com reddit.com {
        template IN A {
          answer "{{ .Name }} 0 IN A 127.0.0.1"
        }
      }
    '';
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp3s0f0" ];
    extraConfig = ''
            option domain-name-servers 10.0.0.1;
            option subnet-mask 255.255.255.0;

            subnet 10.0.0.0 netmask 255.255.255.0 {
              option broadcast-address 10.0.0.255;
      	option routers 10.0.0.1;
      	interface enp3s0f0;
      	range 10.0.0.100 10.0.0.200;
            }
            host brother {
              hardware ethernet 30:05:5c:98:f0:a6;
              fixed-address 10.0.0.5;
            }
          '';
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.groups.ddclient = {};
  users.users.ddclient = {
    isSystemUser = true;
    group = "ddclient";
  };

  sops.secrets.ddclient-config.owner = config.users.users.ddclient.name;
  sops.secrets.ddclient-config.group = config.users.groups.ddclient.name;
  sops.secrets.ddclient-config.mode = "0400";

  services.ddclient = {
    enable = true;
    configFile = config.sops.secrets.ddclient-config.path;
  };

  systemd.services.ddclient.serviceConfig.User = pkgs.lib.mkForce config.users.users.ddclient.name;
  systemd.services.ddclient.serviceConfig.Group = pkgs.lib.mkForce config.users.groups.ddclient.name;

  # Disable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable headscale
  environment.systemPackages = with pkgs; [
    headscale
  ];
  services.headscale = {
    enable = true;
    serverUrl = "https://hs.nheath.com";
    dns.baseDomain = "hs.nheath.com";
    settings = {
      grpc_listen_addr = "127.0.0.1:50443";
      grpc_allow_insecure = true;
      ip_prefixes = [
        "10.100.0.0/16"
      ];
    };
  };

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
