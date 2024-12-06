import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

// Dim dim = new Dim();

class DimGroup {
  static Future<dynamic> inviteGroupMember(List list, String groupId,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.inviteGroupMember(list, groupId);
    //   callback(result);
    // } on PlatformException {
    //   print('邀请好友进群  失败');
    // }
  }

  static Future<dynamic> quitGroupModel(String groupId,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.quitGroup(groupId);
    //   callback(result);
    // } on PlatformException {
    //   print('退出群聊  失败');
    //   callback('退出群聊  失败');
    // }
  }

  static Future<dynamic> deleteGroupMemberModel(String groupId, List deleteList,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.deleteGroupMember(groupId, deleteList);
    //   callback(result);
    // } on PlatformException {
    //   print('删除群成员  失败');
    // }
  }

  static Future<dynamic> getGroupMembersListModel(String groupId,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.getGroupMembersList(groupId);
    //   callback(result);
    // } on PlatformException {
    //   print('获取群成员  失败');
    // }
  }

  static Future<dynamic> getGroupMembersListModelLIST(String groupId,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.getGroupMembersList(groupId);
    //   List memberList = json.decode(result.toString().replaceAll("'", '"'));
    //   if (listNoEmpty(memberList)) {
    //     for (int i = 0; i < memberList.length; i++) {
    //       List<String> ls = [];
    //
    //       ls.add(memberList[i]['user']);
    //     }
    //   }
    //   callback(result);
    // } on PlatformException {
    //   print('获取群成员  失败');
    // }
  }

  static Future<List<V2TimGroupInfo>> getGroupListModel() async {
    final V2TimValueCallback<List<V2TimGroupInfo>> callback =
        await V2TIMManager().getGroupManager().getJoinedGroupList();
    if (callback.code != 0) {
      showToast('获取群列表失败 code=${callback.code} desc=${callback.desc}');
    }
    return callback.data ?? [];
  }

  static Future<dynamic> getGroupInfoListModel(List<String> groupID,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.getGroupInfoList(groupID);
    //   callback(result);
    //   return result;
    // } on PlatformException {
    //   print('获取群资料  失败');
    // }
  }

  static Future<dynamic> deleteGroupModel(String groupId,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.deleteGroup(groupId);
    //   callback(result);
    // } on PlatformException {
    //   print('解散群  失败');
    // }
  }

  static Future<dynamic> modifyGroupNameModel(
      String groupId, String setGroupName,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.modifyGroupName(groupId, setGroupName);
    //   callback(result);
    // } on PlatformException {
    //   print('修改群名称  失败');
    // }
  }

  static Future<dynamic> modifyGroupIntroductionModel(
      String groupId, String setIntroduction,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.modifyGroupIntroduction(groupId, setIntroduction);
    //   callback(result);
    // } on PlatformException {
    //   print('修改群简介  失败');
    // }
  }

  static Future<dynamic> modifyGroupNotificationModel(
      String groupId, String notification, String time,
      {Callback? callback}) async {
    // try {
    //   var result =
    //       await dim.modifyGroupNotification(groupId, notification, time);
    //   if (callback != null) callback(result);
    // } on PlatformException {
    //   print('修改群公告  失败');
    // }
  }

  static Future<dynamic> setReceiveMessageOptionModel(
      String groupId, String identifier, int type,
      {required Callback callback}) async {
    // try {
    //   var result = await dim.setReceiveMessageOption(groupId, identifier, type);
    //   callback(result);
    // } on PlatformException {
    //   print('修改群消息提醒选项  失败');
    // }
  }
}
