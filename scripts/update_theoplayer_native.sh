#!/bin/bash

update_theoplayer_android() {
  if [ -z "${ANDROID}" ]
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
  if [ -z "${IOS}" ]
  then
    echo "iOS version not specified, skipping."
  else
    echo "Updating THEOplayer iOS SDK to: ${IOS}"

    sed -i '' "s/s.dependency 'THEOplayerSDK-core', '.*/s.dependency 'THEOplayerSDK-core', '${IOS}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec
    sed -i '' "s/s.dependency 'THEOplayer-Integration-THEOlive', '.*/s.dependency 'THEOplayer-Integration-THEOlive', '${IOS}'/g" flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec
    pod update THEOplayerSDK-core --project-directory=flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios
    pod update THEOplayer-Integration-THEOlive --project-directory=flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios
    pod install --repo-update --project-directory=flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios
  fi
  echo ""
}

update_theoplayer_web() {
  if [ -z "${WEB}" ]
  then
    echo "Web version not specified, skipping."
  else
    echo "Updating THEOplayer Web SDK to: ${WEB}"

    URL="https://registry.npmjs.org/theoplayer/-/theoplayer-${WEB}.tgz"
    echo "Fetching the package from ${URL}"
    curl -s ${URL} | tar -C flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web/  -xvz --exclude='README.md' --exclude='package.json' --strip-components=1
  fi
  echo ""
}


while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--android)
    # THEOplayer Android SDK version
    ANDROID="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--ios)
    # THEOplayer iOS SDK version
    IOS="$2"
    shift # past argument
    shift # past value
    ;;
    -w|--web)
    # THEOplayer Web SDK version
    WEB="$2"
    shift # past argument
    shift # past value
    ;;
    --all)
    # THEOplayer Android, iOS, Web SDKs version
    ANDROID="$2"
    IOS="$2"
    WEB="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

echo "Updating THEOplayer SDKs:"
echo "ANDROID   = ${ANDROID}"
echo "iOS       = ${IOS}"
echo "WEB       = ${WEB}"
echo ""

update_theoplayer_android
update_theoplayer_ios
update_theoplayer_web
exit 0
