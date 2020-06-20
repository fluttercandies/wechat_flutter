import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ContentMsg extends StatefulWidget {
  final Map msg;

  ContentMsg(this.msg);

  @override
  _ContentMsgState createState() => _ContentMsgState();
}

class _ContentMsgState extends State<ContentMsg> {
  String str;

  TextStyle _style = TextStyle(color: mainTextColor, fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    if (widget.msg == null) return new Text('未知消息', style: _style);
    Map msg = widget.msg['message'];
    String msgType = msg['type'];
    String msgStr = msg.toString();

    bool isI = Platform.isIOS;
    bool iosText = isI && msgStr.contains('text:');
    bool iosImg = isI && msgStr.contains('imageList:');
    var iosS = msgStr.contains('downloadFlag:') && msgStr.contains('second:');
    bool iosSound = isI && iosS;
    if (msgType == "Text" || iosText) {
      str = msg['text'];
    } else if (msgType == "Image" || iosImg) {
      str = '[图片]';
    } else if (msgType == 'Sound' || iosSound) {
      str = '[语音消息]';
    } else {
      str = '[未知消息]';
    }

    return new Text(
      str,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _style,
    );
  }
}
