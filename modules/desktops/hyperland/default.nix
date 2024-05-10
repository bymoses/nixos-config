
{ inputs, ... }:

{
  # imports = (
  #     import ../modules/desktops ++
  #     import ../modules/editors ++
  #     import ../modules/hardware ++
  #     import ../modules/programs ++
  #     import ../modules/services ++
  #     import ../modules/shell ++
  #     import ../modules/theming
  #     );
  #

  nix = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
