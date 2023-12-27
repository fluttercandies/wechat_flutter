import 'package:get/get.dart';

class FloatViewState {

  double viewWidth = 92; //浮窗中画面的宽
  double viewHeight = 116; //浮窗中画面的高

  /// 悬浮窗【小房子图标】左边距离
  double overlayHomeLeft = 5.5;

  /// 悬浮窗【小房子图标】顶部距离
  double overlayHomeTop = 5.5 + Get.statusBarHeight;

  /// 悬浮窗左边距离
  double overlayLeft = Get.width - 90;

  /// 悬浮窗顶部距离
  double overlayTop = 100;

  bool get isShowAudioWindow {
    return false;
  }

  double left = Get.width - 90;
  double top = (Get.height / 2 - 139) / 2;


  FloatViewState() {
    ///Initialize variables
  }
}
