import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/group/group_details_page.dart';
import 'package:wechat_flutter/pages/settings/select_backgroud_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ChatBackgroundPage extends StatefulWidget {
  @override
  _ChatBackgroundPageState createState() => _ChatBackgroundPageState();
}

class _ChatBackgroundPageState extends State<ChatBackgroundPage> {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    return new Scaffold(
      appBar: new ComMomBar(title: '聊天背景'),
      backgroundColor: appBarColor,
      body: new Column(
        children: <Widget>[
          new GroupItem(
            title: '选择背景图',
            onPressed: () => routePush(new SelectBgPage()),
          ),
          new GroupItem(
            title: '从手机相册选择',
            onPressed: () => _openGallery(globalModel, context),
          ),
          new GroupItem(
            title: '拍一张',
            onPressed: () =>
                _openGallery(globalModel, context, source: ImageSource.camera),
          ),
          new Space(height: 15),
          new SizedBox(),
        ],
      ),
    );
  }

  // 从相册选取图片
  _openGallery(
    GlobalModel globalModel,
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
  }) async {
    File data = await ImagePicker.pickImage(source: source);
    if (data != null) {
//      File fileImg = data;
//      globalModel.localAvatarImgPath = fileImg.path;
//      if (Navigator.of(context).canPop()) {
//        Navigator.of(context).pop();
//      }
      showToast(context, '切换完毕');
    } else {
      return;
    }
  }
}
