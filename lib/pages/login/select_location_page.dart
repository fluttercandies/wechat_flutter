import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late List<Map<String, String>> state = <Map<String, String>>[
    <String, String>{'name': S.of(context).australia, 'code': '+61'},
    <String, String>{'name': S.of(context).macao, 'code': '+853'},
    <String, String>{'name': S.of(context).canada, 'code': '+001'},
    <String, String>{'name': S.of(context).uS, 'code': '+001'},
    <String, String>{'name': S.of(context).taiwan, 'code': '+886'},
    <String, String>{'name': S.of(context).hongKong, 'code': '+852'},
    <String, String>{'name': S.of(context).singapore, 'code': '+65'},
    <String, String>{'name': S.of(context).chinaMainland, 'code': '+86'},
  ];

  Widget buildState(BuildContext context, int index) {
    final Map<String, String> item = state[index];

    final Container content = new Container(
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
          Navigator.pop(context, item['name']! + '  ' + '(${item['code']})'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(title: S.of(context).selectCountry),
      body: new ListView.builder(
          itemBuilder: buildState, itemCount: state.length),
    );
  }
}
