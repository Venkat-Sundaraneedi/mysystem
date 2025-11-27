{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-medium.yaml"; # everforest-dark-medium , everforest-dark-soft , horizon-dark , horizon-terminal-dark, sandcastle
  };

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

    firewall = {
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # enable = false;
    };

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    };
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
    xkb = {
      layout = "us";
      variant = "";
    };
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
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
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

  services.printing.enable = true;
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;

  services.kmonad = {
    enable = true;
    keyboards = {
      mykmonadoutput = {
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
    # === Build Tools & Compilers ===
    # cmake # Build system

    # === Development - Language Tools ===
    nodejs_24
    lua51Packages.lua # Lua interpreter
    luajitPackages.luarocks_bootstrap # Lua package manager

    # === Development - Version Control ===
    git # Version control
    lazygit # Git TUI

    # === Development - Project Tools ===
    repomix # Repository management

    # === Terminal & Shell ===
    zellij # Terminal multiplexer
    ghostty # Terminal emulator

    # === CLI - Modern Replacements ===
    nh # Nix helper
    jujutsu
    dust
    nix-output-monitor # Nix build output
    nvd # Nix version diff
    eza # ls → eza (with icons, git info)
    bat # cat → bat (syntax highlighting)
    ripgrep # grep → rg (faster)
    fd # find → fd (simpler, faster)
    zoxide # cd → z (smart jumps)
    discord

    # === CLI - Search & Navigation ===
    fzf # Fuzzy finder

    # === CLI - Text & Data Processing ===
    jq # JSON processor

    # === CLI - File Operations ===
    unzip # Archive extraction

    # === CLI - Network Tools ===
    wget # File downloader
    curl # HTTP client

    # === System Monitoring ===
    fastfetch # System info display
    btop # System monitor (better htop)
    nvtopPackages.nvidia # GPU monitor

    # === System Utilities ===
    lshw # Hardware lister
    pciutils # PCI utilities (lspci)
    wl-clipboard # Wayland clipboard utilities

    # === Containers & Virtualization ===
    lazydocker # Docker TUI

    # === Applications ===
    brave # Web browser

    # === AppImage Support ===
    appimage-run # Run AppImages on NixOS
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # gcc
      # gnumake
      # pkg-config
      # stdenv.cc.cc
      # zlib
      # openssl
      # openssl.dev
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellAliases = {};
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================

  nixpkgs.config.allowUnfree = true;

  nix = {
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

  system.stateVersion = "25.05";
}
