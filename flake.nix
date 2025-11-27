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

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # Core configuration
        ./nixos/configuration.nix

        # Hardware & drivers
        ./nixos/modules/nvidia.nix

        # Services
        ./nixos/modules/docker.nix

        # Stylix
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
