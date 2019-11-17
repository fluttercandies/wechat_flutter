import 'package:dim_example/ui/orther/label_row.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class MoreInfoPage extends StatefulWidget {
  @override
  _MoreInfoPageState createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(title: '更多'),
      body: new Column(
        children: <Widget>[
          new LabelRow(
            label: '个性签名',
            rValue: '暂无',
            isRight: false,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
