import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_search_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_search_result_item.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/im/im_handle/im_group_api.dart';
import 'package:wechat_flutter/im/im_handle/im_msg_api.dart';
import 'package:wechat_flutter/pages/chat/search_record_result_page.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SearchRecordPage extends StatefulWidget {
  final bool isGroup;
  final String id;

  SearchRecordPage(this.isGroup, this.id);

  @override
  _SearchRecordPageState createState() => _SearchRecordPageState();
}

class _SearchRecordPageState extends State<SearchRecordPage> {
  TextEditingController _searchC = new TextEditingController();

  List words = ['群成员', '日期', '图片及视频', '文件', '链接', '音乐', '交易', '小程序'];

  RxList<V2TimMessage> data = <V2TimMessage>[].obs;

  @override
  void initState() {
    super.initState();
    print("isGroup:${widget.isGroup}，id:${widget.id}");
  }

  /// 开始搜索
  Future search() async {
    final List<V2TimMessage> searResult =
        await ImMsgApi.searchLocaltMessageOfGroup(_searchC.text, widget.id);
    if (searResult == null || searResult.length < 1) {
      showToast(context, "未找到数据");
      return;
    }
    print("搜索结果::${searResult.length}");
    data.value = searResult;
  }

  Widget wordView(item) {
    return new InkWell(
      child: new Container(
        width: winWidth(context) / 3,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: new Text(
          item,
          style: TextStyle(color: tipColor),
        ),
      ),
      onTap: () => showToast(context, '$item功能小编正在开发'),
    );
  }

  Widget body() {
    return Obx(() {
      if (listNoEmpty(data)) {
        return SearchRecordResultPage(data);
      } else {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: new Text(
                '搜索指定内容',
                style: TextStyle(color: mainTextColor),
              ),
            ),
            new Wrap(
              children: words.map(wordView).toList(),
            ),
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchView = new Row(
      children: <Widget>[
        new Expanded(
          child: new TextField(
            controller: _searchC,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '搜索',
            ),
            onSubmitted: (v) {
              search();
            },
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        strNoEmpty(_searchC.text)
            ? new InkWell(
                child: new Image.asset('assets/images/ic_delete.webp'),
                onTap: () {
                  _searchC.text = '';
                  setState(() {});
                },
              )
            : new Container()
      ],
    );
    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(titleW: searchView),
      body: new SizedBox(width: winWidth(context), child: body()),
    );
  }
}
