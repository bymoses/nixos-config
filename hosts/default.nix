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
  nixpkgs-stable,
  nixpkgs-unstable,
  home-manager,
  nixvim,
  ...
}:
let
  system = "x86_64-linux";

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs-stable.lib;
in
{
  # Desktop Profile
  host = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable unstable vars;
      host = {
        hostName = "host";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
      ./lenovo-yoga-7-pro
      ./configuration.nix
    ];
  };
}
