import 'package:flutter/material.dart';

showSnack(BuildContext context, text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(content: new Text('$text')),
  );
}
