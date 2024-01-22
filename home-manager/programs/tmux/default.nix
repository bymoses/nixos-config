{
  pkgs,
  lib,
  ...
}:
let
  config = lib.readFile ./tmux.conf;
in {
  programs.tmux = {
    enable = true;
    shortcut = "b";
    baseIndex = 1;
    escapeTime = 0;
    aggressiveResize = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.battery
    ];
    extraConfig = with pkgs.tmuxPlugins; ''
      ${config}
    '';
  };
}
