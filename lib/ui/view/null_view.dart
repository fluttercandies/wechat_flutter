import 'package:dim_example/pages/root/user_page.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class HomeNullView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new InkWell(
        child: new Text(
          '无会话消息',
          style: TextStyle(color: mainTextColor),
        ),
        onTap: () => routePush(new UserPage()),
      ),
    );
  }
}
