import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/im/group/fun_dim_info.dart';
import 'package:wechat_flutter/pages/group/group_billboard_page.dart';
import 'package:wechat_flutter/pages/group/group_member_details.dart';
import 'package:wechat_flutter/pages/group/group_members_page.dart';
import 'package:wechat_flutter/pages/group/group_remarks_page.dart';
import 'package:wechat_flutter/pages/group/select_members_page.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';
import 'package:wechat_flutter/pages/mine/code_page.dart';
import 'package:wechat_flutter/pages/settings/chat_background_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/confirm_alert.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';

import '../../im/info_handle.dart';

class GroupDetailsPage extends StatefulWidget {
  final String peer;
  final Callback? callBack;

  const GroupDetailsPage(this.peer, {Key? key, this.callBack})
      : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  bool _top = false;
  bool _showName = false;
  bool _contact = false;
  bool _dnd = false;

  String? groupName;
  String? groupNotification;
  String? time;
  String cardName = '默认';

  bool isGroupOwner = false;

  List<V2TimGroupMemberFullInfo?> memberList = <V2TimGroupMemberFullInfo?>[
    V2TimGroupMemberFullInfo(userID: '+'),
  ];
  V2TimGroupInfo? dataGroup;

  @override
  void initState() {
    super.initState();
    _getGroupMembers();
    _getGroupInfo();
    getCardName();
  }

  getCardName() async {
    await InfoModel.getSelfGroupNameCardModel(widget.peer, callback: (str) {
      cardName = str.toString();
      setState(() {});
    });
  }

  _getGroupInfo() async {
    final List<V2TimGroupInfoResult> listInfo =
        await DimGroup.getGroupInfoListModel(<String>[widget.peer]);

    dataGroup = listInfo.first.groupInfo!;
    final String? user = await SharedUtil.instance.getString(Keys.account);
    isGroupOwner = dataGroup!.owner == user;
    groupName = dataGroup!.groupName.toString();
    final String notice = strNoEmpty(dataGroup!.notification.toString())
        ? dataGroup!.notification.toString()
        : '暂无公告';
    groupNotification = notice;
    time = dataGroup!.introduction.toString();
    setState(() {});
  }

  _getGroupMembers() async {
    final List<V2TimGroupMemberFullInfo?>? memberDataList =
        await DimGroup.getGroupMembersListModelLIST(widget.peer);

    memberList.insertAll(0, memberDataList!.toSet());
    setState(() {});
  }

