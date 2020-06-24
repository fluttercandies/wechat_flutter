import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupBillBoardPage extends StatefulWidget {
  final String groupOwner;
  final String groupNotice;
  final String groupId;
  final String time;
  final Callback callback;

  GroupBillBoardPage(this.groupOwner, this.groupNotice,
      {this.groupId, this.time, this.callback});

  @override
  _GroupBillBoardPageState createState() => _GroupBillBoardPageState();
}

class _GroupBillBoardPageState extends State<GroupBillBoardPage> {
  bool inputState = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textController = new TextEditingController();
  String _publishTime;

  TextStyle styleLabel =
      TextStyle(fontSize: 12.0, color: Colors.black.withOpacity(0.8));

  @override
  void initState() {
    super.initState();
    _textController.text = widget.groupNotice;
  }

  onChange() {
    if (inputState) {
      _publishTime = '${DateTime.now().year}-' +
          '${DateTime.now().month}-' +
          '${DateTime.now().day} ' +
          '${DateTime.now().hour}:' +
          '${DateTime.now().minute}';
      debugPrint('发布时间>>>>> $_publishTime');
      DimGroup.modifyGroupNotificationModel(
          widget.groupId, _textController.text, _publishTime);
      widget.callback(_publishTime);
      Navigator.pop(context, _textController.text);
      inputState = false;
    } else {
      inputState = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = new ComMomButton(
      text: '确定',
      style: TextStyle(color: Colors.white),
      width: 45.0,
      margin: EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () => onChange(),
    );

    return Scaffold(
      appBar: new ComMomBar(title: '群公告', rightDMActions: <Widget>[rWidget]),
      body: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: '请编辑群公告',
        ),
        autofocus: true,
        focusNode: _focusNode,
        maxLines: null,
        expands: true,
        controller: _textController,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }
}
