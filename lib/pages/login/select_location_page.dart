import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  List state;

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
      {'name': S.of(context).australia, 'code': '+61'},
      {'name': S.of(context).macao, 'code': '+853'},
      {'name': S.of(context).canada, 'code': '+001'},
      {'name': S.of(context).uS, 'code': '+001'},
      {'name': S.of(context).taiwan, 'code': '+886'},
      {'name': S.of(context).hongKong, 'code': '+852'},
      {'name': S.of(context).singapore, 'code': '+65'},
      {'name': S.of(context).chinaMainland, 'code': '+86'},
    ];

    return new Scaffold(
      appBar: new ComMomBar(title: S.of(context).selectCountry),
      body: new ListView.builder(
          itemBuilder: buildState, itemCount: state.length),
    );
  }
}