  Widget memberItem(V2TimGroupMemberFullInfo? item) {
    if (item?.userID == null) {
      return Container();
    }
    if (item!.userID == '+' || item.userID == '-') {
      return InkWell(
        child: SizedBox(
          width: (Get.width - 60) / 5,
          child: Image.asset(
            'assets/images/group/${item.userID}.png',
            height: 48.0,
            width: 48.0,
          ),
        ),
        onTap: () => Get.to<void>(() => SelectMembersPage()),
      );
    }
    return FutureBuilder<List<V2TimUserFullInfo>>(
      future: getUsersProfile(<String>[item.userID]),
      builder:
          (BuildContext context, AsyncSnapshot<List<V2TimUserFullInfo>> snap) {
        final List<V2TimUserFullInfo> data = snap.data ?? <V2TimUserFullInfo>[];
        if (data.isEmpty) {
          return Container();
        }
        final V2TimUserFullInfo item = data.first;
        return SizedBox(
          width: (Get.width - 60) / 5,
          child: TextButton(
            onPressed: () => Get.to<void>(() =>
                GroupMemberDetails(Data.user() == item.userID, item.userID!)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: !strNoEmpty(item.faceUrl)
                      ? Image.asset(
                          defIcon,
                          height: 48.0,
                          width: 48.0,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: item.faceUrl!,
                          height: 48.0,
                          width: 48.0,
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 2),
                Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 50,
                  child: Text(
                    '${!strNoEmpty(item.nickName) ? item.userID : item.nickName!.length > 4 ? '${item.nickName!.substring(0, 3)}...' : item.nickName!}',
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _setDND(int type) {
    DimGroup.setReceiveMessageOptionModel(widget.peer, Data.user(), type,
        callback: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (dataGroup == null) {
      return Container(color: Colors.white);
    }

    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),
      appBar: ComMomBar(title: '聊天信息 (${dataGroup!.memberCount})'),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              width: Get.width,
              child: Wrap(
                runSpacing: 20.0,
                spacing: 10,
                children: memberList.map(memberItem).toList(),
              ),
            ),
            Visibility(
              visible: memberList.length > 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  '查看全部群成员',
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                onPressed: () =>
                    Get.to<void>(() => GroupMembersPage(widget.peer)),
              ),
            ),
            const SizedBox(height: 10.0),
            functionBtn(
              '群聊名称',
              detail: groupName.toString().length > 7
                  ? '${groupName.toString().substring(0, 6)}...'
                  : groupName.toString(),
            ),
            functionBtn(
              '群二维码',
              right:
                  Image.asset('assets/images/group/group_code.png', width: 20),
            ),
            functionBtn(
              '群公告',
              detail: groupNotification.toString(),
            ),
            Visibility(
              visible: isGroupOwner,
              child: functionBtn('群管理'),
            ),
            functionBtn('备注'),
            const SizedBox(height: 10.0),
            functionBtn('查找聊天记录'),
            const SizedBox(height: 10.0),
            functionBtn('消息免打扰',
                right: CupertinoSwitch(
                  value: _dnd,
                  onChanged: (bool value) {
                    _dnd = value;
                    setState(() {});
                    value ? _setDND(1) : _setDND(2);
                  },
                )),
            functionBtn('聊天置顶',
                right: CupertinoSwitch(
                  value: _top,
                  onChanged: (bool value) {
                    _top = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
            functionBtn('保存到通讯录',
                right: CupertinoSwitch(
                  value: _contact,
                  onChanged: (bool value) {
                    _contact = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
            const SizedBox(height: 10.0),
            functionBtn('我在群里的昵称', detail: cardName),
            functionBtn('显示群成员昵称',
                right: CupertinoSwitch(
                  value: _showName,
                  onChanged: (bool value) {
                    _showName = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
            Space(),
            functionBtn('设置当前聊天背景'),
            functionBtn('投诉'),
            Space(),
            functionBtn('清空聊天记录'),
            Space(),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                if (widget.peer == '') return;
                confirmAlert(context, (bool isOK) {
                  if (isOK) {
                    DimGroup.quitGroupModel(widget.peer, callback: (str) {
                      if (str.toString().contains('失败')) {
                        print('失败了，开始执行解散');
                        DimGroup.deleteGroupModel(widget.peer,
                            callback: (data) {
                          if (str.toString().contains('成功')) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            print('解散群聊成功');
                            showToast('解散群聊成功');
                          }
                        });
                      } else if (str.toString().contains('succ')) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                        print('退出成功');
                        showToast('退出成功');
                      }
                    });
                  }
                }, tips: '确定要退出本群吗？');
              },
              child: const Text(
                '删除并退出',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  handle(String title) {
    switch (title) {
      case '备注':
        Get.to<void>(() => GroupRemarksPage(groupId: widget.peer));
        break;
      case '群聊名称':
        Get.to<String>(
          () => GroupRemarksPage(
            groupInfoType: GroupInfoType.name,
            text: groupName ?? '',
            groupId: widget.peer,
          ),
        )?.then((String? data) {
          groupName = data ?? groupName;
          Notice.send(WeChatActions.groupName(), groupName);
        });
        break;
      case '群二维码':
        Get.to<void>(() => CodePage(true));
        break;
      case '群公告':
        Get.to<String>(
          () => GroupBillBoardPage(
            dataGroup!.owner!,
            groupNotification!,
            groupId: widget.peer,
            time: time,
            callback: (String? timeData) => time = timeData,
          ),
        )?.then((String? data) {
          groupNotification = data ?? groupNotification;
        });
        break;
      case '查找聊天记录':
        Get.to<void>(() => SearchPage());
        break;
      case '消息免打扰':
        _dnd = !_dnd;
        _dnd ? _setDND(1) : _setDND(2);
        break;
      case '聊天置顶':
        _top = !_top;
        setState(() {});
        _top ? _setTop(1) : _setTop(2);
        break;
      case '设置当前聊天背景':
        Get.to<void>(() => ChatBackgroundPage());
        break;
      case '我在群里的昵称':
        Get.to<String>(
          () => GroupRemarksPage(
            groupInfoType: GroupInfoType.cardName,
            text: cardName,
            groupId: widget.peer,
          ),
        )?.then((String? data) {
          cardName = data ?? cardName;
        });
        break;
      case '投诉':
        Get.to<void>(() => WebViewPage(url: helpUrl, title: '投诉'));
        break;
      case '清空聊天记录':
        confirmAlert(
          context,
          (bool isOK) {
            if (isOK) showToast('敬请期待');
          },
          tips: '确定删除群的聊天记录吗？',
          okBtn: '清���',
        );
        break;
    }
  }

  _setTop(int i) {}

  Widget functionBtn(
    String title, {
    String? detail,
    Widget? right,
  }) {
    return GroupItem(
      detail: detail,
      title: title,
      right: right,
      onPressed: () => handle(title),
    );
  }
}

class GroupItem extends StatelessWidget {
  final String? detail;
  final String title;
  final VoidCallback onPressed;
  final Widget? right;

  const GroupItem({
    Key? key,
    this.detail,
    required this.title,
    required this.onPressed,
    this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detail == null || detail == '') {
      return Container();
    }
    double? widthT() {
      if (detail != null) {
        return detail!.length > 35
            ? SizeConfig.blockSizeHorizontal! * 60
            : null;
      } else {
        return null;
      }
    }

    final bool isSwitch = title == '消息免打扰' ||
        title == '聊天置顶' ||
        title == '��存到通讯录' ||
        title == '显示群成员昵称';
    final bool noBorder = title == '备注' ||
        title == '查找聊天记录' ||
        title == '保存到通讯录' ||
        title == '显示群成员昵称' ||
        title == '投诉' ||
        title == '清空聊天记录';

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 15, right: 15.0),
        backgroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(
          top: isSwitch ? 10 : 15.0,
          bottom: isSwitch ? 10 : 15.0,
        ),
        decoration: BoxDecoration(
          border: noBorder
              ? null
              : const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(title),
                ),
                Visibility(
                  visible: title != '群公告',
                  child: SizedBox(
                    width: widthT(),
                    child: Text(
                      detail ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                right ?? Container(),
                const SizedBox(width: 10.0),
                isSwitch
                    ? Container()
                    : Image.asset(
                        'assets/images/group/ic_right.png',
                        width: 15,
                      ),
              ],
            ),
            Visibility(
              visible: title == '群公告',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  detail ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
