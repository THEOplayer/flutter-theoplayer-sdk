//
//  VideoTrackBridge.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 27/11/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class VideoTrackBridge: THEOplayerNativeVideoTracksAPI {

    private let theoplayer: THEOplayer
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterVideoTracksAPI: THEOplayerFlutterVideoTracksAPI

    private var addVideoTrackListener: EventListener?
    private var removeVideoTrackListener: EventListener?
    private var videoTrackListChangeListener: EventListener?
    private var trackEventListeners: [Int: [EventListener]] = [:]

    private let emptyCompletion: (Result<Void, PigeonError>) -> Void = {result in }

    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterVideoTracksAPI = THEOplayerFlutterVideoTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeVideoTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }

    func attachListeners() {
        addVideoTrackListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.ADD_TRACK, listener: { [weak self] event in
            guard let self else { return }
            if let videoTrack = event.track as? VideoTrack {
                self.flutterVideoTracksAPI.onAddVideoTrack(
                    id: videoTrack.id,
                    uid: Int64(videoTrack.uid),
                    label: videoTrack.label,
                    language: videoTrack.language,
                    kind: videoTrack.kind,
                    isEnabled: videoTrack.enabled,
                    unlocalizedLabel: videoTrack.unlocalizedLabel,
                    completion: self.emptyCompletion)

                // Emit quality info for each quality in the track
                let qualities = videoTrack.qualities
                for i in 0..<qualities.count {
                    let quality = qualities.get(i)
                    let identifier = String(quality.bandwidth)
                    var width: Int64 = 0
                    var height: Int64 = 0
                    if let videoQuality = quality as? VideoQuality {
                        width = Int64(videoQuality.width)
                        height = Int64(videoQuality.height)
                    }
                    self.flutterVideoTracksAPI.onVideoTrackAddQuality(
                        videoTrackUid: Int64(videoTrack.uid),
                        qualityId: identifier,
                        qualityUid: Int64(quality.bandwidth),
                        name: self.labelFromBandwidth(quality.bandwidth),
                        bandwidth: Int64(quality.bandwidth),
                        codecs: "",
                        width: width,
                        height: height,
                        frameRate: 0,
                        firstFrame: 0,
                        averageBandwidth: quality.averageBandwidth.map { Int64($0) },
                        available: true,
                        completion: self.emptyCompletion)
                }

                self.attachTrackListeners(videoTrack: videoTrack)
            }
        })

        removeVideoTrackListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.REMOVE_TRACK, listener: { [weak self] event in
            guard let self else { return }
            self.removeTrackListeners(trackUid: event.track.uid)
            self.flutterVideoTracksAPI.onRemoveVideoTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })

        videoTrackListChangeListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.CHANGE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterVideoTracksAPI.onVideoTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
    }

    private func attachTrackListeners(videoTrack: VideoTrack) {
        var listeners: [EventListener] = []

        let activeQualityChangedListener = videoTrack.addEventListener(type: MediaTrackEventTypes.ACTIVE_QUALITY_CHANGED, listener: { [weak self] (event: ActiveQualityChangedEvent) in
            guard let self else { return }
            self.flutterVideoTracksAPI.onActiveQualityChange(
                videoTrackUid: Int64(videoTrack.uid),
                qualityUid: Int64(event.quality.bandwidth),
                completion: self.emptyCompletion)
        })
        listeners.append(activeQualityChangedListener)

        trackEventListeners[videoTrack.uid] = listeners
    }

    private func removeTrackListeners(trackUid: Int) {
        trackEventListeners.removeValue(forKey: trackUid)
    }

    private func removeListeners() {
        if let listener = addVideoTrackListener {
            theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.ADD_TRACK, listener: listener)
        }
        if let listener = removeVideoTrackListener {
            theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.REMOVE_TRACK, listener: listener)
        }
        if let listener = videoTrackListChangeListener {
            theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.CHANGE, listener: listener)
        }
        trackEventListeners.removeAll()
    }

    func dispose() {
        removeListeners()
        THEOplayerNativeVideoTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }

    func setTargetQuality(videoTrackUid: Int64, qualityUid: Int64?) throws {
        for i in 0..<theoplayer.videoTracks.count {
            let track = theoplayer.videoTracks.get(i)
            if track.uid == Int(videoTrackUid) {
                if let qualityUid = qualityUid {
                    let qualities = track.qualities
                    for j in 0..<qualities.count {
                        let quality = qualities.get(j)
                        if quality.bandwidth == Int(qualityUid) {
                            track.targetQualities = [quality]
                            return
                        }
                    }
                } else {
                    track.targetQualities = nil
                }
                return
            }
        }
    }

    func setTargetQualities(videoTrackUid: Int64, qualitiesUid: [Int64]?) throws {
        for i in 0..<theoplayer.videoTracks.count {
            let track = theoplayer.videoTracks.get(i)
            if track.uid == Int(videoTrackUid) {
                if let qualitiesUid = qualitiesUid {
                    var targetQualities: [any Quality] = []
                    let qualities = track.qualities
                    for j in 0..<qualities.count {
                        let quality = qualities.get(j)
                        if qualitiesUid.contains(Int64(quality.bandwidth)) {
                            targetQualities.append(quality)
                        }
                    }
                    track.targetQualities = targetQualities
                } else {
                    track.targetQualities = nil
                }
                return
            }
        }
    }

    func setEnabled(videoTrackUid: Int64, enabled: Bool) throws {
        for i in 0..<theoplayer.videoTracks.count {
            var track = theoplayer.videoTracks.get(i)
            if (track.uid == videoTrackUid) {
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
