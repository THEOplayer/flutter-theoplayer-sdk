import Foundation
import Flutter
import THEOplayerSDK

//TODO: This extension of Error is required to do use FlutterError in any Swift code.
//TODO: https://github.com/flutter/packages/blob/main/packages/pigeon/example/README.md#swift
extension FlutterError: Error {}

class THEOplayerViewNative: NSObject, FlutterPlatformView {
    private let _view: UIView
    private let _theoplayer: THEOplayer
    private let _pigeonMessenger: PigeonBinaryMessengerWrapper
    private let _flutterAPI: THEOplayerFlutterAPI
    private let _playerEventForwarder: PlayerEventForwarder
    private let _textTrackBridge: TextTrackBridge
    private let _audioTrackBridge: AudioTrackBridge
    private let _videoTrackBridge: VideoTrackBridge

    func view() -> UIView {
        return _view
    }

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        _view = UIView()
        _view.frame = frame

        let params = args as? [String: Any]
        let playerConfig = params?["playerConfig"] as? [String: Any]
        let license = playerConfig?["license"] as? String
        let licenseUrl = playerConfig?["licenseUrl"] as? String

        _theoplayer = THEOplayer(configuration: THEOplayerConfiguration(
            pip: nil,
            license: license,
            licenseUrl: licenseUrl
        ))
        _theoplayer.frame = _view.bounds
        _theoplayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _theoplayer.addAsSubview(of: _view)
        
        _pigeonMessenger = PigeonBinaryMessengerWrapper(with: messenger!, channelSuffix: "id_\(viewId)")
        
        _flutterAPI = THEOplayerFlutterAPI(binaryMessenger: _pigeonMessenger)
        _playerEventForwarder = PlayerEventForwarder(theoplayer: _theoplayer, flutterAPI: _flutterAPI)
        _playerEventForwarder.attachListeners()
        
        _textTrackBridge = TextTrackBridge(theoplayer: _theoplayer, pigeonMessenger: _pigeonMessenger)
        _textTrackBridge.attachListeners()
        
        _audioTrackBridge = AudioTrackBridge(theoplayer: _theoplayer, pigeonMessenger: _pigeonMessenger)
        _audioTrackBridge.attachListeners()
        
        _videoTrackBridge = VideoTrackBridge(theoplayer: _theoplayer, pigeonMessenger: _pigeonMessenger)
        _videoTrackBridge.attachListeners()

        super.init()
        
        THEOplayerNativeAPISetup.setUp(binaryMessenger: _pigeonMessenger, api: self)
    }
}

extension THEOplayerViewNative: THEOplayerNativeAPI {
    
    func setSource(source: SourceDescription?) throws {
        _theoplayer.source = SourceTransformer.toSourceDescription(source: source)
    }
    
    func getSource() throws -> SourceDescription? {
        return SourceTransformer.toFlutterSourceDescription(source: _theoplayer.source)
    }
    
    func setAutoplay(autoplay: Bool) throws {
        _theoplayer.autoplay = autoplay
    }
    
    func isAutoplay() throws -> Bool {
        return _theoplayer.autoplay
    }
    
    func play() throws {
        _theoplayer.play()
    }
    
    func pause() throws {
        _theoplayer.pause()
    }
    
    func isPaused() throws -> Bool {
        return _theoplayer.paused
    }
    
    func setCurrentTime(currentTime: Double) throws {
        _theoplayer.currentTime = currentTime
    }
    
    func getCurrentTime() throws -> Double {
        return _theoplayer.currentTime
    }
    
    func setCurrentProgramDateTime(currentProgramDateTime: Int64) throws {
        _theoplayer.setCurrentProgramDateTime(Date(timeIntervalSince1970: TimeInterval(currentProgramDateTime)))
    }
    
    func getCurrentProgramDateTime() throws -> Int64? {
        if let currentProgramDateTime = _theoplayer.currentProgramDateTime?.timeIntervalSince1970 {
            return Int64(currentProgramDateTime)
        }
        return nil
    }
    
    func getDuration() throws -> Double {
        return _theoplayer.duration!
    }
    
    func setPlaybackRate(playbackRate: Double) throws {
        _theoplayer.setPlaybackRate(playbackRate)
    }
    
    func getPlaybackRate() throws -> Double {
        return _theoplayer.playbackRate
    }
    
    func setVolume(volume: Double) throws {
        _theoplayer.volume = Float(volume)
    }
    
    func getVolume() throws -> Double {
        return Double(_theoplayer.volume)
    }
    
    func setMuted(muted: Bool) throws {
        _theoplayer.muted = muted
    }
    
    func isMuted() throws -> Bool {
        return _theoplayer.muted
    }
    
    func setPreload(preload: PreloadType) throws {
        _theoplayer.setPreload(PlayerEnumTransformer.toPreloadType(preload: preload))
    }
    
    func getPreload() throws -> PreloadType {
        return PlayerEnumTransformer.toFlutterPreloadType(preload: _theoplayer.preload)
    }
    
    func getReadyState() throws -> ReadyState {
        return PlayerEnumTransformer.toFlutterReadyState(readyState: _theoplayer.readyState)
    }
    
    func isSeeking() throws -> Bool {
        return _theoplayer.seeking
    }
    
    func isEnded() throws -> Bool {
        return _theoplayer.ended
    }
    
    func getVideoWidth() throws -> Int64 {
        return Int64(_theoplayer.videoWidth)
    }
    
    func getVideoHeight() throws -> Int64 {
        return Int64(_theoplayer.videoHeight)
    }
    
    func getBuffered() throws -> [TimeRange] {
        return TimeRangeTransformer.toFlutterTimeRanges(timeRanges: _theoplayer.buffered)
    }
    
    func getSeekable() throws -> [TimeRange] {
        return TimeRangeTransformer.toFlutterTimeRanges(timeRanges: _theoplayer.seekable)
    }
    
    func getPlayed() throws -> [TimeRange] {
        return TimeRangeTransformer.toFlutterTimeRanges(timeRanges: _theoplayer.played)
    }
    
    func getError() throws -> String? {
        return _theoplayer.error
    }
    
    func stop() throws {
        return _theoplayer.stop()
    }
    
    func dispose() throws {
        _playerEventForwarder.removeListeners()
        _textTrackBridge.removeListeners()
        _audioTrackBridge.removeListeners()
        _videoTrackBridge.removeListeners()
        _theoplayer.destroy()
    }
    
    func onLifecycleResume() throws {
        // do nothing
    }
    
    func onLifecyclePause() throws {
        // do nothing
    }
    
    
}
