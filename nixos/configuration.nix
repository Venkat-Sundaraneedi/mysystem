{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # ============================================================================
  # BOOT & KERNEL
  # ============================================================================

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # ============================================================================
  # NETWORKING
  # ============================================================================

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ ];
    # firewall.allowedUDPPorts = [ ];
  };

  # ============================================================================
  # LOCALIZATION
  # ============================================================================

  time.timeZone = "Asia/Kolkata";

  i18n = {
    defaultLocale = "en_IN";
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

  # ============================================================================
  # DISPLAY SERVER & DESKTOP ENVIRONMENT
  # ============================================================================

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # ============================================================================
  # AUDIO
  # ============================================================================

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    # jack.enable = true;
  };

  # ============================================================================
  # HARDWARE
  # ============================================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================================================
  # SERVICES
  # ============================================================================

  services = {
    printing.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    openssh.enable = true;

    kmonad = {
      enable = true;
      keyboards.mykmonadoutput = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ./kmonad/config.kbd;
      };
    };
  };

  # ============================================================================
  # FONTS
  # ============================================================================

  fonts.fontconfig.enable = true;

  # ============================================================================
  # USERS
  # ============================================================================

  users.users.greed = {
    isNormalUser = true;
    description = "0xgsvs";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Development - Languages & Runtimes
    nodejs_24
    lua51Packages.lua
    luajitPackages.luarocks_bootstrap

    # Development - Version Control
    git
    difftastic
    lazygit
    jujutsu
    jjui

    # Development - Tools
    repomix

    # Terminal & Multiplexers
    ghostty
    zellij

    # CLI - Modern Alternatives
    eza # ls replacement
    bat # cat replacement
    ripgrep # grep replacement
    fd # find replacement
    zoxide # cd replacement
    dust # du replacement

    # CLI - Search & Text Processing
    fzf
    jq

    # CLI - File Operations
    unzip

    # CLI - Network Tools
    wget
    curl

    # System Monitoring
    fastfetch
    btop
    # nvtopPackages.nvidia

    # System Utilities
    lshw
    stow
    pciutils
    wl-clipboard

    # Nix Helpers
    nh
    nix-output-monitor
    nvd

    television
    nix-search-tv

    mise
    usage

    #LSP's
    nil

    # Containers
    lazydocker

    # Applications
    brave
    discord
    appimage-run
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs = {
    nix-ld = {
      enable = true;
      # libraries = with pkgs; [
      #   gcc gnumake pkg-config stdenv.cc.cc
      #   zlib openssl openssl.dev
      # ];
    };

    direnv = {
      enable = true;
      package = pkgs.direnv;
      silent = true;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    fish = {
      enable = true;
      useBabelfish = true;
      shellAliases = {
        devshell = "nix shell nixpkgs#glib nixpkgs#openssl nixpkgs#gcc nixpkgs#gnumake nixpkgs#pkg-config nixpkgs#stdenv.cc.cc nixpkgs#zlib nixpkgs#openssl.dev";
      };
    };

    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================

  nixpkgs.config.allowUnfree = true;

  nix = {
    registry.templates = {
      from = {
        type = "indirect";
        id = "templates";
      };
      to = {
        type = "path";
        path = "/home/greed/mysystem/nixos/nixos-templates/";
      };
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # ============================================================================
  # SYSTEM
  # ============================================================================

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.stateVersion = "25.11";
}
