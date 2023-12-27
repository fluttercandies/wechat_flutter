import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/im/util/im_response_tip_util.dart';
import 'package:wechat_flutter/tools/eventbus/contacts_bus.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/orther/verify_input.dart';
import 'package:wechat_flutter/ui/orther/verify_switch.dart';
import 'package:wechat_flutter/ui_commom/bt/small_button.dart';

class AgreeFriendPage extends StatefulWidget {
  /// friendModel 不为空表示从【新的朋友页面进入】
  final V2TimFriendApplication? friendModel;

  AgreeFriendPage(this.friendModel);

  @override
  State<AgreeFriendPage> createState() => _AgreeFriendPageState();
}

class _AgreeFriendPageState extends State<AgreeFriendPage> {
  TextEditingController remarksC = new TextEditingController();
  FocusNode remarksF = new FocusNode();

  /*
  * 同意添加好友
  * */
  Future agree() async {
    final V2TimValueCallback<V2TimFriendOperationResult> result =
        await ImFriendApi.acceptFriendApplication(widget.friendModel!.userID);
    if (result.code == 0 || result.code == 200) {
      /// 刷新通讯录
      contactsBus.fire(ContactsModel());

      /// 路由返回
      Get.back();
    } else {
      showToast(ImResponseTipUtil.getInfoOResultCode(result.code, result.desc));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComMomBar(title: "通过好友验证"),
      backgroundColor: appBarColor,
      body: ListView(
        children: [
          new Padding(
            padding: EdgeInsets.symmetric(vertical: mainSpace),
            child: new VerifyInput(
              title: '为朋友设置备注',
              defStr: widget.friendModel?.nickname ?? 'flutterj.com',
              controller: remarksC,
              focusNode: remarksF,
            ),
          ),
          new VerifySwitch(title: '设置朋友圈和视频动态权限'),
          Space(height: 60),
          SmallButton(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            margin: EdgeInsets.symmetric(horizontal: 100),
            onPressed: () {
              agree();
            },
            child: Text('完成'),
          )
        ],
      ),
    );
  }
}
