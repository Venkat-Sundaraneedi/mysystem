{ config, pkgs, ... }:

{
  hardware.nvidia-container-toolkit.enable = true;
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Docker Compose (v2, plugin-based)
  environment.systemPackages = with pkgs; [ docker-compose ];
}
