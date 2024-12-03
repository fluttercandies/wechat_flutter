import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ButtonRow extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final String text;
  final TextStyle style;
  final VoidCallback? onPressed;
  final bool isBorder;
  final double lineWidth;

  ButtonRow({
    this.margin,
    required this.text,
    this.style = const TextStyle(
        color: btTextColor, fontWeight: FontWeight.w600, fontSize: 16),
    this.onPressed,
    this.isBorder = false,
    this.lineWidth = mainLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        border: isBorder
            ? Border(
          bottom: BorderSide(color: lineColor, width: lineWidth),
        )
            : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(0),
        ),
        onPressed: onPressed ?? () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          alignment: Alignment.center,
          child: Text(text, style: style),
        ),
      ),
    );
  }
}