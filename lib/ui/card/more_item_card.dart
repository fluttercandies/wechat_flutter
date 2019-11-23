import 'package:dim_example/tools/wechat_flutter.dart' as prefix0;
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class MoreItemCard extends StatelessWidget {
  final String name, icon;
  final VoidCallback onPressed;

  MoreItemCard({this.name, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
      width: (winWidth(context) - 70) / 4,
      child: new Column(
        children: <Widget>[
          new Container(
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: new FlatButton(
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(0),
              color: Colors.white,
              child: new Container(
                width: 50.0,
                child: new Image.asset(icon, fit: BoxFit.cover),
              ),
            ),
          ),
          new prefix0.Space(height: mainSpace / 2),
          new Text(
            name ?? '',
            style: TextStyle(color: mainTextColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
