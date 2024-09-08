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
    kernelPackages = pkgs.linuxPackages_latest;   # latest stable kernel
    # kernelPackages = pkgs.linuxPackages;    # default old kernel
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;	# max 20 previous versions of builds
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
      options = "--delete-older-than 7d";
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
  location.provider = "geoclue2";

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
      };
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme && fastfetch";
    };
    git = {
      enable = true;
    };
    lazygit.enable = true;
  
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
        mako 
        networkmanagerapplet
        qt5.qtwayland
        sway-audio-idle-inhibit
        swayidle
        swaylock-effects
        wl-clipboard 
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
      EDITOR = "nvim";
    };
    sessionVariables.GTK_THEME = "Adwaita:dark";
    # shellAliases = {
    #     ls = "ls -a";
    # };
    systemPackages = with pkgs; [
      bat
      bato
      cargo
      # clight
      # clightd
      cmake
      fastfetch
      ffmpeg
      file
      fzf
      gcc
      hunspell
      img2pdf
      kdePackages.gwenview
      kdePackages.okular
      libreoffice-qt
      ncmpcpp
      nodePackages.npm
      nodejs
      nwg-displays
      obs-studio
      obsidian
      playerctl
      proton-pass
      protonmail-desktop
      protonvpn-cli
      protonvpn-cli_2
      protonvpn-gui
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
      tmux
      traceroute
      unzip
      virt-viewer
      virtio-win
      vlc
      wireshark
      wlr-protocols
      wl-gammactl
      zsh-fzf-history-search
      zsh-fzf-tab
      zsh-powerlevel10k
    ];
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
        "image/png" = "org.kde.gwenview.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "text/html" = "nvim.desktop";
        "text/plain" = "nvim.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
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
        enable = true;
        wayland.enable = true;
        # wayland.compositor = "kwin"; ?
        settings = {};
        # theme = "catppuccin";
        extraPackages = [];
      };
      # defaultSession = "gnome";
    };
    getty.autologinUser = "prabhat";

    # Enable CUPS to print documents.
    printing.enable = true;
    # A TUI greeter (login manager a.k.a display manager)
    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.regreet}/bin/regreet -c sway";
    #       user = "greeter";
    #     };
    #   };
    # };
  
    # Enable the OpenSSH daemon.
    openssh.enable = true;
  
    # Suspend on closing laptop lid
    logind.lidSwitch = "suspend";     # hibernate is buggy - Trackpad, Speakers etc.
  
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

    # Text expander written in Rust
    #espanso = {
    #  enable = true;
    #  wayland =true;
    #};
    spice-vdagentd.enable = true;

    # clight display brightness and colour manager
    clight = {
      enable = true;
    };

    mpd = {
      enable = true;
      musicDirectory = "/home/prabhat/Music";
      # Config suggested for ncmpcpp
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';

      # Config suggested on wiki for ALSA
      # extraConfig = ''
      #   audio_output {
      #     type "alsa"
      #     name "My ALSA"
      #     # device "hw:0,0"	# optional 
      #     format "44100:16:2"	# optional
      #     mixer_type		"hardware"
      #     mixer_device	"default"
      #     mixer_control	"PCM"
      #   }
      # '';
      user = "prabhat";

      # Optional:
      # network.listenAddress = "any"; # if you want to allow non-localhost connections
      # network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };
  };

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.prabhat.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  };

  # powerManagement.powerUpCommands = "";
  powerManagement.powerDownCommands = "cat /proc/net/dev >> /home/prabhat/Desktop/networkUsage.txt";

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
      allowReboot = true;
      # For bleeding edge
      channel = "https://channels.nixos.org/nixos-unstable";
      # Stable release
      # system.autoUpgrade.channel = "https://channels.nixos.org/nixos-24.05";
      dates = "weekly";
    };
  };
}
