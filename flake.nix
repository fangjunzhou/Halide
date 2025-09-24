{
  description = "Halide";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";
    };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    eachSystem [
      system.x86_64-linux
      system.x86_64-darwin
      system.aarch64-darwin
    ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default =
            pkgs.mkShell.override { stdenv = pkgs.llvmPackages_20.stdenv; }
              {
                buildInputs = with pkgs; [
                  # LLVM.
                  llvmPackages_20.llvm
                  llvmPackages_20.clang
                  llvmPackages_20.clang-unwrapped
                  llvmPackages_20.lld
                  # C++ development tools.
                  cmake
                  ninja
                  # Halide dependencies.
                  libffi
                  libxml2
                  flatbuffers
                  wabt
                  python3
                  pkgs.python3Packages.pybind11
                  doxygen
                  eigen
                  libpng
                  libjpeg
                  openblas
                ];

                shellHook = ''
                  export LLVM_ROOT="${pkgs.llvmPackages_20.llvm.dev}"
                '';
              };
        }
      );
}
