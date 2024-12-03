import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MoreItemCard extends StatelessWidget {
  final String name;
  final String icon;
  final VoidCallback? onPressed;
  final double? keyboardHeight;

  const MoreItemCard({
    Key? key,
    required this.name,
    required this.icon,
    this.onPressed,
    this.keyboardHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _margin = keyboardHeight ?? 0.0;
    double _top = _margin != 0.0 ? _margin / 10 : 20.0;

    return Container(
      padding: EdgeInsets.only(top: _top, bottom: 5.0),
      width: (Get.width - 70) / 4,
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Container(
                width: 50.0,
                child: Image.asset(icon, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: mainSpace / 2),
          Text(
            name,
            style: TextStyle(color: mainTextColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
