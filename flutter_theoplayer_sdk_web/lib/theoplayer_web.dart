// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:collection';
import 'dart:html';
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theopalyer_config.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_platform_interface.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_view_controller_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the TheoplayerPlatform of the Theoplayer plugin.
class TheoplayerWeb extends TheoplayerPlatform {

  String viewType = 'com.theoplayer/theoplayer-view-native';
  String viewIDString = 'theoplayer_wrapper_';
  int theoViewUniqueID = 0;

  /// Constructs a TheoplayerWeb
  TheoplayerWeb() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId, {Object? params}) {

      final div = DivElement();
      div.id = (params as dynamic)["theoViewID"];
      div.className = 'theoplayer_wrapper';

      return div;
    });
  }

  static void registerWith(Registrar registrar) {
    TheoplayerPlatform.instance = TheoplayerWeb();
  }

  @override
  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback) {
    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{};

    theoViewUniqueID++;
    //generating and passing a unique ID instead of relying on THEOpalyer.players[0] by luck.
    final String generatedViewId = viewIDString + "_$theoViewUniqueID";
    creationParams["theoViewID"] = generatedViewId;

    creationParams["playerConfig"] = theoPlayerConfig.toJson();

    return HtmlElementView(viewType: viewType, creationParams: creationParams, onPlatformViewCreated: (id) {
        createdCallback(THEOplayerViewControllerWeb(id, generatedViewId, theoPlayerConfig));
      },
    );
  }
}
