//
//  AudioTrackBridge.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 27/11/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class AudioTrackBridge: THEOplayerNativeAudioTracksAPI {

    private let theoplayer: THEOplayer
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterAudioTracksAPI: THEOplayerFlutterAudioTracksAPI

    private var addAudioTrackListener: EventListener?
    private var removeAudioTrackListener: EventListener?
    private var audioTrackListChangeListener: EventListener?
    private var trackEventListeners: [Int: [EventListener]] = [:]

    private let emptyCompletion: (Result<Void, PigeonError>) -> Void = {result in }

    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterAudioTracksAPI = THEOplayerFlutterAudioTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeAudioTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }

    func attachListeners() {
        addAudioTrackListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.ADD_TRACK, listener: { [weak self] event in
            guard let self else { return }
            if let audioTrack = event.track as? AudioTrack {
                self.flutterAudioTracksAPI.onAddAudioTrack(
                    id: audioTrack.id,
                    uid: Int64(audioTrack.uid),
                    label: audioTrack.label,
                    language: audioTrack.language,
                    kind: audioTrack.kind,
                    isEnabled: audioTrack.enabled,
                    unlocalizedLabel: audioTrack.unlocalizedLabel,
                    completion: self.emptyCompletion)

                // Emit quality info for each quality in the track
                let qualities = audioTrack.qualities
                for i in 0..<qualities.count {
                    let quality = qualities.get(i)
                    self.flutterAudioTracksAPI.onAudioTrackAddQuality(
                        audioTrackUid: Int64(audioTrack.uid),
                        qualityId: String(quality.bandwidth),
                        qualityUid: Int64(quality.bandwidth),
                        name: self.labelFromBandwidth(quality.bandwidth),
                        bandwidth: Int64(quality.bandwidth),
                        codecs: "",
                        audioSamplingRate: 0,
                        averageBandwidth: quality.averageBandwidth.map { Int64($0) },
                        available: true,
                        completion: self.emptyCompletion)
                }

                self.attachTrackListeners(audioTrack: audioTrack)
            }
        })

        removeAudioTrackListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.REMOVE_TRACK, listener: { [weak self] event in
            guard let self else { return }
            self.removeTrackListeners(trackUid: event.track.uid)
            self.flutterAudioTracksAPI.onRemoveAudioTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })

        audioTrackListChangeListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.CHANGE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterAudioTracksAPI.onAudioTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
    }

    private func attachTrackListeners(audioTrack: AudioTrack) {
        var listeners: [EventListener] = []

        let activeQualityChangedListener = audioTrack.addEventListener(type: MediaTrackEventTypes.ACTIVE_QUALITY_CHANGED, listener: { [weak self] (event: ActiveQualityChangedEvent) in
            guard let self else { return }
            self.flutterAudioTracksAPI.onActiveQualityChange(
                audioTrackUid: Int64(audioTrack.uid),
                qualityUid: Int64(event.quality.bandwidth),
                completion: self.emptyCompletion)
        })
        listeners.append(activeQualityChangedListener)

        trackEventListeners[audioTrack.uid] = listeners
    }

    private func removeTrackListeners(trackUid: Int) {
        trackEventListeners.removeValue(forKey: trackUid)
    }

    private func removeListeners() {
        if let listener = addAudioTrackListener {
            theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.ADD_TRACK, listener: listener)
        }
        if let listener = removeAudioTrackListener {
            theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.REMOVE_TRACK, listener: listener)
        }
        if let listener = audioTrackListChangeListener {
            theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.CHANGE, listener: listener)
        }
        trackEventListeners.removeAll()
    }

    func dispose() {
        removeListeners()
        THEOplayerNativeAudioTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }

    func setTargetQuality(audioTrackUid: Int64, qualityUid: Int64?) throws {
        for i in 0..<theoplayer.audioTracks.count {
            let track = theoplayer.audioTracks.get(i)
            if track.uid == Int(audioTrackUid) {
                if let qualityUid = qualityUid, let qualities = (track as? AudioTrack)?.qualities {
                    for j in 0..<qualities.count {
                        let quality = qualities.get(j)
                        if quality.bandwidth == Int(qualityUid) {
                            (track as? AudioTrack)?.targetQualities = [quality]
                            return
                        }
                    }
                } else {
                    (track as? AudioTrack)?.targetQualities = nil
                }
                return
            }
        }
    }

    func setTargetQualities(audioTrackUid: Int64, qualitiesUid: [Int64]?) throws {
        for i in 0..<theoplayer.audioTracks.count {
            let track = theoplayer.audioTracks.get(i)
            if track.uid == Int(audioTrackUid) {
                if let qualitiesUid = qualitiesUid, let qualities = (track as? AudioTrack)?.qualities {
                    var targetQualities: [any Quality] = []
                    for j in 0..<qualities.count {
                        let quality = qualities.get(j)
                        if qualitiesUid.contains(Int64(quality.bandwidth)) {
                            targetQualities.append(quality)
                        }
                    }
                    (track as? AudioTrack)?.targetQualities = targetQualities
                } else {
                    (track as? AudioTrack)?.targetQualities = nil
                }
                return
            }
        }
    }

    func setEnabled(audioTrackUid: Int64, enabled: Bool) throws {
        for i in 0..<theoplayer.audioTracks.count {
            var track = theoplayer.audioTracks.get(i)
            if (track.uid == audioTrackUid) {
                track.enabled = enabled
            }
        }
    }

    private func labelFromBandwidth(_ bandwidth: Int) -> String {
        if bandwidth >= 1_000_000 {
            return String(format: "%.1f Mbps", Double(bandwidth) / 1_000_000.0)
        } else {
            return String(format: "%d kbps", bandwidth / 1000)
        }
    }

}
