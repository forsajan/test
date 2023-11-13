{
  description = "test shell";

  inputs = {
    nixpkgs = {
      url = github:NixOS/nixpkgs/nixpkgs-unstable;
    };

    flake-utils = {
      url = github:numtide/flake-utils;
    };
  }

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:

        let
          pkgs = nixpkgs.legacyPackages.${system};
          
          inherit (pkgs.stdenv) isDarwin mkDerivation;
          inherit (pkgs.lib.lists) optionals;
          inherit (pkgs.lib.strings) optionalString;

          #global
          global-pkgs = with pkgs; [
            yarn
            nodejs_18
            openssl
            bun
            gh
            pkgs.go-task
          ];

          global-shellHook =
            ''
              # required for fastlane
              export PATH=./node_modules/.bin:$PATH
              export LANG=en_US.UTF-8
              export TASK_X_REMOTE_TASKFILES=1
            '';

          in
          {
            devShells.default = pkgs.mkShell {
              buildInputs = global-pkgs;
              shellHook = global-shellHook;
            };
          });
}
