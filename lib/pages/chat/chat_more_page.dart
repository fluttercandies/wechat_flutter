import 'package:dim_example/ui/card/more_item_card.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ChatMorePage extends StatefulWidget {
  final int index;

  ChatMorePage({this.index = 0});

  @override
  _ChatMorePageState createState() => _ChatMorePageState();
}

class _ChatMorePageState extends State<ChatMorePage> {
  List data = [
    {"name": "相册", "icon": "assets/images/chat/ic_details_photo.webp"},
    {"name": "拍摄", "icon": "assets/images/chat/ic_details_camera.webp"},
    {"name": "视频通话", "icon": "assets/images/chat/ic_details_media.webp"},
    {"name": "位置", "icon": "assets/images/chat/ic_details_localtion.webp"},
    {"name": "红包", "icon": "assets/images/chat/ic_details_red.webp"},
    {"name": "转账", "icon": "assets/images/chat/ic_details_transfer.webp"},
    {"name": "语音输入", "icon": "assets/images/chat/ic_chat_voice.webp"},
    {"name": "我的收藏", "icon": "assets/images/chat/ic_details_favorite.webp"},
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.only(bottom: 20.0),
        child: new Wrap(
          runSpacing: 10.0,
          spacing: 10,
          children: List.generate(data.length, (index) {
            String name = data[index]['name'];
            String icon = data[index]['icon'];
            return new MoreItemCard(
              name: name,
              icon: icon,
              onPressed: () {
                print('onclick $name');
              },
            );
          }),
        ),
      );
    } else {
      return Container();
    }
  }
}
