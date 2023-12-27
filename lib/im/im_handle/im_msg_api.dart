import 'package:path_provider/path_provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_search_param.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_search_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_search_result_item.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_flutter/im/im_handle/im_conversation_api.dart';
import 'package:wechat_flutter/tools/commom/check.dart';
import 'package:wechat_flutter/tools/utils/file_util.dart';
import 'package:wechat_flutter/tools/utils/video_util.dart';

import 'Im_api.dart';

/// IM消息模块Api
class ImMsgApi {
  /*
  * 发送文本消息
  * */
  static Future<V2TimMessage?> sendTextMessage(
    String text, {
    required String receiver,
    required String groupID,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextMessage(text: text);
    String id = createMessage.data!.id!;

    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .sendMessage(
            id: id,
            receiver: receiver,
            groupID: groupID,
            localCustomData: "自定义localCustomData");
    ImApi.imPrint(res.toJson(), "发送文本消息");
    return res.data;
  }

  /*
  * 发送图片消息
  * */
  static Future<V2TimMessage?> sendImageMessage(
    String imagePath, {
    required String receiver,
    required String groupID,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createImageMessage(imagePath: imagePath);
    String id = createMessage.data!.id!;

    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .sendMessage(
            id: id,
            receiver: receiver,
            groupID: groupID,
            localCustomData: "自定义localCustomData");
    ImApi.imPrint(res.toJson(), "发送图片消息");
    return res.data;
  }

  /*
  * 发送视频消息
  * */
  static Future<V2TimMessage?> sendVideoMessage(
    String videoPath, {
    String? receiver,
    String? groupID,
  }) async {
    final snapshotBasePath = (await getTemporaryDirectory()).path;
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: snapshotBasePath,
      imageFormat: ImageFormat.PNG,
      quality: 75,
    );

    final String? snapshotPath = fileName;

    final VideoUtilModel videoUtilModel =
        await VideoUtil.getVideoDuration(videoPath);

    if (!strNoEmpty(snapshotPath)) {
      print("视频封面为空");
      return null;
    }

    print("封面整:$snapshotPath");

    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createVideoMessage(
              duration: videoUtilModel.duration,
              snapshotPath: snapshotPath!,
              // snapshotPath: videoUtilModel.coverPath,
              type: FileUtil.getInstance()!.videoTypeOfPath(videoPath),
              videoFilePath: videoPath,
            );
    String id = createMessage.data!.id!;

    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .sendMessage(
            id: id,
            receiver: receiver!,
            groupID: groupID!,
            localCustomData: "自定义localCustomData");
    ImApi.imPrint(res.toJson(), "发送视频消息");
    return res.data;
  }

  /*
  * 发送自定义消息
  * */
  static Future sendCustomMessage(
    String data, {
    required String receiver,
    required String groupID,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(data: data);
    String id = createMessage.data!.id!;
    V2TimValueCallback<V2TimMessage> res =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id,
              receiver: receiver,
              groupID: groupID,
            );

    ImApi.imPrint(res.toJson(), "发送自定义消息");
  }

  /*
  * 发送文本At消息
  * */
  static Future sendTextAtMessage(
    String text,
    List<String> atUserList, {
    required String receiver,
    required String groupID,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextAtMessage(text: text, atUserList: atUserList);
    String id = createMessage.data!.id!;
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .sendMessage(
            id: id,
            receiver: receiver,
            groupID: groupID,
            localCustomData: "自定义localCustomData");
    ImApi.imPrint(res.toJson(), "发送文本At消息");
  }

  /*
  * 发送表情消息
  * */
  static Future sendFaceMessage(
    int index,
    String data, {
    required String receiver,
    required String groupID,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createMessage =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createFaceMessage(
              index: index,
              data: data,
            );
    String id = createMessage.data!.id!;

    V2TimValueCallback<V2TimMessage> res =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id,
              receiver: receiver,
              groupID: groupID,
            );

    ImApi.imPrint(res.toJson(), "发送表情消息");
  }

  /*
  * 获取C2C历史消息
  * */
  static Future<List<V2TimMessage>?> getC2CHistoryMessageList(
      String userID, String? lastMsgID) async {
    V2TimValueCallback<List<V2TimMessage>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .getC2CHistoryMessageList(
          userID: userID,
          count: 20,
          lastMsgID: lastMsgID,
        );
    ImApi.imPrint(res.toJson(), "获取C2C历史消息");
    return res.data;
  }

  /*
  * 获取Group历史消息
  * */
  static Future<V2TimValueCallback<List<V2TimMessage>>>
      getGroupHistoryMessageList(String groupID,
          {String? lastMsgID, int count = 20}) async {
    V2TimValueCallback<List<V2TimMessage>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .getGroupHistoryMessageList(
          groupID: groupID,
          count: count,
          lastMsgID: lastMsgID,
        );
    ImApi.imPrint(res.toJson(), "获取Group历史消息");
    return res;
  }

  /*
  * 获取历史消息高级接口
  * */
  static Future<List<V2TimMessage>?> getHistoryMessageList(
      {String? userID, String? groupID, String? lastMsgID}) async {
    V2TimValueCallback<List<V2TimMessage>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .getHistoryMessageList(
            userID: userID, groupID: groupID, count: 20, lastMsgID: lastMsgID);
    ImApi.imPrint(res.toJson(), "获取历史消息高级接口");
    return res.data;
  }

  /*
  * 撤回消息
  * */
  static Future revokeMessage(String msgID) async {
    // 注意：web中webMessageInstatnce 为必填写
    V2TimCallback res =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().revokeMessage(
              msgID: msgID,
            );
    ImApi.imPrint(res.toJson(), "撤回消息");
  }

  /*
  * 标记c2c会话已读
  * */
  static Future markC2CMessageAsRead(String userId) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .markC2CMessageAsRead(
          userID: userId,
        );
    ImApi.imPrint(res.toJson(), "标记c2c会话已读");
  }

  /*
  * 标记group会话已读
  * */
  static Future markGroupMessageAsRead(String groupID) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .markGroupMessageAsRead(
          groupID: groupID,
        );
    ImApi.imPrint(res.toJson(), "标记group会话已读");
  }

