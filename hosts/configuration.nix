#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./desktops
#       │   └─ default.nix
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./hardware
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       ├─ ./shell
#       │   └─ default.nix
#       └─ ./theming
#           └─ default.nix
#

{ vars, pkgs-stable, ... }:
{
  imports = (
      import ../modules/desktops
  #     ++ import ../modules/editors
  #     ++ import ../modules/hardware
  #     ++ import ../modules/programs
  #     ++ import ../modules/services
  #     ++ import ../modules/shell
  #     ++ import ../modules/theming
      );

  boot = {
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    # kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "docker" ];
    shell = pkgs-stable.fish;
  };

  time.timeZone = "Europe/Minsk";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    opengl.enable = true;
  };
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    # polkit.enable = true;
    # sudo.wheelNeedsPassword = false;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    # tmp for obsidian
    permittedInsecurePackages = [ ];
  };
  fonts.fontconfig.enable = true;

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      # EDITOR = "${vars.editor}";
      # VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs-stable; [
      home-manager
      htop
      git
      jq
    ];
  };
  virtualisation.docker.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
