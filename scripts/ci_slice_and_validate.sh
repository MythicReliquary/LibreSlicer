#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

find_first_executable() {
  for candidate in "$@"; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

if [[ -z "${PRUSA_CLI:-}" ]]; then
  if DEFAULT_PRUSA_CLI="$(find_first_executable \
      "$ROOT_DIR/build/src/libreslicer.exe" \
      "$ROOT_DIR/build/src/libreslicer" \
      "$ROOT_DIR/build/src/LibreSlicer.exe" \
      "$ROOT_DIR/build/src/LibreSlicer" \
      "$ROOT_DIR/tools/libreslicer.AppImage" \
      "$ROOT_DIR/tools/LibreSlicer.AppImage" \
      "$ROOT_DIR/tools/LibreSlicer.AppImage")"
  then
    PRUSA_CLI="$DEFAULT_PRUSA_CLI"
  else
    PRUSA_CLI="$ROOT_DIR/tools/LibreSlicer.AppImage"
  fi
fi

if [[ -z "${UVTOOLS_CLI:-}" ]]; then
  if DEFAULT_UVTOOLS_CLI="$(find_first_executable \
      "$ROOT_DIR/tools/uvtools.exe" \
      "$ROOT_DIR/tools/UVTools.exe" \
      "$ROOT_DIR/tools/uvtools.AppImage" \
      "$ROOT_DIR/tools/UVtools.AppImage" \
      "$ROOT_DIR/tools/UVTools.AppImage")"
  then
    UVTOOLS_CLI="$DEFAULT_UVTOOLS_CLI"
  else
    UVTOOLS_CLI="$ROOT_DIR/tools/uvtools.AppImage"
  fi
fi

PRINTER_PROFILE="${PRINTER_PROFILE:-$ROOT_DIR/ci_profiles/mars5_printer.ini}"
PRINT_PROFILE="${PRINT_PROFILE:-$ROOT_DIR/ci_profiles/mars5_print_0.05mm.ini}"
RESIN_PROFILE="${RESIN_PROFILE:-$ROOT_DIR/ci_profiles/mars5_resin_siraya.ini}"
AA_LEVEL="0"
VARIANT_TAG="default"
OUTPUT_DIR="$ROOT_DIR/out"
STL_PATH=""
declare -a PRUSA_SET_ARGS=()

usage() {
  cat <<USAGE
Usage: $(basename "$0") --stl <path> [options]

Options:
  --stl PATH             STL to slice (required)
  --aa LEVEL             Anti-aliasing factor (0, 2, 4)
  --variant NAME         Label appended to output artifacts
  --outdir PATH          Output directory (default: $ROOT_DIR/out)
  --printer-profile PATH Override printer profile ini
  --print-profile PATH   Override print profile ini
  --resin-profile PATH   Override resin profile ini
  --set KEY=VALUE        Append a '--set KEY=VALUE' override when invoking LibreSlicer
  -h, --help             Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stl)
      STL_PATH="$(realpath "$2")"
      shift 2
      ;;
    --aa)
      AA_LEVEL="$2"
      shift 2
      ;;
    --variant)
      VARIANT_TAG="$2"
      shift 2
      ;;
    --outdir)
      OUTPUT_DIR="$(realpath "$2")"
      shift 2
      ;;
    --printer-profile)
      PRINTER_PROFILE="$(realpath "$2")"
      shift 2
      ;;
    --print-profile)
      PRINT_PROFILE="$(realpath "$2")"
      shift 2
      ;;
    --resin-profile)
      RESIN_PROFILE="$(realpath "$2")"
      shift 2
      ;;
    --set)
      PRUSA_SET_ARGS+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$STL_PATH" ]]; then
  echo "Missing required --stl argument" >&2
  usage >&2
  exit 1
fi

if [[ ! -x "$PRUSA_CLI" ]]; then
  echo "LibreSlicer CLI not found or not executable: $PRUSA_CLI" >&2
  exit 1
fi

if [[ ! -x "$UVTOOLS_CLI" ]]; then
  echo "UVTools CLI not found or not executable: $UVTOOLS_CLI" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR" "$OUTPUT_DIR/reports" "$OUTPUT_DIR/previews" "$OUTPUT_DIR/intermediate"

BASENAME="$(basename "${STL_PATH%.stl}")"
VARIANT_SUFFIX="${VARIANT_TAG// /_}"
SL1_PATH="$OUTPUT_DIR/intermediate/${BASENAME}_${VARIANT_SUFFIX}.sl1"
CTB_PATH="$OUTPUT_DIR/${BASENAME}_${VARIANT_SUFFIX}.ctb"
REPORT_PATH="$OUTPUT_DIR/reports/${BASENAME}_${VARIANT_SUFFIX}_uvtools.txt"
PREVIEW_PATH="$OUTPUT_DIR/previews/${BASENAME}_${VARIANT_SUFFIX}.png"

prusa_args=(
  --no-splash
  --export-sla
  --load "$PRINTER_PROFILE"
  --load "$PRINT_PROFILE"
  --load "$RESIN_PROFILE"
  --set "anti_aliasing=$AA_LEVEL"
  --output "$SL1_PATH"
)

for set_arg in "${PRUSA_SET_ARGS[@]}"; do
  prusa_args+=(--set "$set_arg")
done

prusa_args+=("$STL_PATH")

"$PRUSA_CLI" "${prusa_args[@]}"

"$UVTOOLS_CLI" headless \
  --input "$SL1_PATH" \
  --export "$CTB_PATH" \
  --analyze \
  --fix \
  --report "$REPORT_PATH"

if [[ ! -s "$PREVIEW_PATH" ]]; then
  if command -v magick >/dev/null 2>&1; then
    magick -size 1200x800 gradient:black-white "$PREVIEW_PATH"
  elif command -v convert >/dev/null 2>&1; then
    convert -size 1200x800 gradient:black-white "$PREVIEW_PATH"
  else
    python3 "$ROOT_DIR/scripts/create_blank_preview.py" "$PREVIEW_PATH"
  fi
fi

echo "Sliced $STL_PATH -> $CTB_PATH (AA=$AA_LEVEL)"
