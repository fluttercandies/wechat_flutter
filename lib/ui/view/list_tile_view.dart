import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ListTileView extends StatelessWidget {
  final BoxBorder border;
  final VoidCallback onPressed;
  final String title;
  final TextStyle titleStyle;
  final String label;
  final bool isLabel;
  final EdgeInsetsGeometry padding;
  final String icon;

  final EdgeInsetsGeometry margin;

  ListTileView(
      {this.border,
      this.onPressed,
      this.title,
      this.label,
      this.padding = const EdgeInsets.symmetric(vertical: 15.0),
      this.isLabel = true,
      this.icon = 'assets/images/favorite.webp',
      this.titleStyle =
          const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      this.margin});

  @override
  Widget build(BuildContext context) {
    var text = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(title ?? '', style: titleStyle ?? null),
        new Text(
          label ?? '',
          style: TextStyle(color: mainTextColor, fontSize: 12),
        ),
      ],
    );

    var view = [
      isLabel ? text : new Text(title, style: titleStyle),
      new Spacer(),
      new Container(
        width: 7.0,
        child: new Image.asset(
          'assets/images/ic_right_arrow_grey.webp',
          color: mainTextColor.withOpacity(0.5),
          fit: BoxFit.cover,
        ),
      ),
      new Space(),
    ];

    var row = new Row(
      children: <Widget>[
        new Container(
          width: 40.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: new Image.asset(icon),
        ),
        new Container(
          width: winWidth(context) - 60,
          padding: padding,
          decoration: BoxDecoration(border: border),
          child: new Row(children: view),
        ),
      ],
    );

    return new Container(
      margin: margin,
      child: new FlatButton(
        color: Colors.white,
        padding: EdgeInsets.all(0),
        onPressed: onPressed ?? () {},
        child: row,
      ),
    );
  }
}
