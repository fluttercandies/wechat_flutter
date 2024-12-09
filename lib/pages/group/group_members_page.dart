import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/pages/group/select_members_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import '../../im/info_handle.dart';

class GroupMembersPage extends StatefulWidget {
  final String groupId;

  GroupMembersPage(this.groupId);

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  late Future<void> _futureBuilderFuture;
  List<V2TimGroupMemberFullInfo?> memberList = <V2TimGroupMemberFullInfo?>[
    V2TimGroupMemberFullInfo(userID: '+'),
    // {'user': '+'},
//    {'user': '-'}
  ];

  @override
  void initState() {
    _futureBuilderFuture = _gerData();
    super.initState();
  }

  Future<void> handle(String? uId) async {
    if (!strNoEmpty(uId)) {
      Get.to<void>(SelectMembersPage());
//      Get.to<void>(CreateGroupChat(
//        'invite',
//        groupId: widget.groupId,
//        callBack: (data) {
//          if (data.toString().contains('suc')) {
//            setState(() {});
//          }
//          print('邀请好友进群callback >>>> $data');
//        },
//      ));
//    } else {
//      Get.to<void>(ConversationDetailPage(
//        title: uId,
//        type: 1,
//      ));
    } else {
      showToast('敬请期待');
    }
  }

  Widget memberItem(V2TimGroupMemberFullInfo? item) {
    if (item == null) {
      return Container();
    }
    if (item.userID == '+' || item.userID == '-') {
      return InkWell(
        child: SizedBox(
          width: (Get.width - 60) / 5,
          child: Image.asset(
            'assets/images/group/${item.userID}.png',
            height: 48.0,
            width: 48.0,
          ),
        ),
        onTap: () => handle(null),
      );
    }

    return FutureBuilder<List<V2TimUserFullInfo>>(
      future: getUsersProfile(<String>[item.userID]),
      builder:
          (BuildContext context, AsyncSnapshot<List<V2TimUserFullInfo>> snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Container();
        }
        final V2TimUserFullInfo currentUser =
            List<V2TimUserFullInfo>.from(snap.data!).first;
        return SizedBox(
          width: (Get.width - 60) / 5,
          child: TextButton(
            onPressed: () => handle(currentUser.userID),
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
              // highlightColor: Colors.transparent,
            ),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: !strNoEmpty(currentUser.faceUrl)
                      ? Image.asset(
                          defIcon,
                          height: 48.0,
                          width: 48.0,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: currentUser.faceUrl!,
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
                    currentUser.nickName == null || currentUser.nickName == ''
                        ? '默认昵称'
                        : currentUser.nickName!.length > 5
                            ? '${currentUser.nickName!.substring(0, 3)}...'
                            : currentUser.nickName!,
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

  Future<void> _gerData() async {
    final List<V2TimGroupMemberFullInfo?>? result =
        await DimGroup.getGroupMembersListModelLIST(
      widget.groupId,
    );

    setState(() {
      memberList.insertAll(0, result!.toSet());
    });
  }

  Widget titleWidget() {
    return FutureBuilder<void>(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snap) {
        return Text(
          '聊天成员(${memberList.isNotEmpty ? memberList.length - 1 : 0})',
          style: const TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!listNoEmpty(memberList)) {
      return Container();
    }

    return Scaffold(
      appBar: ComMomBar(titleW: titleWidget()),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Wrap(
            runSpacing: 20.0,
            spacing: 10,
            children: memberList.map(memberItem).toList(),
          ),
        ],
      ),
    );
  }
}
