{
  description = "My NixOS flake";

  # ============================================================================
  # INPUTS
  # ============================================================================

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  # ============================================================================
  # OUTPUTS
  # ============================================================================

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };

          modules = [
            # Core configuration
            ./nixos/configuration.nix

            # Hardware & drivers
            ./nixos/modules/nvidia.nix

            # Services
            ./nixos/modules/docker.nix
          ];
        };
      };
    };
}
