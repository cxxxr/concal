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

            # Install mallet if not present
            if ! command -v mallet &> /dev/null; then
              MALLET_BIN="$HOME/.local/bin/mallet"
              if [ ! -f "$MALLET_BIN" ]; then
                echo "Installing mallet linter..."
                mkdir -p "$HOME/.local/bin"
                sbcl --non-interactive \
                  --eval '(ql:quickload :mallet)' \
                  --eval '(sb-ext:save-lisp-and-die "'"$MALLET_BIN"'" :toplevel #'"'"'mallet:main :executable t :compression t)' \
                  2>/dev/null && echo "mallet installed to $MALLET_BIN" || echo "mallet installation skipped (run manually if needed)"
              fi
              export PATH="$HOME/.local/bin:$PATH"
            fi

            echo "ConCal development environment"
            echo ""
            echo "Commands:"
            echo "  docker-compose up -d   # Start PostgreSQL"
            echo "  sbcl                   # Start SBCL"
            echo "  mallet src/            # Run linter"
            echo ""
            echo "In SBCL:"
            echo "  (ql:quickload :concal)"
            echo "  (concal:start)"
          '';
        };
      });
}
