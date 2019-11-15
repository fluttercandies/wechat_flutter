import 'package:flutter/material.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/chat/my_conversation_view.dart';

class DefConversation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MyConversationView(
      imageUrl: new Container(
        margin: EdgeInsets.only(top: 5.0, right: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.AvatarRadius),
          child: new Container(
            width: Constants.ConversationAvatarSize,
            height: Constants.ConversationAvatarSize,
            color: Colors.white,
          ),
        ),
      ),
      title: new Text(''),
      content: new Text('', style: AppStyles.DesStyle),
      time: new Text('', style: AppStyles.DesStyle),
    );
  }
}
