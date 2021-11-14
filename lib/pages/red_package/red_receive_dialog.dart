import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

/// 微信领取红包对话框
Future redReceiveDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return RedReceiveDialog();
    },
  );
}

class RedReceiveDialog extends StatefulWidget {
  @override
  _RedReceiveDialogState createState() => _RedReceiveDialogState();
}

class _RedReceiveDialogState extends State<RedReceiveDialog> {
  Color textColor = Color(0xff3e3cea5);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: winWidth(context) - 100,
            height: winHeight(context) / 1.8,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: Color(0xffd26853),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset(
                        'assets/images/wechat/in/default_nor_avatar.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Space(width: 5),
                    Text(
                      'xxx发出的红包',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Space(height: 5),
                Text(
                  '恭喜发财，大吉大利',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Spacer(),
                Spacer(),
                InkWell(
                  child: Image.asset(
                    'assets/images/wechat/aca.png',
                    width: 80,
                  ),
                  onTap: () {
                    showToast(context, ' 敬请期待');
                  },
                ),
                Spacer(),
              ],
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              decoration: BoxDecoration(
                  border: Border.all(color: textColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              width: 35,
              height: 35,
              padding: EdgeInsets.all(5),
              child: Image.asset(
                'assets/images/wechat/b0_.png',
                color: textColor,
              ),
            ),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
