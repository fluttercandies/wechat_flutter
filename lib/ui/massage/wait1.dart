import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_tips_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_tips_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/ui/message_view/Img_msg.dart';
import 'package:wechat_flutter/ui/message_view/join_message.dart';
import 'package:wechat_flutter/ui/message_view/modify_groupInfo_message.dart';
import 'package:wechat_flutter/ui/message_view/modify_notification_message.dart';
import 'package:wechat_flutter/ui/message_view/quit_message.dart';
import 'package:wechat_flutter/ui/message_view/red_package.dart';
import 'package:wechat_flutter/ui/message_view/sound_msg.dart';
import 'package:wechat_flutter/ui/message_view/text_msg.dart';

class SendMessageView extends StatefulWidget {
  final V2TimMessage model;

  SendMessageView(this.model);

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    final V2TimMessage msg = widget.model;
    final int msgType = msg.elemType;
    final String msgStr = msg.textElem?.text ?? "";
    if ((msgType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) &&
        msgStr.contains("测试发送红包消息")) {
      return RedPackage(widget.model);
    } else if (msgType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      return TextMsg(msgStr, widget.model);
    } else if (msgType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      return ImgMsg(widget.model);
    } else if (msgType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      return SoundMsg(widget.model);
//    } else if (msg.toString().contains('snapshotPath') &&
//        msg.toString().contains('videoPath')) {
//      return VideoMessage(msg, msgType, widget.data);
    } else if (msgType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      final V2TimGroupTipsElem groupTipsElem = msg.groupTipsElem!;
      if (groupTipsElem.type ==
              GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_INVITE ||
          groupTipsElem.type == GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_JOIN) {
        return JoinMessage(msg);
      } else if (groupTipsElem.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_QUIT) {
        return QuitMessage(msg);
      } else if (groupTipsElem.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_GROUP_INFO_CHANGE) {
        return ModifyNotificationMessage(msg);
      } else if (groupTipsElem.type ==
          GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_MEMBER_INFO_CHANGE) {
        return ModifyGroupInfoMessage(msg);
      }
    }
    return Text('未知消息');
  }
}
