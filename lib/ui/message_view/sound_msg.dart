import 'package:dim_example/im/model/chat_data.dart';
import 'package:dim_example/provider/global_model.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SoundMsg extends StatefulWidget {
  final ChatData model;
  final int voiceTime;

  SoundMsg(this.model, {this.voiceTime = 0});

  @override
  _SoundMsgState createState() => _SoundMsgState();
}

class _SoundMsgState extends State<SoundMsg> with TickerProviderStateMixin {
  Duration duration;
  Duration position;

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
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
              new Text("${widget.voiceTime}\"",
                  textAlign: TextAlign.start, maxLines: 1),
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
          onPressed: () {},
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
}
