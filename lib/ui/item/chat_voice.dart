import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ChatVoice extends StatefulWidget {
  @override
  _ChatVoiceState createState() => _ChatVoiceState();
}

class _ChatVoiceState extends State<ChatVoice> {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      color: Colors.white,
      onPressed: () {},
      child: new Text('按住 说话'),
    );
  }
}
