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

  int? audioID = -1;
  int? videoID = -1;

  UniqueKey audioKey = UniqueKey();
  UniqueKey videoKey = UniqueKey();

  bool dragging = false;

  void addAudioTrackListener(Event event) {
    var addEvent = event as AddAudioTrackEvent;
    print("addAudioTrack ${addEvent.track.uid}");
    addEvent.track.qualities.forEach((quality) {
          print("addAudioTrack quality ${quality.uid}");
    });
    addEvent.track.addEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGED, activeAudioQualityListener);
  }

  void addVideoTrackListener(Event event) {
    var addEvent = event as AddVideoTrackEvent;
    print("addVideoTrack ${addEvent.track.uid}");
    addEvent.track.qualities.forEach((quality) {
          print("addVideoTrack quality ${quality.uid}");
    });
    addEvent.track.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED, activeVideoQualityListener);
  }

  void activeAudioQualityListener(Event event) {
      var audioQualityChangeEvent = event as AudioActiveQualityChangedEvent;

      setState(() {
        audioID = audioQualityChangeEvent.quality.uid;
      });
  }

  void activeVideoQualityListener(Event event) {
      var videoQualityChangeEvent = event as VideoActiveQualityChangedEvent;

      setState(() {
        videoID = videoQualityChangeEvent.quality.uid;
      });
  }


  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Badge(
        key: audioKey,
        label: Text("$audioID"),
        isLabelVisible: audioID != -1,
        child: 
          SizedBox(
            child: 
              Container(
                padding: const EdgeInsets.all(6),
                color: Colors.green,
                child: const Text("AQ",         
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                ),
              )
          ),
      ),
      Container(width: 8,),
      Badge(
        key: videoKey,
        label: Text("$videoID"),
        isLabelVisible: videoID != -1,
        child: 
          SizedBox(
            child: 
              Container(
                padding: const EdgeInsets.all(6),
                color: Colors.blue,
                child: const Text("VQ",         
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                ),
              )
          ),
      ),
    ],);
  }

}