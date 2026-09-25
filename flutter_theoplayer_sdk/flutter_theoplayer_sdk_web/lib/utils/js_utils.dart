import 'dart:convert';
import 'dart:js_interop';

@JS('JSON.stringify')
external String? _jsonStringify(JSAny? obj);

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
