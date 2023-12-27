import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late List state;

  Widget buildState(context, index) {
    var item = state[index];

    var content = new Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            '${item['name']}',
            style: TextStyle(fontSize: 15.0),
          ),
          new Text(
            '${item['code']}',
            style: TextStyle(fontSize: 15.0, color: Colors.green),
          ),
        ],
      ),
    );

    return new InkWell(
      child: content,
      onTap: () =>
          Navigator.pop(context, item['name'] + '  ' + '(${item['code']})'),
    );
  }

  @override
  Widget build(BuildContext context) {
    state = [
      {'name': "澳大利亚", 'code': '+61'},
      {'name': "澳门", 'code': '+853'},
      {'name': "加拿大", 'code': '+001'},
      {'name': "美国", 'code': '+001'},
      {'name': "台湾", 'code': '+886'},
      {'name': "香港", 'code': '+852'},
      {'name': "新加坡", 'code': '+65'},
      {'name': "中国大陆", 'code': '+86'},
    ];

    return new Scaffold(
      appBar: new ComMomBar(title: "选择国家或地区"),
      body: new ListView.builder(
          itemBuilder: buildState, itemCount: state.length),
    );
  }
}
