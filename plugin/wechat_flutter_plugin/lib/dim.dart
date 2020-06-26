import 'dart:async';
import 'package:flutter/services.dart';

export 'package:dim/commom/check.dart';
export 'package:dim/commom/route.dart';
export 'package:dim/commom/ui.dart';
export 'package:dim/commom/win_media.dart';
export 'package:dim/pinyin/chinese_helper.dart';
export 'package:dim/pinyin/dict_data.dart';
export 'package:dim/pinyin/pinyin_exception.dart';
export 'package:dim/pinyin/pinyin_format.dart';
export 'package:dim/pinyin/chinese_helper.dart';
export 'package:dim/pinyin/pinyin_resourece.dart';
export 'package:dim/time/time_util.dart';

class Dim {
  factory Dim() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('dim_method');
      final EventChannel eventChannel = const EventChannel('dim_event');
      _instance = new Dim.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  Dim.private(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;

  final EventChannel _eventChannel;

  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Dim _instance;

  Stream<dynamic> _listener;

  Stream<dynamic> get onMessage {
    if (_listener == null) {
      _listener = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseBatteryState(event));
    }
    return _listener;
  }

  ///im初始化
  Future<dynamic> init(int appid) async {
    return await _methodChannel.invokeMethod("init", <String, dynamic>{
      'appid': appid,
    });
  }

  ///im登录
  Future<dynamic> imLogin(String identifier, String sig) async {
    return await _methodChannel.invokeMethod("im_login", <String, dynamic>{
      'identifier': identifier,
//      'userSig': sig,
    });
  }

  ///im登出
  Future<dynamic> imLogout() async {
    return await _methodChannel.invokeMethod("im_logout");
  }

  ///获取会话列表
  Future<dynamic> getConversations() async {
    return await _methodChannel.invokeMethod('getConversations');
  }

  ///删除会话
  ///Delete session
  Future<dynamic> delConversation(String identifier, int type) async {
    return await _methodChannel.invokeMethod('delConversation',
        <String, dynamic>{'identifier': identifier, 'type': type});
  }

  ///获取一个会话的消息，暂不支持流式查询
  ///identifier 会话id
  ///count 获取消息数量 ,默认50条
  ///ctype 1 私信，2群聊  ,默认是私信
  Future<dynamic> getMessages(String identifier,
      [int count = 50, int ctype = 1]) async {
    return await _methodChannel.invokeMethod('getMessages', <String, dynamic>{
      'identifier': identifier,
      'count': count,
      'ctype': ctype
    });
  }

  ///发送文本消息
  ///Send a text message
  Future<dynamic> sendTextMessages(String identifier, String content,
      {int type}) async {
    return await _methodChannel
        .invokeMethod('sendTextMessages', <String, dynamic>{
      'identifier': identifier,
      'content': content,
      'type': type ?? 1,
    });
  }

  ///发送图片消息
  ///imagePath   eg for android : Environment.getExternalStorageDirectory() + "/DCIM/Camera/1.jpg"
  Future<dynamic> sendImageMessages(String identifier, String imagePath,
      {int type}) async {
    return await _methodChannel
        .invokeMethod('sendImageMessages', <String, dynamic>{
      'identifier': identifier,
      'image_path': imagePath,
      'type': type ?? 1,
    });
  }

  ///发送语音消息
  ///soundPath   eg for android : Environment.getExternalStorageDirectory() + "/sound.mp3"
  Future<dynamic> sendSoundMessages(
      String identifier, String soundPath, int type,
      [int duration = 10]) async {
    return await _methodChannel
        .invokeMethod('sendSoundMessages', <String, dynamic>{
      'identifier': identifier,
      'sound_path': soundPath,
      'duration': duration,
      'type': type ?? 1,
    });
  }

  ///发送视频消息 （封面和视频必须是在本地存在的，不能直接放网络远程的文件，否则7006）duration为毫秒1秒等于1000毫秒
  ///Send video messages (cover and video must be local, can not directly put the network remote file, otherwise 7006)
  ///duration is milliseconds 1 second equals 1000 milliseconds
  Future<dynamic> buildVideoMessage(
      String identifier, String videoPath, int width, int height, int type,
      [int duration = 10]) async {
    return await _methodChannel
        .invokeMethod('buildVideoMessage', <String, dynamic>{
      'identifier': identifier,
      'videoPath': videoPath,
      'width': width,
      'height': height,
      'duration': duration,
      'type': type ?? 1,
    });
  }

  ///发送位置消息
  ///eg：
  ///lat 113.93
  ///lng 22.54
  ///desc 腾讯大厦
  Future<dynamic> sendLocationMessages(
      String identifier, double lat, double lng, String desc) async {
    return await _methodChannel.invokeMethod('sendLocation', <String, dynamic>{
      'identifier': identifier,
      'lat': lat,
      'lng': lng,
      'desc': desc,
    });
  }

