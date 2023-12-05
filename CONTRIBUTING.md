<!--
SPDX-FileCopyrightText: 2023 Christina Sørensen
SPDX-FileContributor: Christina Sørensen

SPDX-License-Identifier: AGPL-3.0-only
-->

# Contributing to NixOS Landscape

If you'd like to contribute to NixOS Landscape, there are several things you
should make sure to familiarize yourself with first.

- Code of conduct [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md)
- Usage of the [REUSE standard](https://reuse.software/)
- Requirement of conformance to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- Requirement of conformance to [Semantic Versioning](https://semver.org/)
- [Free and Open Source (FOSS) software](https://www.gnu.org/philosophy/free-sw.en.html)

## Hacking on NixOS Landscape

NixOS Landscape is a Nix project. Therefore, it is expected that you have a
version of Nix installed with the "experimental" feature flakes enabled.
Further, to make hacking on NixOS Landscape as easy as possible for yourself,
you'd do yourself a favor to install [direnv](https://direnv.net/) (but this is
optional).

When you enter the NixOS Landscape repository, if you have `direnv` installed,
you'll be prompted to allow it with `direnv allow`. Doing this will save you
from having to manually enter the development environment each time you open
the folder. If you don't have direnv installed however, you can run `nix
develop` in a pinch, to enter the direnv.

The development environment includes basic checks of conformance to
conventional commits, cargo clippy lints, REUSE compliance, and much more.

It also contains a pre-commit-hook making it a lot easier not to make potential
mistakes that will unnescesarrily delay getting your PRs accepted.

## Changing the landscape

If you have either allowed direnv or ran `nix develop` in the repository, you
should have everything you need to add to the landscape.

There are a few files of interest.

- `data.yml`: where individual projects are added.
- `guide-yml`: where guide information is added.
- `settings.yml`: where things such as major categories and tags are added.

Most changes to the landscape will happen in `data.yml`.

### Testing Changes

To test your additons, you'll have to first rebuild the landscape and then
serve it.

To build it, run `just build`, then follow that with `just serve` to launch 
a local instance of the landscape.

Please check the launched webapp and make sure that your changes render
properly, and that you haven't broken anything.

## Before submitting a PR

Please make sure that the thing you worked on... actually works. Make sure to
also add how you ensured this in the PR description. Further, it's expected
that you do your best to check for regressions. We currently don't have any
test suite, so you'll have to use your best judgment. 

Before submitting, you MUST have run `nix flake check` and ensured that all
issues are addressed. For formatting issues, `nix fmt` will format the code for
you. If you have reuse issues, you can run the following command to annotate
your code:

```
reuse annotate --license AGPL-3.0-only --contributor "<Your name>" --copyright "<Your name>" <file(s) you'd like to annotate>
```

For certain binary files or files that can't easily contain comments for
whatever reason, the `--force-dot-license` can help.

Remeber that no one here is an employee, and treat everyone with respect, as
the code of conduct specifies. Also remember to be patient if it takes a while
to get a response on your PR. Usually it doesn't, but there's only so many
hours in a day, and if possible, there would be no delay. The delay alone is
evidence of it's own nescessity.

---

Have fun hacking on NixOS Landscape!
