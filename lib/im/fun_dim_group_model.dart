import 'dart:convert';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

Dim dim = new Dim();

class DimGroup {
  static Future<dynamic> inviteGroupMember(List list, String groupId,
      {Callback callback}) async {
    try {
      var result = await dim.inviteGroupMember(list, groupId);
      callback(result);
    } on PlatformException {
      print('邀请好友进群  失败');
    }
  }

  static Future<dynamic> quitGroupModel(String groupId,
      {Callback callback}) async {
    try {
      var result = await dim.quitGroup(groupId);
      callback(result);
    } on PlatformException {
      print('退出群聊  失败');
      callback('退出群聊  失败');
    }
  }

  static Future<dynamic> deleteGroupMemberModel(String groupId, List deleteList,
      {Callback callback}) async {
    try {
      var result = await dim.deleteGroupMember(groupId, deleteList);
      callback(result);
    } on PlatformException {
      print('删除群成员  失败');
    }
  }

  static Future<dynamic> getGroupMembersListModel(String groupId,
      {Callback callback}) async {
    try {
      var result = await dim.getGroupMembersList(groupId);
      callback(result);
    } on PlatformException {
      print('获取群成员  失败');
    }
  }

  static Future<dynamic> getGroupMembersListModelLIST(String groupId,
      {Callback callback}) async {
    try {
      var result = await dim.getGroupMembersList(groupId);
      List memberList = json.decode(result.toString().replaceAll("'", '"'));
      if (listNoEmpty(memberList)) {
        for (int i = 0; i < memberList.length; i++) {
          List<String> ls = new List();

          ls.add(memberList[i]['user']);
        }
      }
      callback(result);
    } on PlatformException {
      print('获取群成员  失败');
    }
  }

  static Future<dynamic> getGroupListModel(Callback callback) async {
    try {
      var result = await dim.getGroupList();
      callback(result);
    } on PlatformException {
      print('获取群列表  失败');
    }
  }

  static Future<dynamic> getGroupInfoListModel(List<String> groupID,
      {Callback callback}) async {
    try {
      var result = await dim.getGroupInfoList(groupID);
      callback(result);
      return result;
    } on PlatformException {
      print('获取群资料  失败');
    }
  }

  static Future<dynamic> deleteGroupModel(String groupId,
      {Callback callback}) async {
    try {
      var result = await dim.deleteGroup(groupId);
      callback(result);
    } on PlatformException {
      print('解散群  失败');
    }
  }

  static Future<dynamic> modifyGroupNameModel(
      String groupId, String setGroupName,
      {Callback callback}) async {
    try {
      var result = await dim.modifyGroupName(groupId, setGroupName);
      callback(result);
    } on PlatformException {
      print('修改群名称  失败');
    }
  }

  static Future<dynamic> modifyGroupIntroductionModel(
      String groupId, String setIntroduction,
      {Callback callback}) async {
    try {
      var result = await dim.modifyGroupIntroduction(groupId, setIntroduction);
      callback(result);
    } on PlatformException {
      print('修改群简介  失败');
    }
  }

  static Future<dynamic> modifyGroupNotificationModel(
      String groupId, String notification, String time,
      {Callback callback}) async {
    try {
      var result =
          await dim.modifyGroupNotification(groupId, notification, time);
      if (callback != null) callback(result);
    } on PlatformException {
      print('修改群公告  失败');
    }
  }

  static Future<dynamic> setReceiveMessageOptionModel(
      String groupId, String identifier, int type,
      {Callback callback}) async {
    try {
      var result = await dim.setReceiveMessageOption(groupId, identifier, type);
      callback(result);
    } on PlatformException {
      print('修改群消息提醒选项  失败');
    }
  }
}
