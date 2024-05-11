{ config, lib, ... }:
{
  options = {
    gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gnome.enable) {
    services = {
      # Enable the X11 windowing system.
      xserver = {
        enable = true;

        # Enable the GNOME Desktop Environment.
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        # Configure keymap in X11
        xkb = {
          layout = "us,ru";
          variant = "";
          options = "grp:caps_toggle";
        };
      };
    };
  };
}
