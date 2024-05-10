{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    clipboard-history
    dash-to-panel
    vitals
    primary-input-on-lockscreen
    # nasa-apod
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        # "nasa_apod@elinvention.ovh"
        "clipboard-history@alexsaveau.dev"
        "dash-to-panel@jderose9.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "Vitals@CoreCoding.com"
        "primary_input_on_lockscreen@sagidayan.com"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "open-terminal";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super><Shift>q"];
      toggle-maximized = ["<Super>f"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
      move-to-workspace-7 = ["<Super><Shift>7"];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
    };
    "org/gnome/desktop/input-sources" = {
      per-window = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 7;
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["grp:caps_toggle"];
    };
    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = ["<Super>k"];
    };
  };
}
