import 'package:tencent_im_sdk_plugin/enum/group_member_filter_enum.dart';
import 'package:tencent_im_sdk_plugin/enum/group_member_role_enum.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_search_param.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_search_param.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

import 'Im_api.dart';

/// IM群组模块Api
class ImGroupApi {
  /*
  * 高级创建群
  * */
  static Future<String> createGroupV2(
    String groupName, {
    String groupID,
    List<V2TimGroupMember> memberList,
    // Work 工作群
    // Public 公开群
    // Meeting 会议群
    // AVChatRoom 直播群
    String groupType = "Public",
  }) async {
    V2TimValueCallback<String> res =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().createGroup(
              groupType: groupType,
              groupName: groupName,
              groupID: groupID,
              memberList: memberList,
            );
    ImApi.imPrint(res.toJson(), "创建群");
    return res.data;
  }

  /*
  * 获取加群列表
  * */
  static Future<List<V2TimGroupInfo>> getJoinedGroupList() async {
    V2TimValueCallback<List<V2TimGroupInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getGroupManager()
        .getJoinedGroupList();
    ImApi.imPrint(res.toJson(), "获取加群列表");
    return res.data;
  }

  /*
  * 获取群组信息
  * */
  static Future<List<V2TimGroupInfoResult>> getGroupsInfo(
      List<String> groupIDList) async {
    V2TimValueCallback<List<V2TimGroupInfoResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupsInfo(groupIDList: groupIDList);
    ImApi.imPrint(res.toJson(), "获取群组信息");
    return res.data;
  }

  /*
  * 设置群信息
  * */
  static Future setGroupInfo(
    String groupID, {
    String groupName,
    String groupType,
    String notification,
    String introduction,
    String faceUrl,
    String isAllMuted,
    String addOpt,
    String customInfo,
  }) async {
    V2TimCallback res =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupInfo(
              info: V2TimGroupInfo.fromJson(
                {
                  "groupID": groupID,
                  "groupName": groupName,
                  "groupType": groupType,
                  "notification": notification,
                  "introduction": introduction,
                  "faceUrl": faceUrl,
                  "isAllMuted": isAllMuted,
                  "addOpt": addOpt,
                  "customInfo": customInfo,
                },
              ),
            );
    ImApi.imPrint(res.toJson(), "设置群信息");
  }

  /*
  * 获取群在线人数
  * */
  static Future getGroupOnlineMemberCount(String groupID) async {
    V2TimValueCallback<int> res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupOnlineMemberCount(
          groupID: groupID,
        );
    ImApi.imPrint(res.toJson(), "获取群在线人数");
  }

  /*
  * 获取群成员列表
  * */
  static Future<V2TimGroupMemberInfoResult> getGroupMemberList(
    String groupID, {
    GroupMemberFilterTypeEnum filter =
        GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
    String nextSeq = "0",
  }) async {
    V2TimValueCallback<V2TimGroupMemberInfoResult> res =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupMemberList(
              groupID: groupID,
              filter: filter,
              nextSeq: nextSeq,
            );
    ImApi.imPrint(res.toJson(), "获取群成员列表");
    return res.data;
  }

  /*
  * 获取指定的群成员资料
  * */
  static Future getGroupMembersInfo(String groupID, memberId) async {
    V2TimValueCallback<List<V2TimGroupMemberFullInfo>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupMembersInfo(
      groupID: groupID,
      memberList: [memberId],
    );
    ImApi.imPrint(res.toJson(), "获取指定的群成员资料");
  }

  /*
  * 设置群成员信息
  * */
  static Future setGroupMemberInfo(String groupID, String userID,
      {String nameCard}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupMemberInfo(
          groupID: groupID,
          userID: userID,
          nameCard: nameCard,
        );
    ImApi.imPrint(res.toJson(), "设置群成员信息");
  }

  /*
  * 禁言群成员
  * */
  static Future muteGroupMember(
      String groupID, String userID, int seconds) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .muteGroupMember(groupID: groupID, userID: userID, seconds: seconds);
    ImApi.imPrint(res.toJson(), "禁言群成员");
  }

  /*
  * 邀请好友进群
  * */
  static Future inviteUserToGroup(String groupID, List<String> userList) async {
    V2TimValueCallback<List<V2TimGroupMemberOperationResult>> res =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .inviteUserToGroup(
              groupID: groupID,
              userList: userList,
            );
    ImApi.imPrint(res.toJson(), "邀请好友进群");
  }

  /*
  * 踢人出群
  * */
  static Future kickGroupMember(String groupID, List<String> userList) async {
    V2TimCallback res =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().kickGroupMember(
              groupID: groupID,
              memberList: userList,
              reason: "t",
            );
    ImApi.imPrint(res.toJson(), "踢人出群");
  }

  /*
  * 设置群角色
  * */
  static Future setGroupMemberRole(
      String groupID, String userID, GroupMemberRoleTypeEnum role) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupMemberRole(
          groupID: groupID,
          userID: userID, //注意：选择器没做单选，所以这里选第一个
          role: role,
        );
    ImApi.imPrint(res.toJson(), "设置群角色");
  }

  /*
  * 转移群主
  * */
  static Future transferGroupOwner(String groupID, String userID) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .transferGroupOwner(
          groupID: groupID,
          userID: userID,
        );
    ImApi.imPrint(res.toJson(), "转移群主");
  }

  /*
  * 搜索群列表
  * */
  static Future sendTextMessage(String text) async {
    V2TimGroupSearchParam searchParam = new V2TimGroupSearchParam(
        keywordList: [text], isSearchGroupID: true, isSearchGroupName: true);

    V2TimValueCallback<List<V2TimGroupInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getGroupManager()
        .searchGroups(searchParam: searchParam);
    ImApi.imPrint(res.toJson(), "搜索群列表");
  }

  /*
  * 搜索群成员
  * */
  static Future searchGroupMembers(String groupID, String text) async {
    V2TimGroupMemberSearchParam searchGroupMembers =
        new V2TimGroupMemberSearchParam(
      groupIDList: [groupID],
      keywordList: [text],
    );
    var res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .searchGroupMembers(param: searchGroupMembers);
    ImApi.imPrint(res.toJson(), "搜索群成员");
  }
}
