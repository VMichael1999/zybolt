#!/usr/bin/env bash
# Copia la clave de Google Maps del .env al xcconfig de iOS (ignorado por git).
# Android lee el .env directamente desde Gradle.
set -euo pipefail
cd "$(dirname "$0")/.."
KEY=$(grep -E '^EXPO_PUBLIC_GOOGLE_MAPS_API_KEY=' .env | head -1 | cut -d= -f2-)
printf 'GOOGLE_MAPS_API_KEY=%s\n' "$KEY" > ios/Flutter/Secrets.xcconfig
echo "ios/Flutter/Secrets.xcconfig actualizado"
