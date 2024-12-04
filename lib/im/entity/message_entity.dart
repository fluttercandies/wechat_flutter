class MessageEntity {
  int? time;
  Message? message;

  MessageEntity({
    this.time,
    this.message,
  });

  MessageEntity.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  String? type;
  String? content;

  Message({
    this.type,
    this.content,
  });

  Message.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['content'] = content;
    return data;
  }
}