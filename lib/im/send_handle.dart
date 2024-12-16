import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import '../tools/event/im_event.dart';

typedef CallbackMsg = void Function(V2TimMessage messageInfo);

Future<void> sendTextMsg(String targetId, int type, String context,
    {CallbackMsg? call}) async {
  // 创建文本消息
  final V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
      await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .createTextMessage(
            text: context, // 文本信息
          );
  if (createTextMessageRes.code == 0) {
    debugPrint('create message:${createTextMessageRes.toJson()}');
    // 文本信息创建成功
    final String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    final OfflinePushInfo pushInfo = OfflinePushInfo();

    try {
      // 测试鸿蒙推送
      // pushInfo.harmonyCategory = "harmony-Category";
      // pushInfo.harmonyImage = "harmony-Image";
      // pushInfo.ignoreHarmonyBadge = true;
      final V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
                id: id!,
                receiver: type == ConversationType.V2TIM_C2C ? targetId : '',
                groupID: type == ConversationType.V2TIM_GROUP ? targetId : '',
                needReadReceipt: true,
                isSupportMessageExtension: true,
                offlinePushInfo: pushInfo,
              );

      debugPrint('发送消息结果 ${sendMessageRes.code} ===> ${sendMessageRes.desc}');
      if (sendMessageRes.code != 0) {
        showToast(
            '发送消息失败, code ${sendMessageRes.code}, ${sendMessageRes.desc}');
        return;
      }

      if (call != null) {
        call(sendMessageRes.data!);
      }

      /// Notice to refresh conversation list.
      eventBusNewMsg.value = EventBusNewMsg(targetId);
    } on PlatformException catch (e, s) {
      debugPrint('发送消息失败, $s');
      showToast('发送消息失败: $e');
    }
  }
}
