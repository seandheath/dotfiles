# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    "net.ipv6.conf.eno1.accept_ra" = 2;
    "net.ipv6.conf.eno1.autoconf" = 1;

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
  networking.interfaces.enp3s0f1.useDHCP = false;
  networking.interfaces.enp4s0f0.useDHCP = false;
  networking.interfaces.enp4s0f1.useDHCP = false;
  networking.interfaces.eno1 = {
    useDHCP = true;
    mtu = 9000;
  };
  networking.firewall.enable = false;
  networking.nat.enable = false;
  networking.nameservers = [ "10.0.0.1" ];
  networking.interfaces.enp3s0f0 = {
    mtu = 9000; # jumbo frames
    ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };
  networking.dhcpcd.persistent = true;

  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip filter {
      # enable flow offloading for better throughput
        flowtable f {
          hook ingress priority 0;
          devices = { eno1, enp3s0f0 };
        }

        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain input {
          type filter hook input priority filter; policy drop;

          # allow trusted networks to talk to the router
          iifname "enp3s0f0" counter accept

          # Allow returning traffic from wan and drop everything else
          iifname "eno1" ct state { established, related } counter accept
          iifname "eno1" drop
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # allow dnat traffic
          ct status dnat accept

          # enable flow offloading for better throughput
          ip protocol { tcp, udp } flow offload @f

          # allow trusted network wan access
          iifname "enp3s0f0" oifname "eno1" counter accept comment "allow trusted LAN to WAN"

          # allow established WAN to return
          iifname "eno1" oifname "enp3s0f0" ct state established,related counter accept comment "allow established back to LAN"
        }
      }
      table ip nat {

        chain prerouting {
          type nat hook prerouting priority -100;
          iif "eno1" tcp dport 80 log prefix "nc " dnat 10.0.0.2:80
          iif "eno1" tcp dport 443 log prefix "nc " dnat 10.0.0.2:443
        }

        chain nat-out {
          type nat hook output priority filter; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority filter; policy accept;
          #oifname "eno1" masquerade
          masquerade
        }
      }
    '';
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
          answer "{{ .Name }} 0 IN A 10.0.0.2"
        }
      }

      brother.local {
        template IN A {
          answer "{{ .Name }} 0 IN A 10.0.0.5"
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

  services.openssh.enable = true;

  # Disable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}

