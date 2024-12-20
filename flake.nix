{
  description = "Launch Rayman Redemption";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:

    with flake-utils.lib;
    eachSystem allSystems (system:
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        makeWineWrapper = prog:
          pkgs.writeShellScriptBin "wine-wrapper-${
            builtins.replaceStrings [ "/" ":" "." ] [ "_" "_" "_" ] prog
          }" ''
            exec ${pkgs.wine}/bin/wine ${prog}
          '';

        wineApp = prog: {
          type = "app";
          program = "${makeWineWrapper prog}/bin/wine-wrapper-${
              builtins.replaceStrings [ "/" ":" "." ] [ "_" "_" "_" ] prog
            }";
        };
      in {

        apps = { default = wineApp "\"Rayman Redemption.exe\""; };

      });
}

