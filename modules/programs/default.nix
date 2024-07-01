{ pkgs, ... }: {
  imports = [ ./alacritty ./tmux ./fish ./nixvim ./helix ./language-servers ];
}

