{ config, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    impureRtp = false;
    luaLoader.enable = true;
    wrapRc = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    clipboard.register = "unnamedplus";

    colorscheme = "default";

    opts = {
      background = "dark";
      number = true;
      mouse = "a";
      showmode = false;
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      confirm = true;
    };

    diagnostic.settings = {
      update_in_insert = false;
      severity_sort = true;
      float = {
        border = "rounded";
        source = "if_many";
      };
      underline.severity.min.__raw = "vim.diagnostic.severity.WARN";
      virtual_text = true;
      virtual_lines = false;
      jump.on_jump.__raw = ''
        function(_, bufnr)
          vim.diagnostic.open_float({
            bufnr = bufnr,
            scope = "cursor",
            focus = false,
          })
        end
      '';
    };

    autoGroups.kickstart-highlight-yank.clear = true;

    autoCmd = [
      {
        event = "TextYankPost";
        group = "kickstart-highlight-yank";
        desc = "Highlight when yanking text";
        callback.__raw = "function() vim.hl.on_yank() end";
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>q";
        action.__raw = "vim.diagnostic.setloclist";
        options.desc = "Open diagnostic quickfix list";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>f";
        action.__raw = ''
          function()
            require("conform").format({ async = true })
          end
        '';
        options.desc = "Format buffer";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
        options.desc = "Open parent directory";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action.__raw = "function() require('neotest').run.run() end";
        options.desc = "Run nearest test";
      }
      {
        mode = "n";
        key = "<leader>tf";
        action.__raw = "function() require('neotest').run.run(vim.fn.expand('%')) end";
        options.desc = "Run test file";
      }
      {
        mode = "n";
        key = "<leader>tl";
        action.__raw = "function() require('neotest').run.run_last() end";
        options.desc = "Run last test";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action.__raw = "function() require('neotest').summary.toggle() end";
        options.desc = "Toggle test summary";
      }
      {
        mode = "n";
        key = "<leader>to";
        action.__raw = "function() require('neotest').output_panel.toggle() end";
        options.desc = "Toggle test output";
      }
      {
        mode = "n";
        key = "<leader>tS";
        action.__raw = "function() require('neotest').run.stop() end";
        options.desc = "Stop nearest test";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action.__raw = "require('telescope.builtin').help_tags";
        options.desc = "Search help";
      }
      {
        mode = "n";
        key = "<leader>sk";
        action.__raw = "require('telescope.builtin').keymaps";
        options.desc = "Search keymaps";
      }
      {
        mode = "n";
        key = "<leader>sf";
        action.__raw = "require('telescope.builtin').find_files";
        options.desc = "Search files";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = "require('telescope.builtin').builtin";
        options.desc = "Search Telescope pickers";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>sw";
        action.__raw = "require('telescope.builtin').grep_string";
        options.desc = "Search current word";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action.__raw = "require('telescope.builtin').live_grep";
        options.desc = "Search by grep";
      }
      {
        mode = "n";
        key = "<leader>sd";
        action.__raw = "require('telescope.builtin').diagnostics";
        options.desc = "Search diagnostics";
      }
      {
        mode = "n";
        key = "<leader>sr";
        action.__raw = "require('telescope.builtin').resume";
        options.desc = "Resume search";
      }
      {
        mode = "n";
        key = "<leader>s.";
        action.__raw = "require('telescope.builtin').oldfiles";
        options.desc = "Search recent files";
      }
      {
        mode = "n";
        key = "<leader>sc";
        action.__raw = "require('telescope.builtin').commands";
        options.desc = "Search commands";
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action.__raw = "require('telescope.builtin').buffers";
        options.desc = "Find existing buffers";
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = ''
          function()
            require("telescope.builtin").current_buffer_fuzzy_find(
              require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
              })
            )
          end
        '';
        options.desc = "Search in current buffer";
      }
      {
        mode = "n";
        key = "<leader>s/";
        action.__raw = ''
          function()
            require("telescope.builtin").live_grep({
              grep_open_files = true,
              prompt_title = "Live Grep in Open Files",
            })
          end
        '';
        options.desc = "Search in open files";
      }
      {
        mode = "n";
        key = "<leader>sn";
        action.__raw = ''
          function()
            require("telescope.builtin").find_files({
              cwd = "${config.home.homeDirectory}/Code/config/dotfiles/modules/home/editor",
              follow = true,
            })
          end
        '';
        options.desc = "Search Neovim configuration";
      }
    ];

    plugins = {
      guess-indent.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };

      which-key = {
        enable = true;
        settings = {
          delay = 0;
          icons.mappings = true;
          spec = [
            {
              __unkeyed-1 = "<leader>s";
              group = "Search";
              mode = [
                "n"
                "v"
              ];
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Tests";
            }
            {
              __unkeyed-1 = "<leader>h";
              group = "Git hunk";
              mode = [
                "n"
                "v"
              ];
            }
            {
              __unkeyed-1 = "gr";
              group = "LSP actions";
              mode = "n";
            }
          ];
        };
      };

      todo-comments = {
        enable = true;
        settings.signs = false;
      };

      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };

      mini-ai = {
        enable = true;
        settings = {
          mappings = {
            around_next = "aa";
            inside_next = "ii";
          };
          n_lines = 500;
        };
      };

      mini-surround.enable = true;

      mini-statusline = {
        enable = true;
        settings.use_icons = true;
      };

      neotest = {
        enable = true;
        adapters = {
          golang.enable = true;
          jest.enable = true;
          playwright.enable = true;
          python.enable = true;
          vitest.enable = true;
        };
      };

      oil = {
        enable = true;
        settings.columns = [ "icon" ];
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
      };

      fidget.enable = true;

      conform-nvim = {
        enable = true;
        autoInstall.enable = true;
        settings = {
          notify_on_error = false;
          default_format_opts.lsp_format = "fallback";
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
          };
        };
      };

      luasnip.enable = true;

      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          appearance.nerd_font_variant = "mono";
          completion.documentation = {
            auto_show = false;
            auto_show_delay_ms = 500;
          };
          sources.default = [
            "lsp"
            "path"
            "snippets"
          ];
          snippets.preset = "luasnip";
          fuzzy.implementation = "lua";
          signature.enabled = true;
        };
      };

      lspconfig.enable = true;

      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          c
          diff
          go
          html
          javascript
          json
          lua
          luadoc
          markdown
          markdown_inline
          nix
          python
          query
          tsx
          typescript
          vim
          vimdoc
        ];
      };

      treesitter-context = {
        enable = true;
        settings.max_lines = 3;
      };

      ts-autotag.enable = true;
    };

    lsp = {
      servers = {
        "*".config.capabilities.__raw = "require('blink.cmp').get_lsp_capabilities()";

        basedpyright.enable = true;
        gopls.enable = true;

        lua_ls = {
          enable = true;
          config.settings.Lua = {
            format.enable = false;
            runtime = {
              version = "LuaJIT";
              path = [
                "lua/?.lua"
                "lua/?/init.lua"
              ];
            };
            workspace = {
              checkThirdParty = false;
              library.__raw = "vim.api.nvim_get_runtime_file('', true)";
            };
          };
        };

        nixd.enable = true;
        ts_ls.enable = true;
      };

      onAttach = ''
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, {
            buffer = bufnr,
            desc = "LSP: " .. desc,
          })
        end

        map("grn", vim.lsp.buf.rename, "Rename")
        map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("grD", vim.lsp.buf.declaration, "Go to declaration")
        map("grr", require("telescope.builtin").lsp_references, "Go to references")
        map("gri", require("telescope.builtin").lsp_implementations, "Go to implementation")
        map("grd", require("telescope.builtin").lsp_definitions, "Go to definition")
        map("gO", require("telescope.builtin").lsp_document_symbols, "Document symbols")
        map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")
        map("grt", require("telescope.builtin").lsp_type_definitions, "Go to type definition")

        if client.name == "lua_ls" then
          client.server_capabilities.documentFormattingProvider = false
        end

        if client:supports_method("textDocument/documentHighlight", bufnr) then
          local highlight_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", {
            clear = false,
          })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", {
              clear = true,
            }),
            callback = function(event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({
                group = "kickstart-lsp-highlight",
                buffer = event.buf,
              })
            end,
          })
        end

        if client:supports_method("textDocument/inlayHint", bufnr) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            )
          end, "Toggle inlay hints")
        end
      '';
    };

    extraConfigLuaPost = ''
      require("mini.statusline").section_location = function()
        return "%2l:%-2v"
      end
    '';
  };
}
