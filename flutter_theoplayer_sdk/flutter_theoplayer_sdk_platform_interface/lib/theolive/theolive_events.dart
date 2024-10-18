import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOliveApiEventTypes {
  static const PUBLICATIONLOADSTART = "publicationloadstart";
  static const PUBLICATIONLOADED = "publicationloaded";
  static const PUBLICATIONOFFLINE = "publicationoffline";
  static const INTENTTOFALLBACK = "intenttofallback";
  static const ENTERBADNETWORKMODE = "enterbadnetworkmode";
  static const EXITBADNETWORKMODE = "exitbadnetworkmode";
}

class PublicationLoadStartEvent extends Event {
  final String publicationId;

  PublicationLoadStartEvent({required this.publicationId}) : super(type: THEOliveApiEventTypes.PUBLICATIONLOADSTART);
}

class PublicationLoadedEvent extends Event {
  final String publicationId;

  PublicationLoadedEvent({required this.publicationId}) : super(type: THEOliveApiEventTypes.PUBLICATIONLOADED);
}

class PublicationOfflineEvent extends Event {
  final String publicationId;

  PublicationOfflineEvent({required this.publicationId}) : super(type: THEOliveApiEventTypes.PUBLICATIONOFFLINE);
}

class IntentToFallbackEvent extends Event {
  IntentToFallbackEvent() : super(type: THEOliveApiEventTypes.INTENTTOFALLBACK);
}

class EnterBadNetworkModeEvent extends Event {
  EnterBadNetworkModeEvent() : super(type: THEOliveApiEventTypes.ENTERBADNETWORKMODE);
}

class ExitBadNetworkModeEvent extends Event {
  ExitBadNetworkModeEvent() : super(type: THEOliveApiEventTypes.EXITBADNETWORKMODE);
}
