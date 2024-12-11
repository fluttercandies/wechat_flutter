import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_tips_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';

class ContentMsg extends StatefulWidget {
  final V2TimMessage? msg;

  ContentMsg(this.msg);

  @override
  _ContentMsgState createState() => _ContentMsgState();
}

class _ContentMsgState extends State<ContentMsg> {
  String? str;

  TextStyle _style = TextStyle(color: mainTextColor, fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    if (widget.msg == null) {
      return Text('未知消息', style: _style);
    }
    if (widget.msg?.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      str = widget.msg?.textElem?.text ?? "";
    } else if (widget.msg?.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      str = '[图片]';
    } else if (widget.msg?.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      str = '[语音消息]';
    } else if (widget.msg?.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      str = '[视频]';
    } else if (widget.msg?.elemType ==
        MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      if (widget.msg?.groupTipsElem?.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_JOIN) {
        str = '[系统消息] 新人入群';
      } else if (widget.msg?.groupTipsElem?.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_QUIT) {
        str = '[系统消息] 有人退出群聊';
      } else if (widget.msg?.groupTipsElem?.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_GROUP_INFO_CHANGE) {
        str = '[系统消息] 群资料变更';
      } else if (widget.msg?.groupTipsElem?.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_MEMBER_INFO_CHANGE) {
        str = '[系统消息] 群员修改资料';
      } else {
        str = '[系统消息]';
      }
    }else {
      str = '[未知消息]';
    }

    return ExtendedText(
      str!,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _style,
    );
  }
}
