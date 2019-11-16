import 'package:dim_example/http/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dim_example/im/info_handle.dart';
import 'package:dim_example/pages/mine/change_name_page.dart';
import 'package:dim_example/provider/global_model.dart';

import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/orther/label_row.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  action(name) {
    print(name);
  }

  _openGallery(BuildContext context) async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    final model = Provider.of<GlobalModel>(context);

    if (img != null) {
      setUsersProfileMethod(
        context,
        avatarStr:
            'https://c-ssl.duitang.com/uploads/item/201803/09/20180309220127_cRhdH.thumb.700_0.jpeg',
        nickNameStr: model.nickName,
        callback: (data) {
          if (data.toString().contains('ucc')) {
            showToast(context, '设置头像成功');
            model.avatar =
                'https://c-ssl.duitang.com/uploads/item/201803/09/20180309220127_cRhdH.thumb.700_0.jpeg';
            model.refresh();
          } else {
            showToast(context, '设置头像失败');
          }
        },
      );
    } else {
      return;
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
                : new Image.asset(defIcon, fit: BoxFit.fill),
          ),
        ),
        onPressed: () => postSuggestionWithAvatar(context),
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
