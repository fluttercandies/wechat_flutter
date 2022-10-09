import 'package:tencent_im_sdk_plugin/enum/friend_application_type_enum.dart';
import 'package:tencent_im_sdk_plugin/enum/friend_response_type_enum.dart';
import 'package:tencent_im_sdk_plugin/enum/friend_type_enum.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_check_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_search_param.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/tools/app_config.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

/// IM好友模块Api
class ImFriendApi {
  /*
  * 获取好友列表
  * */
  static Future<List<V2TimFriendInfo>> getFriendList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .getFriendList();
    ImApi.imPrint(res.toJson(), "获取好友列表");
    return res.data;
  }

  /*
  * 获取好友信息
  * */
  static Future getFriendsInfo(List<String> users) async {
    V2TimValueCallback<List<V2TimFriendInfoResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendsInfo(
              userIDList: users,
            );
    ImApi.imPrint(res.toJson(), "获取好友信息");
  }

  /*
  * 添加好友
  * */
  static Future<V2TimFriendOperationResult> addFriend(String userID) async {
    if (userID == Data.user() && !AppConfig.isArrowAddSelf) {
      return V2TimFriendOperationResult(
          userID: userID, resultCode: -1, resultInfo: "不能申请添加自己为好友");
    }

    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
              userID: userID,
              addType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,
            );
    ImApi.imPrint(res.toJson(), "添加好友");
    return res.data;
  }

  /*
  * 设置好友信息
  * */
  static Future setFriendInfo(String userID, String friendRemark) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .setFriendInfo(friendRemark: friendRemark, userID: userID);
    ImApi.imPrint(res.toJson(), "设置好友信息");
  }

  /*
  * 删除好友
  * */
  static Future<List<V2TimFriendOperationResult>> deleteFromFriendList(
      List<String> userIDList) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .deleteFromFriendList(
              userIDList: userIDList,
              deleteType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,
            );

    ImApi.imPrint(res.toJson(), "删除好友");
    return res.data;
  }

  /*
  * 检测好友
  *
  * element.resultType;//与查询用户的关系类型 0:不是好友 1:对方在我的好友列表中 2:我在对方的好友列表中 3:互为好友
  * */
  static Future<List<V2TimFriendCheckResult>> checkFriend(
      List<String> userIDList) async {
    V2TimValueCallback<List<V2TimFriendCheckResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .checkFriend(
              userIDList: userIDList,
              checkType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,
            );

    ImApi.imPrint(res.toJson(), "检测好友");
    return res.data;
  }

  /*
  * 获取好友申请列表
  *
  * 关于type可能是。
  *
  * enum FriendApplicationTypeEnum {
  V2TIM_FRIEND_APPLICATION_NULL, // dart 不支持枚举初始值，所以这里加一个null
  // 别人发给我的加好友请求
  V2TIM_FRIEND_APPLICATION_COME_IN,
  //我发给别人的加好友请求
  V2TIM_FRIEND_APPLICATION_SEND_OUT,
  // 别人发给我的和我发给别人的加好友请求。仅在拉取时有效。
  V2TIM_FRIEND_APPLICATION_BOTH,
}
  * */
  static Future<List<V2TimFriendApplication>> getFriendApplicationList() async {
    V2TimValueCallback<V2TimFriendApplicationResult> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendApplicationList();
    ImApi.imPrint(res.toJson(), "获取好友申请列表");
    return res.data.friendApplicationList;
    // flutter: [IM]:-------------获取好友申请列表-----------
    // flutter: [IM]:{"code":0,"desc":"ok","data":{"unreadCount":1,"friendApplicationList":[{"userID":"165","nickname":"u165","faceUrl":null,"addTime":1665300529,"addSource":"AddSource_Type_Unknow","addWording":null,"type":1}]}}
  }

  /*
  * 同意好友申请
  * */
  static Future<V2TimValueCallback<V2TimFriendOperationResult>>
      acceptFriendApplication(String userID) async {
    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .acceptFriendApplication(
                userID: userID,
                responseType:
                    FriendResponseTypeEnum.V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD,
                type: FriendApplicationTypeEnum.V2TIM_FRIEND_APPLICATION_BOTH);

    ImApi.imPrint(res.toJson(), "同意好友申请");
    return res;
  }

  /*
  * 拒绝好友申请
  * */
  static Future refuseFriendApplication(String userID) async {
    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .refuseFriendApplication(
                userID: userID,
                type: FriendApplicationTypeEnum.V2TIM_FRIEND_APPLICATION_BOTH);

    ImApi.imPrint(res.toJson(), "拒绝好友申请");
  }

  /*
  * 获取黑名单列表
  * */
  static Future getBlackList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .getBlackList();
    ImApi.imPrint(res.toJson(), "获取黑名单列表");
  }

  /*
  * 添加到黑名单
  * */
  static Future addToBlackList(List<String> userIDList) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .addToBlackList(
              userIDList: userIDList,
            );
    ImApi.imPrint(res.toJson(), "添加到黑名单");
  }

  /*
  * 从黑名单移除
  * */
  static Future deleteFromBlackList(List<String> userIDList) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .deleteFromBlackList(
              userIDList: userIDList,
            );
    ImApi.imPrint(res.toJson(), "从黑名单移除");
  }

  /*
  * 搜索好友
  * */
  static Future searchFriends(String keyword) async {
    V2TimFriendSearchParam searchParam = new V2TimFriendSearchParam(
        keywordList: [keyword],
        isSearchUserID: true,
        isSearchNickName: true,
        isSearchRemark: true);
    var res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .searchFriends(searchParam: searchParam);
    ImApi.imPrint(res.toJson(), "搜索好友");
  }
}
