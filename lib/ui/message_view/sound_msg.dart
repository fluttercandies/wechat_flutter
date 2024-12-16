import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_sound_elem.dart';

import '../../provider/global_model.dart';
import '../../tools/wechat_flutter.dart';
import 'msg_avatar.dart';

class SoundMsg extends StatefulWidget {
  final V2TimMessage model;

  SoundMsg(this.model);

  @override
  _SoundMsgState createState() => _SoundMsgState();
}

class _SoundMsgState extends State<SoundMsg> with TickerProviderStateMixin {
  Duration? duration;
  Duration? position;

  late AnimationController controller;
  Animation<int>? animation;
  late FlutterSound flutterSound;
  AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription? _positionSubscription;
  StreamSubscription? _audioPlayerStateSubscription;
  StreamSubscription? _playerSubscription;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  @override
  void initState() {
    super.initState();
    flutterSound = FlutterSound();
    initializeDateFormatting();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 3).animate(curve)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
  }

  void start(String path) async {
    showToast('正在兼容最新flutter');
  }

  Future<void> playNew(String url) async {
    await audioPlayer
        .play(url.startsWith('http') ? UrlSource(url) : DeviceFileSource(url));
    // if (result == 1) {
    showToast('播放中');
    // } else {
    //   showToast( '播放出问题了');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalModel globalModel = Provider.of<GlobalModel>(context);
    final bool isSelf = widget.model.sender == globalModel.account;
    List<String> soundImg;
    final List<String> leftSoundNames = <String>[
      'assets/images/chat/sound_left_0.webp',
      'assets/images/chat/sound_left_1.webp',
      'assets/images/chat/sound_left_2.webp',
      'assets/images/chat/sound_left_3.webp',
    ];

    final List<String> rightSoundNames = <String>[
      'assets/images/chat/sound_right_0.png',
      'assets/images/chat/sound_right_1.webp',
      'assets/images/chat/sound_right_2.webp',
      'assets/images/chat/sound_right_3.png',
    ];
    if (isSelf) {
      soundImg = rightSoundNames;
    } else {
      soundImg = leftSoundNames;
    }

    if (widget.model.soundElem == null) {
      return Container();
    }
    final V2TimSoundElem soundElem = widget.model.soundElem!;

    if (GetUtils.isNullOrBlank(soundElem.url)! &&
        GetUtils.isNullOrBlank(soundElem.path)!) {
      return Container();
    }

    final String urlUse = GetUtils.isNullOrBlank(soundElem.url)!
        ? soundElem.path!
        : soundElem.url!;
    List<Widget> body = <Widget>[
      MsgAvatar(model: widget.model, globalModel: globalModel),
      Container(
        width: 100.0,
        padding: const EdgeInsets.only(right: 10.0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 18.0, right: 4.0),
            backgroundColor: widget.model.sender == globalModel.account
                ? const Color(0xff98E165)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Row(
            mainAxisAlignment:
                isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              const Text('0\"', textAlign: TextAlign.start, maxLines: 1),
              const SizedBox(width: mainSpace / 2),
              Image.asset(
                  animation != null
                      ? soundImg[animation!.value % 3]
                      : soundImg[3],
                  height: 20.0,
                  color: Colors.black,
                  fit: BoxFit.cover),
              const SizedBox(width: mainSpace)
            ],
          ),
          onPressed: () {
            if (strNoEmpty(urlUse)) {
              playNew(urlUse);
            } else {
              showToast('未知错误');
            }
          },
        ),
      ),
      const Spacer(),
    ];
    if (isSelf) {
      body = body.reversed.toList();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: body),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayerStateSubscription?.cancel();
    _playerSubscription?.cancel();
    controller.dispose();
    super.dispose();
  }
}
