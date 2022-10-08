import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/im/login_handle.dart';

class SetPage extends StatefulWidget {
  const SetPage({Key key}) : super(key: key);

  @override
  State<SetPage> createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  void actionHandle(e) {
    switch (e) {
      case "退出登录":
        loginOut(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComMomBar(title: "设置"),
      body: ListView(
        children: ["退出登录"].map((e) {
          return TextButton(onPressed: () => actionHandle(e), child: Text(e));
        }).toList(),
      ),
    );
  }
}
