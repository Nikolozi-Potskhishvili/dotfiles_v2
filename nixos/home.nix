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
  
  programs.obs-studio = {
    enable = true;
    # enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

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
    # Rust
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

    openssl
    openssl.dev
    pkg-config

    # Go lsp
    gopls
    # C lsp
    clang-tools
    # Nix lsp
    nil
    # Python lsp
    # tools needed by nvim
    pkgs.universal-ctags

    # system tree-sitter grammars
    pkgs.tree-sitter
    #puthon
    python3
    python3Packages.pip
    python3Packages.pyserial

    # artuino
    arduino-ide
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  };

  programs.zsh = {
    enable = false;

    # New option names:
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    enableCompletion = true;
    # New replacement for deprecated initExtra
    initContent = ''
      export EDITOR=nvim

      PROMPT="%F{cyan}%n@%m%f %F{yellow}%~%f %# "

      alias ll='ls -lah'
      alias gs='git status'
    '';

    # Plugins still work the same
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "23.07.13";
          sha256 = "sha256-/6V6IHwB5p0GT1u5SAiUa20LjFDSrMo731jFBq/bnpw=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
  };

  home.sessionPath = [ "$HOME/bin" "$HOME/.local/bin"];

  home.file."bin/arduino-fixed" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      export PATH=${pkgs.python3.withPackages (ps: [ ps.pyserial ])}/bin:$PATH
      exec ${pkgs.arduino-ide}/bin/arduino-ide "$@"
    '';
    executable = true;
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

	programs.neovim = {
		enable = true;
	};
}
    
