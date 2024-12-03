import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LabelRow extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final double? labelWidth;
  final bool isRight;
  final bool isLine;
  final String? value;
  final String? rValue;
  final Widget? rightW;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Widget? headW;
  final double lineWidth;

  LabelRow({
    this.label,
    this.onPressed,
    this.value,
    this.labelWidth,
    this.isRight = true,
    this.isLine = false,
    this.rightW,
    this.rValue,
    this.margin,
    this.padding = const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 5.0),
    this.headW,
    this.lineWidth = mainLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(0),
        ),
        onPressed: onPressed ?? () {},
        child: Container(
          padding: padding,
          margin: EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            border: isLine
                ? Border(bottom: BorderSide(color: lineColor, width: lineWidth))
                : null,
          ),
          child: Row(
            children: <Widget>[
              if (headW != null) headW!,
              SizedBox(
                width: labelWidth,
                child: Text(
                  label ?? '',
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(
                    color: mainTextColor.withOpacity(0.7),
                  ),
                ),
              Spacer(),
              if (rValue != null)
                Text(
                  rValue!,
                  style: TextStyle(
                    color: mainTextColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (rightW != null) rightW!,
              if (isRight)
                Icon(
                  CupertinoIcons.right_chevron,
                  color: mainTextColor.withOpacity(0.5),
                )
              else
                Container(width: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}