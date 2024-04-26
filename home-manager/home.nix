# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = lib.concatMap import [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./programs
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # tmp for obsidian
      permittedInsecurePackages = [
        "nix-2.16.2"
      ];
    };
  };
  fonts.fontconfig.enable = true;

  # TODO: Set your username
  home = {
    username = "user";
    homeDirectory = "/home/user";
    sessionVariables = {
      EDITOR = "vim";
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
    packages =  with pkgs; [
      # applications
      telegram-desktop
      # obsidian
      # warp-terminal
      # zed-editor

      # fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

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
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
