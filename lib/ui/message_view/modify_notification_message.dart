import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_tips_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../provider/global_model.dart';

class ModifyNotificationMessage extends StatefulWidget {
  const ModifyNotificationMessage(this.msg, {super.key});

  final V2TimMessage msg;

  @override
  ModifyNotificationMessageState createState() =>
      ModifyNotificationMessageState();
}

class ModifyNotificationMessageState extends State<ModifyNotificationMessage> {
  @override
  Widget build(BuildContext context) {
    final V2TimGroupTipsElem groupTipsElem = widget.msg.groupTipsElem!;
    final GlobalModel globalModel = Provider.of<GlobalModel>(context);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        '${groupTipsElem.opMember.userID == globalModel.account ? "你" : groupTipsElem.opMember.nickName} 修改了群公告',
        style: const TextStyle(
            color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}
