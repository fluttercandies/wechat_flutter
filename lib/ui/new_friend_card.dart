import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class NewFriendCard extends StatelessWidget {
  final String name, img;
  final bool isAdd;
  final VoidCallback onTap;

  NewFriendCard({this.name, this.img, this.isAdd = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      onPressed: () {},
      child: new Row(
        children: <Widget>[
          new ImageView(img: img, width: 45.0, height: 45.0, fit: BoxFit.cover),
          new Space(width: mainSpace),
          new Container(
            width: winWidth(context) - 95,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: lineColor, width: 0.3),
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      name ?? '未知',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.normal),
                    ),
                    new Space(height: mainSpace * 0.2),
                    new Text(
                      '你好，我是$name',
                      style: TextStyle(color: mainTextColor, fontSize: 14.0),
                    ),
                  ],
                ),
                new Spacer(),
                isAdd
                    ? new Text(
                        '已添加',
                        style: TextStyle(color: mainTextColor),
                      )
                    : new ComMomButton(
                        text: '添加',
                        width: 60.0,
                        height: 30.0,
                        color: lineColor.withOpacity(0.2),
                        style: TextStyle(color: Colors.green),
                        onTap: () {
                          if (onTap != null) {
                            onTap();
                          }
                        },
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
