import 'package:flutter/material.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var body = new Center(
      child: new Text(
        '加载中...',
        style: TextStyle(color: mainTextColor),
      ),
    );

    return new Scaffold(body: body);
  }
}
