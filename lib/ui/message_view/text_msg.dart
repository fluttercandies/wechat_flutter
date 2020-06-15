import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/ui/message_view/text_item_container.dart';
import 'package:provider/provider.dart';

import '../../provider/global_model.dart';
import '../view/image_view.dart';

class TextMsg extends StatelessWidget {
  final String text;
  final ChatData model;

  TextMsg(this.text, this.model);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: model, globalModel: globalModel),
      new TextItemContainer(
        text: text ?? '文字为空',
        action: '',
        isMyself: model.id == globalModel.account,
      ),
      new Spacer(),
    ];
    if (model.id == globalModel.account) {
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
