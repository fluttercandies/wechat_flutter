import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/pages/chat/chat_page.dart';
import 'package:wechat_flutter/pages/contacts/group_launch_page.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<V2TimGroupInfo> _groupList = [];

  @override
  void initState() {
    super.initState();
    _getGroupListModel();
    Notice.addListener(WeChatActions.groupName(), (v) {
      _getGroupListModel();
    });
  }

  // 获取群聊列表
  Future<void> _getGroupListModel() async {
    final List<V2TimGroupInfo> list = await DimGroup.getGroupListModel();
    setState(() => _groupList = list);
  }

  Widget groupItem(BuildContext context, String gName, String gId,
      String gFaceURL, String title) {
    return TextButton(
      onPressed: () {
        Get.to<void>(ChatPage(
          title: gName,
          type: ConversationType.V2TIM_GROUP,
          id: gId,
//                returnType: 1,
        ));
      },
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  width: 50.0,
                  height: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      imageUrl: gFaceURL,
                      cacheManager: cacheManager,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(gName),
                  // 群聊Id
//                        Text(
//                          gId,
//                          style: TextStyle(color: Colors.grey),
//                        ),
                ],
              ),
            ],
          ),
          Container(
            height: 1.0,
            width: Get.width,
            color: mainBGColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new InkWell(
        child: new Container(
          width: 60.0,
          child: new Image.asset('assets/images/search_black.webp'),
        ),
        onTap: () => Get.to<void>(new SearchPage()),
      ),
      new InkWell(
        child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: new Image.asset('assets/images/contact/ic_contact_add.webp',
              color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
        ),
        onTap: () => Get.to<void>(new GroupLaunchPage()),
      ),
    ];

    return new Scaffold(
      appBar: new ComMomBar(title: '群聊', rightDMActions: rWidget),
      body: listNoEmpty(_groupList)
          ? ListView.builder(
              itemCount: _groupList.length,
              itemBuilder: (context, index) {
                final item = _groupList[index];
                return Column(
                  children: <Widget>[
                    if (_groupList.isNotEmpty)
                      groupItem(
                        context,
                        item.groupName ?? '',
                        item.groupID ?? '',
                        !strNoEmpty(item.faceUrl)
                            ? defGroupAvatar
                            : item.faceUrl!,
                        item.groupID ?? '',
                      )
                    else
                      SizedBox(height: 1),
                  ],
                );
              },
            )
          : const Center(
              child: Text(
                '暂无群聊',
                style: TextStyle(color: mainTextColor),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Notice.removeListenerByEvent(WeChatActions.groupName());
  }
}
