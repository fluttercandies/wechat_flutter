import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:wechat_flutter/ui/massage/wait1.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';

class ChatDetailsBody extends StatelessWidget {
  final ScrollController sC;
  final List<V2TimMessage> chatData;

  ChatDetailsBody({this.sC, this.chatData});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new ListView.builder(
          controller: sC,
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (context, int index) {
            V2TimMessage model = chatData[index];
            return new SendMessageView(model);
          },
          itemCount: chatData.length,
          dragStartBehavior: DragStartBehavior.down,
        ),
      ),
    );
  }
}
