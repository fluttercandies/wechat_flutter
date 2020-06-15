import 'dart:convert';

import 'package:wechat_flutter/im/entity/i_chat_person_entity.dart';
import 'package:wechat_flutter/im/entity/i_person_info_entity.dart';
import 'package:wechat_flutter/im/entity/person_info_entity.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/all_im.dart';

class ChatData {
  final Map msg;
  final String id;
  final int time;
  final String nickName;
  final String avatar;

  ChatData({
    @required this.msg,
    this.avatar,
    this.time,
    this.nickName,
    this.id,
  });
}

class ChatDataRep {
  repData(String id, int type) async {
    List<ChatData> chatData = new List<ChatData>();
    final chatMsgData = await getDimMessages(id, type: type);
    if (Platform.isAndroid) {
      List chatMsgDataList = json.decode(chatMsgData);
      for (int i = 0; i < chatMsgDataList.length; i++) {
        PersonInfoEntity model =
            PersonInfoEntity.fromJson(chatMsgDataList[i]['senderProfile']);

        chatData.insert(
          0,
          new ChatData(
            msg: chatMsgDataList[i]['message'],
            avatar: model.faceUrl,
            time: chatMsgDataList[i]['timeStamp'],
            nickName: model.nickName,
            id: model.identifier,
          ),
        );
      }
    } else {
      List chatMsgDataList = json.decode(chatMsgData);
      for (int i = 0; i < chatMsgDataList.length; i++) {
        final info = await getUsersProfile([chatMsgDataList[i]['sender']]);
        List infoList = json.decode(info);
        IPersonInfoEntity model = IPersonInfoEntity.fromJson(infoList[0]);
        chatData.insert(
          0,
          new ChatData(
            msg: chatMsgDataList[i]['message'],
            avatar: model.faceURL,
            time: chatMsgDataList[i]['timeStamp'],
            nickName: model.nickname,
            id: chatMsgDataList[i]['sender'],
          ),
        );
      }
    }
    return chatData;
  }
}
