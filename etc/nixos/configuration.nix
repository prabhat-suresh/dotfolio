# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../../home/prabhat/kickstart.nixvim/nixvim.nix { 
	pkgs = pkgs;
	inputs.nixvim = import (builtins.fetchGit {
	  url = "https://github.com/nix-community/nixvim";
	  # When using a different channel you can use `ref = "nixos-<version>"` to set it here
	});
      })
    ];

  # Bootloader
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    # kernelPackages = pkgs.linuxPackages_latest;   # latest kernel
    kernelPackages = pkgs.linuxPackages;    # default old kernel
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;	# max 5 previous versions of builds
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    # Optimize storage
    optimise.automatic = true;
  
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wpa_supplicant
  
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
    # Enable networking
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  qt = {
    enable = true;
    # For dark theme
    style = "adwaita-dark";
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Location
  # location.provider = "geoclue2";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  hardware = {

    #hardware acceleration
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
        # NOTE: at some point GPUs in the R600-family and newer
        # may need to replace this with the "rusticl" ICD;
        # and GPUs in the R500-family and older may need to
        # pin the package version or backport/patch this back in
        # - https://www.phoronix.com/news/Mesa-Delete-Clover-Discussion
        # - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/19385
        mesa.opencl
      ];
    };

    # hardware.extraPackages = with pkgs; [
    #   rocmPackages.clr.icd
    #   amdvlk
    # ];

    # opengl.extraPackages = [          opengl.extraPackages has been renamed to graphics.extraPackages
    #   pkgs.amdvlk
    # ];
  
    # enables support for Bluetooth
    bluetooth = {
      enable = true; 
      powerOnBoot = false;
    };
  
    # disable pulseaudio
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.prabhat = {
      isNormalUser = true;
      description = "Prabhat";
      extraGroups = [ "networkmanager" "wheel" "wireshark" "libvirtd"];
      packages = with pkgs; [
      ];
    };
    defaultUserShell = pkgs.zsh;
  };

  programs = {
    # Install firefox.
    firefox.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        strategy = [
           "history"
           "completion"
           "match_prev_cmd"
        ];
      };
      shellAliases = {
        cat = "bat";
        ls = "ls -a --color";
        tmux = "tmux -u";
      };
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme && fastfetch";
    };
    git = {
      enable = true;
    };
  
    waybar.enable = true;
    sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      xwayland.enable = true; # enable xwayland
      extraPackages = with pkgs; [
        autotiling-rs
        bluez
        brightnessctl
        copyq
        flameshot
        foot
        kdePackages.gwenview
        kdePackages.okular
        libreoffice-qt
        networkmanagerapplet
        obs-studio
        obsidian
        playerctl
        qt5.qtwayland
        sway-audio-idle-inhibit
        swayidle
        swaylock-effects
        swaynotificationcenter
        vlc
        wl-clipboard 
        wluma
        wofi
      ];
    };
  
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
    };
  
    wireshark.enable = true;

    iftop.enable = true;

    # virt-manager
    virt-manager.enable = true;

    # dconf (system management tool)
    dconf = {
      enable = true;
    };

    # Yazi - a blazingly fast terminal file manager written in Rust!
    yazi = {
      enable = true;
      # settings = {
      #   theme = {
      #     flavor = "tokyo-night";
      #   };
      # };
      # flavors = {
      #   tokyo-night = /home/prabhat/.config/yazi/flavors/tokyo-night.yazi;
      # };
    };
    fzf.fuzzyCompletion = true;

    tmux = {
      baseIndex = 1;
      clock24 = true;
      enable = true;
      escapeTime = 0;
      extraConfig = "
                    set -g @catppuccin_directory_text '#{b:pane_current_path}'
                    set -g @catppuccin_status_connect_separator 'no'
                    set -g @catppuccin_status_fill 'icon'
                    set -g @catppuccin_status_left_separator  ' '
                    set -g @catppuccin_status_modules_left 'session'
                    set -g @catppuccin_status_modules_right 'directory date_time'
                    set -g @catppuccin_status_right_separator ' '
                    set -g @catppuccin_status_right_separator_inverse 'no'
                    set -g @catppuccin_window_current_fill 'number'
                    set -g @catppuccin_window_current_text '#W#{?window_zoomed_flag,(),}'
                    set -g @catppuccin_window_default_fill 'number'
                    set -g @catppuccin_window_default_text '#W'
                    set -g @catppuccin_window_left_separator ''
                    set -g @catppuccin_window_middle_separator ' █'
                    set -g @catppuccin_window_number_position 'right'
                    set -g @catppuccin_window_right_separator ' '
        ";
                    # set -g @tilish-default 'main-vertical'
                    # set -g default-command "reattach-to-user-namespace -l $SHELL"
                    # set -g detach-on-destroy off     # don't exit from tmux when closing a session

      extraConfigBeforePlugins = "
                    set -g allow-passthrough on
                    set -ga update-environment TERM
                    set -ga update-environment TERM_PROGRAM
                    set -g default-terminal 'foot'
                    set -g pane-active-border-style 'fg=magenta,bg=default'
                    set -g pane-border-style 'fg=brightblack,bg=default'
                    set -g set-clipboard on          # use system clipboard
                    set -g status-position top       # macOS / darwin style
                    set -g mouse on
        ";
      historyLimit = 1000000;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
        mode-indicator
        tilish
      ];
      secureSocket = true;
      terminal = "screen-256color";
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment = {
    variables = {
      GTK_THEME = "Adwaita:dark";  #dark theme
      AMD_VULKAN_ICD = "RADV";	#hardware acceleration
      # Enable wayland on firefox
      MOZ_ENABLE_WAYLAND=1;
      # As suggested in https://github.com/maximbaz/wluma/issues/8
      WLR_DRM_NO_MODIFIERS=1;
      EDITOR = "nvim";
    };
    sessionVariables.GTK_THEME = "Adwaita:dark";
    systemPackages = with pkgs; [
      bat
      bato
      cargo
      cmake
      discord
      exfat
      fastfetch
      ffmpeg
      file
      fzf
      gcc
      ghc
      hunspell
      img2pdf
      nodePackages.npm
      nodejs
      nwg-displays
      ocaml
      opam
      python3
      qemu
      qt-video-wlr
      ripgrep
      ripgrep-all
      rust-analyzer
      rustc
      rustfmt
      rustup
      signal-desktop
      spice
      spice-gtk
      spice-protocol
      stockfish
      tlrc
      tmuxinator
      traceroute
      unzip
      virt-viewer
      virtio-win
      wireshark
      zsh-fzf-history-search
      zsh-fzf-tab
      zsh-powerlevel10k
    ] ++ 
      (with haskellPackages; [
        cabal-install
        diagrams
        # ghc
        # ghcup
        haskell-language-server
      ]) ++
    (with ocamlPackages; [
        batteries
        core 
        core_extended 
        dune_3
        findlib
        merlin 
        ocaml-lsp
        ocamlformat
        odoc
        utop 
        vg # for vector graphics
    ]);
  };

  xdg = {
    portal = {
      enable = true;
    # For screen sharing on wayland
      wlr = {
        enable = true;
        # settings = {
          # screencast = {
            # output_name = "HDMI-A-1";
            # max_fps = 30;
            # exec_before = "disable_notifications.sh";
            # exec_after = "enable_notifications.sh";
            # chooser_type = "simple";
            # chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          # };
        # };
      };
      # gtk portal needed to make gtk apps happy


      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.kde.okular.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "audio/mp3" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "image/gif" = "vlc.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "text/calendar" = "nvim.desktop";
        "text/css" = "nvim.desktop";
        "text/html" = "nvim.desktop";
        "text/markdown" = "obsidian.desktop";
        "text/plain" = "nvim.desktop";
        "text/x-c" = "nvim.desktop";
        "text/x-h" = "nvim.desktop";
        "video/mp4" = "vlc.desktop";
        "video/mpeg" = "vlc.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    ];
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      serif = ["JetBrainsMono Nerd Font"];
      sansSerif = ["JetBrainsMono Nerd Font"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };



  virtualisation = {
    # virt-manager
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    # docker virtualization
    # virtualisation.docker.enable = true;
    spiceUSBRedirection.enable = true;
  };

  services = {
    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    displayManager = {
      autoLogin = {
        user = "prabhat";
      };
      sddm = {
        autoLogin.relogin = true;
        enable = true;
        wayland.enable = true;
        wayland.compositor = "weston";
        settings = {};
        theme = "catppuccin";
        extraPackages = [];
      };
      defaultSession = "sway";
    };
    getty.autologinUser = "prabhat";

    # Enable CUPS to print documents.
    printing.enable = true;
  
    # Enable the OpenSSH daemon.
    openssh.enable = true;
  
    # Suspend on closing laptop lid
    logind.lidSwitch = "suspend"; # Hibernate is buggy - mouse, speakers etc. don't work sometimes
  
    # Power Management
    upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 25;
      percentageCritical = 15;
      percentageAction = 10;
      criticalPowerAction = "Hibernate";
      noPollBatteries = true;
    };
    power-profiles-daemon.enable = true;

    spice-vdagentd.enable = true;
  };

  # powerManagement = {
  #   powerUpCommands = "nmcli c up id jp-free-154028.protonvpn.udp";
  #   powerDownCommands = "cat /proc/net/dev >> /home/prabhat/Desktop/networkUsage.txt";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "24.05"; # Did you read the comment?
  
    #System Autoupgrade
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      # For bleeding edge
      channel = "https://channels.nixos.org/nixos-unstable";
      # Stable release
      # channel = "https://channels.nixos.org/nixos-24.05";
      dates = "weekly";
    };
  };
}
