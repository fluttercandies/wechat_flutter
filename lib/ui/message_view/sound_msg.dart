import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:wechat_flutter/im/entity/i_sound_msg_entity.dart';
import 'package:wechat_flutter/im/entity/sound_msg_entity.dart';
import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SoundMsg extends StatefulWidget {
  final ChatData model;

  SoundMsg(this.model);

  @override
  _SoundMsgState createState() => _SoundMsgState();
}

class _SoundMsgState extends State<SoundMsg> with TickerProviderStateMixin {
  Duration? duration;
  Duration? position;

  late AnimationController controller;
  late Animation<int> animation;
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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
  }

  void start(String path) async {
    showToast(context, "正在兼容最新flutter");
  }

  playNew(String url) async {
    showToast(context, "正在兼容最新flutter");
     // await audioPlayer.play(url);
    // if (result == 1) {
    //   showToast(context, '播放中');
    // } else {
    //   showToast(context, '播放出问题了');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    bool isSelf = widget.model.id == globalModel.account;
    var soundImg;
    var leftSoundNames = [
      'assets/images/chat/sound_left_0.webp',
      'assets/images/chat/sound_left_1.webp',
      'assets/images/chat/sound_left_2.webp',
      'assets/images/chat/sound_left_3.webp',
    ];

    var rightSoundNames = [
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

    SoundMsgEntity model = SoundMsgEntity.fromJson(widget.model.msg);
    ISoundMsgEntity iModel = ISoundMsgEntity.fromJson(widget.model.msg);
    bool isIos = Platform.isIOS;
    if (!listNoEmpty(isIos ? iModel.soundUrls : model.urls)) return Container();

    var urls = isIos ? iModel.soundUrls[0] : model.urls[0];
    var body = [
      MsgAvatar(model: widget.model, globalModel: globalModel),
      Container(
        width: 100.0,
        padding: EdgeInsets.only(right: 10.0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: 18.0, right: 4.0),
            backgroundColor: widget.model.id == globalModel.account
                ? Color(0xff98E165)
                : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
          ),
          child: Row(
            mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text("0\"", textAlign: TextAlign.start, maxLines: 1),
              SizedBox(width: mainSpace / 2),
              Image.asset(
                  animation != null
                      ? soundImg[animation.value % 3]
                      : soundImg[3],
                  height: 20.0,
                  color: Colors.black,
                  fit: BoxFit.cover),
              SizedBox(width: mainSpace)
            ],
          ),
          onPressed: () {
            if (strNoEmpty(urls)) {
              playNew(urls);
            } else {
              showToast(context, '未知错误');
            }
          },
        ),
      ),
      Spacer(),
    ];
    if (isSelf) {
      body = body.reversed.toList();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
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