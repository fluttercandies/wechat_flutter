import 'dart:convert';

import 'package:dim_example/im/entity/person_info_entity.dart';
import 'package:dim_example/im/info_handle.dart';
import 'package:dim_example/ui/item/chat_mamber.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ChatInfoPage extends StatefulWidget {
  final String id;

  ChatInfoPage(this.id);

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  PersonInfoEntity model;

  List<Widget> body() {
    return [
      new ChatMamBer(model: model),
    ];
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    final info = await getUsersProfile([widget.id]);
    List infoList = json.decode(info);
    setState(() {
      model = PersonInfoEntity.fromJson(infoList[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(title: '聊天信息'),
      body: new Column(
        children: body(),
      ),
    );
  }
}
