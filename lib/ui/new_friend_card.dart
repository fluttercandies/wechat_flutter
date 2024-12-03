import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class NewFriendCard extends StatelessWidget {
  final String name;
  final String img;
  final bool isAdd;
  final VoidCallback? onTap;

  NewFriendCard({
    required this.name,
    required this.img,
    this.isAdd = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      onPressed: () {},
      child: Row(
        children: <Widget>[
          ImageView(img: img, width: 45.0, height: 45.0, fit: BoxFit.cover),
          SizedBox(width: mainSpace),
          Container(
            width: MediaQuery.of(context).size.width - 95,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: lineColor, width: 0.3),
              ),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: mainSpace * 0.2),
                    Text(
                      '你好，我是$name',
                      style: TextStyle(color: mainTextColor, fontSize: 14.0),
                    ),
                  ],
                ),
                Spacer(),
                isAdd
                    ? Text(
                  '已添加',
                  style: TextStyle(color: mainTextColor),
                )
                    : ComMomButton(
                  text: '添加',
                  width: 60.0,
                  height: 30.0,
                  color: lineColor.withOpacity(0.2),
                  style: TextStyle(color: Colors.green),
                  onTap: onTap,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}