  /*
  * 标记所有消息为已读
  * */
  static Future markAllMessageAsRead() async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .markAllMessageAsRead();
    ImApi.imPrint(res.toJson(), "标记所有消息为已读");
  }

  /*
  * 删除本地消息
  * */
  static Future deleteMessageFromLocalStorage(String msgID) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .deleteMessageFromLocalStorage(
          msgID: msgID,
        );
    ImApi.imPrint(res.toJson(), "删除本地消息");
  }

  /*
  * 删除消息
  * */
  static Future deleteMessages(List<String> msgIDs) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .deleteMessages(
          msgIDs: msgIDs,
        );
    ImApi.imPrint(res.toJson(), "删除消息");
  }

  /*
  * 向group中插入一条本地消息
  * */
  static Future insertGroupMessageToLocalStorage({
    required String groupID,
    required String data,
    required String sender,
  }) async {
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .insertGroupMessageToLocalStorage(
          groupID: groupID,
          data: data,
          sender: sender,
        );
    ImApi.imPrint(res.toJson(), "向group中插入一条本地消息");
  }

  /*
  * 向c2c会话中插入一条本地消息
  * */
  static Future insertC2CMessageToLocalStorage({
    required String userID,
    required String data,
    required String sender,
  }) async {
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .insertC2CMessageToLocalStorage(
          userID: userID,
          data: data,
          sender: sender,
        );
    ImApi.imPrint(res.toJson(), "向c2c会话中插入一条本地消息");
  }

  /*
  * 清空单聊本地及云端的消息（不删除会话）
  * */
  static Future clearMessage(String userID) async {
    var res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .clearC2CHistoryMessage(
          userID: userID,
        );
    ImApi.imPrint(res.toJson(), "清空单聊本地及云端的消息（不删除会话）");
  }

  /*
  * 查询针对某个用户的 C2C 消息接收选项（免打扰状态）
  * */
  static Future getC2CReceiveMessageOpt(List<String> userIDList) async {
    V2TimValueCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .getC2CReceiveMessageOpt(userIDList: userIDList);
    ImApi.imPrint(res.toJson(), "查询针对某个用户的 C2C 消息接收选项（免打扰状态）");
  }

  /*
  * 清空群组单聊本地及云端的消息
  * */
  static Future getGroupsInfo(String groupID) async {
    var res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .clearGroupHistoryMessage(
          groupID: groupID,
        );
    ImApi.imPrint(res.toJson(), "清空群组单聊本地及云端的消息");
  }

  /*
  * 搜索本地消息
  * */
  static Future<V2TimValueCallback<V2TimMessageSearchResult>?>
      searchLocaltMessage(String keyword, String conversationID) async {
    if (keyword == '') return null;
    V2TimMessageSearchParam searchParam = V2TimMessageSearchParam(
      keywordList: [keyword],
      type: 1,
      // 对应 keywordListMatchType.KEYWORD_LIST_MATCH_TYPE_AND sdk层处理  代表 或 与关系
      pageSize: 50,
      // size 写死
      pageIndex: 0,
      // index写死
      // conversationID: conversationID, // 不传代表指定所有会话,而且不会返回messageList
    );
    V2TimValueCallback<V2TimMessageSearchResult> res = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .searchLocalMessages(searchParam: searchParam);
    ImApi.imPrint(res.toJson(), "搜索本地消息");
    return res;
  }

  /*
  * 搜索本地消息【根据群】
  * */
  static Future<List<V2TimMessage>?> searchLocaltMessageOfGroup(
      String keyword, String groupId) async {
    if (keyword == '') return null;
    V2TimMessageSearchParam searchParam = V2TimMessageSearchParam(
      keywordList: [keyword],
      type: 1,
      // 对应 keywordListMatchType.KEYWORD_LIST_MATCH_TYPE_AND sdk层处理  代表 或 与关系
      pageSize: 50,
      // size 写死
      pageIndex: 0,
      // index写死
      // conversationID: conversationID, // 不传代表指定所有会话,而且不会返回messageList
    );
    V2TimValueCallback<V2TimMessageSearchResult> res = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .searchLocalMessages(searchParam: searchParam);
    ImApi.imPrint(res.toJson(), "搜索本地消息");
    if (res.data!.totalCount == 0) {
      return [];
    }
    for (V2TimMessageSearchResultItem item
        in res.data!.messageSearchResultItems!) {
      V2TimValueCallback<V2TimConversation> cov =
          await IMConversationApi.getConversation(item.conversationID!);

      final bool covSuccess = cov.code == 0 || cov.code == 200;
      if (covSuccess && groupId == cov.data!.groupID) {
        return item.messageList;
      }
    }
    return [];
  }

  /*
  * 查询指定会话中的本地消息
  * */
  static Future findeMessages(List<String> messageIDList) async {
    var res =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().findMessages(
              messageIDList: messageIDList,
            );
    ImApi.imPrint(res.toJson(), "查询指定会话中的本地消息");
  }
}
