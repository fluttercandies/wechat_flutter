import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

EventBus liveLogRefreshBus = EventBus();

class LiveLogRefreshModel {}


/// 【2021 12.30】
/// 直播流质量日志打印到ui，方便测试音画不同步
class LiveLogPageData {
  static StringBuffer strBuf = StringBuffer();
  static void writeData(String str) {
    strBuf.write(str);
  }
}


class LiveLogPage extends StatefulWidget {
  @override
  _LiveLogPageState createState() => _LiveLogPageState();
}

class _LiveLogPageState extends State<LiveLogPage> {
  StreamSubscription? _liveLogRefreshBus;

  ScrollController controller = ScrollController(initialScrollOffset: 300);

  //搜索的字符
  final String _searchStr = '/v1/live/exit';

  //正常文本
  final TextStyle _normalStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
  );

  //高亮文本
  final TextStyle _highlightStyle = TextStyle(
    fontSize: 12,
    color: Colors.blue,
  );

  String get strValue {
    return LiveLogPageData.strBuf.toString();
  }

  @override
  void initState() {
    super.initState();
    _liveLogRefreshBus =
        liveLogRefreshBus.on<LiveLogRefreshModel>().listen((event) {
      if (mounted) setState(() {});
    });
  }

  ///返回设置好的富文本
  Widget _splitEnglish() {
    final List<TextSpan> spans = [];
    //split 截出来
    final List<String> strList = strValue.split(_searchStr);
    for (int i = 0; i < strList.length; i++) {
      //拿出字符串
      final String str = strList[i];
      //为空字符串的都是高亮
      if (str == '' && i < strList.length - 1) {
        spans.add(TextSpan(text: _searchStr, style: _highlightStyle));
      } else {
        //其他
        spans.add(TextSpan(text: str, style: _normalStyle));
        //最后一个字符
        if (i < str.length - 1) {
          spans.add(TextSpan(text: _searchStr, style: _highlightStyle));
        }
      }
    }
    //返回
    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('日志'),
      ),
      body: CupertinoScrollbar(
        controller: controller,
        child: ListView(
          controller: controller,
          reverse: true,
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 20),
            _splitEnglish(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _liveLogRefreshBus?.cancel();
    _liveLogRefreshBus = null;
  }
}
