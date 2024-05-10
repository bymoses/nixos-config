{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./tmux
    ./fish
    ./nixvim
  ];
}

