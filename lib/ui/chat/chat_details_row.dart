import 'package:dim_example/config/contacts.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/item/chat_voice.dart';
import 'package:flutter/material.dart';

class ChatDetailsRow extends StatelessWidget {
  final GestureTapCallback voiceOnTap;
  final bool isVoice;
  final LayoutWidgetBuilder edit;
  final Widget more;

  ChatDetailsRow({this.voiceOnTap, this.isVoice, this.edit, this.more});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Color(AppColors.ChatBoxBg),
          border: Border(
            top: BorderSide(color: lineColor, width: Constants.DividerWidth),
            bottom: BorderSide(color: lineColor, width: Constants.DividerWidth),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InkWell(
              child: new Image.asset('assets/images/chat/ic_voice.webp',
                  width: 25, color: mainTextColor),
              onTap: () {
                if (voiceOnTap != null) {
                  voiceOnTap();
                }
              },
            ),
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(
                    top: 7.0, bottom: 7.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: isVoice
                    ? new ChatVoice()
                    : new LayoutBuilder(builder: edit),
              ),
            ),
            new InkWell(
              child: new Image.asset('assets/images/chat/ic_Emotion.webp',
                  width: 30, fit: BoxFit.cover),
              onTap: () {},
            ),
            more,
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
