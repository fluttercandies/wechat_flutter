import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
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
      appBar: new ComMomBar(title: '二维码名片', rightDMActions: rWidget),
      body: new Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
