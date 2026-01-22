{
  description = "ConCal - Habit tracking calendar application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.sbcl
            pkgs.postgresql_16
            pkgs.docker-compose
            pkgs.openssl
          ];

          shellHook = ''
            export CL_SOURCE_REGISTRY="$PWD//"
            export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH"
            echo "ConCal development environment"
            echo ""
            echo "Commands:"
            echo "  docker-compose up -d   # Start PostgreSQL"
            echo "  sbcl                   # Start SBCL"
            echo ""
            echo "In SBCL:"
            echo "  (ql:quickload :concal)"
            echo "  (concal:start)"
          '';
        };
      });
}
