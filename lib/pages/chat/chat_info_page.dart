import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ChatInfoPage extends StatefulWidget {
  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  List<Widget> body() {
    return [
      new Container(
        color: Colors.white,
        height: 60,
        width: winWidth(context),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(title: '聊天信息'),
      body: new Column(
        children: body(),
      ),
    );
  }
}
