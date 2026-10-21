#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

update_theoplayer_android() {
  if [ -z "${ANDROID:-}" ]
  then
    echo "Android version not specified, skipping."
  else
    echo "Updating THEOplayer Android SDK to: ${ANDROID}"

    sed -i '' "s/def theoplayerVersion =.*/def theoplayerVersion ='${ANDROID}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/android/build.gradle
    sed -i '' "s/def theoplayerVersion =.*/def theoplayerVersion ='${ANDROID}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/android/app/build.gradle
  fi
  echo ""
}

update_theoplayer_ios() {
  if [ -z "${IOS:-}" ]
  then
    echo "iOS version not specified, skipping."
  else
    echo "Updating THEOplayer iOS SDK to: ${IOS}"

    sed -i '' "s/s.dependency 'THEOplayerSDK-core', '.*/s.dependency 'THEOplayerSDK-core', '${IOS}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec
    sed -i '' "s/s.dependency 'THEOplayer-Integration-THEOlive', '.*/s.dependency 'THEOplayer-Integration-THEOlive', '${IOS}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec
    (cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example && flutter pub get)
    pod update THEOplayerSDK-core THEOplayer-Integration-THEOlive --project-directory=flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios
  fi
  echo ""
}

update_theoplayer_web() {
  if [ -z "${WEB:-}" ]
  then
    echo "Web version not specified, skipping."
  else
    echo "Updating THEOplayer Web SDK to: ${WEB}"

    url="https://registry.npmjs.org/theoplayer/-/theoplayer-${WEB}.tgz"
    echo "Fetching the package from ${url}"
    (
      target="$PWD/flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web/theoplayer"
      staging=$(mktemp -d "$PWD/flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web/.theoplayer.XXXXXX")
      trap 'rm -f "$staging"/*; rmdir "$staging"' EXIT
      curl -fLsS "${url}" | tar -C "$staging" -xz --exclude='README.md' --exclude='package.json' --strip-components=1
      if ! diff -u <(ls -A "$target") <(ls -A "$staging"); then
        echo "Web SDK file list changed; review the bundle before updating" >&2
        exit 1
      fi
      for file in "$staging"/*; do mv "$file" "$target/"; done
    )
  fi
  echo ""
}


[[ $# -gt 0 ]] || { echo "Specify --all, --android, --ios, or --web and a version" >&2; exit 1; }

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--android)
    # THEOplayer Android SDK version
    [[ $# -ge 2 ]] || { echo "Missing Android version" >&2; exit 1; }
    ANDROID="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--ios)
    # THEOplayer iOS SDK version
    [[ $# -ge 2 ]] || { echo "Missing iOS version" >&2; exit 1; }
    IOS="$2"
    shift # past argument
    shift # past value
    ;;
    -w|--web)
    # THEOplayer Web SDK version
    [[ $# -ge 2 ]] || { echo "Missing Web version" >&2; exit 1; }
    WEB="$2"
    shift # past argument
    shift # past value
    ;;
    --all)
    # THEOplayer Android, iOS, Web SDKs version
    [[ $# -ge 2 ]] || { echo "Missing SDK version" >&2; exit 1; }
    ANDROID="$2"
    IOS="$2"
    WEB="$2"
    shift # past argument
    shift # past value
    ;;
    *)
    echo "Unknown option: $key" >&2
    exit 1
    ;;
esac
done

for version in "${ANDROID:-}" "${IOS:-}" "${WEB:-}"; do
  if [[ -n "$version" && ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid SDK version: $version" >&2
    exit 1
  fi
done

echo "Updating THEOplayer SDKs:"
echo "ANDROID   = ${ANDROID:-}"
echo "iOS       = ${IOS:-}"
echo "WEB       = ${WEB:-}"
echo ""

update_theoplayer_android
update_theoplayer_ios
update_theoplayer_web
exit 0