  ///添加好友
  ///
  Future<dynamic> addFriend(String identifier) async {
    return await _methodChannel
        .invokeMethod("addFriend", <String, dynamic>{'identifier': identifier});
  }

  ///删除好友
  ///
  Future<dynamic> delFriend(String identifier) async {
    return await _methodChannel
        .invokeMethod("delFriend", <String, dynamic>{'identifier': identifier});
  }

  ///获取好友列表
  ///
  Future<dynamic> listFriends(String identifier) async {
    return await _methodChannel.invokeMethod(
        "listFriends", <String, dynamic>{'identifier': identifier});
  }

  ///处理好友的请求，接受/拒绝
  ///opTypeStr 接受传 Y
  ///opTypeStr 拒绝传 N
  Future<dynamic> opFriend(String identifier, String opTypeStr) async {
    return await _methodChannel.invokeMethod("opFriend",
        <String, dynamic>{'identifier': identifier, 'opTypeStr': opTypeStr});
  }

  ///获取用户资料
  ///param user is a list ["usersf1","jiofoea2"]
  Future<dynamic> getUsersProfile(List<String> users) async {
    return await _methodChannel
        .invokeMethod("getUsersProfile", <String, dynamic>{'users': users});
  }

  ///设置个人资料
  Future<dynamic> setUsersProfile(
      int gender, String nick, String faceUrl) async {
    return await _methodChannel.invokeMethod("setUsersProfile",
        <String, dynamic>{'gender': gender, 'nick': nick, 'faceUrl': faceUrl});
  }

  ///测试使用eventChannel推送数据过来
  Future<dynamic> postDataTest() async {
    return await _methodChannel.invokeMethod("post_data_test");
  }

  ///========================以下IOS端的开发中
  ///
  ///
  ///
  ///获取当前登录用户
  ///getCurrentLoginUser
  Future<dynamic> getCurrentLoginUser() async {
    return await _methodChannel.invokeMethod('getCurrentLoginUser');
  }

  ///自动登录
  ///im_autoLogin
  Future<dynamic> imAutoLogin(String identifier) async {
    return await _methodChannel.invokeMethod(
        'im_autoLogin', <String, dynamic>{'identifier': identifier});
  }

  ///删除会话和记录
  ///deleteConversationAndLocalMsg
  Future<dynamic> deleteConversationAndLocalMsg(
      int type, String identifier) async {
    return await _methodChannel.invokeMethod('deleteConversationAndLocalMsg',
        <String, dynamic>{'type': type, 'identifier': identifier});
  }

  ///获取未读消息数量
  ///getUnreadMessageNum
  Future<dynamic> getUnreadMessageNum(int type, String identifier) async {
    return await _methodChannel.invokeMethod('getUnreadMessageNum',
        <String, dynamic>{'type': type, 'identifier': identifier});
  }

  ///设置消息为已读
  ///setReadMessage
  Future<dynamic> setReadMessage(int type, String identifier) async {
    return await _methodChannel.invokeMethod('setReadMessage',
        <String, dynamic>{'type': type, 'identifier': identifier});
  }


  ///解散群组
  ///deleteGroup
  Future<dynamic> deleteGroup(String groupId) async {
    return await _methodChannel.invokeMethod('deleteGroup', <String, dynamic>{
      'groupId': groupId,
    });
  }

  ///修改群名
  ///modifyGroupName
  Future<dynamic> modifyGroupName(String groupId, String setGroupName) async {
    return await _methodChannel.invokeMethod('modifyGroupName',
        <String, dynamic>{'groupId': groupId, 'setGroupName': setGroupName});
  }

  ///修改群简介
  ///modifyGroupIntroduction
  Future<dynamic> modifyGroupIntroduction(
      String groupId, String setIntroduction) async {
    return await _methodChannel.invokeMethod(
        'modifyGroupIntroduction', <String, dynamic>{
      'groupId': groupId,
      'setIntroduction': setIntroduction
    });
  }

  ///修改群公告
  ///modifyGroupNotification
  Future<dynamic> modifyGroupNotification(
      String groupId, String notification, String time) async {
    return await _methodChannel
        .invokeMethod('modifyGroupNotification', <String, dynamic>{
      'groupId': groupId,
      'notification': notification,
      'time': time,
    });
  }

  ///修改群消息提醒选项
  ///setReceiveMessageOption
  Future<dynamic> setReceiveMessageOption(
      String groupId, String identifier, int type) async {
    return await _methodChannel
        .invokeMethod('setReceiveMessageOption', <String, dynamic>{
      'groupId': groupId,
      'identifier': identifier,
      'type': type,
    });
  }

