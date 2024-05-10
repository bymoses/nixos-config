{ ... }:
let
  # keymap options
  options = {
    noremap = true;
    silent = true;
  };
in
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    globals = {
      netrw_liststyle = 3;
      mapleader = " ";
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    luaLoader.enable = true;

    opts = {
      completeopt = ["menu" "menuone" "noselect"];
      mouse = "a";

      # Tab
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;

      # UI config
      number = true;
      relativenumber = true;
      splitbelow = true;
      splitright = true;
      scrolloff = 8;
      sidescrolloff = 8;
      list = false;
      cmdheight = 0;
      listchars = {eol = "↵"; tab = "│ "; trail = "~"; extends = ">"; precedes = "<";};

      # Searching
      incsearch = true;
      hlsearch = true;
      ignorecase = true;
      smartcase = true;
      showmatch = true;
    };

    keymaps = [
      # { mode = "i"; key = "jk"; action = "<ESC>"; inherit options; }

      # resize
      { mode = "n"; key = "<C-Up>"; action = ":resize -1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Down>"; action = ":resize +1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Left>"; action = ":vertical resize -1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Right>"; action = ":vertical resize +1<CR>"; inherit options; }

      # Save
      { mode = "n"; key = "fs"; action = ":write<CR>"; inherit options; }

      # Telescope
      { mode = "n"; key = "<leader>ff"; action = ":Telescope find_files<CR>"; inherit options; }
      { mode = "n"; key = "<leader>fg"; action = ":Telescope live_grep<CR>"; inherit options; }
      { mode = "n"; key = "<leader>fb"; action = ":Telescope buffers<CR>"; inherit options; }
      { mode = "n"; key = "<leader>hl"; action = ":Telescope harpoon marks<CR>"; inherit options; }

      # LSP
      { mode = "n"; key = "gr"; action = ":Telescope lsp_references<CR>"; inherit options; }
      { mode = "n"; key = "gd"; action = ":Telescope lsp_definitions<CR>"; inherit options; }
      { mode = "n"; key = "ga"; action = ":lua vim.lsp.buf.code_action()<CR>"; inherit options; }
      { mode = "n"; key = "gh"; action = ":lua vim.lsp.buf.hover()<CR>"; inherit options; }
      { mode = "n"; key = "gt"; action = ":lua vim.lsp.buf.type_definition()<CR>"; inherit options; }
      { mode = "n"; key = "K"; action = ":lua vim.diagnostic.open_float()<CR>"; inherit options; }

      # Buffers
      { mode = "n"; key = "<leader>bp"; action = ":bp<CR>"; inherit options; }
      { mode = "n"; key = "<leader>bn"; action = ":bn<CR>"; inherit options; }
      { mode = "n"; key = "<leader>bd"; action = ":bd<CR>"; inherit options; }

      # Neotree
      # { mode = "n"; key = "<leader>tn"; action = ":Neotree toggle<CR>"; inherit options; }

      # Netrw
      # { mode = "n"; key = "tn"; action = ":Explore<CR><CR>"; inherit options; }

      # Telescope file browser
      { mode = "n"; key = "<leader>tn"; action = ":Telescope file_browser path=%:p:h<CR>"; inherit options; }

      # Visual mode
      { mode = "v"; key = "<"; action = "<gv"; inherit options; }
      { mode = "v"; key = ">"; action = ">gv"; inherit options; }

      # vim-tmux-plugin
      { key = "<M-h>"; action = "<cmd>TmuxNavigateLeft<cr>"; }
      { key = "<M-j>"; action = "<cmd>TmuxNavigateDown<cr>"; }
      { key = "<M-k>"; action = "<cmd>TmuxNavigateUp<cr>"; }
      { key = "<M-l>"; action = "<cmd>TmuxNavigateRight<cr>"; }

      # other
      { mode = "n"; key = "<leader>s"; action = ":split<CR>"; inherit options; }
      { mode = "n"; key = "<leader>vs"; action = ":vs<CR>"; inherit options; }
    ];

    # Highlight and remove extra white spaces
    highlight.ExtraWhitespace.bg = "red";
    match.ExtraWhitespace = "\\s\\+$";

    colorschemes.kanagawa = {
      enable = true;
      settings = {
        transparent = true;
        colors = {
          theme = {
            all.ui.bg_gutter = "none";
            all.ui.float.bg = "none";
          };
        };
        overrides = ''
          function(colors)
            local theme = colors.theme
            return {
              Pmenu = { fg = theme.ui.shade0, bg = "none" },  -- add `blend = vim.o.pumblend` to enable transparency
                PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                         PmenuSbar = { bg = theme.ui.bg_m1 },
                         PmenuThumb = { bg = theme.ui.bg_p2 },

                         NormalFloat = { bg = "none" },
                         FloatBorder = { bg = "none" },
                         FloatTitle = { bg = "none" },

                         -- Save an hlgroup with dark background and dimmed foreground
                           -- so that you can use it where your still want darker windows.
                           -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                           NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                         -- Popular plugins that open floats will link to NormalFloat by default;
              -- set their background accordingly if you wish to keep them dark and borderless
                LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                           MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                           TelescopeTitle = { fg = theme.ui.special, bold = true },
                           TelescopePromptNormal = { bg = "none" },
                           TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = "none" },
                           -- TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                           TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = "none" },
                           -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                           TelescopePreviewBorder = { bg = "none", fg = theme.ui.bg_dim },
            }
          end
          '';
      };
    };

    plugins = {
      harpoon = {
        enable = true;
        enableTelescope = true;
        keymaps = {
          navFile = { "1" = "<C-j>"; "2" = "<C-k>"; "3" = "<C-l>"; "4" = "<C-m>"; };
          navNext = "<C-n>";
          navPrev = "<C-p>";
          addFile = "<leader>ha";
        };
      };
      better-escape = {
        enable = true;
        clearEmptyLines = true;
        mapping = [ "jk" ];
      };
      lsp = {
        enable = true;
        preConfig = ''
          local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
          function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
          end
        '';
        servers = {
          dockerls.enable = true;
          graphql.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          tsserver = {
            enable = true;
          };
          tailwindcss.enable = true;
          # vuels.enable = true;
          volar.enable = true;
          yamlls.enable = true;
        };
      };
      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          menu = {
            buffer = "[buf]";
            copilot = "[copilot]";
            path = "[path]";
            nvim_lsp = "[lsp]";
            luasnip = "[snip]";
            nvim_lua = "[lua]";
          };
        };
      };
      # lspsaga = {
      #   enable = true;
      # };
      cmp = {
        enable = true;
        settings = {
          window.completion.border = "rounded";
          window.documentation.border = "rounded";
          experimental = {
            ghost_text = true;
          };
          sorting = {
            comparators = [
              "require('cmp.config.compare').score"
                "require('cmp.config.compare').offset"
                "require('cmp.config.compare').locality"
                "require('cmp.config.compare').exact"
                "require('cmp.config.compare').recently_used"
                "require('cmp.config.compare').kind"
                "require('cmp.config.compare').length"
                "require('cmp.config.compare').order"
            ];
          };
          sources = [
          { name = "nvim_lsp"; }
          # { name = "copilot"; }
          { name = "path"; }
          { name = "buffer"; }
          # { name = "luasnip"; }
          ];
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                },

                ['<Tab>'] = function(fallback)
                  if not cmp.select_next_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                      cmp.complete()
                    else
                      fallback()
                    end
                  end
                end,

                ['<S-Tab>'] = function(fallback)
                  if not cmp.select_prev_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                      cmp.complete()
                    else
                      fallback()
                    end
                  end
                end,
              })
            '';
          };
        };
      };
      telescope = {
        enable = true;
        extensions = {
          file-browser = {
            enable = true;
            settings = {
              grouped = true;
            };
          };
          fzf-native.enable = true;
          frecency.enable = true;
          ui-select.enable = true;
        };
      };
      lualine = {
        enable = true;
        sections = {
          lualine_z = [ "%l/%L :%c" "%p%%" ];
        };
      };
      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
        nixGrammars = true;
        ensureInstalled = [
          "bash"
          "css"
          "fish"
          "html"
          "javascript"
          "json"
          "rust"
          "scss"
          "sql"
          "tsx"
          "typescript"
          "lua"
          "vim"
          "vimdoc"
          "python"
          "vue"
          "yaml"
          "hcl"
          "bash"
          "markdown"
          "graphql"
          "nix"
          "helm"
        ];
      };
      neo-tree = {
        enable = true;
        # filesystem.followCurrentFile = {
        #   enabled = true;
        #   leaveDirsOpen = true;
        # };
        # eventHandlers = {
        #   file_opened = ''
        #     function(file_path)
        #     --auto close
        #     require("neo-tree").close_all()
        #     end
        #     '';
        # };
      };

      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      luasnip.enable = true;
      # copilot-cmp.enable = true;
      # copilot-lua = {
      #   enable = true;
      #   panel.enabled = false;
      #   suggestion.enabled = false;
      #   filetypes =   {
      #     javascript = true; # allow specific filetype
      #     typescript = true; # allow specific filetype
      #     "*" = false; # disable for all other filetypes and ignore default `filetypes`
      #   };
      # };

      notify.enable = true;
      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
        };
      };
      ts-autotag.enable = true;
      nvim-autopairs.enable = true;
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          css = true;
          tailwind = "both";
        };
      };
      comment.enable = true;
      ts-context-commentstring.enable = true;
      markdown-preview.enable = true;
      which-key.enable = true;

      tmux-navigator = {
        enable = true;
        settings = {
          no_mappings = true;
        };
      };
    };

    extraConfigLua = ''
      function has_words_before()
        local cursor = vim.api.nvim_win_get_cursor(0)
        return vim.api.nvim_get_current_line():sub(1, cursor[2]):match('^%s$')
      end
    '';
  };
}
