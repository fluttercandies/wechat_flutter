import 'dart:io';

import 'package:dim_example/im/model/chat_data.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/provider/global_model.dart';

import 'package:dim_example/ui/message_view/Img_msg.dart';
import 'package:dim_example/ui/message_view/join_message.dart';
import 'package:dim_example/ui/message_view/quit_message.dart';
import 'package:dim_example/ui/message_view/sound_message.dart';
import 'package:dim_example/ui/message_view/tem_message.dart';
import 'package:dim_example/ui/message_view/text_msg.dart';
import 'package:dim_example/ui/message_view/video_message.dart';

class SendMessageView extends StatefulWidget {
  final ChatData model;

  SendMessageView(this.model);

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    Map msg = widget.model.msg;
    String msgType = msg['type'];

    bool isI = Platform.isIOS;
    bool iosText = isI && msg.toString().contains('text:');
    bool iosImg = isI && msg.toString().contains('imageList:');
    if (msgType == "Text" || iosText) {
      return new TextMsg(msg['text'], widget.model);
    } else if (msgType == "Image" || iosImg) {
      return new ImgMsg(msg, widget.model);
    } else {
      return new Text('未知消息');
    }
  }
}
