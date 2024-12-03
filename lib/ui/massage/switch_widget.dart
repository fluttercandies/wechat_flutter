import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final String title;
  final String? id;
  final Function? functionT;
  final Function? functionF;

  SwitchWidget({
    required this.value,
    required this.title,
    this.id,
    this.functionT,
    this.functionF,
  });

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool valueCan;

  @override
  void initState() {
    super.initState();
    valueCan = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
            backgroundColor: Colors.white,
          ),
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
                    widget.functionT?.call();
                    // DimFriend.addBlack(widget.id ?? '');
                  } else {
                    widget.functionF?.call();
                    // DimFriend.deleteBlackListModel(widget.id ?? '');
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