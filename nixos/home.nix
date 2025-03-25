{ config, pkgs, inputs, ... }:
  {
  home.username = "nika";
  home.homeDirectory = "/home/nika";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.kitty = {
    enable = true;
    # themeFile = "base2tone-mall-dark";
    themeFile = "duckbones";
    settings = {
      cursor_trail = 3; 
      dynamic_background_opacity = true;
      background_opacity = "0.5";
      background_blur = 5;
    };
  };

  services.picom = {
    enable = false;
    settings = {
      blur = {
	method = "gaussian";  # Options: "kernel", "box", "gaussian"
	size = 10;  # Increase for stronger blur
	deviation = 5.0;  # Adjust for smoothness
      };
      blur-background = true;
      blur-background-frame = true;
      blur-kern = "3x3box";  # Alternative kernel blur
      experimental-backends = true;
    };
  };


  home.packages = with pkgs; [
    rustup 
    openssl
    openssl.dev
    pkg-config
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  };

  programs.tmux = {
    enable = true;
    clock24 = true; 
    keyMode = "vi";
    mouse = true; 
    historyLimit = 10000; 
    escapeTime = 0;
    extraConfig = ''
      # set -g default-terminal "tmux-256color"
      # set-option -sa terminal-overrides ",xterm-256color:RGB"
      # set -g set-clipboard on
      # bind-key r source-file ~/.tmux.conf \; display-message "Tmux reloaded!"
      # Use vim keys for navigating between panes
      # bind h split-window -h
      # bind j split-window -v
      # bind k select-pane -U
      # bind l select-pane -D
      # Use vim-like keys to navigate between panes
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';
  };
    
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    globals.mapleader = " ";
    
    opts = {
      updatetime = 300;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      swapfile = false;
      undofile = true;
      incsearch = true;
      inccommand = "split";
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes:1";
    };

    # colorschemes.rose-pine.enable = true;
    colorschemes.cyberdream.enable = true;
    clipboard = {
      providers = {
        wl-copy.enable = true; # Wayland 
        xsel.enable = true; # For X11
      };
      register = "unnamedplus";
    };
 
    keymaps = [
      # Center cursor when scrolling with Ctrl+d and Ctrl+u
      {
        mode = "n"; key = "<C-d>"; action = "<C-d>zz"; options.silent = true;
      }
      {
        mode = "n"; key = "<C-u>"; action = "<C-u>zz"; options.silent = true;
      }

      # Ctrl+Backspace: Delete previous word
      {
        mode = "i"; key = "<C-BS>"; action = "<C-w>"; options.silent = true;
      }

      # Ctrl+Delete: Delete next word
      {
        mode = "i"; key = "<C-Del>"; action = "<C-o>dw"; options.silent = true;
      }

    ];

    plugins = {
      lualine.enable = true;
      autoclose.enable = true;
      comment.enable = true;
      telescope = {
	enable = true;
	extensions = {
	  fzf-native = {
	    enable = true;
	  };
	};
	settings = {
	};
	keymaps = {
	  "<leader>ff" = {
	    action = "find_files";
	    options = {
	      desc = "Find project files";
	    };
	  };
	}; 
      };
      treesitter = {
        enable = true;
	settings = {
	  indent.enable = true;
	  highlight.enable = true;
	};
	folding = false;
	nixvimInjections = true;
	grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      treesitter-textobjects = {
	enable = false;
      };
      luasnip.enable = true;
      web-devicons.enable = true;
      lspkind.enable = true;
      which-key.enable = true;
    };

    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
	lua_ls.enable = true;
	nil_ls.enable = true;
	clangd.enable = true;
	htmx.enable = true;
	html.enable = true;
	gopls.enable = true;
	rust_analyzer = {
	  enable = true;
	  installCargo = false;
          installRustc = false;
	};
      };
      keymaps.lspBuf = {
	"gd" = "definition";
	"gD" = "references";
	"gt" = "type_definition";
	"gi" = "implementation";
	"K" = "hover";
      };
    };
    
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
	{ name = "nvim_lsp"; }
	{ name = "path"; }
	{ name = "buffer"; }
      ];
      settings = {
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })"; # Autocomplete confirm
            "<C-Space>" = "cmp.mapping.complete()"; # Trigger completion manually

	    # Add next/previous selection
	    "<Tab>" = "cmp.mapping.select_next_item()";  # Next suggestion
	    "<S-Tab>" = "cmp.mapping.select_prev_item()"; # Previous suggestion
	  };
      };
    };

    extraConfigLua = ''
      -- Rust LSP settings
      require("lspconfig").rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
	    checkOnSave = { command = "clippy" },
	    diagnostics = {
	      enable = true,
	      -- experimental = {
		 -- enable = true,
	      -- },
            },
          }
        }
      })

      vim.diagnostic.config({
	update_in_insert = true, -- Update diagnostics while typing
	virtual_text = true, -- Show errors inline
	signs = true, -- Show signs in the gutter
	underline = true, -- Underline errors
      })

      vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
	pattern = "*.rs",
	callback = function()
	  vim.lsp.buf.clear_references()
	  vim.lsp.buf.document_highlight()
	  vim.diagnostic.setloclist()
	end,
      })
    '';
  };

}
