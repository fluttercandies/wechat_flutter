import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_check_result.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/pages/common/chat/more_info_page.dart';
import 'package:wechat_flutter/pages/common/contacts/agree_friend_page.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/friend_item_dialog.dart';
import 'package:wechat_flutter/ui/item/contact_card.dart';
import 'package:wechat_flutter/ui/orther/button_row.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';

class ContactsDetailsPage extends StatefulWidget {
  final String? avatar, title, id;

  /// friendModel 不为空表示从【新的朋友页面进入】
  final V2TimFriendApplication? friendModel;

  ContactsDetailsPage({this.avatar, this.title, this.id, this.friendModel});

  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();
}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {
  RxBool isFriend = true.obs;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    if (widget.friendModel == null) {
      return;
    }

    /// 检测对方是否为好友
    final V2TimFriendCheckResult type =
        (await ImFriendApi.checkFriend([widget.friendModel!.userID]))![0];

    // element.resultType;//与查询用户的关系类型 0:不是好友 1:对方在我的好友列表中 2:我在对方的好友列表中 3:互为好友
    isFriend.value = type.resultType == 1 || type.resultType == 3;
    print("检测是否为好友:L:${isFriend.value}");
  }

  List<Widget> body(bool isSelf) {
    return [
      new ContactCard(
        img: widget.avatar,
        id: widget.id ?? widget.title!,
        title: widget.title,
        nickName: widget.title,
        area: '北京 海淀',
        isBorder: true,
      ),
      // new Visibility(
      //   visible: !isSelf,
      //   child: new LabelRow(
      //     label: '设置备注和标签',
      //     onPressed: () => Get.to(new SetRemarkPage()),
      //   ),
      // ),
      new Space(),
      // new LabelRow(
      //   label: '朋友圈',
      //   isLine: true,
      //   lineWidth: 0.3,
      //   onPressed: () => Get.to(new WeChatFriendsCircle()),
      // ),
      new LabelRow(
        label: '更多信息',
        onPressed: () => Get.to(new MoreInfoPage()),
      ),
      Obx(() {
        if (isFriend.value) {
          return new ButtonRow(
            margin: EdgeInsets.only(top: 10.0),
            text: '发消息',
            isBorder: true,
            onPressed: () {
              Get.offNamed(RouteConfig.chatPage, arguments: {
                "title": widget.title,
                "type": 1,
                "id": widget.id,
              });
            },
          );
        } else {
          return new ButtonRow(
            margin: EdgeInsets.only(top: 10.0),
            text: '前往验证',
            isBorder: false,
            onPressed: () async {
              await Get.to(new AgreeFriendPage(widget.friendModel));
              getData();
            },
          );
        }
      }),
      // Obx(() {
      //   if (isFriend.value) {
      //     return new Visibility(
      //       visible: !isSelf,
      //       child: new ButtonRow(
      //         text: '音视频通话',
      //         onPressed: () => q1Toast( '敬请期待'),
      //       ),
      //     );
      //   } else {
      //     return Container();
      //   }
      // }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    bool isSelf = globalModel.account == widget.id;

    var rWidget = [
      new SizedBox(
        width: 60,
        child: new TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          ),
          onPressed: () => friendItemDialog(context, userId: widget.id),
          child: new Image.asset(contactAssets + 'ic_contacts_details.png'),
        ),
      )
    ];

    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
          title: '',
          backgroundColor: Colors.white,
          rightDMActions: isSelf ? [] : rWidget),
      body: new SingleChildScrollView(
        child: new Column(children: body(isSelf)),
      ),
    );
  }
}
