import 'package:pigeon/pigeon.dart';

// run in the `flutter_theoplayer_sdk_platform_interface` folder:
// dart run build_runner build --delete-conflicting-outputs

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/apis.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: '../flutter_theoplayer_sdk_android/android/src/main/kotlin/com/theoplayer/flutter/pigeon/APIs.g.kt',
  kotlinOptions: KotlinOptions(
      package: 'com.theoplayer.flutter.pigeon'
  ),
  swiftOut: '../flutter_theoplayer_sdk_ios/ios/Classes/pigeon/APIs.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'theoplayer_platform_interface',
))
