import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart';
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
  return getHistoryMessageListRes.data?.messageList ?? [];
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

  // try {
  //   await im.sendImageMessages(userName, compressImg.path, type: type);
  //   callback(compressImg.path);
  // } on PlatformException {
  //   debugPrint("发送图片消息失败");
  // }
}

Future<dynamic> sendSoundMessages(String id, String soundPath, int duration,
    int type, Callback callback) async {
  // try {
  //   var result = await im.sendSoundMessages(id, soundPath, type, duration);
  //   callback(result);
  // } on PlatformException {
  //   debugPrint('发送语音  失败');
  // }
}
