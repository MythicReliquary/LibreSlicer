#!/usr/bin/env bash
set -euo pipefail

# Validate that rebrand remnants from "Aegis Slicer" are not present in the tree.
# Allowed references live in the historical rebrand notice and release notes.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

patterns=("Aegis Slicer" "AegisSlicer" "aegisslicer.org")

ignored=(
  "docs/REBRAND.md"
  "RELEASE_NOTES_v1.0.0.md"
  "scripts/verify_rebrand.sh"
)

ignore_args=()
for path in "${ignored[@]}"; do
  ignore_args+=("--glob" "!${path}")
done

found=0
for pattern in "${patterns[@]}"; do
  if rg --no-heading "${pattern}" . "${ignore_args[@]}" >/tmp/rebrand_hits.txt; then
    if [[ -s /tmp/rebrand_hits.txt ]]; then
      echo "Found legacy branding references for pattern '${pattern}':"
      cat /tmp/rebrand_hits.txt
      found=1
    fi
  fi
  : > /tmp/rebrand_hits.txt
done

if [[ $found -ne 0 ]]; then
  echo "\nRebrand verification failed. Please replace the legacy references above with 'LibreSlicer'." >&2
  exit 1
fi

echo "Rebrand verification passed: no legacy brand strings detected."
