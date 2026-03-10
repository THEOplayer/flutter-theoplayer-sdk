import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

class QualityChangeWidget extends StatefulWidget {
  const QualityChangeWidget({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  State<StatefulWidget> createState() {
    return _QualityChangeState();
  }
}

class _QualityChangeState extends State<QualityChangeWidget> {
  AudioQuality? _activeAudioQuality;
  VideoQuality? _activeVideoQuality;

  UniqueKey audioKey = UniqueKey();
  UniqueKey videoKey = UniqueKey();

  void addAudioTrackListener(Event event) {
    var addEvent = event as AddAudioTrackEvent;
    print("addAudioTrack ${addEvent.track.uid}");
    for (var quality in addEvent.track.qualities) {
      print("addAudioTrack quality uid=${quality.uid} bw=${quality.bandwidth} name=${quality.name}");
    }
    addEvent.track.addEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGED, activeAudioQualityListener);
  }

  void addVideoTrackListener(Event event) {
    var addEvent = event as AddVideoTrackEvent;
    print("addVideoTrack ${addEvent.track.uid}");
    for (var quality in addEvent.track.qualities) {
      var vq = quality as VideoQuality;
      print("addVideoTrack quality uid=${vq.uid} bw=${vq.bandwidth} ${vq.width}x${vq.height} name=${vq.name}");
    }
    addEvent.track.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED, activeVideoQualityListener);
  }

  void activeAudioQualityListener(Event event) {
    var e = event as AudioActiveQualityChangedEvent;
    print("activeAudioQuality changed: uid=${e.quality.uid} bw=${e.quality.bandwidth} name=${e.quality.name}");
    setState(() {
      _activeAudioQuality = e.quality;
    });
  }

  void activeVideoQualityListener(Event event) {
    var e = event as VideoActiveQualityChangedEvent;
    print("activeVideoQuality changed: uid=${e.quality.uid} bw=${e.quality.bandwidth} ${e.quality.width}x${e.quality.height} name=${e.quality.name}");
    setState(() {
      _activeVideoQuality = e.quality;
    });
  }

  @override
  void initState() {
    super.initState();

    _activeAudioQuality = widget.player.getAudioTracks().firstWhereOrNull((track) => track.isEnabled)?.activeQuality;
    _activeVideoQuality = widget.player.getVideoTracks().firstWhereOrNull((track) => track.isEnabled)?.activeQuality;

    widget.player.getAudioTracks().addEventListener(AudioTracksEventTypes.ADDTRACK, addAudioTrackListener);
    widget.player.getVideoTracks().addEventListener(VideoTracksEventTypes.ADDTRACK, addVideoTrackListener);
  }

  @override
  void dispose() {
    widget.player.getAudioTracks().removeEventListener(AudioTracksEventTypes.ADDTRACK, addAudioTrackListener);
    widget.player.getAudioTracks().forEach((element) {
      element.removeEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGED, activeAudioQualityListener);
    });
    widget.player.getVideoTracks().removeEventListener(VideoTracksEventTypes.ADDTRACK, addVideoTrackListener);
    widget.player.getVideoTracks().forEach((element) {
      element.removeEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED, activeVideoQualityListener);
    });
    super.dispose();
  }

  String _formatBandwidth(int bw) {
    if (bw >= 1000000) {
      return '${(bw / 1000000).toStringAsFixed(1)} Mbps';
    } else {
      return '${(bw / 1000).toStringAsFixed(0)} kbps';
    }
  }

  String _audioLabel() {
    final q = _activeAudioQuality;
    if (q == null) return 'AQ: –';
    return 'AQ: ${_formatBandwidth(q.bandwidth)}';
  }

  String _videoLabel() {
    final q = _activeVideoQuality;
    if (q == null) return 'VQ: –';
    return 'VQ: ${_formatBandwidth(q.bandwidth)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _videoLabel(),
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            _audioLabel(),
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
