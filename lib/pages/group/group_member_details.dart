import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupMemberDetails extends StatefulWidget {
  final bool isSelf;
  final String id;

  GroupMemberDetails(this.isSelf, this.id);

  @override
  _GroupMemberDetailsState createState() => _GroupMemberDetailsState();
}

class _GroupMemberDetailsState extends State<GroupMemberDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(title: '等待编写'),
    );
  }
}
