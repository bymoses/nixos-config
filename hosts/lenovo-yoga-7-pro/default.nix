#
#  Specific system configuration settings for xps
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./xps
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ docker.nix
#

{ host, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  programs = {
    fish.enable = true;
  };

  gnome.enable = true;
  # hyprland.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  networking = {
    hostName = host.hostName;
    # Enable networking
    networkmanager.enable = true;
    extraHosts = ''
      # 127.0.0.1 residual-dev-v1-app.proxy.bymoses.pro
      # 127.0.0.1 residual-dev-v1-graphql.proxy.bymoses.pro
      # 127.0.0.1 residual-dev-v1-minio.proxy.bymoses.pro
      # 127.0.0.1 residual-dev-v1-hasura.proxy.bymoses.pro
      # 127.0.0.1 residual-dev-v1-migrations.proxy.bymoses.pro
    '';
  };
}
