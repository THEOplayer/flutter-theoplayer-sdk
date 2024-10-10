package com.theoplayer.theoplayer_example

import com.theoplayer.android.api.THEOplayerGlobal
import com.theoplayer.android.api.contentprotection.KeySystemId
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()

        THEOplayerGlobal.getSharedInstance(context).registerContentProtectionIntegration(
            "KeyOSDRMIntegration",
            KeySystemId.WIDEVINE,
            KeyOsWidevineContentProtectionIntegrationFactory()
        )
    }
}
