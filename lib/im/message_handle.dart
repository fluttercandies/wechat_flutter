import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<List<V2TimMessage>> getDimMessages(String id,
    {required int type, Callback? callback, int num = 50}) async {
  final V2TimValueCallback<V2TimMessageListResult> getHistoryMessageListRes =
      await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .getHistoryMessageListV2(
            getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
            // 拉取消息的位置及方向
            userID: type == ConversationType.V2TIM_C2C ? id : null,
            // 用户id 拉取单聊消息，需要指定对方的 userID，此时 groupID 传空即可。
            groupID: type == ConversationType.V2TIM_GROUP ? id : null,
            // 群组id 拉取群聊消息，需要指定群聊的 groupID，此时 userID 传空即可。
            count: num, // 拉取数据数量
            // 仅能在群聊中使用该字段。
            // 设置 lastMsgSeq 作为拉取的起点，返回的消息列表中包含这条消息。
            // 如果同时指定了 lastMsg 和 lastMsgSeq，SDK 优先使用 lastMsg。
            // 如果均未指定 lastMsg 和 lastMsgSeq，拉取的起点取决于是否设置 getTimeBegin。设置了，则使用设置的范围作为起点；未设置，则使用最新消息作为起点。
            // lastMsgSeq:2506157533,
            // messageTypeList: [
            //   MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
            //   MessageElemType.V2TIM_ELEM_TYPE_SOUND,
            //   MessageElemType.V2TIM_ELEM_TYPE_VIDEO,
            //   MessageElemType.V2TIM_ELEM_TYPE_FILE,
            // ], // 用于过滤历史信息属性，若为空则拉取所有属性信息。
          );
  return (getHistoryMessageListRes.data?.messageList ?? []).reversed.toList();
}

Future<void> sendImageMsg(String userName, int type,
    {required Callback callback,
    required ImageSource source,
    required File file}) async {
  XFile? image;
  if (file.existsSync()) {
    image = XFile(file.path);
  } else {
    image = await ImagePicker().pickImage(source: source);
  }
  if (image == null) return;
  File compressImg = await singleCompressFile(File(image.path));

  /// Send image message

  // 创建消息
  V2TimValueCallback<V2TimMsgCreateInfoResult> createImgMessageRes =
      await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .createImageMessage(imagePath: file.path);

  if (createImgMessageRes.code == 0) {
    log('create message:${createImgMessageRes.toJson()}');
    callback(compressImg.path);
    // 文本信息创建成功
    String? id = createImgMessageRes.data?.id;
    // 发送消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    OfflinePushInfo pushInfo = OfflinePushInfo();
    // 测试鸿蒙推送
    // pushInfo.harmonyCategory = "harmony-Category";
    // pushInfo.harmonyImage = "harmony-Image";
    // pushInfo.ignoreHarmonyBadge = true;
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              receiver: type == ConversationType.V2TIM_C2C ? userName : '',
              groupID: type == ConversationType.V2TIM_GROUP ? userName : '',
              needReadReceipt: true,
              isSupportMessageExtension: true,
              offlinePushInfo: pushInfo,
            );
    log('Send image message: ${sendMessageRes.toJson()}');
  }
}

Future<dynamic> sendSoundMessages(String id, String soundPath, int duration,
    int type, Callback callback) async {
  /// Send sound message

  // 创建消息
  V2TimValueCallback<V2TimMsgCreateInfoResult> createSoundMessageRes =
      await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .createSoundMessage(soundPath: soundPath, duration: duration);

  if (createSoundMessageRes.code == 0) {
    log('create message:${createSoundMessageRes.toJson()}');
    // 信息创建成功
    String? id = createSoundMessageRes.data?.id;
    // 发送消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    OfflinePushInfo pushInfo = OfflinePushInfo();
    // 测试鸿蒙推送
    // pushInfo.harmonyCategory = "harmony-Category";
    // pushInfo.harmonyImage = "harmony-Image";
    // pushInfo.ignoreHarmonyBadge = true;
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              receiver: type == ConversationType.V2TIM_C2C ? id : '',
              groupID: type == ConversationType.V2TIM_GROUP ? id : '',
              needReadReceipt: true,
              isSupportMessageExtension: true,
              offlinePushInfo: pushInfo,
            );
    log('Send image message: ${sendMessageRes.toJson()}');
    callback(sendMessageRes.code);
  }
}
