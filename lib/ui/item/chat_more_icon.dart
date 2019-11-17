import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ChatMoreIcon extends StatelessWidget {
  final bool isMore;
  final String value;
  final VoidCallback onTap;

  ChatMoreIcon({
    this.isMore = false,
    this.value,
    this.onTap,
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
        : new Container();
  }
}
