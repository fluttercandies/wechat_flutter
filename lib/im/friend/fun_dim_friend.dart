import 'package:wechat_flutter/tools/wechat_flutter.dart';

Dim dim = new Dim();

class DimFriend {
  static Future<dynamic> getFriends(String userName, Callback callback) async {
    try {
      var result = await dim.listFriends(userName);
      callback(result);
    } on PlatformException {
      print('获取好友  失败');
    }
  }

  static Future<dynamic> addFriend(String userName, Callback callback) async {
    try {
      var result = await dim.addFriend(userName);
      callback(result);
    } on PlatformException {
      print('添加好友  失败');
    }
  }

  static Future<dynamic> setUsersProfile(
      String userName, Callback callback) async {
    try {
      var result = await dim.setUsersProfile(0, '133',
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1566381537639&di=7fa7af026fada06b215fc4be94d8ca1b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F31%2F20181031092120_G5eBk.thumb.700_0.jpeg');
      callback(result);
    } on PlatformException {
      print('设置用户信息  失败');
    }
  }

  static Future<dynamic> getUsersProfile(String userName, Callback callback,
      {List<String> userS}) async {
    try {
      List<String> ls = new List();
      ls.add(userName);
      var result = await dim.getUsersProfile(listNoEmpty(userS) ? userS : ls);
      callback(result);
    } on PlatformException {
      print('获取用户信息  失败');
    }
  }

  static Future<dynamic> delFriend(String userName, Callback callback) async {
    try {
      var result = await dim.delFriend(userName);
      callback(result);
    } on PlatformException {
      print('删除用户  失败');
    }
  }

  static Future<dynamic> createGroupChat(List<String> personList,
      {String name, Callback callback}) async {
    try {
      var result =
          await dim.createGroupChat(name: name, personList: personList);
      callback(result);
    } on PlatformException {
      print('创建群组  失败');
    }
  }

  static Future<dynamic> editFriendNotesModel(String id, String remarks,
      {Callback callback}) async {
    try {
      var result = await dim.editFriendNotes(id, remarks);
      callback(result);
    } on PlatformException {
      print('修改备注失败');
    }
  }

  static Future<dynamic> getRemarkModel(String id, {Callback callback}) async {
    try {
      var result = await dim.getRemark(id);
      callback(result);
      return result;
    } on PlatformException {
      print('获取备注失败');
      return '';
    }
  }
//
//  static Future<dynamic> deleteFriendModel(String id,
//      {Callback callback}) async {
//    try {
//      var result = await dim.deleteFriend(id);
//      callback(result);
//    } on PlatformException {
//      print('删除好友失败');
//    }
//  }

//  static Future<dynamic> addBlack(String mId, {Callback callback}) async {
//    try {
//      var result = await dim.addBlack(mId);
//      callback(result ?? '');
//    } on PlatformException {
//      print('好友移动至黑名单失败');
//    }
//  }
//
//  static Future<dynamic> deleteBlackListModel(String mId,
//      {Callback callback}) async {
//    try {
//      var result = await dim.deleteBlackList(mId);
//      callback(result);
//    } on PlatformException {
//      print('好友移出黑名单失败');
//    }
//  }
//
//  static Future<dynamic> getBlackList(Callback callback) async {
//    try {
//      var result = await dim.getBlackList();
//      callback(result);
//    } on PlatformException {
//      print('获取黑名单列表失败');
//    }
//  }

  // 处理好友请求
  static Future<dynamic> opFriend(
      String identifier, String opTypeStr, Callback callback) async {
    try {
      var result = await dim.opFriend(identifier, opTypeStr);
      callback(result);
    } on PlatformException {
      print('同意好友请求  失败');
    }
  }
}
