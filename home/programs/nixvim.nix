{ nixvim-module, ... }:
{
  imports = [ nixvim-module ];

  programs.nixvim = {
    enable = true;

    # 基本設定
    opts = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      ignorecase = true;
      smartcase = true;

      clipboard = "unnamedplus";

      termguicolors = true;

      # 日本語設定
      encoding = "utf-8";
      fileencoding = "utf-8";
      fileencodings = "utf-8,sjis,euc-jp,iso-2022-jp";

      # 全角スペースを可視化
      list = true;
      listchars = "tab:»-,trail:-,extends:»,precedes:«,nbsp:%";
    };

    # カラースキーム
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast = "hard";
        transparent_mode = true;
      };
    };

    # プラグイン
    plugins = {
      # ステータスライン
      lualine = {
        enable = true;
      };

      # ファイルツリー
      neo-tree = {
        enable = true;
      };

      # ファジーファインダー
      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
      };

      # シンタックスハイライト
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };

      # コード補完
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
          ];
        };
      };

      # Git統合
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {text = "+";};
            change = {text = "~";};
            delete = {text = "_";};
            topdelete = {text = "‾";};
            changedelete = {text = "~";};
          };
        };
      };

      # コメントアウト
      comment = {
        enable = true;
      };

      # キーマップヘルプ
      which-key = {
        enable = true;
      };

      # オートペア
      nvim-autopairs = {
        enable = true;
      };

      # インデントガイド
      indent-blankline = {
        enable = true;
      };

      # 関数シグネチャ表示
      lsp-signature = {
        enable = true;
        settings = {
          hint_enable = true;
          hint_prefix = " ";
          floating_window = true;
          bind = true;
        };
      };
    };

    plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        nushell.enable = true;
        tsgo.enable = true;
        rust_analyzer.enable = true;
        svelte.enable = true;
      };
    };

    # 診断設定（カーソル位置の警告を自動表示）
    diagnostics = {
      virtual_text = true;
      float = {
        border = "rounded";
        source = true;
      };
    };

    autoCmd = [
      {
        event = "CursorHold";
        pattern = "*";
        callback.__raw = ''
          function()
            vim.diagnostic.open_float(nil, { focus = false })
          end
        '';
      }
    ];

    # CursorHoldの発火時間を短くする（デフォルト4000ms → 300ms）
    opts.updatetime = 300;


    # キーマップ
    keymaps = [
      # ファイルツリーのトグル
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle file tree";
        };
      }

      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = {
          silent = true;
          desc = "Find files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          silent = true;
          desc = "Live grep";
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options = {
          silent = true;
          desc = "Find buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options = {
          silent = true;
          desc = "Help tags";
        };
      }

      # LSP キーマップ
      {
        mode = "n";
        key = "K";
        action.__raw = "vim.lsp.buf.hover";
        options = {
          silent = true;
          desc = "Show hover information";
        };
      }
      {
        mode = "n";
        key = "gd";
        action.__raw = "vim.lsp.buf.definition";
        options = {
          silent = true;
          desc = "Go to definition";
        };
      }
      {
        mode = "n";
        key = "gD";
        action.__raw = "vim.lsp.buf.declaration";
        options = {
          silent = true;
          desc = "Go to declaration";
        };
      }
      {
        mode = "n";
        key = "gi";
        action.__raw = "vim.lsp.buf.implementation";
        options = {
          silent = true;
          desc = "Go to implementation";
        };
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = "vim.lsp.buf.references";
        options = {
          silent = true;
          desc = "Show references";
        };
      }
      {
        mode = "n";
        key = "<leader>rn";
        action.__raw = "vim.lsp.buf.rename";
        options = {
          silent = true;
          desc = "Rename symbol";
        };
      }
      {
        mode = "n";
        key = "<leader>ca";
        action.__raw = "vim.lsp.buf.code_action";
        options = {
          silent = true;
          desc = "Code action";
        };
      }
      {
        mode = "n";
        key = "<leader>D";
        action.__raw = "vim.lsp.buf.type_definition";
        options = {
          silent = true;
          desc = "Type definition";
        };
      }
      {
        mode = "n";
        key = "<leader>fs";
        action.__raw = "vim.lsp.buf.signature_help";
        options = {
          silent = true;
          desc = "Signature help";
        };
      }
    ];

    # グローバル設定
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
