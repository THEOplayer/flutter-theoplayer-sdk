import 'package:pigeon/pigeon.dart';

// 1. run in the root folder: dart run build_runner build --delete-conflicting-outputs
//run in the root folder: flutter pub run pigeon --input pigeons/pigeons_merged.dart

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
