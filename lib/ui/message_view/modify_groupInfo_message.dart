import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/group/fun_dim_info.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ModifyGroupInfoMessage extends StatefulWidget {
  final dynamic data;

  ModifyGroupInfoMessage(this.data);

  ModifyGroupInfoMessageState createState() => ModifyGroupInfoMessageState();
}

class ModifyGroupInfoMessageState extends State<ModifyGroupInfoMessage> {
  String name;
  List membersData;

  @override
  void initState() {
    super.initState();
    String user = widget.data['opGroupMemberInfo']['user'];
    getCardName(user);
  }

  getCardName(String user) async {
    await InfoModel.getGroupMembersInfoModel(widget.data['groupId'], [user],
        callback: (str) {
      String strToData = str.toString().replaceAll("'", '"');
      membersData = json.decode(strToData);
    });
    var userPhone = await getStoreValue('userPhone');
    if (listNoEmpty(membersData)) if (user == userPhone)
      name = '你';
    else if (strNoEmpty(membersData[0]['nameCard']))
      name = membersData[0]['nameCard'];
    else
      name = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data['groupInfoList'].toString() != '[]') {
      return new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: new Text(
          '${name ?? ''} 修改群名称为 ”${widget.data['groupInfoList'][0]['content']}“',
          style: TextStyle(
              color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
        ),
      );
    } else {
      return new Container();
    }
  }
}
