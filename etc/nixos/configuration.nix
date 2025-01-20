{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    (import ../../home/prabhat/kickstart.nixvim/nixvim.nix {
      pkgs = pkgs;
      inputs.nixvim = import (builtins.fetchGit { url = "https://github.com/nix-community/nixvim"; });
      # When using a different channel you can use `ref = "nixos-<version>"` to set it here
    })
    <home-manager/nixos>
    <catppuccin/modules/nixos>
  ];
  boot = {
    # Bootloader
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5; # max 5 previous versions of builds # latest kernel
      efi.canTouchEfiVariables = true;
    };
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    variables = {
      AMD_VULKAN_ICD = "RADV";
      MOZ_ENABLE_WAYLAND = 1; # Enable wayland on firefox TODO: add more environment variables
      EDITOR = "nvim";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    systemPackages =
      with pkgs;
      [
        # Terminal utils
        acpi
        btop
        cmake
        fastfetch
        ffmpeg
        file
        fzf
        gcc
        gdb
        gnumake
        img2pdf
        inetutils
        lsd # ls with icons and colors written in rust
        meson
        netcat
        nmap
        openssl
        ripgrep
        ripgrep-all
        tlrc # blazingly fast tldr client (written in Rust)
        tree
        unzip
        wget
        wl-clipboard
        zip
        # zsh setup
        zsh-nix-shell
        zsh-powerlevel10k
        zsh-vi-mode
        zsh-z
        # Misc utils
        catppuccin
        discord
        jq
        localsend # file sharing on same network
        obs-studio
        signal-desktop
        spotify
        vlc
        wireshark
        # Nix setup
        home-manager
        nixfmt-rfc-style
        # Rust setup
        cargo
        rust-analyzer
        rustc
        rustfmt
        rustup
        # Python setup
        python3
        python313Packages.numpy
        python313Packages.pip
        ruff
        # Markdown setup
        markdown-oxide # LSP inspired by Obsidian
        hedgedoc # Self hosted collaborative markdown editor
        hedgedoc-cli
        # Coq setup
        coq
        coqPackages.coq-lsp
        # Node JS setup
        nodePackages.npm
        nodejs
      ]
      # Hyprland setup
      ++ [
        bato
        brightnessctl
        copyq
        dunst
        evince
        grimblast
        hyprcursor
        hyprdim
        hyprls
        hyprpaper
        hyprpicker
        hyprpolkitagent
        kitty
        loupe
        nautilus
        playerctl
        wofi
      ]
      # Haskell setup
      ++ [ ghc ]
      ++ (with haskellPackages; [
        cabal-install
        haskell-language-server
      ])
      # Ocaml setup
      ++ [
        ocaml # ocaml compiler
        opam
      ]
      ++ (with ocamlPackages; [
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
      ]);
  };
  fonts = {
    packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    fontDir.enable = true;
  };
  hardware = {
    graphics = {
      # hardware acceleration
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
        mesa.opencl
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
  i18n = {
    defaultLocale = "en_IN"; # Select internationalisation properties.
    extraLocaleSettings = {
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
  };
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    firewall.enable = false;
  };
  nix = {
    optimise.automatic = true; # Optimize storage
    gc = {
      # Garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  programs = {
    bat.enable = true;
    firefox.enable = true;
    fzf.fuzzyCompletion = true;
    git.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = false;
    };
    hyprlock.enable = true;
    iftop.enable = true; # network usage
    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    mtr.enable = true;
    tcpdump.enable = true;
    tmux.enable = true;
    uwsm.enable = true;
    wireshark.enable = true;
    yazi.enable = true;
    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
        strategy = [
          "history"
          "completion"
          "match_prev_cmd"
        ];
      };
      histSize = 1000000;
      interactiveShellInit = ''source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh '';
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      shellAliases = {
        btop = "btop --utf-force";
        cat = "bat";
        ls = "lsd -a";
        open = "xdg-open";
        rg = "rg -i";
        tmux = "tmux -u";
      };
      shellInit = ''
        source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh 
         source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh 
         source ~/.p10k.zsh '';
      syntaxHighlighting.enable = true;
      zsh-autoenv.enable = true;
    };
  };
  qt = {
    enable = true;
    style = "adwaita-dark";
  };
  security.rtkit.enable = true;
  services = {
    hypridle.enable = true;
    logind.lidSwitch = "hibernate"; # Suspend on closing laptop lid
    openssh.enable = true; # Enable the OpenSSH daemon.
    power-profiles-daemon.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    upower = {
      criticalPowerAction = "PowerOff";
      enable = true;
      noPollBatteries = true;
      percentageAction = 15;
      percentageCritical = 20;
      percentageLow = 25;
      usePercentageForPolicy = true;
    };
    xserver.displayManager.gdm.enable = true;
  };
  # This value determines the NixOS release from which the default  settings for stateful data, like file locations and database versions  on your system were taken. It‘s perfectly fine and recommended to leave  this value at the release version of the first install of this system.  Before changing this value read the documentation for this option  (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "24.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      channel = "https://channels.nixos.org/nixos-unstable";
      dates = "weekly";
    };
  };
  time.timeZone = "Asia/Kolkata";
  users = {
    users.prabhat = {
      isNormalUser = true;
      description = "Prabhat";
      extraGroups = [
        "adm"
        "audio"
        "cdrom"
        "dialout"
        "disk"
        "floppy"
        "input"
        "keys"
        "kmem"
        "kvm"
        "lp"
        "messagebus"
        "networkmanager"
        "nixbld"
        "nm-openvpn"
        "nscd"
        "pcap"
        "pipewire"
        "polkituser"
        "render"
        "resolvconf"
        "root"
        "rtkit"
        "sgx"
        "shadow"
        "sshd"
        "systemd-coredump"
        "systemd-journal"
        "systemd-network"
        "systemd-oom"
        "systemd-resolve"
        "systemd-timesync"
        "tape"
        "tty"
        "users"
        "utmp"
        "uucp"
        "video"
        "wheel"
        "wireshark"
      ];
    };
    defaultUserShell = pkgs.zsh;
  };
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true; # For screen sharing on wayland
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk # gtk portal needed to make gtk apps happy
      ];
    };
    mime.enable = true;
  };
  home-manager = {
    useGlobalPkgs = true;
    users.prabhat =
      { pkgs, ... }:
      {
        imports = [
          <catppuccin/modules/home-manager>
        ];
        home = {
          homeDirectory = "/home/prabhat";
          packages = [ pkgs.dconf ];
          pointerCursor = {
            gtk.enable = true;
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
            size = 16;
          };
          stateVersion = "24.11";
          username = "prabhat";
        };
        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        };
        catppuccin.enable = true;
        gtk = {
          enable = true;
          gtk3.extraConfig = {
            Settings = ''gtk-application-prefer-dark-theme=1'';
          };
          gtk4.extraConfig = {
            Settings = ''gtk-application-prefer-dark-theme=1'';
          };
          iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
          };
        };
        programs = {
          git = {
            enable = true;
            userEmail = " prabhatsuresh5@gmail.com";
          };
          hyprlock = {
            enable = true;
            settings = {
              general = {
                immediate_render = true;
              };
              background = {
                path = "$HOME/Pictures/Wallpapers/wp4489091-abstract-purple-wallpapers.jpg";
                color = "rgba (25, 20, 20, 1.0)";
                blur_passes = 0; # 0 disables blurring
                blur_size = 2;
                noise = 0;
                contrast = 0;
                brightness = 0;
                vibrancy = 0;
                vibrancy_darkness = 0.0;
              };
              input-field = {
                size = "300, 30";
                outline_thickness = 0;
                dots_size = 0.25; # Scale of input-field height, 0.2 - 0.8;
                dots_spacing = 0.55; # Scale of dots' absolute size, 0.0 - 1.0;
                dots_center = true;
                dots_rounding = -1;
                outer_color = "rgba(242, 243, 244, 0)";
                inner_color = "rgba(242, 243, 244, 0)";
                font_color = "rgba(242, 243, 244, 0.75)";
                fade_on_empty = false;
                hide_input = false;
                check_color = "rgba(204, 136, 34, 0)";
                fail_color = "rgba(204, 34, 34, 0)"; # if authentication failed, changes outer_color and fail message color;
                fail_text = "$FAIL <b>($ATTEMPTS)</b>"; # can be set to empty;
                fail_transition = 300; # transition time in ms between normal outer_color and fail_color;
                capslock_color = -1;
                numlock_color = -1;
                bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above);
                invert_numlock = false; # change color if numlock is off;
                swap_font_color = false; # see below;
                position = "0, -468";
                halign = "center";
                valign = "center";
              };
              label = [
                {
                  text = ''cmd[update:1000] echo "$(date +'%A, %B %d')"'';
                  color = "rgba(242, 243, 244, 0.75)";
                  font_size = 20;
                  font_family = "Jetbrains Mono";
                  position = "0, 405";
                  halign = "center";
                  valign = "center";
                }
                {
                  text = ''cmd[update:1000] echo "$(date +'%k:%M')"'';
                  color = "rgba(242, 243, 244, 0.75)";
                  font_size = 93;
                  font_family = "Jetbrains Mono";
                  position = "0, 310";
                  halign = "center";
                  valign = "center";
                }
                {
                  text = "Prabhat Suresh";
                  color = "rgba(242, 243, 244, 0.75)";
                  font_size = 12;
                  font_family = "Jetbrains Mono";
                  position = "0, -407";
                  halign = "center";
                  valign = "center";
                }
                {
                  text = "Enter Password";
                  color = "rgba(242, 243, 244, 0.75)";
                  font_size = 10;
                  font_family = "Jetbrains Mono";
                  position = "0, -438";
                  halign = "center";
                  valign = "center";
                }
              ];
              image = {
                border_color = "0xffdddddd";
                border_size = 0;
                size = 73;
                rounding = -1;
                rotate = 0;
                reload_time = -1;
                position = "0, -353";
                halign = "center";
                valign = "center";
              };
            };
          };
          kitty = {
            enable = true;
            font = {
              name = "JetBrainsMono Nerd Font";
              package = pkgs.nerd-fonts.jetbrains-mono;
              size = 18;
            };
            settings = {
              enable_audio_bell = false;
              hide_window_decorations = true;
            };
            shellIntegration.enableZshIntegration = true;
            themeFile = "Catppuccin-Mocha";
          };
          tmux = {
            enable = true;
            baseIndex = 1;
            clock24 = true;
            escapeTime = 0;
            extraConfig = ''
              set -g set-clipboard on
              set -g status-position top
              set -g allow-passthrough on
              set -g @tilish-default 'main-vertical'

              set -g @catppuccin_date_time_text " %a %h-%d  %H:%M"
              set -g @catppuccin_window_status_style "rounded"
              set -g @catppuccin_window_default_fill ""
              set -g @catppuccin_window_default_text ""
              set -g @catppuccin_window_default_fill ""
              set -g @catppuccin_window_default_text ""
              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"
              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator " "
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"
              set -g @tilish-default 'main-vertical'

              set -g status-right-length 100
              set -g status-left-length 100
              set -g status-left ""
              set -g status-right ""
              set -ag status-left "#{E:@catppuccin_status_session}"
              set -ag status-right "#[bg=#{@thm_red},fg=#{@thm_crust}]#[reverse]#[noreverse] "
              set -ag status-right "#[fg=default,bg=#313244] #(acpi -t | awk '{print $4}')°C"
              set -ag status-right "#[fg=#313244,bg=default]"
              set -ag status-right "#[bg=#{@thm_yellow},fg=#{@thm_crust}]#[reverse]#[noreverse] "
              set -ag status-right "#[fg=default,bg=#313244] #(grep 'cpu ' /proc/stat | awk '{print ($2+$4)*100/($2+$4+$5)'})%"
              set -ag status-right "#[fg=#313244,bg=default]"
              set -ag status-right "#[bg=#{@thm_pink},fg=#{@thm_crust}]#[reverse]#[noreverse] "
              set -ag status-right "#[fg=default,bg=#313244] #(free -m | grep Mem | awk '{print ($3/$2)*100}')%"
              set -ag status-right "#[fg=#313244,bg=default]"
              set -ag status-right "#{E:@catppuccin_status_date_time}"
              set -ag status-right "#[bg=#{@thm_mauve},fg=#{@thm_crust}]#[reverse]#[noreverse]󰂄 "
              set -ag status-right "#[fg=default,bg=#313244] #(acpi | awk '{print $4}')"
              set -ag status-right "#[fg=#313244,bg=default]"
            '';
            historyLimit = 1000000;
            keyMode = "vi";
            mouse = true;
            newSession = true;
            plugins = with pkgs.tmuxPlugins; [
              catppuccin
              mode-indicator
              sensible
              tilish
              yank
            ];
            sensibleOnTop = true;
            shortcut = "a";
          };
          wofi = {
            enable = true;
            settings = {
              allow_images = true;
              allow_markup = true;
              content_halign = "fill";
              filter_rate = 100;
              gtk_dark = true;
              halign = "fill";
              height = 500;
              image_size = 40;
              insensitive = true;
              location = "center";
              no_actions = true;
              orientation = "vertical";
              prompt = "Search...";
              show = "drun";
              theme = "catppuccin-mocha";
              width = 800;
            };
            style = ''
              window {
                  font-size: 50px;
                  margin: 0px;
                  border: 5px solid #f5c2e7;
                  background-color: #f5c2e7;
                  border-radius: 15px;
              }
              #input {
                padding: 4px;
                margin: 4px;
                padding-left: 20px;
                border: none;
                color: #000;
                font-weight: bold;
                background-color: #fff;
                background: linear-gradient(90deg, rgba(203, 166, 247, 1) 0%, rgba(245, 194, 231, 1) 100%);
                outline: none;
                border-radius: 15px;
                margin: 10px;
                margin-bottom: 2px;
              }
              #input:focus {
                  border: 0px solid #fff;
                  margin-bottom: 0px;
              }
              #inner-box {
                  margin: 4px;
                  border: 10px
                  color: #cba6f7;
                  font-weight: bold;
                  background-color: #fff;
                  border-radius: 15px;
              }
              #outer-box {
                  margin: 0px;
                  border: none;
                  border-radius: 15px;
                  background-color: #fff;
                  font-size: 2.2rem;
              }
              #scroll {
                  margin-top: 5px;
                  border: none;
                  border-radius: 15px;
                  margin-bottom: 5px;
                  /* background: rgb(255,255,255); */
              }
              #text{
                  color: #000;
                  margin: 0px 0px;
                  border: none;
                  border-radius: 15px;
              }
              #entry {
                  margin: 0px 0px;
                  border: none;
                  border-radius: 15px;
                  background-color: transparent;
              }
              #entry:selected {
                  margin: 0px 0px;
                  border: none;
                  border-radius: 15px;
                  background: linear-gradient(45deg, rgba(203, 166, 247, 1) 30%, rgba(245, 194, 231, 1) 100%);
              }
            '';
          };
          yazi = {
            enable = true;
            enableZshIntegration = true;
            settings = {
              manager = {
                lineMode = "size";
                show_hidden = true;
                show_symlink = true;
                sort_by = "size";
              };
              preview = {
                image_quality = 90;
                sixel_fraction = 10;
              };
            };
          };
          zsh = {
            enable = true;
            initExtraBeforeCompInit = ''
              zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
            '';
          };
        };
        services = {
          dunst = {
            enable = true;
            settings = {
              global = {
                alignment = "left";
                always_run_script = true;
                class = "Dunst";
                corner_radius = 8;
                follow = "mouse";
                font = "JetBrainsMono Nerd Font 16";
                force_xinerama = false;
                format = "<h1>%i %a:</h1>\n<b>%s</b>\n%b";
                frame_color = "#000000";
                frame_width = 3;
                geometry = "0x5-15+46";
                hide_duplicate_count = false;
                history_length = 20;
                horizontal_padding = 8;
                icon_position = "left";
                idle_threshold = 120;
                ignore_newline = false;
                indicate_hidden = true;
                line_height = 0;
                markup = "full";
                max_icon_size = 32;
                monitor = 0;
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action";
                mouse_right_click = "close_all";
                notification_height = 0;
                padding = 8;
                separator_color = "frame";
                separator_height = 2;
                show_age_threshold = 60;
                show_indicators = true;
                shrink = true;
                sort = true;
                stack_duplicates = true;
                startup_notification = false;
                sticky_history = true;
                title = "Dunst";
                verbosity = "mesg";
                word_wrap = true;
              };
              experimental = {
                per_monitor_dpi = false;
              };
              urgency_low = {
                foreground = "#ffd5cd";
                background = "#121212";
                frame_color = "#181A20";
                timeout = 10;
              };
              urgency_normal = {
                background = "#121212";
                foreground = "#ffd5cd";
                frame_color = "#181A20";
                timeout = 10;
              };
              urgency_critical = {
                background = "#121212";
                foreground = "#ffd5cd";
                frame_color = "#181A20";
                timeout = 0;
              };
            };
          };
          hypridle = {
            enable = true;
            settings = {
              general = {
                after_sleep_cmd = "hyprctl dispatch dpms on";
                before_sleep_cmd = "loginctl lock-session";
                ignore_dbus_inhibit = false;
                lock_cmd = "pidof hyprlock || hyprlock";
              };
              listener = [
                {
                  timeout = 300;
                  on-timeout = "loginctl lock-session";
                }
                {
                  timeout = 360;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
                }
                {
                  timeout = 420;
                  on-timeout = "systemctl suspend";
                }
              ];
            };
          };
          hyprpaper = {
            enable = true;
            settings = {
              ipc = "off";
              splash = false;
              preload = [ "~/Pictures/Wallpapers/wp5234084-violet-flower-4k-wallpapers.jpg" ];
              wallpaper = [ ",~/Pictures/Wallpapers/wp5234084-violet-flower-4k-wallpapers.jpg" ];
            };
          };
        };
        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            "$menu" = "wofi --show drun";
            "$mainMod" = "SUPER";
            "$terminal" = "kitty";
            monitor = [
              "DP-1, preferred, auto, 1, mirror, eDP-1"
              "eDP-1,preferred,auto,1"
            ];
            exec-once = [
              "bato"
              "copyq"
              "dunst"
              "hypridle"
              "hyprdim"
              "hyprpaper"
            ];
            env = [
              "XCURSOR_SIZE,24"
              "HYPRCURSOR_SIZE,24"
              "QT_QPA_PLATFORM,wayland"
              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "XDG_SESSION_DESKTOP,Hyprland"
              # QT_QPA_PLATFORMTHEME,qt6ct;qt5ct
            ];
            general = {
              gaps_in = 1;
              gaps_out = 0;
              border_size = 2;
              "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
              "col.inactive_border" = "rgba(595959aa)";
              resize_on_border = false;
              allow_tearing = false;
              layout = "dwindle";
            };
            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 1.0;
              blur = {
                enabled = false;
              };
            };
            animations = {
              enabled = false;
            };
            master = {
              new_status = "master";
            };
            misc = {
              vfr = true;
            };
            input = {
              kb_layout = "us";
              follow_mouse = 1;
              repeat_delay = 200;
              repeat_rate = 50;
              sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
              touchpad = {
                natural_scroll = true;
              };
            };
            gestures = {
              workspace_swipe = false;
            };
            bind = [
              "$mainMod, C, exec, copyq toggle"
              "$mainMod, D, exec, $menu"
              "$mainMod, E, exit,"
              "$mainMod, F, fullscreen"
              "$mainMod, P, exec, hyprpicker -a # color picker"
              "$mainMod, Q, killactive,"
              "$mainMod, Return, exec, $terminal"
              "$mainMod, H, movefocus, l"
              "$mainMod, L, movefocus, r"
              "$mainMod, K, movefocus, u"
              "$mainMod, J, movefocus, d"
              "$mainMod, 1, workspace, 1"
              "$mainMod, 2, workspace, 2"
              "$mainMod, 3, workspace, 3"
              "$mainMod, 4, workspace, 4"
              "$mainMod, 5, workspace, 5"
              "$mainMod, 6, workspace, 6"
              "$mainMod, 7, workspace, 7"
              "$mainMod, 8, workspace, 8"
              "$mainMod, 9, workspace, 9"
              "$mainMod, 0, workspace, 10"
              "$mainMod SHIFT, 1, movetoworkspace, 1"
              "$mainMod SHIFT, 2, movetoworkspace, 2"
              "$mainMod SHIFT, 3, movetoworkspace, 3"
              "$mainMod SHIFT, 4, movetoworkspace, 4"
              "$mainMod SHIFT, 5, movetoworkspace, 5"
              "$mainMod SHIFT, 6, movetoworkspace, 6"
              "$mainMod SHIFT, 7, movetoworkspace, 7"
              "$mainMod SHIFT, 8, movetoworkspace, 8"
              "$mainMod SHIFT, 9, movetoworkspace, 9"
              "$mainMod SHIFT, 0, movetoworkspace, 10"
              ",PRINT, exec, grimblast copy area"
              "$mainMod, PRINT, exec, grimblast copy screen"
            ];
            bindel = [
              ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
              ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
              ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
            ];
            bindl = [
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPause, exec, playerctl play-pause"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioPrev, exec, playerctl previous"
            ];
            # Ignore maximize requests from apps. You'll probably like this.
            windowrulev2 = "suppressevent maximize, class:.*";
          };
        };
      };
  };
}
