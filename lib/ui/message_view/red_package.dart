import 'package:dim/commom/check.dart';
import 'package:dim/commom/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/config/const.dart';
import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/provider/global_model.dart';

import 'msg_avatar.dart';

class RedPackage extends StatelessWidget {
  final ChatData model;

  RedPackage(this.model);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: model, globalModel: globalModel),
      new Space(width: mainSpace),
      new Expanded(
        child: new Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Text(
            '我是红包',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
