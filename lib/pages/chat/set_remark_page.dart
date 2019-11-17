import 'package:dim_example/ui/orther/tip_verify_Input.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class SetRemarkPage extends StatefulWidget {
  @override
  _SetRemarkPageState createState() => _SetRemarkPageState();
}

class _SetRemarkPageState extends State<SetRemarkPage> {
  TextEditingController _tc = new TextEditingController();
  FocusNode _f = new FocusNode();

  String initContent;

  Widget body() {
    return new Column(
      children: [
        new TipVerifyInput(
          title: '备注',
          defStr: initContent,
          controller: _tc,
          focusNode: _f,
          color: appBarColor,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = new FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {},
      child: new Text('完成'),
    );

    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
        title: '设置备注和标签',
        rightDMActions: <Widget>[rWidget],
      ),
      body: new MainInputBody(child: body()),
    );
  }
}
