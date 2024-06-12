{
  inputs,
  vars,
  pkgs-stable,
  pkgs-unstable,
  home-manager,
  ...
}:
{
  user = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgs-unstable;
    extraSpecialArgs = {
      inherit (vars) system;
      inherit inputs pkgs-stable pkgs-unstable vars;
    };
    modules = [
      ./user.nix
    ];
  };
}
