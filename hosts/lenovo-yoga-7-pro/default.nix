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

{ host, unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
      # ../../modules/desktops/virtualisation/docker.nix
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
        device = "nodev"; # or "nodev" for efi only
          efiSupport = true;
      };
    };
  };

  programs = {
    fish = {
      enable = true;
      promptInit = ''
        ${unstable.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
    };
  };

  gnome.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  networking = {
    hostName = host.hostName;
    # Enable networking
    networkmanager.enable = true;
    extraHosts = ''
      176.222.53.54 traefik.residual.internal
      176.222.53.54 minio-console.residual.internal
      176.222.53.54 hasura-console.residual.internal

      127.0.0.1 residual-dev-v1.app.proxy.bymoses.pro
      127.0.0.1 residual-dev-v1.graphql.proxy.bymoses.pro
      127.0.0.1 residual-dev-v1.minio.proxy.bymoses.pro
      127.0.0.1 residual-dev-v1.hasura.proxy.bymoses.pro
      127.0.0.1 residual-dev-v1.migrations.proxy.bymoses.pro
    '';
  };
}
