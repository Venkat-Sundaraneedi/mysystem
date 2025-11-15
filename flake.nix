{
  description = "My NixOS flake";

  # ============================================================================
  # INPUTS
  # ============================================================================

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix.url = "github:danth/stylix";
  };

  # ============================================================================
  # OUTPUTS
  # ============================================================================

  outputs = { nixpkgs, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
        };

        modules = [
          # Core configuration
          ./nixos/configuration.nix

          # Hardware & drivers
          ./nixos/modules/nvidia.nix

          # Services
          ./nixos/modules/docker.nix

          inputs.stylix.nixModules.stylix
        ];
      };
    };
}
