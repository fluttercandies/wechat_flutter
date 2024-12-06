import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_type.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

typedef OnSuCc = void Function(bool v);

Future<dynamic> addFriend(String userName, BuildContext context,
    {OnSuCc? suCc}) async {
  try {
    final V2TimValueCallback<V2TimFriendOperationResult> result =
        await V2TIMManager().getFriendshipManager().addFriend(
            userID: userName, addType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    if (result.data?.resultCode == 0) {
      showToast('添加成功');
      return;
    }
    if (result.toString().contains('Friend_Exist')) {
      showToast('朋友已存在');
    } else if (result.toString().contains('30014')) {
      showToast('对方好友人数上限');
      return;
    } else if (result.toString().contains('30003')) {
      showToast('添加的这个账号不存在');
      return;
    } else {
      showToast('添加成功');
    }
    if (suCc == null) {
      popToHomePage(context);
    } else {
      suCc(true);
    }
  } on PlatformException {
    debugPrint('Dim添加好友  失败');
  }
}

Future<dynamic> delFriend(String userName, BuildContext context,
    {OnSuCc? suCc}) async {
  try {
    final V2TimValueCallback<List<V2TimFriendOperationResult>> result =
        await V2TIMManager().getFriendshipManager().deleteFromFriendList(
            userIDList: <String>[userName],
            deleteType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    if (result.code == 0) {
      showToast('删除成功');
    } else {
      showToast(result.desc);
    }

    if (suCc == null) {
      popToHomePage(context);
    } else {
      suCc(true);
    }

    return result;
  } on PlatformException {
    debugPrint('删除好友  失败');
  }
}

Future<List<V2TimFriendInfo>> getContactsFriends(String userName) async {
  final V2TimValueCallback<List<V2TimFriendInfo>> result =
      await V2TIMManager().getFriendshipManager().getFriendList();
  return result.data ?? <V2TimFriendInfo>[];
}

Future<bool> createGroupChat(List<String> personList, {String? name}) async {
  final V2TimValueCallback<String> call =
      await V2TIMManager().getGroupManager().createGroup(
            groupType: GroupType.Public,
            groupName: name ?? '',
            memberList: personList.map(
              (String e) {
                return V2TimGroupMember(
                  userID: e,
                  role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER,
                );
              },
            ).toList(),
          );
  return call.code == 0;
}
