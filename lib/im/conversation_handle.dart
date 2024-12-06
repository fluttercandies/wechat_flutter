import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_filter.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<List<V2TimConversation?>?> getConversationsListData() async {
  final V2TimValueCallback<V2TimConversationResult> result =
      await V2TIMManager()
          .getConversationManager()
          .getConversationList(nextSeq: '0', count: 100);
  return result.data?.conversationList ?? [];
}

Future<dynamic> deleteConversationAndLocalMsgModel(String id, int type) async {
  await delConversationModel(id, type);
  await delLocalMsg(id, type);
}

Future<dynamic> delLocalMsg(String identifier, int type) async {
  final V2TimCallback callback = await V2TIMManager()
      .getMessageManager()
      .deleteMessages(msgIDs: [identifier]);
  final bool success = callback.code == 0;
  if (!success) {
    showToast(callback.desc);
  }
  return success;
}

Future<dynamic> delConversationModel(String identifier, int type) async {
  final V2TimCallback callback = await V2TIMManager()
      .getConversationManager()
      .deleteConversation(conversationID: identifier);
  final bool success = callback.code == 0;
  if (!success) {
    showToast(callback.desc);
  }
  return success;
}

//获取未读消息数量
Future<int> getUnreadMessageNumModel(int type, String id) async {
  final V2TimValueCallback<int> result = await V2TIMManager()
      .getConversationManager()
      .getUnreadMessageCountByFilter(
        filter: V2TimConversationFilter(
          conversationType: type,
          conversationGroup: id,
        ),
      );
  return result.data ?? 0;
}

//设置消息为已读
Future<void> setReadMessageModel(int type, String id) async {
  final V2TimCallback callback = await V2TIMManager()
      .getConversationManager()
      .cleanConversationUnreadMessageCount(
          conversationID: id, cleanTimestamp: 0, cleanSequence: 0);
  if (callback.code != 0) {
    showToast(callback.desc);
  }
}
