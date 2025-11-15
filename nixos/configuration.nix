{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
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

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
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

  # Enable the GNOME Desktop Environment.
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    fwupd.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    printing.enable = true;
    flatpak.enable = true;
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      #media-session.enable = true;
    };

    kmonad = {
      enable = true;
      keyboards = {
        mykmonadoutput = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ./kmonad/config.kbd;
        };
      };
    };

    openssh.enable = true;
  };

  fonts.fontconfig.enable = true;
  users.users.greed = {
    isNormalUser = true;
    description = "0xgsvs";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    # === Build Tools & Compilers ===
    gcc # C/C++ compiler (needed for cargo install)
    cmake # Build system
    pkg-config # Package config tool

    # === Development - Language Toolchains ===
    rustup # Rust toolchain manager
    nodejs_24 # Node.js runtime

    # === Development - Language Tools ===
    poetry # Python package/dependency manager
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
    nh
    nix-output-monitor
    nvd
    eza # ls → eza (with icons, git info)
    bat # cat → bat (syntax highlighting)
    ripgrep # grep → rg (faster)
    fd # find → fd (simpler, faster)
    zoxide # cd → z (smart jumps)

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

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        gcc
        gnumake
        pkg-config
        stdenv.cc.cc
        zlib
        openssl
        openssl.dev
      ];
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    fish = {
      enable = true;
      useBabelfish = true;
      shellAliases = { };
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  # Nix settings 
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  security.rtkit.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "25.05";

}
