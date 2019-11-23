import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ContentMsg extends StatefulWidget {
  final Map msg;

  ContentMsg(this.msg);

  @override
  _ContentMsgState createState() => _ContentMsgState();
}

class _ContentMsgState extends State<ContentMsg> {
  String str;

  @override
  Widget build(BuildContext context) {
    if (widget.msg == null) return new Text('消息为空');
    Map msg = widget.msg['message'];
    String msgType = msg['type'];

    bool isI = Platform.isIOS;
    bool iosText = isI && msg.toString().contains('text:');
    bool iosImg = isI && msg.toString().contains('imageList:');
    if (msgType == "Text" || iosText) {
      str = msg['text'];
    } else if (msgType == "Image" || iosImg) {
      str = '[图片]';
    } else {
      str = '[未知消息]';
    }

    return new Text(
      str,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: mainTextColor, fontSize: 14.0),
    );
  }
}
