import 'package:flutter/material.dart';

class MessageNum extends StatefulWidget {
  final String num;

  MessageNum(this.num);

  @override
  _MessageNumState createState() => _MessageNumState();
}

class _MessageNumState extends State<MessageNum> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      alignment: Alignment.center,
      height: 17.0,
      width: 20.0,
      child: Text(
        widget.num,
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}
