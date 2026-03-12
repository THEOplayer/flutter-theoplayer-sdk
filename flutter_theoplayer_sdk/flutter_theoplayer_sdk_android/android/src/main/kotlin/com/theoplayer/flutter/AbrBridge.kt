package com.theoplayer.flutter

import com.theoplayer.android.api.player.Player
import com.theoplayer.android.api.abr.AbrStrategyConfiguration
import com.theoplayer.android.api.abr.AbrStrategyMetadata
import com.theoplayer.android.api.abr.AbrStrategyType
import com.theoplayer.flutter.pigeon.AbrStrategyConfigurationPigeon
import com.theoplayer.flutter.pigeon.AbrStrategyMetadataPigeon
import com.theoplayer.flutter.pigeon.AbrStrategyTypePigeon
import com.theoplayer.flutter.pigeon.THEOplayerNativeAbrAPI

class AbrBridge(
    private val pigeonMessenger: PigeonBinaryMessengerWrapper,
    private val player: Player
) : THEOplayerNativeAbrAPI {

    init {
        THEOplayerNativeAbrAPI.setUp(pigeonMessenger, this)
    }

    fun dispose() {
        THEOplayerNativeAbrAPI.setUp(pigeonMessenger, null)
    }

    // MARK: - THEOplayerNativeAbrAPI

    override fun getAbrStrategy(): AbrStrategyConfigurationPigeon {
        val native = player.abr.abrStrategy
        return AbrStrategyConfigurationPigeon(
            type = toPigeonType(native.type),
            metadata = native.metadata?.let { meta ->
                AbrStrategyMetadataPigeon(bitrate = meta.bitrate?.toLong())
            }
        )
    }

    override fun setAbrStrategy(config: AbrStrategyConfigurationPigeon) {
        val metadata = config.metadata?.bitrate?.let { bitrate ->
            AbrStrategyMetadata(bitrate = bitrate.toInt())
        }
        player.abr.abrStrategy = AbrStrategyConfiguration(
            type = toNativeType(config.type),
            metadata = metadata
        )
    }

    override fun getTargetBuffer(): Double {
        return player.abr.targetBuffer?.toDouble() ?: 20.0
    }

    override fun setTargetBuffer(value: Double) {
        player.abr.targetBuffer = value.toInt()
    }

    override fun getPreferredPeakBitRate(): Double {
        // Not supported on Android
        return 0.0
    }

    override fun setPreferredPeakBitRate(value: Double) {
        // No-op on Android
    }

    // MARK: - Mapping helpers

    private fun toPigeonType(type: AbrStrategyType): AbrStrategyTypePigeon {
        return when (type) {
            AbrStrategyType.PERFORMANCE -> AbrStrategyTypePigeon.PERFORMANCE
            AbrStrategyType.QUALITY -> AbrStrategyTypePigeon.QUALITY
            AbrStrategyType.BANDWIDTH -> AbrStrategyTypePigeon.BANDWIDTH
        }
    }

    private fun toNativeType(type: AbrStrategyTypePigeon): AbrStrategyType {
        return when (type) {
            AbrStrategyTypePigeon.PERFORMANCE -> AbrStrategyType.PERFORMANCE
            AbrStrategyTypePigeon.QUALITY -> AbrStrategyType.QUALITY
            AbrStrategyTypePigeon.BANDWIDTH -> AbrStrategyType.BANDWIDTH
        }
    }
}
