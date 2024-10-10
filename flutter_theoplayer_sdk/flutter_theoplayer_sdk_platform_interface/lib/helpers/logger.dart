import 'package:flutter/foundation.dart';

/// Wrapper around [print]
void debugLog(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

/// Wrapper around [print], use it to print user-facing messages (these will be visible in release mode too)
void printLog(Object? object){
  print(object);
}