  ///获取未决消息列表
  ///getPendencyList
  Future<dynamic> getPendencyList() async {
    return await _methodChannel.invokeMethod('getPendencyList');
  }

  ///获取网络保存的自己资料 主要获取加我的方式
  ///getSelfProfile
  Future<dynamic> getSelfProfile() async {
    return await _methodChannel.invokeMethod('getSelfProfile');
  }

  ///设置增加我的方式 1为需要认证  2为无需认证
  ///setAddMyWay
  Future<dynamic> setAddMyWay(int type) async {
    return await _methodChannel
        .invokeMethod('setAddMyWay', <String, dynamic>{'type': type});
  }

  ///获取登录的用户
  ///getLoginUser
  Future<dynamic> getLoginUser() async {
    return await _methodChannel.invokeMethod('getLoginUser');
  }

  ///未登录情况下加载本地缓存
  ///initStorage
  Future<dynamic> initStorage(String identifier) async {
    return await _methodChannel.invokeMethod(
        'initStorage', <String, dynamic>{'identifier': identifier});
  }

  ///校验好友关系
  ///checkFriends
  Future<dynamic> checkFriends(List<String> users) async {
    return await _methodChannel
        .invokeMethod('checkFriends', <String, dynamic>{'users': users});
  }

  ///获取群内自己群名片
  ///getSelfGroupNameCard
  Future<dynamic> getSelfGroupNameCard(String groupId) async {
    return await _methodChannel.invokeMethod(
        'getSelfGroupNameCard', <String, dynamic>{'groupId': groupId});
  }

  ///修改群名片
  ///modifyMemberInfo
  Future<dynamic> setGroupNameCard(
      String groupId, String identifier, String name) async {
    return await _methodChannel
        .invokeMethod('setGroupNameCard', <String, dynamic>{
      'groupId': groupId,
      'identifier': identifier,
      'name': name,
    });
  }

  ///获取群内指定会员信息
  ///getGroupMembersInfo
  Future<dynamic> getGroupMembersInfo(
      String groupId, List<String> userIDs) async {
    return await _methodChannel.invokeMethod('getGroupMembersInfo',
        <String, dynamic>{'groupId': groupId, 'userIDs': userIDs});
  }

  ///获取网络群资料列表
  ///getGroupInfoList
  Future<dynamic> getGroupInfoList(List<String> groupID) async {
    return await _methodChannel.invokeMethod(
        'getGroupInfoList', <String, dynamic>{'groupID': groupID});
  }

  ///获取群列表
  ///getGroupList
  Future<dynamic> getGroupList() async {
    return await _methodChannel.invokeMethod('getGroupList');
  }

  ///发起群聊
  ///createGroupChat commit up
  Future<dynamic> createGroupChat(
      {String name, List<String> personList}) async {
    return await _methodChannel.invokeMethod(
        "createGroupChat", <String, dynamic>{
      'name': name ?? personList[0] + 'name',
      'personList': personList
    });
  }

  ///修改好友备注
  ///Edit friend notes
  Future<dynamic> editFriendNotes(String identifier, String remarks) async {
    return await _methodChannel.invokeMethod('editFriendNotes',
        <String, dynamic>{'identifier': identifier, 'remarks': remarks});
  }

  ///获取好友备注
  ///getRemark
  Future<dynamic> getRemark(String identifier) async {
    return await _methodChannel
        .invokeMethod('getRemark', <String, dynamic>{'identifier': identifier});
  }

  ///获取群成员列表
  ///getGroupMembersList
  Future<dynamic> getGroupMembersList(String groupId) async {
    return await _methodChannel.invokeMethod(
        'getGroupMembersList', <String, dynamic>{'groupId': groupId});
  }

  ///邀请群成员进群
  ///inviteGroupMember
  Future<dynamic> inviteGroupMember(List list, String groupId) async {
    return await _methodChannel.invokeMethod('inviteGroupMember',
        <String, dynamic>{'list': list, 'groupId': groupId});
  }

  ///退出群聊
  ///quitGroup
  Future<dynamic> quitGroup(String groupId) async {
    return await _methodChannel
        .invokeMethod('quitGroup', <String, dynamic>{'groupId': groupId});
  }

  ///删除群成员
  ///deleteGroupMember
  Future<dynamic> deleteGroupMember(String groupId, List deleteList) async {
    return await _methodChannel.invokeMethod('deleteGroupMember',
        <String, dynamic>{'groupId': groupId, 'deleteList': deleteList});
  }

  dynamic _parseBatteryState(event) {
    return event;
  }
}
