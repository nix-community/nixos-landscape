# SPDX-FileCopyrightText: 2023 Christina Sørensen
# SPDX-FileContributor: Christina Sørensen
#
# SPDX-License-Identifier: AGPL-3.0-only
{
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true; # nix
    statix.enable = true; # nix static analysis
    deadnix.enable = true; # find dead nix code
    rustfmt.enable = true; # rust
    taplo.enable = true; # toml
    yamlfmt.enable = true; # yaml
  };
  settings = {
    formatter = {
      taplo.excludes = ["src/*.toml"];
    };
  };
}
