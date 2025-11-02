#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $0 [output-dir] [tree-ish]

Creates libreslicer-<tree-ish>-src.zip in the output directory (default: dist).
When tree-ish is omitted, HEAD is used. The script verifies that mandatory
compliance documents are present in the resulting archive and emits a matching
SHA-256 file alongside it.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

out_dir=${1:-dist}
treeish=${2:-HEAD}

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip is required" >&2
  exit 1
fi

if ! command -v sha256sum >/dev/null 2>&1; then
  echo "sha256sum is required" >&2
  exit 1
fi

mkdir -p "$out_dir"

archive_basename="libreslicer-${treeish}-src.zip"
archive_path="${out_dir}/${archive_basename}"

rm -f "$archive_path"

git archive --format=zip --output="$archive_path" "$treeish"

required=(
  "LICENSE"
  "THIRD_PARTY_NOTICES.txt"
  "CREDITS.md"
  "COMPLIANCE/SOURCE_OFFER.md"
)

missing=()
for file in "${required[@]}"; do
  if ! unzip -l "$archive_path" "$file" >/dev/null 2>&1; then
    missing+=("$file")
  fi
done

if (( ${#missing[@]} )); then
  echo "Archive ${archive_path} is missing required files: ${missing[*]}" >&2
  exit 1
fi

checksum_file="${archive_path}.sha256"
sha256sum "$archive_path" > "$checksum_file"

echo "Wrote ${archive_path}"
echo "SHA-256 saved to ${checksum_file}"
