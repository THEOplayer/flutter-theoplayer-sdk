#!/bin/bash

# Verifies that the CocoaPods and Swift Package Manager integrations use the same native THEOplayer SDK version.
# This catches incomplete native version updates before the Flutter plugin is built or released.

# Locate the dependency manifests relative to the repository root.
podspec="flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec"
package="flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios/Package.swift"

# Extract the THEOplayer core CocoaPods dependency version.
core_version=$(sed -n "s/.*s.dependency 'THEOplayerSDK-core', '\([^']*\)'.*/\1/p" "${podspec}")
# Extract the THEOlive CocoaPods integration dependency version.
theolive_version=$(sed -n "s/.*s.dependency 'THEOplayer-Integration-THEOlive', '\([^']*\)'.*/\1/p" "${podspec}")
# Extract the native Apple SDK Swift package dependency version.
swift_package_version=$(sed -n 's/.*theoplayer-sdk-apple.*, exact: "\([^"]*\)".*/\1/p' "${package}")

# Fail when a manifest no longer matches the expected format and its version cannot be extracted.
if [ -z "${core_version}" ] || [ -z "${theolive_version}" ] || [ -z "${swift_package_version}" ]
then
  echo "Unable to determine all iOS dependency versions." >&2
  exit 1
fi

# Fail when CocoaPods and SwiftPM would resolve different native SDK versions.
if [ "${core_version}" != "${theolive_version}" ] || [ "${core_version}" != "${swift_package_version}" ]
then
  echo "iOS dependency versions do not match:" >&2
  echo "THEOplayerSDK-core: ${core_version}" >&2
  echo "THEOplayer-Integration-THEOlive: ${theolive_version}" >&2
  echo "theoplayer-sdk-apple: ${swift_package_version}" >&2
  exit 1
fi

# Report the shared version for release and CI logs.
echo "iOS dependency versions are consistent: ${core_version}"
