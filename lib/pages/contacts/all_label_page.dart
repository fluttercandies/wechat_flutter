import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AllLabelPage extends StatefulWidget {
  @override
  _AllLabelPageState createState() => _AllLabelPageState();
}

class _AllLabelPageState extends State<AllLabelPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(title: '所有标签'),
      body: new Center(
        child: new Text(
          '您暂时没有标签',
          style: TextStyle(color: mainTextColor),
        ),
      ),
    );
  }
}
