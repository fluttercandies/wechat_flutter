import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/ui/message_view/msg_avatar.dart';
import 'package:wechat_flutter/ui/message_view/text_item_container.dart';


class TextMsg extends StatelessWidget {
  final String? text;
  final V2TimMessage model;

  TextMsg(this.text, this.model);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: model, globalModel: globalModel),
      new TextItemContainer(
        text: text ?? '文字为空',
        action: '',
        isMyself: model.sender == globalModel.account,
      ),
      new Spacer(),
    ];
    if (model.sender == globalModel.account) {
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
