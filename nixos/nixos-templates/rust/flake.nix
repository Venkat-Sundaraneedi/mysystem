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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [(import rust-overlay)];
    };
    naerskLib = pkgs.callPackage naersk {};
    # rustToolchain = pkgs.rust-bin.stable.latest.default;
    rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
  in {
    packages.${system}.default =
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

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (rust-bin.nightly.latest.default)
        bacon
        cargo-nextest
        cargo-audit
        cargo-udeps
        glib
        openssl
        pkg-config
        rust-analyzer
      ];

      # Optional: set environment variables
      # Uncomment if you are having issues with go to definitions
      # RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
    };
  };
}
