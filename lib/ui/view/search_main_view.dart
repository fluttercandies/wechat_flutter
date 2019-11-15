import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class SearchMainView extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;

  SearchMainView({this.onTap, this.text});

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
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: row,
      ),
      onTap: onTap ?? () {},
    );
  }
}
