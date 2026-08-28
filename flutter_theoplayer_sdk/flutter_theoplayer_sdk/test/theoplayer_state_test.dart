import 'package:flutter_test/flutter_test.dart';
import 'package:theoplayer/src/theoplayer_state.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';

class FakeViewController implements THEOplayerViewController {
  final EventManager _eventManager = EventManager();

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispatchEvent(Event event) {
    _eventManager.dispatchEvent(event);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeViewController viewController;
  late PlayerState playerState;

  setUp(() {
    viewController = FakeViewController();
    playerState = PlayerState();
    playerState.setViewController(viewController);
  });

  test('timeupdate populates currentProgramDateTime with millisecond precision', () {
    viewController.dispatchEvent(TimeUpdateEvent(currentTime: 12.5, currentProgramDateTime: 1756389661234));

    expect(playerState.currentProgramDateTime, DateTime.fromMillisecondsSinceEpoch(1756389661234));
  });

  test('timeupdate without a program-date-time clears currentProgramDateTime', () {
    viewController.dispatchEvent(TimeUpdateEvent(currentTime: 12.5, currentProgramDateTime: 1756389661234));
    viewController.dispatchEvent(TimeUpdateEvent(currentTime: 13.0, currentProgramDateTime: null));

    expect(playerState.currentProgramDateTime, isNull);
  });
}
