package com.theoplayer.flutter

import com.theoplayer.android.api.player.track.texttrack.id3.ID3Frame
import org.json.JSONObject
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import java.util.Base64
import kotlin.test.Test
import kotlin.test.assertContentEquals
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

internal class TextTrackCueContentSerializerTest {

    private val base64Encoder: (ByteArray) -> String = { Base64.getEncoder().encodeToString(it) }

    @Test
    fun nullContentPrivateFramePreservesOwnerAndAsciiTimestamp() {
        val owner = "example.org:metadata:timestamp"
        val timestamp = "1791987654321"
        val bytes = timestamp.toByteArray(Charsets.US_ASCII)
        val frame = ID3Frame.Private(owner, bytes)

        val serializedFrame = JSONObject(serializeTextTrackCueContent(null, frame, base64Encoder))
        assertEquals(3, serializedFrame.length())
        assertEquals("PRIV", serializedFrame.getString("id"))
        assertEquals(owner, serializedFrame.getString("ownerIdentifier"))
        val decoded = Base64.getDecoder().decode(serializedFrame.getString("data"))
        assertContentEquals(bytes, decoded)
        assertEquals(timestamp, decoded.toString(Charsets.US_ASCII))
    }

    @Test
    fun privateFramePreservesBinaryBytesAndEscapesAnyOwner() {
        val owner = "another-owner:\"\\\n\u2603"
        val bytes = byteArrayOf(0, 1, 127, -128, -1)
        val frame = ID3Frame.Private(owner, bytes)
        val content = JSONObject().put("legacy", true)

        val serializedFrame = JSONObject(serializeTextTrackCueContent(content, frame, base64Encoder))
        assertEquals(owner, serializedFrame.getString("ownerIdentifier"))
        assertContentEquals(bytes, Base64.getDecoder().decode(serializedFrame.getString("data")))
    }

    @Test
    fun privateFramePreservesEmptyData() {
        val frame = ID3Frame.Private("", byteArrayOf())

        val serializedFrame = JSONObject(serializeTextTrackCueContent(null, frame, base64Encoder))
        assertEquals("", serializedFrame.getString("ownerIdentifier"))
        assertEquals("", serializedFrame.getString("data"))
    }

    @Test
    fun nonId3ContentIsUnchanged() {
        val content = JSONObject().put("text", "Subtitle <b>content</b>").put("metadata", JSONObject().put("value", 42))

        assertEquals(content.toString(), serializeTextTrackCueContent(content, null, base64Encoder))
    }

    @Test
    fun nullNonId3ContentBecomesEmptyString() {
        assertEquals("", serializeTextTrackCueContent(null, null, base64Encoder))
    }

    @Test
    fun nullJsonStringBecomesEmptyString() {
        val content = mock(JSONObject::class.java)
        `when`(content.toString()).thenReturn(null)

        assertEquals("", serializeTextTrackCueContent(content, null, base64Encoder))
    }

    @Test
    fun nonPrivateId3ContentIsUnchanged() {
        val frame = ID3Frame.Text("TXXX", "description", "text")
        val content = JSONObject().put("frame", JSONObject().put("id", frame.id).put("text", frame.text))

        assertEquals(content.toString(), serializeTextTrackCueContent(content, frame, base64Encoder))
    }

    @Test
    fun nullNonPrivateId3ContentPreservesFrameId() {
        val frame = ID3Frame.Unknown("XABC", byteArrayOf(1, 2))

        val serializedFrame = JSONObject(serializeTextTrackCueContent(null, frame, base64Encoder))
        assertEquals(1, serializedFrame.length())
        assertEquals("XABC", serializedFrame.getString("id"))
    }

    @Test
    fun encoderFailureIsNotSwallowed() {
        val frame = ID3Frame.Private("example.org", byteArrayOf(1))
        val failure = IllegalStateException("Encoding failed")

        assertEquals(failure, assertFailsWith<IllegalStateException> {
            serializeTextTrackCueContent(null, frame) { throw failure }
        })
    }
}
