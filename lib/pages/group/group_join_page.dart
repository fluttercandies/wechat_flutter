import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:wechat_flutter/im/im_handle/im_group_api.dart';
import 'package:wechat_flutter/im/util/im_response_tip_util.dart';
import 'package:wechat_flutter/pages/chat/chat_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui_commom/bt/small_button.dart';
import 'package:wechat_flutter/ui_commom/image/sw_image.dart';

class GroupJoinPage extends StatefulWidget {
  final String groupId;

  const GroupJoinPage({@required this.groupId, Key key}) : super(key: key);

  @override
  State<GroupJoinPage> createState() => _GroupJoinPageState();
}

class _GroupJoinPageState extends State<GroupJoinPage> {
  TextStyle tipStyle =
      TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14);

  /// 加入群聊
  Future join() async {
    final V2TimCallback result = await ImGroupApi.joinGroup(widget.groupId);
    if (result.code == 200 || result.code == 0) {
      Get.off(ChatPage(id: widget.groupId, type: 2));
    } else {
      showToast(context, ImResponseTipUtil.getInfoOResultCode(result.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ComMomBar(
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Space(height: 60),
          SwImage(
            defGroupAvatar,
            width: 80,
            height: 80,
          ),
          Space(height: 20),
          Center(
            child: Text(
              '扩列xxx(110)',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Space(height: 60),
          HorizontalLine(),
          Space(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('•你需要实名验证后才能扫码进群，可绑定银行卡进行验证。', style: tipStyle),
          ),
          Space(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('•为维护微信平台绿色网络环境，请勿在群内传播违法违规内容。', style: tipStyle),
          ),
          Space(height: 190),
          SmallButton(
            onPressed: () => join(),
            margin: EdgeInsets.symmetric(horizontal: 80),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Text('加入群聊'),
          )
        ],
      ),
    );
  }
}
