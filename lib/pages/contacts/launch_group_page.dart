import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class LaunchGroupPage extends StatefulWidget {
  @override
  _LaunchGroupPageState createState() => _LaunchGroupPageState();
}

class _LaunchGroupPageState extends State<LaunchGroupPage> {
  List<Widget> body() {
    return [
      new Space(height: 50.0),
      new Container(
        width: winWidth(context),
        height: winHeight(context),
        color: CupertinoColors.activeBlue.withOpacity(0.5),
      ),
      new Container(
        width: winWidth(context),
        height: winHeight(context),
        color: CupertinoColors.destructiveRed.withOpacity(0.5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = new FlatButton(
      onPressed: () {},
      child: new Text('确定'),
    );
    return Scaffold(
      appBar: new ComMomBar(
        title: '发起群聊',
        rightDMActions: <Widget>[rWidget],
      ),
      body: new Stack(
        children: <Widget>[
          new SingleChildScrollView(
            child: new Column(children: body()),
          ),
          new Container(
            color: Colors.white.withOpacity(0.5),
            width: winWidth(context),
            alignment: Alignment.center,
            height: 50.0,
            child: new Text('搜索'),
          )
        ],
      ),
    );
  }
}
