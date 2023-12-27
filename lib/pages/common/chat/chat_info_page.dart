import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/chat_mamber.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';

class ChatInfoPage extends StatefulWidget {
  final String? id;

  ChatInfoPage(this.id);

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  bool isRemind = false;
  bool isTop = false;
  bool isDoNotDisturb = true;

  V2TimUserFullInfo? info;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  /// 获取基本信息
  Future getInfo() async {
    info = (await ImApi.getUsersInfo([widget.id!]))![0];
    setState(() {});
  }

  Widget buildSwitch(item) {
    return new LabelRow(
      label: item['label'],
      margin: item['label'] == '消息免打扰' ? EdgeInsets.only(top: 10.0) : null,
      isLine: item['label'] != '强提醒',
      isRight: false,
      rightW: new SizedBox(
        height: 25.0,
        child: new CupertinoSwitch(
          value: item['value'],
          onChanged: (v) {},
        ),
      ),
      onPressed: () {},
    );
  }

  List<Widget> body() {
    List switchItems = [
      // {"label": '消息免打扰', 'value': isDoNotDisturb},
      // {"label": '置顶聊天', 'value': isTop},
      // {"label": '强提醒', 'value': isRemind},
    ];

    if (info == null) {
      return [];
    }

    return [
      new ChatMamBer(info),
      // new LabelRow(
      //   label: '查找聊天记录',
      //   margin: EdgeInsets.only(top: 10.0),
      //   onPressed: () => Get.to(new SearchPage()),
      // ),
      new Column(
        children: switchItems.map(buildSwitch).toList(),
      ),
      // new LabelRow(
      //   label: '设置当前聊天背景',
      //   margin: EdgeInsets.only(top: 10.0),
      //   onPressed: () => Get.to(new ChatBackgroundPage()),
      // ),
      // new LabelRow(
      //   label: '清空聊天记录',
      //   margin: EdgeInsets.only(top: 10.0),
      //   onPressed: () {
      //     confirmAlert(
      //       context,
      //       (isOK) {
      //         if (isOK) q1Toast( '敬请期待');
      //       },
      //       tips: '确定删除群的聊天记录吗？',
      //       okBtn: '清空',
      //     );
      //   },
      // ),
      // new LabelRow(
      //   label: '投诉',
      //   margin: EdgeInsets.only(top: 10.0),
      //   onPressed: () => Get.to(new WebViewPage(helpUrl, '投诉')),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(title: '聊天信息'),
      body: new SingleChildScrollView(
        child: new Column(children: body()),
      ),
    );
  }
}
