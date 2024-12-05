import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimCommunityListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import '../pages/login/login_begin_page.dart';
import '../pages/root/root_page.dart';
import '../tools/event/im_event.dart';
import 'GenerateUserSig.dart';

class ImLoginManager {
  static V2TimSDKListener? _sdkListener;

  // 默认时间：7 x 24 x 60 x 60 = 604800 = 7 天
  static const int expireTime = 604800;

  static Future<void> init(BuildContext context) async {
    _sdkListener = V2TimSDKListener(
      onConnectFailed: (int code, String error) {
        log('[ImLoginManager] onConnectFailed code:$code error:$error');
      },
      onConnectSuccess: () {
        log('[ImLoginManager] onConnectSuccess');
      },
      onConnecting: () {
        log('[ImLoginManager] onConnecting');
      },
      onKickedOffline: () {
        log('[ImLoginManager] onKickedOffline');
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        log('[ImLoginManager] onSelfInfoUpdated, ${json.encode(info)}');
      },
      onUserSigExpired: () {
        log('[ImLoginManager] onUserSigExpired');
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        log('[ImLoginManager] onUserStatusChanged, ${json.encode(userStatusList)}');
      },
    );
    V2TimValueCallback<bool> initSDKRes =
        await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: appId, // SDKAppID
      loglevel: LogLevelEnum.V2TIM_LOG_ALL, // 日志登记等级
      listener: _sdkListener!, // 事件监听器
    );

