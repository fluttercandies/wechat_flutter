/*
*
* 实体类 - 消息
* @param senderProfile 发送人资料
* @param remark 备注
* @param time 发送时间
* @param message 消息
* @param timConversation 会话信息
* @param status 发送状态
*
* */
import 'package:wechat_flutter/im/entity/person_info_entity.dart';

import 'chat_list_entity.dart';

class MessageEntity {
  PersonInfoEntity senderProfile;
  String remark;
  int time;
  MessageMessage message;
  ChatListEntity timConversation;
  String status;

  MessageEntity(
      {this.senderProfile,
      this.remark,
      this.time,
      this.message,
      this.timConversation,
      this.status});

  MessageEntity.fromJson(Map<String, dynamic> json) {
    senderProfile = json['senderProfile'] != null
        ? new PersonInfoEntity.fromJson(json['senderProfile'])
        : null;
    remark = json['remark'];
    time = json['time'];
    message = json['message'] != null
        ? new MessageMessage.fromJson(json['message'])
        : null;
    timConversation = json['timConversation'] != null
        ? new ChatListEntity.fromJson(json['timConversation'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.senderProfile != null) {
      data['senderProfile'] = this.senderProfile.toJson();
    }
    data['remark'] = this.remark;
    data['time'] = this.time;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    if (this.timConversation != null) {
      data['timConversation'] = this.timConversation.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

/*
* 实体类 - 消息内容（文本）
* @param text 文字消息内容
* @param type 消息类型
*
* */
class MessageMessage {
  String text;
  String type;

  MessageMessage({this.text, this.type});

  MessageMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}

class MessageTimconversationMconversation {
  MessageTimconversationMconversation.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
