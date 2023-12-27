import 'package:wechat_flutter/tools/wechat_flutter.dart' as prefix0;
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MoreItemCard extends StatelessWidget {
  final String? name, icon;
  final VoidCallback? onPressed;
  final double? keyboardHeight;

  MoreItemCard({this.name, this.icon, this.onPressed, this.keyboardHeight});

  @override
  Widget build(BuildContext context) {
    double? _margin =
        keyboardHeight != null && keyboardHeight != 0.0 ? keyboardHeight : 0.0;
    double _top = _margin != 0.0 ? _margin! / 10 : 20.0;

    return new Container(
      padding: EdgeInsets.only(top: _top, bottom: 5.0),
      width: (FrameSize.winWidth() - 70) / 4,
      child: new Column(
        children: <Widget>[
          new Container(
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: new TextButton(
              onPressed: () {
                if (onPressed != null) {
                  onPressed!();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              ),
              child: new Container(
                width: 50.0,
                child: new Image.asset(icon!, fit: BoxFit.cover),
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
