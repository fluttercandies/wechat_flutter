import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/pages/red_package/red_receive_dialog.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import 'msg_avatar.dart';

class RedPackage extends StatelessWidget {
  const RedPackage(this.model, {super.key});

  final V2TimMessage model;

  @override
  Widget build(BuildContext context) {
    final GlobalModel globalModel = Provider.of<GlobalModel>(context);
    List<Widget> body = <Widget>[
      MsgAvatar(model: model, globalModel: globalModel),
      const SizedBox(width: mainSpace),
      InkWell(
        child: Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 3),
          decoration: const BoxDecoration(
            color: Color(0xffe3a353),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: model.id != globalModel.account
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5), width: 0.2),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/wechat/c2c_hongbao_icon_hk.png',
                        width: 30),
                    const SizedBox(width: 5),
                    const Text(
                      '恭喜发财，大吉大利',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(color: Colors.white, height: 1),
              Text(
                '微信红包',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 8),
              )
            ],
          ),
        ),
        onTap: () {
          redReceiveDialog(context);
        },
      ),
    ];
    final bool self = model.sender == globalModel.account;
    if (self) {
      body = body.reversed.toList();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            !self ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: body,
      ),
    );
  }
}
