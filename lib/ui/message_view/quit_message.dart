import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_tips_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/provider/global_model.dart';

class QuitMessage extends StatelessWidget {
  const QuitMessage(this.msg, {super.key});

  final V2TimMessage msg;

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final V2TimGroupTipsElem groupTipsElem = msg.groupTipsElem!;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: new Text(
        '${groupTipsElem.opMember.userID == globalModel.account ? '你' : groupTipsElem.opMember.nickName}'
        ' 退出了群聊',
        style: const TextStyle(
            color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}
