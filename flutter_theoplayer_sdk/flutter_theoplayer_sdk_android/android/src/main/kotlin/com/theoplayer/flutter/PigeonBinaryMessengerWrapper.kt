package com.theoplayer.flutter

import io.flutter.plugin.common.BinaryMessenger
import java.nio.ByteBuffer

// BinaryMessenger that proxies all calls to another BinaryMessenger,
// but with a suffix appended to the channel name.
// Different player instances use different suffixes to avoid channel name conflicts.

class PigeonBinaryMessengerWrapper(
  private val messenger: BinaryMessenger,
  private val channelSuffix: String,
) : BinaryMessenger {

  override fun send(channel: String, message: ByteBuffer?) {
    messenger.send("$channel/$channelSuffix", message)
  }

  override fun send(channel: String, message: ByteBuffer?, callback: BinaryMessenger.BinaryReply?) {
    messenger.send("$channel/$channelSuffix", message, callback)
  }

  override fun setMessageHandler(channel: String, handler: BinaryMessenger.BinaryMessageHandler?) {
    messenger.setMessageHandler("$channel/$channelSuffix", handler)
  }
}