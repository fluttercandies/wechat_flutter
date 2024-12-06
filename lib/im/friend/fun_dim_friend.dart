import 'package:wechat_flutter/tools/wechat_flutter.dart';

// Dim dim = new Dim();

class DimFriend {
  static Future<dynamic> editFriendNotesModel(String id, String remarks,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.editFriendNotes(id, remarks);
    //   callback(result);
    // } on PlatformException {
    //   print('修改备注失败');
    // }
  }

  static Future<dynamic> getRemarkModel(String id,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.getRemark(id);
    //   callback(result);
    //   return result;
    // } on PlatformException {
    //   print('获取备注失败');
    //   return '';
    // }
  }

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
    // try {
    //   var result = await dim.opFriend(identifier, opTypeStr);
    //   callback(result);
    // } on PlatformException {
    //   print('同意好友请求  失败');
    // }
  }
}
