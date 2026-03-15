#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

nix flake update

if git diff --quiet -- flake.lock; then
  echo "No flake.lock changes after update; exiting."
  exit 0
fi

nix build .#nixosConfigurations.nixos.config.system.build.toplevel --print-build-logs

echo "Build completed. cachix-action will push built paths to Cachix via its post-build hook."

git add flake.lock
git commit -m "chore: update flake.lock"
git push origin HEAD:${GITHUB_REF_NAME:-main}
