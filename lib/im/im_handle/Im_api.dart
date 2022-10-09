import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimConversationListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimFriendshipListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimGroupListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimSDKListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimSignalingListener.dart';
import 'package:tencent_im_sdk_plugin/enum/V2TimSimpleMsgListener.dart';
import 'package:tencent_im_sdk_plugin/enum/log_level_enum.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/im/im_handle/GenerateTestUserSig.dart';
import 'package:wechat_flutter/provider/im/im_event.dart';
import 'package:wechat_flutter/tools/app_config.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

/// IM基础功能模块Api
class ImApi {
  static String printHead = "[IM]";

  static V2TimSimpleMsgListener simpleMsgListener;
  static V2TimAdvancedMsgListener advancedMsgListener;
  static V2TimSignalingListener signalingListener;

  /*
  * im打印
  * */
  static void imPrint(Map jsonData, [String title]) {
    debugPrint("$printHead:-------------${title ?? "imPrint"}-----------");
    debugPrint("$printHead:${json.encode(jsonData)}");
    debugPrint("");
  }

  static Future init(BuildContext context) async {
    V2TimValueCallback<bool> res =
        await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: AppConfig.IMSdkAppID,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: new V2TimSDKListener(
        onConnectFailed:
            Provider.of<IMEvent>(context, listen: false).onConnectFailed,
        onConnectSuccess:
            Provider.of<IMEvent>(context, listen: false).onConnectSuccess,
        onConnecting:
            Provider.of<IMEvent>(context, listen: false).onConnectSuccess,
        onKickedOffline:
            Provider.of<IMEvent>(context, listen: false).onKickedOffline,
        onSelfInfoUpdated:
            Provider.of<IMEvent>(context, listen: false).onSelfInfoUpdated,
        onUserSigExpired:
            Provider.of<IMEvent>(context, listen: false).onUserSigExpired,
      ),
    );
    imPrint(res.toJson(), "初始化");

    // 如果初始化成功
    addIMEventListener(context);

