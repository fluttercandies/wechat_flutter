import 'package:flutter/material.dart';

class ChatList {
  ChatList({
    @required this.avatar,
    @required this.name,
    @required this.identifier,
    @required this.content,
    @required this.time,
    @required this.type,
    @required this.msgType,
  });

  final String avatar;
  final String name;
  final int time;
  final Map content;
  final String identifier;
  final dynamic type;
  final String msgType;
}
