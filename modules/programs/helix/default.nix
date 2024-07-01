{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "kanagawa_transparent";
      editor = {
        line-number = "relative";
        file-picker = { hidden = false; };
        gutters = { line-numbers.min-width = 0; };
        indent-guides = {
          render = true;
          character = "│";
        };
        lsp = {
          display-messages = false;
          # display-inlay-hints = true;
        };
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" "file-modification-indicator" ];
          right = [
            "total-line-numbers"
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-type"
          ];
          separator = "|";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        whitespace = {
          render = {
            space = "none";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
          # characters = {
          #   newline = "↴";
          #   tab = "│";
          # };
        };

      };
      keys = {
        normal = {
          f.s = ":w";
          "A-j" = "jump_view_down";
          "A-k" = "jump_view_up";
          "A-h" = "jump_view_left";
          "A-l" = "jump_view_right";
        };
        insert = { j.k = "normal_mode"; };
      };
    };
    languages = {
      language = [
        {
          name = "vue";
          file-types = [ "vue" ];
          language-servers = [ "vue-language-server" ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
        }
      ];
      language-server.vue-language-server = {
        command = "vue-language-server";
        args = [ "--stdio" ];
        languages = [ "vue" ];
      };
    };
    themes = {
      kanagawa_transparent = {
        "inherits" = "kanagawa";
        "ui.background" = { };
      };
    };
  };
}
