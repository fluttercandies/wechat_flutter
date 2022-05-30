import 'package:flutter/material.dart';

class Contact {
  Contact({
    @required this.avatar,
    @required this.name,
    @required this.nameIndex,
    @required this.identifier,
  });

  final String avatar;
  final String name;
  final String nameIndex;
  final String identifier;
}
