////import 'package:audioplayer/audioplayer.dart';
//import 'package:flutter/material.dart';
//import 'package:dim_example/tools/flutter/download.dart';
//import 'package:dim_example/tools/wechat_flutter.dart';
//import 'package:dim_example/ui/massage/sound_item_container.dart';
//import 'package:dim_example/ui/massage/vertical_container.dart';
//import 'package:dim_example/ui/message_view/wai2.dart';
//
//class SoundMessage extends StatefulWidget {
//  final int voiceTime;
//  final int type;
//  final dynamic data;
//
//  SoundMessage(this.voiceTime, this.type, this.data);
//
//  SoundMessageState createState() => SoundMessageState();
//}
//
//class SoundMessageState extends State<SoundMessage>
//    with TickerProviderStateMixin {
//  bool isSelf = false;
//
//  StreamSubscription _positionSubscription;
//  StreamSubscription _audioPlayerStateSubscription;
////  AudioPlayer audioPlayer;
//
//  Duration duration;
//  Duration position;
//
//  AnimationController controller;
//  Animation animation;
//
//  var leftSoundNames = [
//    'assets/images/sound_left_0.png',
//    'assets/images/sound_left_1.png',
//    'assets/images/sound_left_2.png' /*,
//    'assets/images/sound_left_3.png'*/
//  ];
//
//  var rightSoundNames = [
//    'assets/images/sound_right_0.png',
//    'assets/images/sound_right_1.png',
//    'assets/images/sound_right_2.png' /*,
//    'assets/images/sound_right_3.png'*/
//  ];
//
//  @override
//  void initState() {
//    super.initState();
//    initAudioPlayer();
//  }
//
//  @override
//  void dispose() {
//    _positionSubscription.cancel();
//    _audioPlayerStateSubscription.cancel();
////    audioPlayer.stop();
//    super.dispose();
//  }
//
//  void initAudioPlayer() {
////    //控制语音动画
////    controller = AnimationController(
////        duration: const Duration(milliseconds: 1000), vsync: this);
////    final Animation curve =
////        CurvedAnimation(parent: controller, curve: Curves.easeOut);
////    animation = IntTween(begin: 0, end: 3).animate(curve)
////      ..addStatusListener((status) {
////        if (status == AnimationStatus.completed) {
////          controller.reverse();
////        }
////        if (status == AnimationStatus.dismissed) {
////          controller.forward();
////        }
////      });
////
////    audioPlayer = new AudioPlayer();
////    _positionSubscription = audioPlayer.onAudioPositionChanged
////        .listen((p) => setState(() => position = p));
////    _audioPlayerStateSubscription =
////        audioPlayer.onPlayerStateChanged.listen((s) {
////      if (s == AudioPlayerState.PLAYING) {
////        setState(() => duration = audioPlayer.duration);
////      } else if (s == AudioPlayerState.STOPPED) {
////        controller.reset();
//////            onComplete();
////        setState(() {
////          position = duration;
////        });
////      }
////    }, onError: (msg) {
////      setState(() {
//////            playerState = PlayerState.stopped;
////        duration = new Duration(seconds: 0);
////        position = new Duration(seconds: 0);
////      });
////    });
//  }
//
//  Future play(String url) async {
////    controller.forward();
////    await audioPlayer.play(url);
////    setState(() {
//////      playerState = PlayerState.playing;
////    });
//  }
//
//  void playVoice(String url, String uuid) async {
//    File file = new File((await DownloadUtil.savePath) + "/" + uuid);
//
//    print('语音文件路劲：${file.path}');
//    if (!await file.exists()) {
//      print('语音文件不存在');
//      DownloadUtil.downloadVoice(url, uuid, callback: () async {
//        String path = (await DownloadUtil.savePath) + "/" + uuid;
//        print('语音保存路劲：$path');
//        play(path);
//      });
//    } else {
//      print('语音文件存在');
//      play(file.path);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (widget.type == 1) {
//      return VerticalContainer(
//        type: 1,
//        children: <Widget>[
//          new MassageAvatar(widget.data, type: 1),
//          new SoundItemContainer(
//            children: <Widget>[
//              animation != null
//                  ? Image.asset(
//                      leftSoundNames[animation.value % 3],
//                      height: 25.0,
//                    )
//                  : Container(),
//              Text(
//                "${widget.voiceTime}\"",
//                textAlign: TextAlign.start,
//                maxLines: 1,
//                style: TextStyle(color: Colors.white),
//              ),
//              Container(width: 10),
//            ],
//            onPressed: () {
//              if (widget.data['message']['urls'][0] != null) {
//                playVoice(widget.data['message']['urls'][0],
//                    widget.data['message']['uuid']);
//              }
//            },
//          ),
//        ],
//      );
//    } else {
//      return VerticalContainer(
//        type: 2,
//        children: <Widget>[
//          new SoundItemContainer(
//            children: <Widget>[
//              Container(width: 10),
//              Text(
//                "${widget.voiceTime}\"",
//                textAlign: TextAlign.start,
//                maxLines: 1,
//                style: TextStyle(color: Colors.white),
//              ),
//              animation != null
//                  ? Image.asset(leftSoundNames[animation.value % 3],
//                      height: 25.0)
//                  : Container(),
//            ],
//            onPressed: () {
//              if (widget.data['message']['urls'][0] != null) {
//                playVoice(widget.data['message']['urls'][0],
//                    widget.data['message']['uuid']);
//              }
//            },
//          ),
//          new MassageAvatar(widget.data, type: 0),
//        ],
//      );
//    }
//  }
//}
