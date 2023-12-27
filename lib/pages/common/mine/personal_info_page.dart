import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart' as wxp;
import 'package:wechat_flutter/tools/http/api_v2.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/im/util/im_response_tip_util.dart';
import 'package:wechat_flutter/pages/common/mine/code_page.dart';
import 'package:wechat_flutter/tools/config/app_config.dart';
import 'package:wechat_flutter/tools/func/commom.dart';
import 'package:wechat_flutter/tools/theme/my_theme.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/common/mine/change_name_page.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';

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
      Get.to(new CodePage(id: Q1Data.user()));
    } else if (v == '${AppConfig.appName}号') {
    } else {
      q1Toast("开发中");
      print(v);
    }
  }

  _openGallery({type = ImageSource.gallery}) async {
    final model = Provider.of<GlobalModel>(context, listen: false);

    wxp.AssetPicker.pickAssets(
      context,
      pickerConfig: wxp.AssetPickerConfig(
        maxAssets: 1,
        pageSize: 320,
        gridCount: 4,
        themeColor: MyTheme.themeColor(),
        requestType: wxp.RequestType.image,
        textDelegate: wxp.AssetPickerTextDelegate(),
      ),
    ).then((List<wxp.AssetEntity>? result) {
      /// 没有选择文件
      if (result == null) {
        return;
      }
      result.forEach((wxp.AssetEntity element) async {
        File? imageFile = await (element.file);
        if (imageFile == null) {
          q1Toast("文件出错");
          return;
        }

        File? resultFile = await compressFileGetFile(imageFile);
        if (resultFile != null) {
          final apiValue = strNoEmpty(Q1Data.userInfoRspEntity!.avatar)
              ? await ApiV2.fileChange(
                  context,
                  Q1Data.userInfoRspEntity!.avatar!
                      .split('/')
                      .last
                      .split('?')
                      .first,
                  model.account,
                  resultFile)
              : await ApiV2.uploadFile(context, model.account, resultFile);
          if (!strNoEmpty(apiValue)) {
            return;
          }
          final String resultAvatar =
              "$apiValue?time=${DateTime.now().millisecondsSinceEpoch}";
          final V2TimCallback callback = await ImApi.setSelfInfo(
            faceUrl: resultAvatar,
            nickname: model.nickName,
          );
          if (callback.code == 0) {
            /// 【用户资料更新同时通知服务api】服务api更新头像
            ApiV2.updateUserInfo(
              null,
              Q1Data.userInfoRspEntity!.id!,
              avatar: apiValue,
            );

            q1Toast('设置头像成功');
            model.setAvatar(resultAvatar);
            model.refresh();
            Q1Data.userInfoRspEntity!.avatar = resultAvatar;
          } else {
            q1Toast(ImResponseTipUtil.getInfoOResultCode(callback.code));
          }
        } else {
          q1Toast("压缩图片出现错误");
        }
      });
    });
  }

  Widget dynamicAvatar(avatar, {size}) {
    if (isNetWorkImg(avatar)) {
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.cover);
    } else {
      return new Image.asset(avatar,
          fit: BoxFit.cover, width: size ?? null, height: size ?? null);
    }
  }

  Widget body(GlobalModel model) {
    List data = [
      {'label': '${AppConfig.appName}号', 'value': model.account},
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
        onPressed: () => Get.to(new ChangeNamePage(model.nickName)),
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
      isRight: item['label'] == '${AppConfig.appName}号' ? false : true,
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
