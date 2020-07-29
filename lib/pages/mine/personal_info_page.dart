import 'dart:convert';

import 'package:wechat_flutter/http/api.dart';
import 'package:wechat_flutter/pages/mine/code_page.dart';
import 'package:wechat_flutter/tools/commom.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/pages/mine/change_name_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';

import 'package:wechat_flutter/ui/orther/label_row.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  action(v) {
    if (v == '二维码名片') {
      routePush(new CodePage());
    } else {
      print(v);
    }
  }

  _openGallery({type = ImageSource.gallery}) async {
    final model = Provider.of<GlobalModel>(context, listen: false);
    File imageFile = await ImagePicker.pickImage(source: type);
    List<int> imageBytes = await compressFile(imageFile);
    if (imageFile != null) {
      String base64Img = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';
      uploadImgApi(context, base64Img, (v) {
        if (v == null) {
          showToast(context, '上传头像失败,请换张图像再试');
          return;
        }

        setUsersProfileMethod(
          context,
          avatarStr: v,
          nickNameStr: model.nickName,
          callback: (data) {
            if (data.toString().contains('ucc')) {
              showToast(context, '设置头像成功');
              model.avatar = v;
              model.refresh();
            } else {
              showToast(context, '设置头像失败');
            }
          },
        );
      });
    }
  }

  Widget dynamicAvatar(avatar, {size}) {
    if (isNetWorkImg(avatar)) {
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.fill);
    } else {
      return new Image.asset(avatar,
          fit: BoxFit.fill, width: size ?? null, height: size ?? null);
    }
  }

  Widget body(GlobalModel model) {
    List data = [
      {'label': '微信号', 'value': model.account},
      {'label': '二维码名片', 'value': ''},
      {'label': '更多', 'value': ''},
      {'label': '我的地址', 'value': ''},
    ];

    var content = [
      new LabelRow(
        label: '头像',
        isLine: true,
        isRight: true,
        rightW: new SizedBox(
          width: 55.0,
          height: 55.0,
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: strNoEmpty(model.avatar)
                ? dynamicAvatar(model.avatar)
                : new Image.asset(defIcon, fit: BoxFit.cover),
          ),
        ),
        onPressed: () => _openGallery(),
      ),
      new LabelRow(
        label: '昵称',
        isLine: true,
        isRight: true,
        rValue: model.nickName,
        onPressed: () => routePush(new ChangeNamePage(model.nickName)),
      ),
      new Column(
        children: data.map((item) => buildContent(item, model)).toList(),
      ),
    ];

    return new Column(children: content);
  }

  Widget buildContent(item, GlobalModel model) {
    return new LabelRow(
      label: item['label'],
      rValue: item['value'],
      isLine: item['label'] == '我的地址' || item['label'] == '更多' ? false : true,
      isRight: item['label'] == '微信号' ? false : true,
      margin: EdgeInsets.only(bottom: item['label'] == '更多' ? 10.0 : 0.0),
      rightW: item['label'] == '二维码名片'
          ? new Image.asset('assets/images/mine/ic_small_code.png',
              color: mainTextColor.withOpacity(0.7))
          : new Container(),
      onPressed: () => action(item['label']),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(title: '个人信息'),
      body: new SingleChildScrollView(child: body(model)),
    );
  }
}
