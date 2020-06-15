import 'package:wechat_flutter/pages/root/user_page.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LoadingView extends StatelessWidget {
  final bool isStr;

  LoadingView({this.isStr = true});

  @override
  Widget build(BuildContext context) {
    var body = new Center(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new InkWell(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '加载中',
                  style: TextStyle(color: mainTextColor),
                ),
                isStr
                    ? new Text(
                        '第一次进点我',
                        style: TextStyle(color: mainTextColor, fontSize: 9),
                      )
                    : new Container(),
              ],
            ),
            onTap: () {
              if (isStr) routePush(new UserPage());
            },
          ),
          new Space(),
          new SizedBox(
            width: 20.0,
            height: 20.0,
            child: new CircularProgressIndicator(
              strokeWidth: 1.0,
              backgroundColor: Colors.transparent,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(mainTextColor),
            ),
          )
        ],
      ),
    );

    return new Scaffold(body: body);
  }
}
