import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:wechat_flutter/ui/message_view/Img_msg.dart';
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
  V2TimMessage get model {
    return widget.model;
  }

  @override
  Widget build(BuildContext context) {
    if ((model.textElem != null) &&
        widget.model.textElem.text.toString().contains("测试发送红包消息")) {
      return new RedPackage(widget.model);
    } else if (model.textElem != null) {
      return new TextMsg(model.textElem.text, widget.model);
    } else if (model.imageElem != null) {
      return new ImgMsg(model.imageElem, widget.model);
    } else if (model.soundElem != null) {
      return new SoundMsg(widget.model);
//    } else if (msg.toString().contains('snapshotPath') &&
//        msg.toString().contains('videoPath')) {
//      return VideoMessage(msg, msgType, widget.data);
//     } else if (msg['tipsType'] == 'Join') {
//       return JoinMessage(msg);
//     } else if (msg['tipsType'] == 'Quit') {
//       return QuitMessage(msg);
//     } else if (msg['groupInfoList'][0]['type'] == 'ModifyIntroduction') {
//       return ModifyNotificationMessage(msg);
//     } else if (msg['groupInfoList'][0]['type'] == 'ModifyName') {
//       return ModifyGroupInfoMessage(msg);
    } else {
      return new Text('未知消息');
    }
  }
}
