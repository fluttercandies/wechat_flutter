import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/pages/contacts/contacts_details_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MsgAvatar extends StatelessWidget {
  final GlobalModel globalModel;
  final ChatData model;

  MsgAvatar({@required this.globalModel, @required this.model});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.only(right: 10.0),
        child: new ImageView(
          img: model.id == globalModel.account
              ? globalModel.avatar??defIcon
              : model.avatar,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      onTap: () {
        routePush(new ContactsDetailsPage(
          title: model.nickName,
          avatar: model.avatar,
          id: model.id,
        ));
      },
    );
  }
}
