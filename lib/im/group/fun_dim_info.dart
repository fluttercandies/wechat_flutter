import 'package:wechat_flutter/tools/wechat_flutter.dart';

Dim im = Dim();

class InfoModel {
  static getSelfProfileModel({Callback callback}) async {
    try {
      var result = await im.getSelfProfile();
      callback(result);
      return result;
    } on PlatformException {
      print("获取网络保存的自己资料失败");
    }
  }

  static setAddMyWayModel(int type, {Callback callback}) async {
    try {
      var result = await im.setAddMyWay(type);
      callback(result);
    } on PlatformException {
      print("设置添加我的方式失败");
    }
  }

  static checkFriendsModel(List<String> users, {Callback callback}) async {
    try {
      var result = await im.checkFriends(users);
      callback(result);
    } on PlatformException {
      print("校验好友 失败");
    }
  }

  static getSelfGroupNameCardModel(String groupId, {Callback callback}) async {
    try {
      var result = await im.getSelfGroupNameCard(groupId);
      callback(result);
    } on PlatformException {
      print("获取群内自己的名片 失败");
    }
  }

  static setGroupNameCardModel(String groupId, String identifier, String name,
      {Callback callback}) async {
    try {
      var result = await im.setGroupNameCard(groupId, identifier, name);
      callback(result);
    } on PlatformException {
      print("修改群名片 失败");
    }
  }

  static getGroupMembersInfoModel(String groupId, List<String> userIDs,
      {Callback callback}) async {
    try {
      var result = await im.getGroupMembersInfo(groupId, userIDs);
      callback(result);
    } on PlatformException {
      print("获取群内指定会员资料 失败");
    }
  }
}
