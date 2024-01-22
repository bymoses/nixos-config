let
  more = { pkgs, ... }: {
    programs = {
      home-manager.enable = true;
      jq.enable = true;
      htop.enable = true;
      brave.enable = true;
      # ssh = {
      #   enable = true;
      #   startAgent = true;
      # };
      git = {
        enable = true;
        userName = "mml00";
        userEmail = "mml00.work@gmail.com";
      };
    };
  };
in
[
  ./alacritty
  ./tmux
  ./fish
  ./gnome
  ./nixvim
  more
]
