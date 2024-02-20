import 'package:theoplayer_platform_interface/theoplayer_events.dart';

typedef EventListener<Event> = void Function(Event event);

abstract interface class EventDispatcher {
  void addEventListener(String eventType, EventListener<Event> listener);

  void removeEventListener(String eventType, EventListener<Event> listener);
}
