import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class AdEventTypes {
  static const AD_BEGIN = "adbegin";
  static const AD_END = "adend";
  static const AD_SKIP = "adskip";
  static const AD_ERROR = "aderror";
  static const AD_BREAK_BEGIN = "adbreakbegin";
  static const AD_BREAK_END = "adbreakend";
  static const AD_LOADED = "adloaded";
  static const AD_IMPRESSION = "adimpression";
  static const AD_FIRST_QUARTILE = "adfirstquartile";
  static const AD_THIRD_QUARTILE = "adthirdquartile";
  static const AD_MIDPOINT = "admidpoint";
  static const ADD_AD = "addad";
  static const ADD_AD_BREAK = "addadbreak";
  static const AD_BREAK_CHANGE = "adbreakchange";
  static const REMOVE_AD_BREAK = "removeadbreak";
  static const AD_TAPPED = "adtapped";
  static const AD_CLICKED = "adclicked";
}

// Ad events
abstract class _AdEvent extends Event {
  final Ad? ad;

  _AdEvent(this.ad, {required super.type});
}


class AdBeginEvent extends _AdEvent {
  AdBeginEvent(super.ad): super(type: AdEventTypes.AD_BEGIN);
}

// AdBreak events
abstract class _AdBreakEvent extends Event {
  final AdBreak? adBreak;

  _AdBreakEvent(this.adBreak, {required super.type});
}

class AdEndEvent extends _AdEvent {
  AdEndEvent(super.ad): super(type: AdEventTypes.AD_END);
}

class AdSkipEvent extends _AdEvent {
  AdSkipEvent(super.ad): super(type: AdEventTypes.AD_SKIP);
}

class AdErrorEvent extends _AdEvent {
  AdErrorEvent(super.ad): super(type: AdEventTypes.AD_ERROR);
}

class AdLoadedEvent extends _AdEvent {
  AdLoadedEvent(super.ad): super(type: AdEventTypes.AD_LOADED);
}

class AdImpressionEvent extends _AdEvent {
  AdImpressionEvent(super.ad): super(type: AdEventTypes.AD_IMPRESSION);
}

class AdFirstQuartileEvent extends _AdEvent {
  AdFirstQuartileEvent(super.ad): super(type: AdEventTypes.AD_FIRST_QUARTILE);
}

class AdThirdQuartileEvent extends _AdEvent {
  AdThirdQuartileEvent(super.ad): super(type: AdEventTypes.AD_THIRD_QUARTILE);
}

class AdMidpointEvent extends _AdEvent {
  AdMidpointEvent(super.ad): super(type: AdEventTypes.AD_MIDPOINT);
}

class AddAdEvent extends _AdEvent {
  AddAdEvent(super.ad): super(type: AdEventTypes.ADD_AD);
}

class AdTappedEvent extends _AdEvent {
  AdTappedEvent(super.ad): super(type: AdEventTypes.AD_TAPPED);
}

class AdClickedEvent extends _AdEvent {
  AdClickedEvent(super.ad): super(type: AdEventTypes.AD_CLICKED);
}

class AdBreakBeginEvent extends _AdBreakEvent {
  AdBreakBeginEvent(super.adBreak): super(type: AdEventTypes.AD_BREAK_BEGIN);
}

class AdBreakEndEvent extends _AdBreakEvent {
  AdBreakEndEvent(super.adBreak): super(type: AdEventTypes.AD_BREAK_END);
}

class AddAdBreakEvent extends _AdBreakEvent {
  AddAdBreakEvent(super.adBreak): super(type: AdEventTypes.ADD_AD_BREAK);
}

class AdBreakChangeEvent extends _AdBreakEvent {
  AdBreakChangeEvent(super.adBreak): super(type: AdEventTypes.AD_BREAK_CHANGE);
}

class RemoveAdBreakEvent extends _AdBreakEvent {
  RemoveAdBreakEvent(super.adBreak): super(type: AdEventTypes.REMOVE_AD_BREAK);
}
