{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    naersk,
    rust-overlay,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Generate pkgs for each system
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };
  in {
    packages = forAllSystems (system: let
      pkgs = pkgsFor system;
      naerskLib = pkgs.callPackage naersk {};

      # rustToolchain = pkgs.rust-bin.stable.latest.default;
      rustToolchain =
        pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
    in {
      default =
        (naerskLib.override {
          cargo = rustToolchain;
          rustc = rustToolchain;
        }).buildPackage {
          src = ./.;
          nativeBuildInputs = [pkgs.pkg-config];
          buildInputs = [
            pkgs.glib
            pkgs.openssl
            # pkgs.sqlite
          ];
        };
    });

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
      rustToolchain = pkgs.rust-bin.nightly.latest.default;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rustToolchain
          rust-analyzer
          cargo-nextest
          cargo-audit
          bacon
          cargo-udeps

          pkg-config
          glib
          openssl
        ];

        # Optional: set environment variables
        # Uncomment if you are having issues with go to definitions
        # RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
      };
    });
  };
}
