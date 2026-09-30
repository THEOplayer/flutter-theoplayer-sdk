package com.theoplayer.flutter

import com.theoplayer.android.api.util.Logger
import com.theoplayer.flutter.pigeon.DebugFlagPigeon
import com.theoplayer.flutter.pigeon.THEOplayerNativeDebugFlagsAPI
import io.flutter.plugin.common.BinaryMessenger

class DebugFlagsBridge(
    private val binaryMessenger: BinaryMessenger,
    private val messageChannelSuffix: String,
    private val logger: Logger
) : THEOplayerNativeDebugFlagsAPI {

    init {
        THEOplayerNativeDebugFlagsAPI.setUp(binaryMessenger, this, messageChannelSuffix)
    }

    fun dispose() {
        THEOplayerNativeDebugFlagsAPI.setUp(binaryMessenger, null, messageChannelSuffix)
    }

    // MARK: - THEOplayerNativeDebugFlagsAPI

    override fun getAvailableFlags(): List<DebugFlagPigeon> {
        return logger.availableTags().map { tag ->
            DebugFlagPigeon(
                key = tag,
                description = tag,
                defaultValue = false,
                isEnabled = logger.isTagEnabled(tag)
            )
        }
    }

    override fun enableFlag(key: String) {
        logger.enableTags(key)
    }

    override fun disableFlag(key: String) {
        logger.disableTags(key)
    }

    override fun enableAll() {
        logger.enableAllTags()
    }

    override fun disableAll() {
        logger.disableAllTags()
    }

    override fun resetAll() {
        logger.disableAllTags()
    }

    override fun enableFileLogging() {
        // No-op on Android — file logging is iOS-only.
    }
}
