import 'dart:convert';

enum LiveEventName {
  /// 打开摄像头
  openCamera,

  /// 关闭摄像头
  closeCamera,

  /// 打开麦克风
  openMicrophone,

  /// 关闭麦克风
  closeMicrophone,

  /// 切换到音频
  changeToVoice,

  /// 语音转文字内容
  ttsContent,
}

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class LiveSteamEvent {
  LiveSteamEvent({
    required this.uid,
    required this.eventName,
    this.content,
    this.msgId,
  });

  factory LiveSteamEvent.fromJson(Map<String, dynamic> json) => LiveSteamEvent(
        uid: asT<int>(json['uid'])!,
        eventName: asT<String>(json['eventName'])!,
        content: asT<String?>(json['content']),
        msgId: asT<String?>(json['msgId']),
      );

  int uid;
  String eventName;

  // When [eventName] is [ttsContent] can't be null.
  String? content;
  String? msgId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'eventName': eventName,
        'content': content,
        'msgId': msgId,
      };
}
