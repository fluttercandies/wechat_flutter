import 'package:wechat_flutter/ui/orther/tip_verify_Input.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SetRemarkPage extends StatefulWidget {
  @override
  _SetRemarkPageState createState() => _SetRemarkPageState();
}

class _SetRemarkPageState extends State<SetRemarkPage> {
  TextEditingController _tc = new TextEditingController();
  FocusNode _f = new FocusNode();

  String initContent;

  Widget body() {
    return new SingleChildScrollView(
      child: new Column(
        children: [
          new TipVerifyInput(
            title: '备注',
            defStr: initContent,
            controller: _tc,
            focusNode: _f,
            color: appBarColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = new ComMomButton(
      text: '完成',
      style: TextStyle(color: Colors.white),
      width: 45.0,
      margin: EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () {
        if (!strNoEmpty(_tc.text)) {
          showToast(context, '输入的内容不能为空');
          return;
        }
      },
    );

    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(
        title: '设置备注和标签',
        rightDMActions: <Widget>[rWidget],
      ),
      body: new MainInputBody(child: body(), color: appBarColor),
    );
  }
}
