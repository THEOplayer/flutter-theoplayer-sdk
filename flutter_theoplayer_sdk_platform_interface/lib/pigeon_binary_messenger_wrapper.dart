import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class PigeonBinaryMessengerWrapper implements BinaryMessenger {

  final BinaryMessenger _binaryMessenger;
  final String _channelSuffix;

  PigeonBinaryMessengerWrapper({required String suffix, BinaryMessenger? binaryMessenger})
      : _channelSuffix = suffix, _binaryMessenger = binaryMessenger ?? ServicesBinding.instance.defaultBinaryMessenger;

  @override
  Future<void> handlePlatformMessage(String channel, ByteData? data, ui.PlatformMessageResponseCallback? callback) {
      return _binaryMessenger.handlePlatformMessage("$channel/$_channelSuffix", data, callback);
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
      return _binaryMessenger.send("$channel/$_channelSuffix", message);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    _binaryMessenger.setMessageHandler("$channel/$_channelSuffix", handler);
  }

}