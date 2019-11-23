import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class MoreItemCard extends StatelessWidget {
  final String name, icon;
  final VoidCallback onPressed;

  MoreItemCard({this.name, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      padding: EdgeInsets.all(0),
      child: new Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
        width: 100.0,
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: new Image.asset(icon, fit: BoxFit.cover),
            ),
            new Text(
              name ?? '',
              style: TextStyle(color: mainTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
