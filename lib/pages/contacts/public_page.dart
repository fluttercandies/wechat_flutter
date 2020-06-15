import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class PublicPage extends StatefulWidget {
  @override
  _PublicPageState createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(title: '公众号'),
      body: new Center(
        child: new Text(
          '您没有关注任何公众号',
          style: TextStyle(color: mainTextColor),
        ),
      ),
    );
  }
}
