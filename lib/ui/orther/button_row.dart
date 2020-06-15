import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ButtonRow extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final String text;
  final TextStyle style;
  final VoidCallback onPressed;
  final bool isBorder;
  final double lineWidth;

  ButtonRow({
    this.margin,
    this.text,
    this.style = const TextStyle(
        color: btTextColor, fontWeight: FontWeight.w600, fontSize: 16),
    this.onPressed,
    this.isBorder = false,
    this.lineWidth = mainLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: margin,
      decoration: BoxDecoration(
        border: isBorder
            ? Border(
                bottom: BorderSide(color: lineColor, width: lineWidth),
              )
            : null,
      ),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        onPressed: onPressed ?? () {},
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          alignment: Alignment.center,
          child: new Text(text, style: style),
        ),
      ),
    );
  }
}
