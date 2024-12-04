import 'dart:convert';

import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/im/conversation_handle.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
//
// class ChatList {
//   ChatList({
//     required this.avatar,
//     required this.name,
//     required this.identifier,
//     required this.content,
//     required this.time,
//     required this.type,
//     required this.msgType,
//   });
//
//   final String avatar;
//   final String name;
//   final int time;
//   final Map<String, dynamic>? content;
//   final String identifier;
//   final dynamic type;
//   final String msgType;
// }

class ChatListData {
  Future<bool> isNull() async {
    final str = await getConversationsListData();
    List<dynamic> data = json.decode(str);
    return !listNoEmpty(data);
  }

  Future<List<V2TimConversation?>> chatListData() async {
    V2TimValueCallback<V2TimConversationResult> getConversationListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversationList(
                count: 100, //分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
                nextSeq: "0" //分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
                );
    return getConversationListRes.data?.conversationList ??
        <V2TimConversation>[];
  }
}
