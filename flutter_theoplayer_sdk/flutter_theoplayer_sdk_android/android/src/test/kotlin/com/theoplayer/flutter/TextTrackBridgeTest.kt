package com.theoplayer.flutter

import com.theoplayer.android.api.event.Event
import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.track.texttrack.AddCueEvent
import com.theoplayer.android.api.event.track.texttrack.TextTrackEventTypes
import com.theoplayer.android.api.event.track.texttrack.list.AddTrackEvent
import com.theoplayer.android.api.event.track.texttrack.list.TextTrackListEventTypes
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.TextTrackCueEventTypes
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.UpdateEvent
import com.theoplayer.android.api.player.Player
import com.theoplayer.android.api.player.track.texttrack.TextTrack
import com.theoplayer.android.api.player.track.texttrack.TextTrackList
import com.theoplayer.android.api.player.track.texttrack.TextTrackMode
import com.theoplayer.android.api.player.track.texttrack.TextTrackReadyState
import com.theoplayer.android.api.player.track.texttrack.TextTrackType
import com.theoplayer.android.api.player.track.texttrack.cue.DateRangeCue
import com.theoplayer.android.api.player.track.texttrack.cue.TextTrackCue
import com.theoplayer.android.api.player.track.texttrack.id3.ID3Cue
import com.theoplayer.android.api.player.track.texttrack.id3.ID3Frame
import com.theoplayer.flutter.pigeon.THEOplayerFlutterTextTracksAPI
import io.flutter.plugin.common.BinaryMessenger
import org.json.JSONObject
import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.*
import org.mockito.Mockito.*
import java.nio.ByteBuffer
import java.util.Base64
import java.util.Date
import kotlin.test.Test
import kotlin.test.assertContentEquals
import kotlin.test.assertEquals

internal class TextTrackBridgeTest {
    private val track = mock(TextTrack::class.java)
    private val messages = mutableListOf<Pair<String, List<*>>>()
    private val bytes = byteArrayOf(0, 1, 127, -128, -1)
    private val owner = "owner:\"\\\n\u2603"
    private val addCueListener: EventListener<AddCueEvent>

    init {
        val player = mock(Player::class.java)
        val tracks = mock(TextTrackList::class.java)
        val messenger = mock(BinaryMessenger::class.java)
        `when`(player.textTracks).thenReturn(tracks)
        `when`(track.uid).thenReturn(7)
        `when`(track.readyState).thenReturn(TextTrackReadyState.LOADED)
        `when`(track.type).thenReturn(TextTrackType.ID3)
        `when`(track.mode).thenReturn(TextTrackMode.HIDDEN)
        doAnswer {
            val buffer = it.getArgument<ByteBuffer>(1).duplicate()
            buffer.flip()
            val name = it.getArgument<String>(0)
            val payload = if (name == channel("onAddTextTrack")) emptyList<Any?>()
                else THEOplayerFlutterTextTracksAPI.codec.decodeMessage(buffer) as List<*>
            messages += name to payload
            null
        }.`when`(messenger).send(anyString(), any(), any())
        TextTrackBridge(player, PigeonBinaryMessengerWrapper(messenger, "id_test")) {
            Base64.getEncoder().encodeToString(it)
        }.attachListeners()
        val event = mock(AddTrackEvent::class.java)
        `when`(event.track).thenReturn(track)
        captured<AddTrackEvent> {
            verify(tracks).addEventListener(eq(TextTrackListEventTypes.ADDTRACK) ?: TextTrackListEventTypes.ADDTRACK, it.capture() ?: EventListener {})
        }.handleEvent(event)
        assertEquals(listOf(channel("onAddTextTrack")), messages.map { it.first })
        addCueListener = captured {
            verify(track).addEventListener(eq(TextTrackEventTypes.ADDCUE) ?: TextTrackEventTypes.ADDCUE, it.capture() ?: EventListener {})
        }
        messages.clear()
    }

    @Test fun nullPrivateContentOnAddCuePreservesEscapedOwnerAndBinaryData() = assertPrivate(false)
    @Test fun nullPrivateContentOnUpdatePreservesEscapedOwnerAndBinaryData() = assertPrivate(true)
    @Test fun nullNonId3ContentOnAddCueIsEmptyString() = assertEquals("", deliver(cue(TextTrackCue::class.java))[5])
    @Test fun nullNonId3ContentOnUpdateIsEmptyString() = assertEquals("", deliver(cue(TextTrackCue::class.java), true)[3])

    @Test
    fun genericContentIsUnchangedOnAddAndUpdate() {
        val content = JSONObject().put("text", "Subtitle <b>content</b>").put("metadata", JSONObject().put("value", 42))
        assertBothContents(cue(TextTrackCue::class.java, content), content.toString())
    }

    @Test
    fun nonPrivateId3ContentIsUnchangedOnAddAndUpdate() {
        val cue = cue(ID3Cue::class.java, JSONObject().put("frame", JSONObject().put("id", "TXXX").put("text", "text")))
        `when`(cue.frame).thenReturn(ID3Frame.Text("TXXX", "description", "text"))
        assertBothContents(cue, cue.content.toString())
    }

    @Test
    fun nullNonPrivateId3ContentRetainsFrameIdOnAddAndUpdate() {
        val cue = cue(ID3Cue::class.java)
        `when`(cue.frame).thenReturn(ID3Frame.Unknown("XABC", bytes))
        deliver(cue, true)
        listOf(messages[0].second[5], messages[1].second[3]).forEach {
            val content = JSONObject(it as String)
            assertEquals(1, content.length())
            assertEquals("XABC", content.getString("id"))
        }
    }

