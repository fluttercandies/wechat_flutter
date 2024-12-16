import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';
import 'package:wechat_flutter/pages/settings/chat_background_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/confirm_alert.dart';
import 'package:wechat_flutter/ui/item/chat_mamber.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';

class ChatInfoPage extends StatefulWidget {
  final String id;

  ChatInfoPage(this.id);

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  V2TimUserFullInfo? model;

  bool isRemind = false;
  bool isTop = false;
  bool isDoNotDisturb = true;

  Widget buildSwitch(item) {
    return new LabelRow(
      label: item['label'] as String,
      margin: item['label'] == '消息免打扰' ? EdgeInsets.only(top: 10.0) : null,
      isLine: item['label'] != '强提醒',
      isRight: false,
      rightW: new SizedBox(
        height: 25.0,
        child: new CupertinoSwitch(
          value: item['value'] as bool,
          onChanged: (v) {},
        ),
      ),
      onPressed: () {},
    );
  }

  List<Widget> body() {
    List switchItems = [
      {"label": '消息免打扰', 'value': isDoNotDisturb},
      {"label": '置顶聊天', 'value': isTop},
      {"label": '强提醒', 'value': isRemind},
    ];

    return [
      new ChatMamBer(model: model),
      new LabelRow(
        label: '查找聊天记录',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => Get.to<void>(new SearchPage()),
      ),
      new Column(
        children: switchItems.map(buildSwitch).toList(),
      ),
      new LabelRow(
        label: '设置当前聊天背景',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => Get.to<void>(new ChatBackgroundPage()),
      ),
      new LabelRow(
        label: '清空聊天记录',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () {
          confirmAlert(
            context,
            (isOK) {
              if (isOK) showToast('敬请期待');
            },
            tips: '确定删除群的聊天记录吗？',
            okBtn: '清空',
          );
        },
      ),
      new LabelRow(
        label: '投诉',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () =>
            Get.to<void>(new WebViewPage(url: helpUrl, title: '投诉')),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    final List<V2TimUserFullInfo> infoList = await getUsersProfile([widget.id]);
    if (infoList.isEmpty) {
      showToast('获取用户信息错误');
      return;
    }
    setState(() {
      model = infoList[0];
    });
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
