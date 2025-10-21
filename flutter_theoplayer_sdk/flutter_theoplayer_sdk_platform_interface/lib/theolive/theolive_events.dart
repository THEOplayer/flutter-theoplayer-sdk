import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOliveApiEventTypes {
  static const DISTRIBUTIONLOADSTART = "distributionloadstart";
  static const ENDPOINTLOADED = "endpointloaded";
  static const DISTRIBUTIONOFFLINE = "distributionoffline";
  static const INTENTTOFALLBACK = "intenttofallback";
  static const ENTERBADNETWORKMODE = "enterbadnetworkmode";
  static const EXITBADNETWORKMODE = "exitbadnetworkmode";
}

class DistributionLoadStartEvent extends Event {
  final String distributionId;

  DistributionLoadStartEvent({required this.distributionId}) : super(type: THEOliveApiEventTypes.DISTRIBUTIONLOADSTART);
}

class EndpointLoadedEvent extends Event {
  final Endpoint endpoint;

  EndpointLoadedEvent({required this.endpoint}) : super(type: THEOliveApiEventTypes.ENDPOINTLOADED);
}

class DistributionOfflineEvent extends Event {
  final String distributionId;

  DistributionOfflineEvent({required this.distributionId}) : super(type: THEOliveApiEventTypes.DISTRIBUTIONOFFLINE);
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
