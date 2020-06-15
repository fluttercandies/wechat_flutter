import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/provider/global_model.dart';

class JoinMessage extends StatelessWidget {
  final dynamic data;

  JoinMessage(this.data);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: new Text(
        data['changedGroupMemberInfo'].toString().substring(
                    data['changedGroupMemberInfo'].toString().indexOf('{') + 1,
                    data['changedGroupMemberInfo'].toString().indexOf(':')) ==
                globalModel.account
            ? '你 加入了群聊'
            : data['changedGroupMemberInfo'].toString().substring(
                    data['changedGroupMemberInfo'].toString().indexOf('{') + 1,
                    data['changedGroupMemberInfo'].toString().indexOf(':')) +
                ' 加入了群聊',
        style:
            TextStyle(color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}
