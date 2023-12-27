
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/msg/live_msg_event.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class CustomMsgEvent {
  /// 语音消息
  static String voiceChat = "VoiceChat";

  /// 视频消息
  static String videoChat = "VideoChat";
}

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

/// 个人隐形数据模型【现在群也用这个了】
class LiveSingleHideMsgModel {
  /// [LiveMsgEventSingleHide.value]
  final String msgType;

  /// [LivePageType.value]
  final String livePageType;
  final String channelId;
  final String sendChatId;
  final String sendChatName;
  final String sendAvatarUrl;
  final String sendAgoraUid;
  final String? msgContent;

  /// 现在群组也用这个了
  final String? groupId;

  bool get livePageTypeIsGroup {
    return livePageType == LivePageType.multipleAudio.toString() ||
        livePageType == LivePageType.multipleVideo.toString();
  }

  LivePageType get livePageTypeRuntime {
    LivePageType? livePageTypeValue;
    for (LivePageType item in LivePageType.values) {
      if (livePageType == item.toString()) {
        livePageTypeValue = item;
      }
    }
    return livePageTypeValue!;
  }

  LiveMsgEventSingleHide get msgTypeRuntime {
    LiveMsgEventSingleHide? msgTypeValue;
    for (LiveMsgEventSingleHide item in LiveMsgEventSingleHide.values) {
      if (msgType == item.toString()) {
        msgTypeValue = item;
      }
    }
    return msgTypeValue!;
  }

  Map<String, dynamic> toJson() {
    return {
      'msgType': msgType,
      'livePageType': livePageType,
      'channelId': channelId,
      'sendChatId': sendChatId,
      'sendChatName': sendChatName,
      'sendAvatarUrl': sendAvatarUrl,
      'sendAgoraUid': sendAgoraUid,
      'msgContent': msgContent,
      'groupId': groupId,
    };
  }

  factory LiveSingleHideMsgModel.no() {
    return LiveSingleHideMsgModel(
      msgType: '',
      livePageType: "",
      channelId: "",
      sendChatId: "",
      sendChatName: "",
      sendAvatarUrl: "",
      sendAgoraUid: '',
      msgContent: '',
      groupId: '',
    );
  }

  factory LiveSingleHideMsgModel.fromJson(Map<String, dynamic> json) =>
      LiveSingleHideMsgModel(
        msgType: asT<String>(json['msgType'])!,
        livePageType: asT<String>(json['livePageType'])!,
        channelId: asT<String>(json['channelId'])!,
        sendChatId: asT<String>(json['sendChatId'])!,
        sendChatName: asT<String>(json['sendChatName'])!,
        sendAvatarUrl: asT<String>(json['sendAvatarUrl'])!,
        sendAgoraUid: asT<String>(json['sendAgoraUid'])!,
        msgContent: asT<String?>(json['msgContent']),
        groupId: asT<String?>(json['groupId']),
      );

  LiveSingleHideMsgModel({
    required this.msgType,
    required this.livePageType,
    required this.channelId,
    required this.sendChatId,
    required this.sendChatName,
    required this.sendAvatarUrl,
    required this.sendAgoraUid,
    required this.groupId,
    this.msgContent,
  });
}

/// 个人可视数据模型
class LiveSingleShowMsgModel {
  /// [LiveMsgEventSingleShow.value]
  final String msgType;

  /// [LivePageType.value]
  final String? livePageType;
  final String channelId;
  final String sendChatId;
  final String sendChatName;
  final String sendAvatarUrl;
  final String sendAgoraUid;

  /// 通话时长【当状态为正常是必须要传】
  final String? longTime;

  bool get livePageTypeIsGroup {
    return livePageType == LivePageType.multipleAudio.toString() ||
        livePageType == LivePageType.multipleVideo.toString();
  }

  LivePageType get livePageTypeRuntime {
    LivePageType? livePageTypeValue;
    for (LivePageType item in LivePageType.values) {
      if (livePageType == item.toString()) {
        livePageTypeValue = item;
      }
    }
    return livePageTypeValue!;
  }

  LiveMsgEventSingleShow get msgTypeRuntime {
    LiveMsgEventSingleShow? msgTypeValue;
    for (LiveMsgEventSingleShow item in LiveMsgEventSingleShow.values) {
      if (msgType == item.toString()) {
        msgTypeValue = item;
      }
    }
    return msgTypeValue!;
  }

  Map<String, dynamic> toJson() {
    return {
      'msgType': msgType,
      'livePageType': livePageType,
      'channelId': channelId,
      'sendChatId': sendChatId,
      'sendChatName': sendChatName,
      'sendAvatarUrl': sendAvatarUrl,
      'sendAgoraUid': sendAgoraUid,
      'longTime': longTime,
    };
  }

  factory LiveSingleShowMsgModel.no() {
    return LiveSingleShowMsgModel(
      msgType: '',
      livePageType: "",
      channelId: "",
      sendChatId: "",
      sendChatName: "",
      sendAvatarUrl: "",
      sendAgoraUid: '',
      longTime: '',
    );
  }

  factory LiveSingleShowMsgModel.fromJson(Map<String, dynamic> json) =>
      LiveSingleShowMsgModel(
        msgType: asT<String>(json['msgType'])!,
        livePageType: asT<String?>(json['livePageType']),
        channelId: asT<String>(json['channelId'] ?? "")!,
        sendChatId: asT<String>(json['sendChatId'] ?? "")!,
        sendChatName: asT<String>(json['sendChatName'] ?? "")!,
        sendAvatarUrl: asT<String>(json['sendAvatarUrl'] ?? "")!,
        sendAgoraUid: asT<String>(json['sendAgoraUid'] ?? "")!,
        longTime: asT<String?>(json['longTime']),
      );

  LiveSingleShowMsgModel({
    required this.msgType,
    required this.livePageType,
    required this.channelId,
    required this.sendChatId,
    required this.sendChatName,
    required this.sendAvatarUrl,
    required this.sendAgoraUid,
    required this.longTime,
  });
}
