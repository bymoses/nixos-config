#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{
  inputs,
  vars,
  lib,
  pkgs-stable,
  # hyprland,
  ...
}:
{
  # Desktop Profile
  host = lib.nixosSystem {
    inherit (vars) system;
    specialArgs = {
      inherit inputs pkgs-stable vars;
      # inherit hyprland;
      host = {
        hostName = "host";
      };
    };
    modules = [
      ./lenovo-yoga-7-pro
      ./configuration.nix
    ];
  };
}