    // 检测登录
    checkLogin();
  }

  /*
  * 添加事件监听
  * */
  static void addIMEventListener(BuildContext context) async {
    simpleMsgListener = new V2TimSimpleMsgListener(
      onRecvC2CCustomMessage:
          Provider.of<IMEvent>(context, listen: false).onRecvC2CCustomMessage,
      onRecvC2CTextMessage:
          Provider.of<IMEvent>(context, listen: false).onRecvC2CTextMessage,
      onRecvGroupCustomMessage:
          Provider.of<IMEvent>(context, listen: false).onRecvGroupCustomMessage,
      onRecvGroupTextMessage:
          Provider.of<IMEvent>(context, listen: false).onRecvGroupTextMessage,
    );

    advancedMsgListener = new V2TimAdvancedMsgListener(
      onRecvC2CReadReceipt:
          Provider.of<IMEvent>(context, listen: false).onRecvC2CReadReceipt,
      onRecvMessageRevoked:
          Provider.of<IMEvent>(context, listen: false).onRecvMessageRevoked,
      onRecvNewMessage:
          Provider.of<IMEvent>(context, listen: false).onRecvNewMessage,
      onSendMessageProgress:
          Provider.of<IMEvent>(context, listen: false).onSendMessageProgress,
    );

    signalingListener = new V2TimSignalingListener(
      onInvitationCancelled:
          Provider.of<IMEvent>(context, listen: false).onInvitationCancelled,
      onInvitationTimeout:
          Provider.of<IMEvent>(context, listen: false).onInvitationTimeout,
      onInviteeAccepted:
          Provider.of<IMEvent>(context, listen: false).onInviteeAccepted,
      onInviteeRejected:
          Provider.of<IMEvent>(context, listen: false).onInviteeRejected,
      onReceiveNewInvitation:
          Provider.of<IMEvent>(context, listen: false).onReceiveNewInvitation,
    );
    //注册简单消息监听器
    // ignore: deprecated_member_use
    await TencentImSDKPlugin.v2TIMManager.addSimpleMsgListener(
      listener: simpleMsgListener,
    );
    //注册群组消息监听器
    await TencentImSDKPlugin.v2TIMManager.setGroupListener(
      listener: new V2TimGroupListener(
        onApplicationProcessed:
            Provider.of<IMEvent>(context, listen: false).onApplicationProcessed,
        onGrantAdministrator:
            Provider.of<IMEvent>(context, listen: false).onGrantAdministrator,
        onGroupAttributeChanged: Provider.of<IMEvent>(context, listen: false)
            .onGroupAttributeChanged,
        onGroupCreated:
            Provider.of<IMEvent>(context, listen: false).onGroupCreated,
        onGroupDismissed:
            Provider.of<IMEvent>(context, listen: false).onGroupDismissed,
        onGroupInfoChanged:
            Provider.of<IMEvent>(context, listen: false).onGroupInfoChanged,
        onGroupRecycled:
            Provider.of<IMEvent>(context, listen: false).onGroupRecycled,
        onMemberEnter:
            Provider.of<IMEvent>(context, listen: false).onMemberEnter,
        onMemberInfoChanged:
            Provider.of<IMEvent>(context, listen: false).onMemberInfoChanged,
        onMemberInvited:
            Provider.of<IMEvent>(context, listen: false).onMemberInvited,
        onMemberKicked:
            Provider.of<IMEvent>(context, listen: false).onMemberKicked,
        onMemberLeave:
            Provider.of<IMEvent>(context, listen: false).onMemberLeave,
        onQuitFromGroup:
            Provider.of<IMEvent>(context, listen: false).onQuitFromGroup,
        onReceiveJoinApplication: Provider.of<IMEvent>(context, listen: false)
            .onReceiveJoinApplication,
        onReceiveRESTCustomData: Provider.of<IMEvent>(context, listen: false)
            .onReceiveRESTCustomData,
        onRevokeAdministrator:
            Provider.of<IMEvent>(context, listen: false).onRevokeAdministrator,
      ),
    );
    //注册高级消息监听器
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(
          listener: advancedMsgListener,
        );
    //注册信令消息监听器
    await TencentImSDKPlugin.v2TIMManager
        .getSignalingManager()
        .addSignalingListener(
          listener: signalingListener,
        );
    //注册会话监听器
    await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .setConversationListener(
          listener: new V2TimConversationListener(
            onConversationChanged: Provider.of<IMEvent>(context, listen: false)
                .onConversationChanged,
            onNewConversation:
                Provider.of<IMEvent>(context, listen: false).onNewConversation,
            onSyncServerFailed:
                Provider.of<IMEvent>(context, listen: false).onSyncServerFailed,
            onSyncServerFinish:
                Provider.of<IMEvent>(context, listen: false).onSyncServerFinish,
            onSyncServerStart:
                Provider.of<IMEvent>(context, listen: false).onSyncServerStart,
          ),
        );
    //注册关系链监听器
    await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .setFriendListener(
          listener: new V2TimFriendshipListener(),
        );
  }

  /*
  * 注销simpleMsgListener事件
  * */
  removeSimpleMsgListener() async {
    await TencentImSDKPlugin.v2TIMManager
        .removeSimpleMsgListener(listener: simpleMsgListener);
  }

  /*
  * 注销所有simpleMsgListener事件
  * */
  removeAllSimpleMsgListener() async {
    await TencentImSDKPlugin.v2TIMManager.removeSimpleMsgListener();
  }

  /*
  * 注销advanceMsgListener
  * */
  removeAdvanceMsgListener() async {
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: advancedMsgListener);
  }

  /*
  * 注销所有advanceMsgListener
  * */
  removeAllAdvanceMsgListener() async {
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener();
  }

  /*
  * 注销signalingListener
  * */
  removeSignalingListener() async {
    await TencentImSDKPlugin.v2TIMManager
        .getSignalingManager()
        .removeSignalingListener(listener: signalingListener);
  }

  /*
  * 注销所有signalingListener
  * */
  removeAllSignalingListener() async {
    await TencentImSDKPlugin.v2TIMManager
        .getSignalingManager()
        .removeSignalingListener();
  }

  /*
  * 获取服务端时间
  * */
  static void getServerTime() async {
    V2TimValueCallback<int> res =
        await TencentImSDKPlugin.v2TIMManager.getServerTime();
    imPrint(res.toJson(), "获取服务端时间");
  }

  /// 检测登录
  static Future checkLogin() async {
    // 获取登录状态
    final int loginStatus = await getLoginStatus();

    // 获取用户id
    final String userId = Data.user();

    // 登录状态
    // V2TIM_STATUS_LOGINED 已登录1
    // V2TIM_STATUS_LOGINING 登录中2
    // V2TIM_STATUS_LOGOUT 无登录3
    if (loginStatus == 1) {
      // 已登录

      // 判断登录的是否当前用户
      final String _getLoginUser = await getLoginUser();
      if (_getLoginUser == userId) {
        // 是当前用户不再继续执行
        return;
      }

      // 不是的话退出登录；
      await logout();
    }

    // 没有登录
    // 获取token
    // final String accessToken = Q1Data.token;
    // if (!strNoEmpty(accessToken)) {
    //   // token为空，实际未登录
    //   return;
    // }

    if (!strNoEmpty(userId)) {
      // 用户Id为空，实际也没有登录
      return;
    }

    // 登录
    await login(userId);
  }

  /*
  * 登录
  * */
  static Future<V2TimCallback> login(String userID) async {
    // 正式环境请在服务端计算userSIg
    String userSig = new GenerateTestUserSig(
      sdkappid: AppConfig.IMSdkAppID,
      key: AppConfig.ImSdkSign,
    ).genSig(
      identifier: userID,
      expire: 7 * 24 * 60 * 1000, // userSIg有效期
    );
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.login(
      userID: userID,
      userSig: userSig,
    );
    imPrint(res.toJson(), "登录");

    final userInfoList = await getUsersInfo([userID]);

    /// 获取用户信息失败了
    if (!listNoEmpty(userInfoList)) {
      return res;
    }

    /// 如果昵称不为空则直接返回
    /// 如果昵称为空去设置信息
    if (strNoEmpty(userInfoList[0].nickName)) {
      return res;
    }

    setSelfInfo(
        nickname: "u" + (userID.length > 5 ? userID.substring(0, 4) : userID));
    return res;
  }

  /*
  * 登出【退出登录】
  * */
  static Future<V2TimCallback> logout() async {
    final V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.logout();
    imPrint(res.toJson(), "登出【退出登录】");
    return res;
  }

  /*
  * 获取sdk版本
  * */
  static Future getVersion() async {
    V2TimValueCallback<String> res =
        await TencentImSDKPlugin.v2TIMManager.getVersion();
    imPrint(res.toJson(), "获取sdk版本");
  }

  /*
  * 获取当前登录用户
  * */
  static Future<String> getLoginUser() async {
    V2TimValueCallback<String> res =
        await TencentImSDKPlugin.v2TIMManager.getLoginUser();
    imPrint(res.toJson(), "获取当前登录用户");

    return res.data;
  }

  /*
  * 获取当前登录状态
  * */
  static Future<int> getLoginStatus() async {
    V2TimValueCallback<int> res =
        await TencentImSDKPlugin.v2TIMManager.getLoginStatus();
    imPrint(res.toJson(), "获取当前登录状态");

    print("获取当前登录状态::${res.data.toString()}");
    return res.data;
  }

  /*
  * 获取用户信息
  * */
  static Future<List<V2TimUserFullInfo>> getUsersInfo(
      List<String> users) async {
    V2TimValueCallback<List<V2TimUserFullInfo>> res =
        await TencentImSDKPlugin.v2TIMManager.getUsersInfo(
      userIDList: users,
    );
    imPrint(res.toJson(), "获取用户信息");
    return res.data;
  }

  /*
  * 设置个人信息
  * */
  static Future setSelfInfo({
    String nickname,
    String faceUrl,
    String selfSignature,
    String gender,
    String allowType,
    String customInfo,
  }) async {
    // todo 设置基本信息只需填某个，未填的传原本的，或者不传
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson({
        "nickName": nickname,
        "faceUrl": faceUrl,
        "selfSignature": selfSignature,
        "gender": gender,
        "allowType": allowType,
        "customInfo": customInfo,
      }),
    );
    imPrint(res.toJson(), "设置个人信息");
  }
}
