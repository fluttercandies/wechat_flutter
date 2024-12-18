import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class EditView extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final Color? bottomLineColor;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;

  EditView({
    this.label,
    this.hint,
    this.controller,
    this.bottomLineColor,
    this.focusNode,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var row = Row(
      children: <Widget>[
        Container(
          width: Get.width * 0.25,
          alignment: Alignment.centerLeft,
          child: Text(
            label ?? '',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          child: TextField(
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: hint ?? '',
              border: InputBorder.none,
            ),
            onTap: onTap ?? () {},
            onChanged: onChanged ?? (str) {},
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: bottomLineColor ?? lineColor,
            width: bottomLineColor == null ? 0.3 : 0.7,
          ),
        ),
      ),
      child: row,
    );
  }
}