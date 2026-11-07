#!/usr/bin/env bash
#
# Builds signed release APKs of Veronica, one per ABI.
#
# Reads the keystore and passwords from .env at the repo root (gitignored;
# see .env.example). The keystore is stored there base64-encoded. This
# script decodes it to a temporary file for the build only and deletes it
# afterwards. Nothing secret is printed.
#
# android/app/build.gradle.kts reads the VERONICA_KEYSTORE_FILE,
# VERONICA_KEYSTORE_PASSWORD, VERONICA_KEY_PASSWORD and VERONICA_KEY_ALIAS
# variables this script exports. Without them, release builds use the
# debug key.
#
# Usage: ./build_signed.sh
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$REPO/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "No .env at $ENV_FILE. Copy .env.example to .env and fill it in." >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${VERONICA_KEYSTORE_BASE64:?Missing VERONICA_KEYSTORE_BASE64 in .env}"
: "${VERONICA_KEYSTORE_PASSWORD:?Missing VERONICA_KEYSTORE_PASSWORD in .env}"
VERONICA_KEY_PASSWORD="${VERONICA_KEY_PASSWORD:-$VERONICA_KEYSTORE_PASSWORD}"
VERONICA_KEY_ALIAS="${VERONICA_KEY_ALIAS:-upload}"

TMP_KEYSTORE="$(mktemp -t veronica-release-XXXXXX.jks)"
trap 'rm -f "$TMP_KEYSTORE"' EXIT
printf '%s' "$VERONICA_KEYSTORE_BASE64" | base64 -d > "$TMP_KEYSTORE"

export VERONICA_KEYSTORE_FILE="$TMP_KEYSTORE"
export VERONICA_KEYSTORE_PASSWORD VERONICA_KEY_PASSWORD VERONICA_KEY_ALIAS

echo "Building signed release APKs (alias: $VERONICA_KEY_ALIAS)"
( cd "$REPO" && flutter build apk --release --split-per-abi )

echo "Done: build/app/outputs/flutter-apk/app-*-release.apk"
