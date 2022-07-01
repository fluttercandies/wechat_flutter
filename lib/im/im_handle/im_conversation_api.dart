import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/tools/app_config.dart';

/// IM会话模块Api
class IMConversationApi {
  /*
  * 获取会话列表
  *
  * @param nextSeq 默认传0
  * */
  static Future<V2TimConversationResult> getConversationList(
      String nextSeq) async {
    V2TimValueCallback<V2TimConversationResult> res = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversationList(nextSeq: nextSeq, count: AppConfig.cvsPageCount);

    ImApi.imPrint(res.toJson(), "获取会话列表");
    return res.data;
  }

  /*
  * 获取会话详情【列表】
  * */
  static Future getConversationDetList(List<String> conversationIDList) async {
    V2TimValueCallback<List<V2TimConversation>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversationListByConversaionIds(
          conversationIDList: conversationIDList,
        );
    ImApi.imPrint(res.toJson(), "获取会话详情【列表】");
  }

  /*
  * 获取会话详情【单个】
  * */
  static Future getConversation(String conversationID) async {
    V2TimValueCallback<V2TimConversation> res = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversation(
          conversationID: conversationID,
        );
    ImApi.imPrint(res.toJson(), "获取会话详情【单个】");
  }

  /*
  * 删除会话
  * */
  static Future deleteConversation(String conversationID) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .deleteConversation(
          conversationID: conversationID,
        );
    ImApi.imPrint(res.toJson(), "删除会话");
  }

  /*
  * 设置草稿/取消草稿
  * */
  static Future setConversationDraft(
    String conversationID,
    // 草稿内容，null为取消
    String draftText,
  ) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .setConversationDraft(
          conversationID: conversationID,
          draftText: draftText,
        );
    ImApi.imPrint(res.toJson(), "设置草稿/取消草稿");
  }

  /*
  * 会话置顶/取消置顶
  * */
  static Future pinConversation(String conversationID, bool isPinned) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .pinConversation(conversationID: conversationID, isPinned: isPinned);
    ImApi.imPrint(res.toJson(), "会话置顶/取消置顶");
  }

  /*
  * 获取会话未读总数
  * */
  static Future getTotalUnreadMessageCount() async {
    V2TimValueCallback<int> res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getTotalUnreadMessageCount();
    ImApi.imPrint(res.toJson(), "获取会话未读总数");
  }
}
