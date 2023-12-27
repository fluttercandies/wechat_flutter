import 'dart:convert';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class ChannelEntity {
  ChannelEntity({
    required this.channelId,
    required this.mediaType,
    required this.toChatId,
    required this.toChatName,
    required this.toAvatar,
    required this.sendChatId,
    required this.sendChatName,
    required this.sendAvatarUrl,
    required this.sendAgoraUid,
    required this.groupId,
  });

  /// 总是发送消息的id【真实需要取到的消息id】【targetId目标id】
  ///
  /// 如果自己是发起人，返回的就是toChatId
  /// 如果自己是接收人，返回的就是sendChatId
  String get targetId {
    LogUtil.d("ChannelEntity格式化的groupId::$groupId");
    if (strNoEmpty(groupId)) {
      return groupId!;
    }
    // String userAccountSp = SpUtil().get(KeyConstant.agoraAccount);
    String userAccountSp = Q1Data.user();
    LogUtil.d("获取targetId时候拿到的userAccountSp::$userAccountSp");
    bool isSend = sendAgoraUid == userAccountSp;
    if (isSend) {
      return toChatId;
    } else {
      return sendChatId;
    }
  }

  ChannelEntity.no({
    this.channelId = 0,
    this.mediaType = "",
    this.toChatId = "",
    this.toChatName = "",
    this.toAvatar = "",
    this.sendChatId = "",
    this.sendChatName = "",
    this.sendAvatarUrl = "",
    this.sendAgoraUid = "",
    this.groupId = "",
  });

  factory ChannelEntity.fromJson(Map<String, dynamic> json) => ChannelEntity(
        channelId: asT<int>(json['channelId'])!,
        mediaType: asT<String>(json['mediaType'])!,
        toChatId: asT<String>(json['toChatId'])!,
        toChatName: asT<String>(json['toChatName'])!,
        toAvatar: asT<String>(json['toAvatar'])!,
        sendChatId: asT<String>(json['sendChatId'])!,
        sendChatName: asT<String>(json['sendChatName'])!,
        sendAvatarUrl: asT<String>(json['sendAvatarUrl'])!,
        sendAgoraUid: asT<String>(json['sendAgoraUid'])!,
        groupId: asT<String?>(json['groupId']),
      );

  int channelId;
  String mediaType;
  String toChatId;
  String toChatName;
  String toAvatar;
  String sendChatId;
  String sendChatName;
  String sendAvatarUrl;
  String sendAgoraUid;
  String? groupId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'channelId': channelId,
        'mediaType': mediaType,
        'toChatId': toChatId,
        'toChatName': toChatName,
        'toAvatar': toAvatar,
        'sendChatId': sendChatId,
        'sendChatName': sendChatName,
        'sendAvatarUrl': sendAvatarUrl,
        'sendAgoraUid': sendAgoraUid,
        'groupId': groupId,
      };
}
