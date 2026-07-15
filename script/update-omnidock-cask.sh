#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT_DIR/script/omnidock.rb.in"
TARGET="$ROOT_DIR/Casks/omnidock.rb"

usage() {
  echo "Usage: $0 <release-zip> <version> <build-number>" >&2
}

[[ $# -eq 3 ]] || {
  usage
  exit 1
}

ARCHIVE="$1"
VERSION="$2"
BUILD_NUMBER="$3"

[[ -f "$ARCHIVE" ]] || {
  echo "Release archive not found: $ARCHIVE" >&2
  exit 1
}
[[ "$VERSION" =~ ^[0-9]+([.][0-9]+){1,2}$ ]] || {
  echo "Invalid version: $VERSION" >&2
  exit 1
}
[[ "$BUILD_NUMBER" =~ ^[1-9][0-9]*$ ]] || {
  echo "Invalid build number: $BUILD_NUMBER" >&2
  exit 1
}

EXPECTED_NAME="OmniDock-${VERSION}-build-${BUILD_NUMBER}.zip"
[[ "$(basename "$ARCHIVE")" == "$EXPECTED_NAME" ]] || {
  echo "Expected archive name: $EXPECTED_NAME" >&2
  exit 1
}

SHA256="$(shasum -a 256 "$ARCHIVE" | awk '{ print $1 }')"
TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/omnidock-cask.XXXXXX")"
trap 'rm -f "$TEMP_FILE"' EXIT

sed \
  -e "s/__VERSION__/$VERSION/g" \
  -e "s/__BUILD__/$BUILD_NUMBER/g" \
  -e "s/__SHA256__/$SHA256/g" \
  "$TEMPLATE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$TARGET"
trap - EXIT

echo "Updated $TARGET"
echo "SHA-256: $SHA256"
echo "Next: brew style Casks/omnidock.rb"
echo "Next: brew audit --cask --strict quanzhankeji/tap/omnidock"
