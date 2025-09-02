import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:theoplayer_web/theoplayer_api_web.dart';

/// Helper utilities for JSArray operations in WASM-compatible way
class JSHelpers {
  /// Get the length of a JSArray<JSAny?>
  static int getJSArrayLength(JSArray<JSAny?> array) {
    return (array as JSObject)['length']! as int;
  }
  
  /// Get an item from JSArray<JSAny?> at a specific index
  static JSAny? getJSArrayItem(JSArray<JSAny?> array, int index) {
    return (array as JSObject)[index.toString()];
  }
  
  /// Convert List<String> to JSArray<JSAny?>
  static JSArray<JSAny?> stringListToJSArray(List<String> list) {
    final jsArray = <JSAny?>[].toJS;
    for (String item in list) {
      (jsArray as JSObject).callMethod('push'.toJS, item.toJS);
    }
    return jsArray;
  }
  
  /// Convert List of items to JSArray<JSAny?>
  static JSArray<JSAny?> jsItemsToJSArray(List<dynamic> list) {
    final jsArray = <JSAny?>[].toJS;
    for (dynamic item in list) {
      (jsArray as JSObject).callMethod('push'.toJS, item as JSAny);
    }
    return jsArray;
  }
  
  /// Convert JSArray<JSAny?> to List<T> where T is a JS interop type
  static List<T> jsArrayToList<T>(JSArray<JSAny?> jsArray) {
    final List<T> list = [];
    for (int i = 0; i < getJSArrayLength(jsArray); i++) {
      final item = getJSArrayItem(jsArray, i);
      if (item != null) {
        list.add(item as T);
      }
    }
    return list;
  }
}

/// Extension for THEOplayerArrayList to provide WASM-compatible access methods
extension THEOplayerArrayListHelpers<T> on THEOplayerArrayList<T> {
  /// Get an item safely from THEOplayerArrayList
  T getItem(int index) {
    return this.item(index) as T;
  }
  
  /// Get the length safely from THEOplayerArrayList
  int getLength() {
    return this.length;
  }
}

/// Extension for JSArray to provide WASM-compatible access methods
extension JSArrayHelpers on JSArray<JSAny?> {
  /// Get the length of the JSArray using property access
  int getLength() {
    return JSHelpers.getJSArrayLength(this);
  }
  
  /// Get an item from the JSArray at a specific index
  JSAny? getItem(int index) {
    return JSHelpers.getJSArrayItem(this, index);
  }
}