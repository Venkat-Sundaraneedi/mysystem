{
  config,
  pkgs,
  ...
}: {
  # Load NVIDIA driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
    };

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Environment variables for NVIDIA
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Add nvidia-offload script for easy GPU switching
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # GPU monitoring
  ];
}
