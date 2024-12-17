class Ad {
  final String id;
  //Error: pigeons/pigeons_merged.dart:60: Generic type arguments must be nullable in field "companions" in class "Ad".
  final List<CompanionAd?> companions;
  final String? type;
  AdBreak? adBreak;
  final int skipOffset;
  final IntegrationKind integration;
  final String? customIntegration;
  Object? customData;

  Ad({required this.id, required this.companions, required this.type, required this.skipOffset, required this.integration, required this.customIntegration});
}

enum IntegrationKind {
  theoads,
  google_ima,
  google_dai,
  mediatailor,
  custom,
}

class CompanionAd {
  String adSlotId;
  String altText;
  String clickThrough;
  int height;
  int width;
  String resourceURI;
  String type;

  CompanionAd({required this.adSlotId, required this.altText, required this.clickThrough, required this.height, required this.width, required this.resourceURI, required this.type});

}

class AdBreak {
  //Error: pigeons/pigeons_merged.dart:93: Generic type arguments must be nullable in field "ads" in class "AdBreak".
  final List<Ad?> ads;
  int maxDuration;
  int maxRemainingDuration;
  int timeOffset;
  IntegrationKind integration;
  String? customIntegration;
  Object? customData;

  AdBreak({ required this.ads, required this.maxDuration, required this.maxRemainingDuration, required this.timeOffset, required this.integration});
}

class AdDescription {
  String adIntegration;

  AdDescription({required this.adIntegration});
}