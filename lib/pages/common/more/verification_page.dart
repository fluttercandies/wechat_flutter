import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/im/util/im_response_tip_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/orther/verify_input.dart';
import 'package:wechat_flutter/ui/orther/verify_switch.dart';

class VerificationPage extends StatefulWidget {
  final String? nickName;
  final String? id;

  VerificationPage({this.nickName = '', this.id});

  @override
  _VerificationPageState createState() => new _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController infoC = new TextEditingController();
  TextEditingController remarksC = new TextEditingController();

  FocusNode infoF = new FocusNode();
  FocusNode remarksF = new FocusNode();

  /// 发送好友请求
  Future sendRequest() async {
    final V2TimFriendOperationResult? model =
        await ImFriendApi.addFriend(widget.id);

    if (model == null) {
      q1Toast("发送失败");
      return;
    }

    if (model.resultCode == 200 || model.resultCode == 0) {
      Navigator.of(context).pop();
      q1Toast("添加成功");
      return;
    } else if (model.resultCode == 30539) {
      Navigator.of(context).pop();
      q1Toast("等待对方通过好友申请");
      return;
    } else {
      q1Toast(ImResponseTipUtil.getInfoOResultCode(model.resultCode));
    }
  }

  Widget body() {
    var content = [
      new VerifyInput(
        title: '你需要发送验证申请，等对方通过',
        defStr: '你好，我是**',
        controller: infoC,
        focusNode: infoF,
      ),
      new Padding(
        padding: EdgeInsets.symmetric(vertical: mainSpace),
        child: new VerifyInput(
          title: '为朋友设置备注',
          defStr: widget.nickName ?? 'flutterj.com',
          controller: remarksC,
          focusNode: remarksF,
        ),
      ),
      new VerifySwitch(title: '设置朋友圈和视频动态权限'),
    ];

    return new Column(children: content);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(
        title: '验证申请',
        rightDMActions: <Widget>[
          new ComMomButton(
            text: '发送',
            style: TextStyle(color: Colors.white),
            width: 55.0,
            margin: EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10.0),
            radius: 4.0,
            onTap: () {
              sendRequest();
            },
          ),
        ],
      ),
      body: new MainInputBody(
        child: body(),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }
}
