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

{ inputs, vars, stable, unstable, ... }:
let
  # terminal = stable.${vars.terminal};
in
{
  imports = (
      import ../modules/desktops
  #     import ../modules/editors ++
  #     import ../modules/hardware ++
  #     import ../modules/programs ++
  #     import ../modules/services ++
  #     import ../modules/shell ++
  #     import ../modules/theming
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
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" ];
    shell = unstable.fish;
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
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
    systemPackages = with stable; [
      git
    ];
  };

  home-manager.users.${vars.user} = {
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "mml00";
        userEmail = "mml00.work@gmail.com";
      };
    };
    home = {
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.11";
      username = "user";
      homeDirectory = "/home/user";
      sessionVariables = {
        EDITOR = "nvim";
      };
      shellAliases = {
        d = "docker";
        dps = "d ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}'";
        dr = "d run --rm -v (pwd):/app -w /app -u (id -u):(id -g)";
        dc = "d compose";
        dcu = "dc up --build -d --force-recreate";
        dcd = "dc down";
        dce = "dc exec";
        dcr = "dc run --build --rm";
        dcrs = "dcr --service-ports --use-aliases";
        dcl = "dc logs -f --no-log-prefix -n 50";
        dcps = ''dc ps --format json | jq --slurp '(["Id", "Service", "Ports", "Image", "Status", "Uptime"] | (., map(length*"-"))), (.[] | [.ID[0:5], .Service, .Ports, .Image, .Status, .RunningFor ]) | @tsv' | sed "s/\\\\\\t/;/g" | sed "s/\"//g" | column -ts ";"'';

        k = "kubecolor";
        kl = "k logs --tail 50 -f";
        kgp = "k get po";
        kgn = "k get no";
        ksns = "k config set-context --current --namespace";
      };
      packages =  with unstable; [
        # applications
        # obsidian
        # warp-terminal
        # zed-editor
        # mkcert

        # fonts
        (nerdfonts.override { fonts = [ "FiraCode" ]; })

        # cli utils
        freshfetch
        ripgrep
        killall
        grc
        jq

        # docker
        docker-compose

        # kubernetes
        kubernetes-helm
        kubecolor
        kubectl
      ] ++ [
        inputs.telegram-desktop.legacyPackages.x86_64-linux.telegram-desktop
      ];
      # pointerCursor =
      #   let
      #   getFrom = url: hash: name: {
      #     gtk.enable = true;
      #     x11.enable = true;
      #     name = name;
      #     size = 24;
      #     package =
      #       pkgs.runCommand "moveUp" {} ''
      #       mkdir -p $out/share/icons
      #       ln -s ${pkgs.fetchzip {
      #         url = url;
      #         hash = hash;
      #       }} $out/share/icons/${name}
      #     '';
      #   };
      # in
      #   getFrom
      #   "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.0/BreezeX-Dark.tar.gz"
      #   "9e4c5d02a2981568725d91a7d6b67440f0d327f92a3cc641bf103bfa0961853b"
      #   "BreezeX-Dark";

    };
    # Nicely reload system units when changing configs
    # systemd.user.startServices = "sd-switch";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
