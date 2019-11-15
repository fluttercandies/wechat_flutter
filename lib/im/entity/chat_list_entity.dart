/*
* 实体类 - 聊天会话列表
* @param mConversation 会话
* @param peer 回话ID
* @param type 会话类型
* */
class ChatListEntity {
  ChatListMconversation mConversation;
  String peer;
  dynamic type;

  ChatListEntity({this.mConversation, this.peer, this.type});

  ChatListEntity.fromJson(Map<String, dynamic> json) {
    mConversation = json['mConversation'] != null
        ? new ChatListMconversation.fromJson(json['mConversation'])
        : null;
    peer = json['peer'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mConversation != null) {
      data['mConversation'] = this.mConversation.toJson();
    }
    data['peer'] = this.peer;
    data['type'] = this.type;
    return data;
  }
}

class ChatListMconversation {
  ChatListMconversation.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
