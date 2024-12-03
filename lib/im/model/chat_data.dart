import 'dart:convert';
import 'dart:io';

import '../entity/i_person_info_entity.dart';
import '../entity/person_info_entity.dart';
import '../info_handle.dart';
import '../message_handle.dart';

class ChatData {
  final Map<String, dynamic> msg;
  final String id;
  final int time;
  final String nickName;
  final String avatar;

  ChatData({
    required this.msg,
    required this.avatar,
    required this.time,
    required this.nickName,
    required this.id,
  });
}

class ChatDataRep {
  Future<List<ChatData>> repData(String id, int type) async {
    List<ChatData> chatData = [];
    final chatMsgData = await getDimMessages(id, type: type);
    if (Platform.isAndroid) {
      List chatMsgDataList = json.decode(chatMsgData);
      for (int i = 0; i < chatMsgDataList.length; i++) {
        PersonInfoEntity model =
            PersonInfoEntity.fromJson(chatMsgDataList[i]['senderProfile']);

        chatData.insert(
          0,
          ChatData(
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
          ChatData(
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
