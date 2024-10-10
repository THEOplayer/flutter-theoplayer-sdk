// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_platform_interface.dart';
import 'package:theoplayer_web/theoplayer_view_controller_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

/// A web implementation of the TheoplayerPlatform of the Theoplayer plugin.
class TheoplayerWeb extends TheoplayerPlatform {
  String viewType = 'com.theoplayer/theoplayer-view-native';
  String viewIDString = 'theoplayer_wrapper_';
  int theoViewUniqueID = -1;

  /// Constructs a TheoplayerWeb
  TheoplayerWeb() {
    // ignore: undefined_prefixed_name

    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId, {Object? params}) {
      final div = document.createElement('div') as HTMLDivElement;
      div.id = (params as dynamic)["theoViewID"];
      div.className = 'theoplayer_wrapper';
      div.style.width = '100%';
      div.style.height = '100%';
      return div;
    });
  }

  static void registerWith(Registrar registrar) {
    TheoplayerPlatform.instance = TheoplayerWeb();
  }

  @override
  void initalize(THEOplayerConfig theoPlayerConfig, InitializeNativeResultCallback callback) {
    callback(TheoplayerPlatform.UNSUPPORTED_TEXTURE_ID);
  }

  @override
  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback, int textureId) {
    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{};

    theoViewUniqueID++;
    //generating and passing a unique ID instead of relying on THEOpalyer.players[0] by luck.
    final String generatedViewId = viewIDString + "_$theoViewUniqueID";
    creationParams["theoViewID"] = generatedViewId;

    creationParams["playerConfig"] = theoPlayerConfig.toJson();

    return HtmlElementView(
      viewType: viewType,
      creationParams: creationParams,
      onPlatformViewCreated: (id) {
        createdCallback(THEOplayerViewControllerWeb(id, ui.platformViewRegistry.getViewById(id) as HTMLElement, theoPlayerConfig), context);
      },
    );
  }
}
