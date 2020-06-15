import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new InkWell(
        child: new Container(
          width: 60.0,
          child: new Image.asset('assets/images/search_black.webp'),
        ),
        onTap: () => showToast(context, 'search'),
      ),
      new InkWell(
        child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: new Image.asset('assets/images/contact/ic_contact_add.webp',
              color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
        ),
        onTap: () => {},
      ),
    ];

    return new Scaffold(
      appBar: new ComMomBar(title: '群聊', rightDMActions: rWidget),
      body: new Center(
        child: new Text(
          '暂无群聊',
          style: TextStyle(color: mainTextColor),
        ),
      ),
    );
  }
}
