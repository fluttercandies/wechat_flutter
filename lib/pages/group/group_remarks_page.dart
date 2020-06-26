import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupRemarksPage extends StatefulWidget {
  final bool isGroupName;
  final String groupName;
  final String groupId;

  GroupRemarksPage({
    this.isGroupName = false,
    this.groupName = '',
    this.groupId,
  });

  @override
  _GroupRemarksPageState createState() => _GroupRemarksPageState();
}

class _GroupRemarksPageState extends State<GroupRemarksPage> {
  TextEditingController _textController = TextEditingController();

  handle() {
    if (!strNoEmpty(_textController.text)) {
      showToast(context, '请输入内容');
      return;
    }
    if (widget.isGroupName) {
      DimGroup.modifyGroupNameModel(widget.groupId, _textController.text,
          callback: (_) {});
      Navigator.pop(context, _textController.text);
    } else {
      showToast(context, '敬请期待');
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.groupName;
  }

  @override
  Widget build(BuildContext context) {
    return new MainInputBody(
      child: new Scaffold(
        appBar: new ComMomBar(backgroundColor: Colors.white),
        body: new Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Space(height: 30),
              new Text(
                '${widget.isGroupName ? '修改群聊名称' : '备注'}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: new Text(
                    '${widget.isGroupName ? '修改群聊名称后，将在群内通知其他成员' : '群聊的备注仅自己可见'}'),
              ),
              new Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.2),
                    bottom: BorderSide(color: Colors.grey, width: 0.2),
                  ),
                ),
                child: new Row(
                  children: <Widget>[
                    new Image.network(
                      defGroupAvatar,
                      width: 48,
                    ),
                    new Space(),
                    new Expanded(
                      child: new TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: '${widget.isGroupName ? '群聊名称' : '备注'}',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Space(),
              new Visibility(
                visible: !widget.isGroupName,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      '群聊名称：wechat_flutter 106号群',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    new Space(),
                    new InkWell(
                      child: new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: new Text(
                          '填入',
                          style: TextStyle(color: mainTextColor, fontSize: 14),
                        ),
                      ),
                      onTap: () => showToast(context, '敬请期待'),
                    )
                  ],
                ),
              ),
              new Spacer(),
              new ComMomButton(
                text: '完成',
                onTap: () => handle(),
                width: winWidth(context) / 2,
              ),
              new Space(height: winKeyHeight(context) > 1 ? 15 : 50),
            ],
          ),
        ),
      ),
    );
  }
}
