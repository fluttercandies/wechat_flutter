import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SearchMainView extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final bool isBorder;

  SearchMainView({
    this.onTap,
    this.text,
    this.isBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    var row = new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: new Icon(Icons.search, color: mainTextColor),
        ),
        new Text(
          text,
          style: TextStyle(color: mainTextColor),
        )
      ],
    );

    return new InkWell(
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder
              ? Border(
                  bottom: BorderSide(color: lineColor, width: 0.2),
                )
              : null,
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: row,
      ),
      onTap: onTap ?? () {},
    );
  }
}
