{
  description = "Your new nix config";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # hardware.url = "github:nixos/nixos-hardware";
    # telegram-desktop.url = "github:nixos/nixpkgs/2a2ccc0c974d3bdb590597b77f35c454bbfa8a6a";
    telegram-desktop.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    # hyprland,
    telegram-desktop,
    home-manager,
    nixvim,
    ...
  } @inputs:
  let
    vars = {
      user = "user";
      terminal = "alacritty";
      system = "x86_64-linux";
    };

    pkgs-stable = import nixpkgs-stable {
      inherit (vars) system;
      config.allowUnfree = true;
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit (vars) system;
      config.allowUnfree = true;
    };
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs-stable) lib;
        inherit inputs vars nixpkgs-stable nixpkgs-unstable pkgs-stable pkgs-unstable;
        # inherit hyprland;
      }
    );

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = (
      import ./users {
        inherit (nixpkgs-unstable) lib;
        inherit inputs vars nixpkgs-stable nixpkgs-unstable pkgs-stable pkgs-unstable telegram-desktop home-manager nixvim;
        # inherit hyprland;
      }
    );
  };
}
