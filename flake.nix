# SPDX-FileCopyrightText: 2023 Christina Sørensen
# SPDX-FileContributor: Christina Sørensen
#
# SPDX-License-Identifier: AGPL-3.0-only
{
  description = "rime:  Nix Flake Input Versioning";

  inputs = {
    flake-utils.url = "http://rime.cx/v1/github/semnix/flake-utils.tar.gz";
    nixpkgs.url = "http:/rime.cx/v1/github/NixOS/nixpkgs/b/nixpkgs-unstable.tar.gz";
    treefmt-nix.url = "http://rime.cx/v1/github/semnix/treefmt-nix.tar.gz";

    pre-commit-hooks = {
      url = "http://rime.cx/v1/github/semnix/pre-commit-hooks.nix.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    treefmt-nix,
    pre-commit-hooks,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in rec {
        # For `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # For `nix develop`:
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          nativeBuildInputs = with pkgs; [just reuse];
        };

        # For `nix flake check`
        checks = {
          pre-commit-check = let
            # some treefmt formatters are not supported in pre-commit-hooks we filter them out for now.
            toFilter =
              # HACK: This is a nice hack to not have to manually filter we should keep in mind for a future refactor.
              # Stolen from eza
              ["yamlfmt"];
            filterFn = n: _v: (!builtins.elem n toFilter);
            treefmtFormatters = pkgs.lib.mapAttrs (_n: v: {inherit (v) enable;}) (pkgs.lib.filterAttrs filterFn (import ./treefmt.nix).programs);
          in
            pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks =
                treefmtFormatters
                // {
                  convco.enable = true; # not in treefmt
                  reuse = {
                    enable = true;
                    name = "reuse";
                    entry = with pkgs; "${pkgs.reuse}/bin/reuse lint";
                    pass_filenames = false;
                  };
                };
            };
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
