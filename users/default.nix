{
  inputs,
  vars,
  pkgs-stable,
  pkgs-unstable,
  home-manager,
  ...
}:
let
  pkgs-telegram = import inputs.telegram-desktop {
    inherit (vars) system;
    config.allowUnfree = true;
  };
in
{
  user = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgs-unstable;
    extraSpecialArgs = {
      inherit (vars) system;
      inherit inputs pkgs-stable pkgs-unstable vars;
    };
    modules = [
      {
        imports = [
          # ( import ../modules/programs ( { inherit inputs; pkgs = pkgs-unstable; } ) )
          ( import ../modules/programs )
          ( import ../modules/desktops/gnome/home.nix )
          ( import ../modules/desktops/hyprland/home.nix )
        ];
        programs = {
          home-manager.enable = true;
          htop.enable = true;
          brave.enable = true;
          git = {
            enable = true;
            userName = "mml00";
            userEmail = "mml00.work@gmail.com";
          };
        };
        home = {
          stateVersion = "23.11";
          username = vars.user;
          homeDirectory = "/home/${vars.user}";
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
          packages =  with pkgs-unstable; [
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
            pkgs-telegram.telegram-desktop
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
      }
    ];
  };
}
