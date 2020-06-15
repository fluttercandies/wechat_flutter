import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class VerifySwitch extends StatefulWidget {
  final String title;
  final String defStr;

  VerifySwitch({this.title, this.defStr = ''});

  @override
  _VerifySwitchState createState() => new _VerifySwitchState();
}

class _VerifySwitchState extends State<VerifySwitch> {
  bool valueSwitch = false;

  Widget contentBuild() {
    var row = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text('不让他(她)看'),
        new CupertinoSwitch(
          value: valueSwitch,
          dragStartBehavior: DragStartBehavior.start,
          onChanged: (value) {
            valueSwitch = value;
            setState(() {});
          },
        )
      ],
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          widget.title ?? '',
          style: TextStyle(color: mainTextColor, fontSize: 15.0),
        ),
        new Space(height: mainSpace * 1),
        new Container(
          width: winWidth(context) - 20,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.center,
          child: row,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0,
      width: winWidth(context),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: contentBuild(),
    );
  }
}
