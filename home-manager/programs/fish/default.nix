{
  pkgs,
    lib,
    ...
}:
let
  config = lib.readFile ./config.fish;
in {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      ${config}
    '';
    plugins = [
# Enable a plugin (here grc for colorized command output) from nixpkgs
    { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
}
