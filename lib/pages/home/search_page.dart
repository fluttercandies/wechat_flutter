import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchC = new TextEditingController();

  List words = ['朋友圈', '文章', '公众号', '小程序', '音乐', '表情'];

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
        )
      ],
    );
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
