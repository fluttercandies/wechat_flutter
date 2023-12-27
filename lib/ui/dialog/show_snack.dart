import 'package:flutter/material.dart';

showSnack(BuildContext context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: new Text('$text')),
  );
}
