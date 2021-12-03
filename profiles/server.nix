{ config, pkgs, ... }: {

  # Set up network stuff
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

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    btrfs-progs
    firefox
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    ffmpeg-full
    cudatoolkit
  ];

  # Enable SSH
  services.openssh.enable = true;

  # Enable watchdog
  services.das_watchdog.enable = true;

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}

