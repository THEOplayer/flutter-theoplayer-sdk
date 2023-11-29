import 'dart:convert';
import 'dart:js';

String? jsObjectToJsonString(dynamic obj) { //LegacyJavaScriptObject
  if (obj == null) return null;
  return context['JSON'].callMethod('stringify', [obj]);
}

Map? jsObjectToDartMap(JsObject? obj) {
  if (obj == null) {
    return null;
  }

  var jsonString = jsObjectToJsonString(obj);
  if (jsonString == null) {
    return null;
  }

  return jsonDecode(jsonString);
}

JsObject dartObjectToJsObject(object) {
  return JsObject.jsify(object);
} 
