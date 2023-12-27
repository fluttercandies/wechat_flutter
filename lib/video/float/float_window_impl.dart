// 混装类，通用
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/float/overlay_view.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

FloatWindow floatWindow = IosFloatWindow();

/// IOS专用
/// Android和iOS都先试用这个，后续再一
class IosFloatWindow extends FloatWindow {
  @override
  void open(BuildContext context, {required FloatWindowParam param}) {
    paramValue = param;
    OverlayView.showOverlayEntry(context, param: param);
  }

  @override
  Future<bool> close() async {
    OverlayView.removeOverlayEntry();
    return true;
  }

  @override
  void closeFloatUIAndEngine() {}

  @override
  void floatClick() {
    close();
    Map arguments = {
      "isWindowPush": true,
      "channelId": paramValue?.channelId ?? "",
      "isSend": paramValue?.agoraVideoIml?.isSend,
    };
    LiveUtil.checkPermissionThen(() async {
      if (paramValue?.type == LivePageType.singleVideo) {
        Get.toNamed(RouteConfig.videoSinglePage, arguments: arguments);
      } else if (paramValue?.type == LivePageType.multipleVideo) {
        Get.toNamed(RouteConfig.videoMultiplePage, arguments: arguments);
      } else if (paramValue?.type == LivePageType.singleAudio) {
        Get.toNamed(RouteConfig.audioSinglePage, arguments: arguments);
      } else if (paramValue?.type == LivePageType.multipleAudio) {
        Get.toNamed(RouteConfig.audioMultiplePage, arguments: arguments);
      }
    });
  }

  @override
  bool get isHaveFloat => OverlayView.overlayEntry != null;

  void pushToLive() {}

  Future<bool> onlyCloseUI() async {
    return false;
  }

  @override
  void setParamValue({required FloatWindowParam param}) {
    paramValue = param;
  }
}
