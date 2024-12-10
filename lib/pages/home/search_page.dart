import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchC = TextEditingController();

  List<String> words = ['朋友圈', '文章', '公众号', '小程序', '音乐', '表情'];

  Widget wordView(String item) {
    return InkWell(
      child: Container(
        width: Get.width / 3,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          item,
          style: TextStyle(color: tipColor),
        ),
      ),
      onTap: () => showToast('$item功能小编正在开发'),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '搜索指定内容',
            style: TextStyle(color: mainTextColor),
          ),
        ),
        Wrap(
          children: words.map(wordView).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var searchView = Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _searchC,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '搜索',
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        strNoEmpty(_searchC.text)
            ? InkWell(
                child: Image.asset('assets/images/ic_delete.webp'),
                onTap: () {
                  _searchC.text = '';
                  setState(() {});
                },
              )
            : Container()
      ],
    );
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: ComMomBar(titleW: searchView),
      body: SizedBox(width: Get.width, child: body()),
    );
  }
}
