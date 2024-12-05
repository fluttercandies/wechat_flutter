import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/orther/tip_verify_Input.dart';

class ChangeNamePage extends StatefulWidget {
  final String name;

  ChangeNamePage(this.name);

  @override
  _ChangeNamePageState createState() => new _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  TextEditingController _tc = new TextEditingController();
  FocusNode _f = new FocusNode();

  late String initContent;

  Future<void> setInfoMethod(GlobalModel model) async {
    if (!strNoEmpty(_tc.text)) {
      showToast('输入的内容不能为空');
      return;
    }
    if (_tc.text.length > 12) {
      showToast('输入的内容太长了');
      return;
    }

    final result = await setUsersProfileMethod(
      context,
      nickNameStr: _tc.text,
      avatarStr: model.avatar,
    );

    if (result) {
      showToast('设置名字成功');
      model.refresh();
      Navigator.of(context).pop();
    } else {
      showToast('设置名字失败');
    }
  }

  Widget body() {
    var widget = new TipVerifyInput(
      title: '好名字可以让你的朋友更容易记住你',
      defStr: initContent,
      controller: _tc,
      focusNode: _f,
      color: appBarColor,
    );

    return new SingleChildScrollView(child: new Column(children: [widget]));
  }

  @override
  void initState() {
    initContent = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    var rWidget = new ComMomButton(
      text: '保存',
      style: TextStyle(color: Colors.white),
      width: 55.0,
      margin: EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10.0),
      radius: 4.0,
      onTap: () => setInfoMethod(model),
    );

    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(title: '更改名字', rightDMActions: [rWidget]),
      body: new MainInputBody(color: appBarColor, child: body()),
    );
  }
}
