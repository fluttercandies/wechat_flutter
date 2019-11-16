import 'package:dim_example/pages/chat/chat_page.dart';
import 'package:dim_example/ui/item/contact_card.dart';
import 'package:dim_example/ui/orther/button_row.dart';
import 'package:dim_example/ui/orther/label_row.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ContactsDetailsPage extends StatefulWidget {
  final String avatar, title, id;

  ContactsDetailsPage({this.avatar, this.title, this.id});

  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();
}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {
  List<Widget> body() {
    return [
      new ContactCard(
        img: widget.avatar,
        id: widget.id,
        title: widget.title,
        nickName: widget.title,
        area: '北京 海淀区',
        isBorder: true,
      ),
      new LabelRow(
        label: '设置备注和标签',
        margin: EdgeInsets.only(bottom: 10.0),
      ),
      new LabelRow(label: '朋友圈', isLine: true),
      new LabelRow(label: '更多信息'),
      new ButtonRow(
        margin: EdgeInsets.only(top: 10.0),
        text: '发消息',
        isBorder: true,
        onPressed: () => routePushReplace(
            new ChatPage(id: widget.id, title: widget.title, type: 1)),
      ),
      new ButtonRow(
        text: '音视频通话',
        onPressed: () => showToast(context, '敬请期待'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new SizedBox(
        width: 60,
        child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: new Image.asset(contactAssets + 'ic_contacts_details.png'),
        ),
      )
    ];

    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
          title: '', backgroundColor: Colors.white, rightDMActions: rWidget),
      body: new SingleChildScrollView(
        child: new Column(children: body()),
      ),
    );
  }
}
