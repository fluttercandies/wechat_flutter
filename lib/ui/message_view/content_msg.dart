import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';

class ContentMsg extends StatefulWidget {
  final V2TimMessage? msg;

  ContentMsg(this.msg);

  @override
  _ContentMsgState createState() => _ContentMsgState();
}

class _ContentMsgState extends State<ContentMsg> {
  String? str = "[未知消息]";

  TextStyle _style = TextStyle(color: mainTextColor, fontSize: 14.0);

  V2TimMessage? get msg {
    return widget.msg;
  }

  @override
  Widget build(BuildContext context) {
    if (msg == null) return new Text('未知消息', style: _style);

    if (msg!.textElem != null) {
      str = widget.msg!.textElem!.text;
    } else if (msg!.imageElem != null) {
      str = '[图片]';
    } else if (msg!.soundElem != null) {
      str = '[语音消息]';
    } else if (msg!.videoElem != null) {
      str = '[视频]';
    } else {
      str = '[未知消息]';
    }
    // } else if (msg['tipsType'] == 'Join') {
    //   str = '[系统消息] 新人入群';
    // } else if (msg['tipsType'] == 'Quit') {
    //   str = '[系统消息] 有人退出群聊';
    // } else if (msg['groupInfoList'][0]['type'] == 'ModifyIntroduction') {
    //   str = '[系统消息] 群公告';
    // } else if (msg['groupInfoList'][0]['type'] == 'ModifyName') {
    //   str = '[系统消息] 群名修改';
    // }

    return new ExtendedText(
      str!,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _style,
    );
  }
}
