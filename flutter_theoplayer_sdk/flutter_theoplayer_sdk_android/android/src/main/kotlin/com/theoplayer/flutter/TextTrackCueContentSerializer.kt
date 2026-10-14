package com.theoplayer.flutter

import com.theoplayer.android.api.player.track.texttrack.id3.ID3Frame
import org.json.JSONObject

internal fun serializeTextTrackCueContent(
    content: JSONObject?,
    frame: ID3Frame?,
    base64Encoder: (ByteArray) -> String,
): String {
    if (frame == null) {
        return content?.toString().orEmpty()
    }
    if (frame is ID3Frame.Private) {
        return JSONObject()
            .put("id", frame.id)
            .put("ownerIdentifier", frame.ownerIdentifier)
            .put("data", base64Encoder(frame.data))
            .toString()
    }
    return content?.toString() ?: JSONObject().put("id", frame.id).toString()
}
