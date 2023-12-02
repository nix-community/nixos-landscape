# SPDX-FileCopyrightText: 2023 Christina Sørensen
# SPDX-FileContributor: Christina Sørensen
#
# SPDX-License-Identifier: AGPL-3.0-only

serve:
  ./landscape2 serve --landscape-dir build

build:
  ./landscape2 build --data-file data.yml --settings-file settings.yml --guide-file guide.yml --logos-path logos --output-dir build

container:
  docker image rm nixlang/landscape2:latest --force
  docker build -t nixlang/landscape2 -t ghcr.io/nixlang-wiki/nixos-landscape -t registry.digitalocean.com/rime/nixos-landscape --label org.opencontaienrs.image.source="https://github.com/nixlang-wiki/nixos-landscape" --label org.opencontaienrs.image.description="landscape of nix/nixos" --label org.opencontainers.image.license="AGPL-3.0" .

buildContainer:
  docker build -t nixlang/landscape2 -t ghcr.io/nixlang-wiki/nixos-landscape -t registry.digitalocean.com/rime/nixos-landscape --label org.opencontaienrs.image.source="https://github.com/nixlang-wiki/nixos-landscape" --label org.opencontaienrs.image.description="landscape of nix/nixos" --label org.opencontainers.image.license="AGPL-3.0" .

pushContainer:
  docker push ghcr.io/nixlang-wiki/nixos-landscape:latest

buildAndPushContainer:
  just buildContainer
  just pushContainer

run:
  docker run -p 8000:80 ghcr.io/nixlang-wiki/nixos-landscape:latest

deploy:
  just buildAndPushContainer
  kubectl rollout -n landscape restart statefulset landscape
