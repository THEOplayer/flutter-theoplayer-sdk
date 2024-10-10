import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

typedef TextureCreatedCallback = void Function(int textureId);
class TextureManager  {
  static var textureIds = <int>{};

  static Texture createTexture(int textureId, TextureCreatedCallback textureCreatedCallback) {
    if (!textureIds.contains(textureId)) {
      textureIds.add(textureId);
      SchedulerBinding.instance.addPostFrameCallback((_){
        //call the callback after the Texture is attach to the hierarchy
        textureCreatedCallback(textureId);
      });
    }
    return Texture(textureId: textureId);
  }

}