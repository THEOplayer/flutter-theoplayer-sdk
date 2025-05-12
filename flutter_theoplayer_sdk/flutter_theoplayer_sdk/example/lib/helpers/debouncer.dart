import 'dart:async';

import 'package:theoplayer/theoplayer.dart';

/// Used to workaround THEOlive's initial iOS stutter audio fix on the client-side.
/// The debouncer will unmute the player once the playback (and events) seems to be stabilized.

class DebounceManager {

  DebounceManager({required this.player,});

  final THEOplayer player;
  _Debouncer? _debouncer;

  void initialize() {
    player.addEventListener(PlayerEventTypes.PLAYING, _unMuteEventListener);
    player.theoLive?.addEventListener(PlayerEventTypes.SEEKED, _unMuteEventListener);

    player.theoLive?.addEventListener(PlayerEventTypes.SEEKING, _cancelDebouncerEventListener);
    player.addEventListener(PlayerEventTypes.WAITING, _cancelDebouncerEventListener);

    player.addEventListener(PlayerEventTypes.PAUSE, _resetDebouncerEventListener);
    player.addEventListener(PlayerEventTypes.SOURCECHANGE, _resetDebouncerEventListener);
  }

  void _unMuteEventListener(Event event) {
    print("[DEBOUNCER] ${DateTime.now()} unmute event received: ${event.type}");
    _debouncer?.call((){
      print("[DEBOUNCER] ${DateTime.now()} UNMUTE!!! (after ${event.type})");
      player.muted = false;
    });
  }

  void _cancelDebouncerEventListener(Event event) {
    print("[DEBOUNCER] ${DateTime.now()} cancel event received: ${event.type}");
    _debouncer?.cancel();
  }

  void _resetDebouncerEventListener(Event event) {
    print("[DEBOUNCER] ${DateTime.now()} reset event received: ${event.type}");
    _debouncer?.cancel();
    player.muted = true;
    _debouncer = _Debouncer(delay: _Debouncer.defaultHoldback);
    print("[DEBOUNCER] ${DateTime.now()} new Debouncer created, player muted");
  }

  void dispose() {
    player.removeEventListener(PlayerEventTypes.PLAYING, _unMuteEventListener);
    player.theoLive?.removeEventListener(PlayerEventTypes.SEEKED, _unMuteEventListener);

    player.theoLive?.removeEventListener(PlayerEventTypes.SEEKING, _cancelDebouncerEventListener);
    player.removeEventListener(PlayerEventTypes.WAITING, _cancelDebouncerEventListener);

    player.removeEventListener(PlayerEventTypes.PAUSE, _resetDebouncerEventListener);
    player.removeEventListener(PlayerEventTypes.SOURCECHANGE, _resetDebouncerEventListener);
  }
}

class _Debouncer {
  static const Duration defaultHoldback = Duration(milliseconds: 500);

  final Duration delay;
  Timer? _timer;
  bool _done = false;

  _Debouncer({required this.delay});

  void call(void Function() action) {
    if (_done) return;

    // Cancel any existing timer
    _timer?.cancel();

    // Create a new delayed task
    _timer = Timer(delay, () {
      _done = true;
      action();
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}