    if (initSDKRes.code == 0) {
      debugPrint('初始化结果 ======>   ${json.encode(initSDKRes)}');
      addGroupListener();
      await addAdvancedMsgListener();
      addFriendshipListener();
      addConversationListener();
    } else {
      showToast('初始化失败');
    }
  }

  static Future<void> login(String userName, BuildContext context) async {
    final model = Provider.of<GlobalModel>(context, listen: false);

    //初始化成功
    GenerateDevUsersigForTest generateDevUsersigForTest =
        GenerateDevUsersigForTest(sdkappid: appId, key: appKey);
    String userSig = generateDevUsersigForTest.genSig(
        identifier: userName, expire: expireTime);
    V2TimCallback loginRes = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userName, userSig: userSig);
    print('login ==> ' + json.encode(loginRes));

    V2TimCallback call = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userName, userSig: userSig);
    if (call.code == 0) {
      model.account = userName;
      model.goToLogin = false;
      await SharedUtil.instance.saveString(Keys.account, userName);
      await SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
      model.refresh();
      await Get.offAll(new RootPage());
    } else {
      showToast('登录失败: ${call.desc}');
    }
  }

  static Future<void> loginOut(BuildContext context) async {
    final model = Provider.of<GlobalModel>(context, listen: false);

    V2TimCallback call = await TencentImSDKPlugin.v2TIMManager.logout();
    if (call.code == 0) {
      model.goToLogin = true;
      model.refresh();
      await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
      await Get.offAll(new LoginBeginPage());
      showToast('登出成功');
    } else {
      showToast(call.desc);
      print('error::' + call.desc);
    }
  }

  static String _conversationListenerData = '';

  static String get conversationListenerData => _conversationListenerData;
  static late V2TimConversationListener conversationListener;
  static late V2TimCommunityListener communityListener;

  static void addConversationListener() {
    communityListener = V2TimCommunityListener(
      onDeletePermissionGroup: (groupID, permissionGroupIDList) {
        print('delete p group');
      },
    );
    TencentImSDKPlugin.v2TIMManager
        .getCommunityManager()
        .addCommunityListener(listener: communityListener);
    conversationListener = V2TimConversationListener(
      onConversationDeleted: (conversationIDList) {
        print('conversation deleted');
        print(conversationIDList);
      },
      onConversationChanged: (List<V2TimConversation> conversationList) {
        //某些会话的关键信息发生变化（未读计数发生变化、最后一条消息被更新等等）的回调函数
        //conversationList    变化的会话列表
        _conversationListenerData =
            'onConversationChanged ${conversationList.toString()}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationChanged");
        // increment();
        // notifyListeners();
      },
      onConversationGroupCreated:
          (String groupName, List<V2TimConversation> conversationList) {
        // 会话分组被创建
        // groupName 会话分组名称
        // conversationList 会话分组包含的会话列表
        _conversationListenerData =
            'onConversationGroupCreated groupName: ${groupName} conversationList ${conversationList.toString()}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationGroupCreated ${groupName}");
        // increment();
        // notifyListeners();
      },
      onConversationGroupDeleted: (String groupName) {
        // 会话分组被删除
        // groupName  被删除的会话分组名称
        _conversationListenerData = 'onConversationGroupDeleted ${groupName}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationGroupDeleted ${groupName}");
        // increment();
        // notifyListeners();
      },
      onConversationGroupNameChanged: (String oldName, String newName) {
        // 会话分组名变更
        // oldName 旧名称
        // newName 新名称
        _conversationListenerData =
            'onConversationGroupNameChanged oldName: ${oldName}, newName: ${newName}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationGroupNameChanged");
        // increment();
        // notifyListeners();
      },
      onConversationsAddedToGroup:
          (String groupName, List<V2TimConversation> conversationList) {
        // 会话分组新增会话
        // groupName 会话分组名称
        // conversationList 被加入会话分组的会话列表
        _conversationListenerData =
            'onConversationsAddedToGroup groupName: ${groupName}, conversationList: ${conversationList.toString()}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationsAddedToGroup ${groupName}");
        // increment();
        // notifyListeners();
      },
      onConversationsDeletedFromGroup:
          (String groupName, List<V2TimConversation> conversationList) {
        // 会话分组删除会话
        // groupName 会话分组名称
        // conversationList 被删除的会话列表
        _conversationListenerData =
            'onConversationsDeletedFromGroup groupName:${groupName} conversationList: ${conversationList.toString()}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onConversationsDeletedFromGroup");
        // increment();
        // notifyListeners();
      },
      onNewConversation: (List<V2TimConversation> conversationList) {
        // 新会话的回调函数
        // conversationList 收到的新会话列表
        _conversationListenerData =
            'onNewConversation ${conversationList.toString()}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onNewConversation");
        // increment();
        // notifyListeners();
      },
      onSyncServerFailed: () {
        // 同步服务失败的回调函数
        _conversationListenerData = 'onSyncServerFailed';
        // _callbackList.add("${getCurrentTime()}ConversationListener onSyncServerFailed");
        // increment();
        // notifyListeners();
      },
      onSyncServerFinish: () {
        // 同步服务完成的回调函数
        _conversationListenerData = 'onSyncServerFinish';
        // _callbackList.add("${getCurrentTime()}ConversationListener onSyncServerFinish");
        // increment();
        // notifyListeners();
      },
      onSyncServerStart: () {
        // 同步服务开始的回调函数
        _conversationListenerData = 'onSyncServerStart';
        // _callbackList.add("${getCurrentTime()}ConversationListener onSyncServerStart");
        // increment();
        // notifyListeners();
      },
      onTotalUnreadMessageCountChanged: (int totalUnreadCount) {
        // 会话未读总数改变的回调函数
        // totalUnreadCount 会话未读总数
        _conversationListenerData =
            'onTotalUnreadMessageCountChanged ${totalUnreadCount}';
        // _callbackList.add("${getCurrentTime()}ConversationListener onTotalUnreadMessageCountChanged ${totalUnreadCount}");
        // increment();
        // notifyListeners();
      },
    );
    TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .addConversationListener(listener: conversationListener);
  }

  void removeConversationListener() {
    TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .removeConversationListener(listener: conversationListener);
  }

  static String _friendshipListenerData = '';

  static String get friendshipListenerData => _friendshipListenerData;
  static late V2TimFriendshipListener friendshipListener;

  static void addFriendshipListener() {
    friendshipListener = V2TimFriendshipListener(
      onBlackListAdd: (List<V2TimFriendInfo> infoList) async {
        //黑名单列表新增用户的回调
        //infoList 新增的用户信息列表
        _friendshipListenerData = 'onBlackListAdd ${infoList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onBlackListAdd");
        // increment();
        // notifyListeners();
      },
      onBlackListDeleted: (List<String> userList) async {
        //黑名单列表删除的回调
        //userList 被删除的用户id列表
        _friendshipListenerData = 'onBlackListDeleted ${userList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onBlackListDeleted");
        // increment();
        // notifyListeners();
      },
      onFriendApplicationListAdded:
          (List<V2TimFriendApplication> applicationList) async {
        //好友请求数量增加的回调
        //applicationList 新增的好友请求信息列表
        _friendshipListenerData =
            'onFriendApplicationListAdded ${applicationList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendApplicationListAdded");
        // increment();
        // notifyListeners();
      },
      onFriendApplicationListDeleted: (List<String> userIDList) async {
        //好友请求数量减少的回调
        //减少的好友请求的请求用户id列表
        _friendshipListenerData =
            'onFriendApplicationListDeleted ${userIDList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendApplicationListDeleted");
        // increment();
        // notifyListeners();
      },
      onFriendApplicationListRead: () async {
        //好友请求已读的回调
        _friendshipListenerData = 'onFriendApplicationListRead';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendApplicationListRead");
        // increment();
        // notifyListeners();
      },
      onFriendInfoChanged: (List<V2TimFriendInfo> infoList) async {
        //好友信息改变的回调
        //infoList 好友信息改变的好友列表
        _friendshipListenerData = 'onFriendInfoChanged ${infoList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendInfoChanged");
        // increment();
        // notifyListeners();
      },
      onFriendListAdded: (List<V2TimFriendInfo> users) async {
        //好友列表增加人员的回调
        //users 新增的好友信息列表
        _friendshipListenerData = 'onFriendListAdded ${users.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendListAdded");
        // increment();
        // notifyListeners();
      },
      onFriendListDeleted: (List<String> userList) async {
        //好友列表减少人员的回调
        //userList 减少的好友id列表
        _friendshipListenerData = 'onFriendListDeleted ${userList.toString()}';
        log('_friendshipListenerData::$_friendshipListenerData');
        // _callbackList.add("${getCurrentTime()}FriendshipListener onFriendListDeleted");
        // increment();
        // notifyListeners();
      },
    );
    TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .addFriendListener(listener: friendshipListener);
  }

  void removeFriendshipListener() {
    TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .removeFriendListener(listener: friendshipListener);
  }

  static String _msgListenerData = '';
  static late V2TimAdvancedMsgListener advancedMsgListener;

  static Future<void> addAdvancedMsgListener() async {
    advancedMsgListener = V2TimAdvancedMsgListener(
      onRecvC2CReadReceipt: (List<V2TimMessageReceipt> receiptList) {
        _msgListenerData = 'onRecvC2CReadReceipt $receiptList';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        // _callbackList
        //     .add("${getCurrentTime()}AdvancedMsgListener onRecvC2CReadReceipt");
        // increment();
        // notifyListeners();

        //单聊已读回调
      },
      onRecvMessageModified: (V2TimMessage message) {
        _msgListenerData = 'onRecvMessageModified ${message.toJson()}';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        // _callbackList.add(
        //     "${getCurrentTime()}AdvancedMsgListener onRecvMessageModified");
        // increment();
        // notifyListeners();

        // msg 为被修改之后的消息对象
      },
      onRecvMessageReadReceipts: (List<V2TimMessageReceipt> receiptList) {
        _msgListenerData = 'onRecvMessageReadReceipts $receiptList';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        // _callbackList.add(
        //     "${getCurrentTime()}AdvancedMsgListener onRecvMessageReadReceipts");
        // increment();
        // notifyListeners();
      },
      onRecvMessageRevoked: (String messageid) {
        // 在本地维护的消息中处理被对方撤回的消息
        _msgListenerData = 'onRecvMessageRevoked $messageid';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        // _callbackList
        //     .add("${getCurrentTime()}AdvancedMsgListener onRecvMessageRevoked");
        // increment();
        // notifyListeners();
      },
      onRecvNewMessage: (V2TimMessage message) async {
        if (kDebugMode) {
          print('onRecvNewMessage ${message.toJson()}');
        }

        _msgListenerData = 'onRecvNewMessage ${message.toJson()}';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        String m = '';
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
          m = 'text ${message.textElem?.text}';
        }
        // 使用自定义消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
          m = 'custom ${message.customElem?.data}';
        }
        // 使用图片消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
          m = 'image';
        }
        // 处理视频消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
          m = 'video';
        }
        // 处理音频消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
          m = 'sound';
        }
        // 处理文件消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
          m = 'file';
        }
        // 处理位置消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_LOCATION) {
          m = 'location';
        }
        // 处理表情消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FACE) {
          m = 'face';
        }
        // 处理群组tips文本消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
          m = 'group tips';
        }
        // 处理合并消息消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_MERGER) {
          m = 'merger';
        }
        V2TimValueCallback<List<V2TimMessage>> download =
            await TencentImSDKPlugin.v2TIMManager
                .getMessageManager()
                .downloadMergerMessage(
                  msgID: message.msgID!,
                );
        // _callbackList.add(
        //     "${getCurrentTime()}AdvancedMsgListener onRecvNewMessage sender:${message.sender} receiver:${message.userID} message: ${m}");
        // increment();
        // notifyListeners();

        /// Receive a new message then notice the chat Page.
        eventBusNewMsg.value =
            EventBusNewMsg(message.userID ?? message.groupID!);
      },
      onSendMessageProgress: (V2TimMessage message, int progress) {
        //文件上传进度回调

        _msgListenerData = 'onSendMessageProgress ${message.toJson()}';
        log('[ImLoginManager] _msgListenerData ==> $_msgListenerData');
        // _callbackList.add(
        //     "${getCurrentTime()}AdvancedMsgListener onSendMessageProgress");
        // increment();
        // notifyListeners();
      },
      onRecvMessageReactionsChanged: (changeInfos) {
        print(
            'onRecvMessageReactionsChanged ${changeInfos.map((e) => e.toJson()).toList()}');
      },
    );

    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(listener: advancedMsgListener);
  }

  void removeAdvancedMessageListener() {
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: advancedMsgListener);
  }

  static late V2TimGroupListener groupListener;
  static String _groupListenerData = '';

  static String get groupListenerData => _groupListenerData;

  static Future<void> addGroupListener() async {
    groupListener = V2TimGroupListener(
      onApplicationProcessed: (String groupID, V2TimGroupMemberInfo opUser,
          bool isAgreeJoin, String opReason) async {
        _groupListenerData =
            'onApplicationProcessed groupID: ${groupID}, opUser: ${opUser.toJson()}, isAgreeJoin: ${isAgreeJoin}, opReason: ${opReason}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");

        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onApplicationProcessed ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGrantAdministrator: (String groupID, V2TimGroupMemberInfo opUser,
          List<V2TimGroupMemberInfo> memberList) async {
        _groupListenerData =
            'onGrantAdministrator groupID: ${groupID}, opUser: ${opUser}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");

        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onGrantAdministrator ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGroupAttributeChanged:
          (String groupID, Map<String, String> groupAttributeMap) async {
        //收到群属性更新的回调
        //groupID    群 ID
        //groupAttributeMap    群的所有属性
        _groupListenerData = 'onGroupAttributeChanged groupID: ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onGroupAttributeChanged ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGroupCreated: (String groupID) async {
        //创建群（主要用于多端同步）
        //groupID    群 ID
        _groupListenerData = 'onGroupCreated ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onGroupCreated ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGroupDismissed: (String groupID, V2TimGroupMemberInfo opUser) async {
        //群被解散了（全员能收到）
        //groupID    群 ID
        //opUser    处理人
        _groupListenerData = 'onGroupDismissed ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onGroupDismissed ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGroupInfoChanged:
          (String groupID, List<V2TimGroupChangeInfo> changeInfos) async {
        //群信息被修改（全员能收到）
        //groupID    群 ID
        //changeInfos    修改的群信息
        _groupListenerData = 'onGroupInfoChanged ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onGroupInfoChanged ${groupID}");
        // increment();
        // notifyListeners();
      },
      onGroupRecycled: (String groupID, V2TimGroupMemberInfo opUser) async {
        //群被回收（全员能收到）
        //groupID    群 ID
        //opUser    处理人
        _groupListenerData = 'onGroupRecycled ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onGroupRecycled ${groupID}");
        // increment();
        // notifyListeners();
      },
      onMemberEnter:
          (String groupID, List<V2TimGroupMemberInfo> memberList) async {
        //有用户加入群（全员能够收到）
        //groupID    群 ID
        //memberList    加入的成员
        _groupListenerData = 'onMemberEnter ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onMemberEnter ${groupID}");
        // increment();
        // notifyListeners();
      },
      onMemberInfoChanged: (String groupID,
          List<V2TimGroupMemberChangeInfo>
              v2TIMGroupMemberChangeInfoList) async {
        //群成员信息被修改，仅支持禁言通知（全员能收到）。
        //groupID    群 ID
        //v2TIMGroupMemberChangeInfoList    被修改的群成员信息
        _groupListenerData = 'onMemberInfoChanged ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onMemberInfoChanged ${groupID}");
        // increment();
        // notifyListeners();
      },
      onMemberInvited: (String groupID, V2TimGroupMemberInfo opUser,
          List<V2TimGroupMemberInfo> memberList) async {
        //某些人被拉入某群（全员能够收到）
        //groupID    群 ID
        //opUser    处理人
        //memberList    被拉进群成员
        _groupListenerData = 'onMemberInvited ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onMemberInvited ${groupID}");
        // increment();
        // notifyListeners();
      },
      onMemberKicked: (String groupID, V2TimGroupMemberInfo opUser,
          List<V2TimGroupMemberInfo> memberList) async {
        //某些人被踢出某群（全员能够收到）
        //groupID    群 ID
        //opUser    处理人
        //memberList    被踢成员
        _groupListenerData = 'onMemberKicked ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onMemberKicked ${groupID}");
        // increment();
        // notifyListeners();
      },
      onMemberLeave: (String groupID, V2TimGroupMemberInfo member) async {
        //有用户离开群（全员能够收到）
        //groupID    群 ID
        //member    离开的成员
        _groupListenerData = 'onMemberLeave ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onMemberLeave ${groupID}");
        // increment();
        // notifyListeners();
      },
      onQuitFromGroup: (String groupID) async {
        //主动退出群组（主要用于多端同步，直播群（AVChatRoom）不支持）
        //groupID    群 ID
        _groupListenerData = 'onQuitFromGroup ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList
        //     .add("${getCurrentTime()}GroupListener onQuitFromGroup ${groupID}");
        // increment();
        // notifyListeners();
      },
      onReceiveJoinApplication:
          (String groupID, V2TimGroupMemberInfo member, String opReason) async {
        //有新的加群请求（只有群主或管理员会收到）
        //groupID    群 ID
        //member    申请人
        //opReason    申请原因
        _groupListenerData = 'onReceiveJoinApplication ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onReceiveJoinApplication ${groupID}");
        // increment();
        // notifyListeners();
      },
      onReceiveRESTCustomData: (String groupID, String customData) async {
        //收到 RESTAPI 下发的自定义系统消息
        //groupID    群 ID
        //customData    自定义数据
        _groupListenerData = 'onReceiveRESTCustomData';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onReceiveRESTCustomData ${groupID}");
        // increment();
        // notifyListeners();
      },
      onRevokeAdministrator: (String groupID, V2TimGroupMemberInfo opUser,
          List<V2TimGroupMemberInfo> memberList) async {
        //取消管理员身份
        //groupID    群 ID
        //opUser    处理人
        //memberList    被处理的群成员
        _groupListenerData = 'onRevokeAdministrator ${groupID}';
        log("[LoginHandle] _groupListnerData $_groupListenerData");
        // _callbackList.add(
        //     "${getCurrentTime()}GroupListener onRevokeAdministrator ${groupID}");
        // increment();
        // notifyListeners();
      },
    );
    //添加群组监听器
    await TencentImSDKPlugin.v2TIMManager
        .addGroupListener(listener: groupListener);
  }

  void removeGroupListener() {
    TencentImSDKPlugin.v2TIMManager
        .removeGroupListener(listener: groupListener);
  }

  static Future<void> removeAllListeners() async {
    TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .removeConversationListener(listener: conversationListener);
    TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .removeFriendListener(listener: friendshipListener);
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: advancedMsgListener);
    TencentImSDKPlugin.v2TIMManager
        .removeGroupListener(listener: groupListener);
  }
}
