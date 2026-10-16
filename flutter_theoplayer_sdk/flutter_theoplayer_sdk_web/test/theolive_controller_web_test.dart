@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter_test/flutter_test.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_web/theolive/theolive_controller_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';

void main() {
  test('forwards numeric and missing fallback reason codes', () {
    final listeners = <String, JSFunction>{};
    final jsApi = <String, Object?>{}.jsify() as JSObject;
    jsApi['addEventListener'] = ((JSString type, JSFunction listener) {
      listeners[type.toDart] = listener;
    }).toJS;
    jsApi['removeEventListener'] = ((JSString type, JSFunction listener) {
      listeners.remove(type.toDart);
    }).toJS;

    final controller = THEOliveControllerWeb(jsApi as THEOplayerTheoLiveApi);
    final events = <IntentToFallbackEvent>[];
    final endpoints = <EndpointLoadedEvent>[];
    controller.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, (event) => events.add(event as IntentToFallbackEvent));
    controller.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, (event) => endpoints.add(event as EndpointLoadedEvent));

    for (final code in [13000, 6000, null]) {
      final event = {
        'reason': {'code': code, 'message': 'failover'},
      }.jsify() as JSObject;
      listeners[THEOliveApiEventTypes.INTENTTOFALLBACK]!.callAsFunction(null, event);
    }
    listeners[THEOliveApiEventTypes.INTENTTOFALLBACK]!.callAsFunction(null, <String, Object?>{}.jsify() as JSObject);
    listeners[THEOliveApiEventTypes.ENDPOINTLOADED]!.callAsFunction(
        null,
        {
          'endpoint': {'weight': 1, 'priority': 1},
        }.jsify() as JSObject);

    expect(events.map((event) => event.reason?.errorCode), ['13000', '6000', '', null]);
    expect(events.take(3).every((event) => event.reason?.errorMessage == 'failover'), isTrue);
    expect(endpoints.single.endpoint.priority, 1);
    controller.dispose();
  });
}