    @Test
    fun updateSerializesCurrentFrameAndEndTimeRatherThanAddedValues() {
        val cue = cue(ID3Cue::class.java)
        `when`(cue.frame).thenReturn(ID3Frame.Private("old", byteArrayOf()))
        val payload = deliver(cue, true) {
            `when`(cue.frame).thenReturn(ID3Frame.Private(owner, bytes))
            `when`(cue.endTime).thenReturn(9.5)
        }
        assertEquals("old", JSONObject(messages[0].second[5] as String).getString("ownerIdentifier"))
        assertEquals(9.5, payload[2])
        assertPrivateContent(payload[3] as String)
    }

    @Test
    fun dateRangeAddAndUpdateKeepDedicatedChannelsAndSemantics() {
        val cue = cue(DateRangeCue::class.java)
        val attributes = mock(DateRangeCue.CustomAttributes::class.java)
        `when`(cue.endTime).thenReturn(Double.POSITIVE_INFINITY)
        `when`(cue.startDate).thenReturn(Date(1234))
        `when`(cue.endDate).thenReturn(null)
        `when`(cue.attributeClass).thenReturn("ad")
        `when`(cue.duration).thenReturn(null)
        `when`(cue.plannedDuration).thenReturn(30.0)
        `when`(cue.isEndOnNext).thenReturn(true)
        `when`(cue.customAttributes).thenReturn(attributes)
        `when`(attributes.asMap()).thenReturn(mapOf("X-BINARY" to bytes, "X-NULL" to null))
        `when`(cue.scte35Out).thenReturn(bytes)
        deliver(cue, true)
        messages.forEach { (_, payload) ->
            assertEquals(listOf(7L, "cue", 42L, 1.25, Double.POSITIVE_INFINITY, "ad", 1234.0, null, null, 30.0, true), payload.take(11))
            val custom = JSONObject(payload[11] as String)
            assertContentEquals(bytes, Base64.getDecoder().decode(custom.getString("X-BINARY")))
            assertEquals(JSONObject.NULL, custom.get("X-NULL"))
            assertEquals(null, payload[12])
            assertContentEquals(bytes, payload[13] as ByteArray)
            assertEquals(null, payload[14])
        }
        verify(cue, never()).content
    }

    private fun assertPrivate(update: Boolean) {
        val cue = cue(ID3Cue::class.java)
        `when`(cue.frame).thenReturn(ID3Frame.Private(owner, bytes))
        val payload = deliver(cue, update)
        assertPrivateContent(payload[if (update) 3 else 5] as String)
    }

    private fun assertPrivateContent(serialized: String) {
        val content = JSONObject(serialized)
        assertEquals(3, content.length())
        assertEquals("PRIV", content.getString("id"))
        assertEquals(owner, content.getString("ownerIdentifier"))
        assertEquals(Base64.getEncoder().encodeToString(bytes), content.getString("data"))
        assertContentEquals(bytes, Base64.getDecoder().decode(content.getString("data")))
    }

    private fun assertBothContents(cue: TextTrackCue, expected: String) {
        assertEquals(expected, deliver(cue, true)[3])
        assertEquals(expected, messages[0].second[5])
    }

    private fun <T : TextTrackCue> cue(type: Class<T>, content: JSONObject? = null): T = mock(type).also {
        `when`(it.id).thenReturn("cue")
        `when`(it.uid).thenReturn(42L)
        `when`(it.startTime).thenReturn(1.25)
        `when`(it.endTime).thenReturn(2.5)
        `when`(it.content).thenReturn(content)
    }

    private fun deliver(cue: TextTrackCue, update: Boolean = false, beforeUpdate: () -> Unit = {}): List<*> {
        val add = mock(AddCueEvent::class.java)
        `when`(add.track).thenReturn(track)
        `when`(add.cue).thenReturn(cue)
        addCueListener.handleEvent(add)
        if (update) {
            beforeUpdate()
            val event = mock(UpdateEvent::class.java)
            `when`(event.cue).thenReturn(cue)
            captured<UpdateEvent> {
                verify(cue).addEventListener(eq(TextTrackCueEventTypes.UPDATE) ?: TextTrackCueEventTypes.UPDATE, it.capture() ?: EventListener {})
            }.handleEvent(event)
        }
        val methods = if (cue is DateRangeCue) listOf("onTextTrackAddDateRangeCue", "onTextTrackUpdateDateRangeCue") else listOf("onTextTrackAddCue", "onCueUpdate")
        assertEquals(methods.take(if (update) 2 else 1).map(::channel), messages.map { it.first })
        assertEquals(listOf(7L, "cue", 42L, 1.25, 2.5).take(if (cue is DateRangeCue) 4 else 5), messages[0].second.take(if (cue is DateRangeCue) 4 else 5))
        if (update) assertEquals(listOf(7L, 42L).take(if (cue is DateRangeCue) 1 else 2), messages[1].second.take(if (cue is DateRangeCue) 1 else 2))
        return messages.last().second
    }

    @Suppress("UNCHECKED_CAST")
    private fun <E : Event<*>> captured(registration: (ArgumentCaptor<EventListener<E>>) -> Unit): EventListener<E> {
        val captor = ArgumentCaptor.forClass(EventListener::class.java) as ArgumentCaptor<EventListener<E>>
        registration(captor)
        return captor.value
    }

    private fun channel(method: String) = "dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerFlutterTextTracksAPI.$method/id_test"
}
