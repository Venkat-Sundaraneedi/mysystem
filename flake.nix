{
  description = "My NixOS flake";

  # ============================================================================
  # INPUTS
  # ============================================================================

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # OUTPUTS
  # ============================================================================

  outputs = { nixpkgs, stylix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Core configuration
        ./nixos/configuration.nix

        # Hardware & drivers
        ./nixos/modules/nvidia.nix

        # Services
        ./nixos/modules/docker.nix

        stylix.nixosModules.stylix
      ];
    };
  };
}
