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
  final String channelId;

  DistributionLoadStartEvent({required this.channelId}) : super(type: THEOliveApiEventTypes.DISTRIBUTIONLOADSTART);
}

class EndpointLoaded extends Event {
  final Endpoint endpoint;

  EndpointLoaded({required this.endpoint}) : super(type: THEOliveApiEventTypes.ENDPOINTLOADED);
}

class DistributionOfflineEvent extends Event {
  final String channelId;

  DistributionOfflineEvent({required this.channelId}) : super(type: THEOliveApiEventTypes.DISTRIBUTIONOFFLINE);
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
