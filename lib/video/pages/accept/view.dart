import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:wechat_flutter/live/msg/live_msg.dart';
import 'package:wechat_flutter/video/msg/live_msg.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/video/pages/video_sigle/view.dart';
import 'package:wechat_flutter/video/ui_commom/func/av_permissions_state.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
// import 'package:wechat_flutter/util/check/regular.dart';
// import 'package:wechat_flutter/util/screen_util.dart';
// import 'package:wechat_flutter/widgets/func/av_permissions_state.dart';

import 'logic.dart';

/// 接受通话页面、接听通话页面
class AcceptPage extends StatelessWidget {
  final logic = Get.put(AcceptLogic());

  AcceptPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvPermissionsBuilder(
      child: Scaffold(
        body: Obx(() {
          LiveSingleHideMsgModel? model = logic.myMsgModel.value;
          return VideoLiveBg.bgImg(
            model?.sendAvatarUrl ?? "",
            callItem: (VideoBtType e) => logic.btActions(e),
            bottomBts: logic.bottomBts,
            topBts: logic.topBts,
            timeShow: "".obs,
            content: Column(
              children: [
                SizedBox(height: 90.h),
                CircleAvatar(
                  radius: 86 / 2,
                  backgroundImage: strNoEmpty(model?.sendAvatarUrl)
                      ? NetworkImage(model!.sendAvatarUrl)
                      : (AssetImage(AppConfig.defPic)
                          as ImageProvider),
                ),
                SizedBox(height: 16.h),
                Text(
                  model?.sendChatName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 20.f),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
