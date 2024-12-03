import 'package:flutter/material.dart';

class ConfirmAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmAlert({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel', style: TextStyle(color: Color(0xffFF5252))),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text('Confirm', style: TextStyle(color: Color(0xffFF5252))),
        ),
      ],
    );
  }
}