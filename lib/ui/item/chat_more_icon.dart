import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ChatMoreIcon extends StatelessWidget {
  final bool isMore;
  final String value;
  final VoidCallback onTap;
  final GestureTapCallback moreTap;

  ChatMoreIcon({
    this.isMore = false,
    this.value,
    this.onTap,
    this.moreTap,
  });

  @override
  Widget build(BuildContext context) {
    return strNoEmpty(value)
        ? new ComMomButton(
            text: '发送',
            style: TextStyle(color: Colors.white),
            width: 45.0,
            margin: EdgeInsets.all(10.0),
            radius: 4.0,
            onTap: onTap ?? () {},
          )
        : new InkWell(
            child: new Container(
              width: 23,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: new Image.asset(
                'assets/images/chat/ic_chat_more.webp',
                color: mainTextColor,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              if (moreTap != null) {
                moreTap();
              }
            },
          );
  }
}
