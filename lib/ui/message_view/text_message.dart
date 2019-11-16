import 'package:dim_example/im/model/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/ui/message_view/text_item_container.dart';
import 'package:provider/provider.dart';

import '../../provider/global_model.dart';
import '../view/image_view.dart';

class TextMessage extends StatelessWidget {
  final String text;
  final ChatData model;

  TextMessage(this.text, this.model);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        margin: EdgeInsets.only(right: 10.0),
        child: new ImageView(
            img: model.id == globalModel.account ? globalModel.avatar : model.avatar,
            height: 50,
            width: 50,
            fit: BoxFit.fill),
      ),
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
