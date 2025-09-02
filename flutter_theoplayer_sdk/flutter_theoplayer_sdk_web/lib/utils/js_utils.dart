import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;

@JS('JSON.stringify')
external String? _jsonStringify(JSAny? obj);

@JS('JSON.parse')
external JSAny? _jsonParse(String jsonString);

String? jsObjectToJsonString(JSAny? obj) {
  if (obj == null) return null;
  return _jsonStringify(obj);
}

Map? jsObjectToDartMap(JSAny? obj) {
  if (obj == null) {
    return null;
  }

  var jsonString = jsObjectToJsonString(obj);
  if (jsonString == null) {
    return null;
  }

  return jsonDecode(jsonString);
}

JSAny dartObjectToJsObject(Object? object) {
  if (object == null) return null.jsify()!;
  return object.jsify()!;
}
