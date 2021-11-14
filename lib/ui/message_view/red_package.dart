import 'package:dim/commom/check.dart';
import 'package:dim/commom/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/config/const.dart';
import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

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
      new Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 3),
        decoration: BoxDecoration(
          color: Color(0xffe3a353),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          crossAxisAlignment: model.id != globalModel.account
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.white.withOpacity(0.5), width: 0.2),
                ),
              ),
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Image.asset('assets/images/wechat/c2c_hongbao_icon_hk.png',
                      width: 30),
                  Space(width: 5),
                  Text(
                    '恭喜发财，大吉大利',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            HorizontalLine(color: Colors.white, height: 1),
            Text(
              '微信红包',
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 8),
            )
          ],
        ),
      ),
    ];
    if (model.id == globalModel.account) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(
        mainAxisAlignment: model.id != globalModel.account
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: body,
      ),
    );
  }
}
