import 'package:dim_example/im/info_handle.dart';
import 'package:dim_example/provider/global_model.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 随机头像 [Random avatar]
void postSuggestionWithAvatar(BuildContext context) async {
  final model = Provider.of<GlobalModel>(context);

  Req.getInstance().get(
    API.cat,
    (v) async {
      String avatarUrl = v['url'];
      final data = await setUsersProfileMethod(
        context,
        avatarStr: avatarUrl,
        nickNameStr: model.nickName,
        callback: (data) {},
      );

      if (data.toString().contains('ucc')) {
        showToast(context, '设置头像成功');
        model.avatar = avatarUrl;
        model.refresh();
        await SharedUtil.instance.saveString(Keys.faceUrl, avatarUrl);
      } else {
        showToast(context, '设置头像失败');
      }
    },
  );
}
