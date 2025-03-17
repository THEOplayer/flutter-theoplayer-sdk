import 'dart:collection';

import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class EventManager implements EventDispatcher {
  final Map<String, List<EventListener<Event>>> _eventListenerMap = HashMap();
  final List<EventListener<Event>> _allEventListenerList = List.empty(growable: true);

  void addEventListener(String eventType, EventListener<Event> listener) {
    if (!_eventListenerMap.containsKey(eventType) || _eventListenerMap[eventType] == null) {
      _eventListenerMap[eventType] = [];
    }

    _eventListenerMap[eventType]!.add(listener);
  }

  void addAllEventListener(EventListener<Event> listener) {
    _allEventListenerList.add(listener);
  }

  void removeAllEventListener(EventListener<Event> listener) {
    _allEventListenerList.remove(listener);
  }

  void removeEventListener(String eventType, EventListener<Event> listener) {
    if (_eventListenerMap.containsKey(eventType) && _eventListenerMap[eventType] != null) {
      _eventListenerMap[eventType]!.remove(listener);

      if (_eventListenerMap[eventType]!.isEmpty) {
        _eventListenerMap.remove(eventType);
      }
    }
  }

  void dispatchEvent(Event event) {
    _allEventListenerList.forEach((element) {
      element(event);
    });

    _eventListenerMap[event.type]?.forEach((element) {
      element(event);
    });
  }

  void clear() {
    _eventListenerMap.clear();
    _allEventListenerList.clear();
  }
}
