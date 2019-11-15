import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final String title;
  final String id;
  final Function functionT;
  final Function functionF;

  SwitchWidget(this.value, this.title,
      {this.id, this.functionT, this.functionF});

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool valueCan;

  @override
  void initState() {
    super.initState();
    valueCan = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
          color: Colors.white,
          onPressed: () {
            valueCan = !valueCan;
            setState(() {});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.title),
              Expanded(child: Container()),
              Switch(
                value: valueCan,
                onChanged: (v) {
                  if (!valueCan) {
//                    widget.functionT();
//                    DimFriend.addBlack(widget.id ?? '');
                  } else {
//                    widget.functionF();
//                    DimFriend.deleteBlackListModel(widget.id ?? '');
                  }
                  setState(() => valueCan = !valueCan);
                },
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
