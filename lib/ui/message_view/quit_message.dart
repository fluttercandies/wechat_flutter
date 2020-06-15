import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/provider/global_model.dart';

class QuitMessage extends StatelessWidget {
  final dynamic data;

  QuitMessage(this.data);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: new Text(
        '${data['opGroupMemberInfo']['user'] == globalModel.account ? '你' : data['opGroupMemberInfo']['user']}' +
            ' 退出了群聊',
        style:
            TextStyle(color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}
