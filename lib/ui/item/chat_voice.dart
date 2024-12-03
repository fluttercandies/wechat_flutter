import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/date.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/voice_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

typedef VoiceFile = void Function(String path);

class ChatVoice extends StatefulWidget {
  final VoiceFile? voiceFile;

  ChatVoice({this.voiceFile});

  @override
  _ChatVoiceWidgetState createState() => _ChatVoiceWidgetState();
}

class _ChatVoiceWidgetState extends State<ChatVoice> {
  double startY = 0.0;
  double offset = 0.0;
  int? index;

  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";

  StreamSubscription? _recorderSubscription;
  StreamSubscription? _dbPeakSubscription;

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry? overlayEntry;
  late FlutterSound flutterSound;

  @override
  void initState() {
    super.initState();
    flutterSound = FlutterSound();
    initializeDateFormatting();
  }

  void start() async {
    print('开始拉。当前路径');
    showToast( "正在兼容最新flutter");
    // try {
    //   String path = await flutterSound
    //       .startRecorder(Platform.isIOS ? 'ios.m4a' : 'android.mp4');
    //   widget.voiceFile?.call(path);
    //   _recorderSubscription =
    //       flutterSound.onRecorderStateChanged.listen((e) {});
    // } catch (err) {
    //   RecorderRunningException e = err;
    //   showToast( 'startRecorder error: ${e.message}');
    // }
  }

  void stop() async {
    // try {
    //   String result = await flutterSound.stopRecorder();
    //   print('stopRecorder: $result');
    //
    //   _recorderSubscription?.cancel();
    //   _recorderSubscription = null;
    //   _dbPeakSubscription?.cancel();
    //   _dbPeakSubscription = null;
    // } catch (err) {
    //   RecorderStoppedException e = err;
    //   showToast( 'stopRecorder error: ${e.message}');
    // }
  }

  void showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
      DateTime now = DateTime.now();
      int date = now.millisecondsSinceEpoch;
      DateTime current = DateTime.fromMillisecondsSinceEpoch(date);

      String recordingTime =
      DateTimeForMater.formatDateV(current, format: "ss:SS");
      index = int.parse(recordingTime.substring(3, 5));
    });

    start();

    if (overlayEntry == null) {
      overlayEntry = showVoiceDialog(context, index: index!);
    }
  }

  void hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    overlayEntry?.remove();
    overlayEntry = null;

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
      Notice.send(WeChatActions.voiceImg(), true);
    }
  }

  void moveVoiceView() {
    setState(() {
      isUp = startY - offset > 100;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragDown: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragCancel: hideVoiceView,
      onVerticalDragEnd: (details) => hideVoiceView(),
      onVerticalDragUpdate: (details) {
        offset = details.globalPosition.dy;
        moveVoiceView();
      },
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        width: Get.width,
        color: Colors.white,
        child: Text(textShow),
      ),
    );
  }
}