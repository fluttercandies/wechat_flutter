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
  Duration duration;
  Duration position;

  AnimationController controller;
  Animation animation;
  FlutterSound flutterSound;
  AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  StreamSubscription _playerSubscription;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    //控制语音动画
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final Animation curve =
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
//
//    _audioPlayerStateSubscription =
//        flutterSound.onPlayerStateChanged.listen((s) {
//      if (s != null) {
//      } else {
//        controller.reset();
//        setState(() {
//          position = duration;
//        });
//      }
//    }, onError: (msg) {
//      setState(() {
//        duration = new Duration(seconds: 0);
//        position = new Duration(seconds: 0);
//      });
//    });
  }

  void start(String path) async {
    try {
      controller.forward();
      await flutterSound.startPlayer(path);
      await flutterSound.setVolume(1.0);
      debugPrint('startPlayer: $path');

      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          sliderCurrentPosition = e.currentPosition;
          maxDuration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

          print(txt.substring(0, 8).toString());
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  playNew(url) async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      showToast(context, '播放中');
    } else {
      showToast(context, '播放出问题了');
    }
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
      new MsgAvatar(model: widget.model, globalModel: globalModel),
      new Container(
        width: 100.0,
        padding: EdgeInsets.only(right: 10.0),
        child: new FlatButton(
          padding: EdgeInsets.only(left: 18.0, right: 4.0),
          child: new Row(
            mainAxisAlignment:
                isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              new Text("0\"", textAlign: TextAlign.start, maxLines: 1),
              new Space(width: mainSpace / 2),
              new Image.asset(
                  animation != null
                      ? soundImg[animation.value % 3]
                      : soundImg[3],
                  height: 20.0,
                  color: Colors.black,
                  fit: BoxFit.cover),
              new Space(width: mainSpace)
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: widget.model.id == globalModel.account
              ? Color(0xff98E165)
              : Colors.white,
          onPressed: () {
            if (strNoEmpty(urls)) {
              playNew(urls);
            } else {
              showToast(context, '未知错误');
            }
          },
        ),
      ),
      new Spacer(),
    ];
    if (isSelf) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }

  @override
  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription.cancel();
    }
    if (_audioPlayerStateSubscription != null) {
      _audioPlayerStateSubscription.cancel();
    }
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
    }
    controller.dispose();
    super.dispose();
  }
}
