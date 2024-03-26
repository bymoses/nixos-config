{
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        dynamic_title = false;
        dynamic_padding = false;
        decorations = "none";
        dimensions = { lines = 0; columns = 0; };
        padding = { x = 0; y = 0; };
        # startup_mode = "Fullscreen";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      mouse = { hide_when_typing = false; };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
        # args = [ "${pkgs.fish}/bin/fish" ];
      };

      # key_bindings = [
      # {
      #   # clear terminal
      #   key = "L";
      #   mods = "Control";
      #   chars = "\\x0c";
      # }
      # ];

      font = let fontname = "FiraCode Nerd Font Mono"; in
      {
        normal = { family = fontname; style = "Regular"; };
        bold = { family = fontname; style = "Bold"; };
        italic = { family = fontname; style = "Light"; };
        size = 10;
        offset = { x = 0; y = 0; };
        glyph_offset = { x = 0; y = 0; };
      };
      cursor.style = "Block";

      colors = {
        primary = {
          background = "0x101214";
          foreground = "0xfff1f3";
        };
        normal = {
          black =   "0x15161e";
          red =     "0xf7768e";
          green =   "0x9ece6a";
          yellow =  "0xe0af68";
          blue =    "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan =    "0x7dcfff";
          white =   "0xa9b1d6";
        };
        bright = {
          black =   "0x414868";
          red =     "0xf7768e";
          green =   "0x9ece6a";
          yellow =  "0xe0af68";
          blue =    "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan =    "0x7dcfff";
          white =   "0xc0caf5";
        };
        indexed_colors = [
        { index = 16; color = "0xff9e64"; }
        { index = 17; color = "0xdb4b4b"; }
        ];
      };
    };
  };
}
