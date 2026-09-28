#!/bin/bash
set -euo pipefail

SOURCE_SHA="${1:?Usage: scripts/check_release_diff.sh SOURCE_SHA}"
changed_files=$(git diff --name-only "$SOURCE_SHA")

if [[ -z "$changed_files" ]]; then
  echo "::error::Release preparation produced no changes."
  exit 1
fi

while IFS= read -r path; do
  case "$path" in
    flutter_theoplayer_sdk/flutter_theoplayer_sdk/pubspec.yaml | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk/CHANGELOG.md | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/pubspec.yaml | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/CHANGELOG.md | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/android/build.gradle | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/pubspec.yaml | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/CHANGELOG.md | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/pubspec.yaml | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/CHANGELOG.md | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_web/pubspec.yaml | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk_web/CHANGELOG.md | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/android/app/build.gradle | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios/Podfile.lock | \
    flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web/theoplayer/*)
      ;;
    *)
      echo "::error::Unexpected release change: $path"
      exit 1
      ;;
  esac
done <<< "$changed_files"

git diff --check "$SOURCE_SHA"
