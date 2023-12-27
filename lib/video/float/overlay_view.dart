import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class OverlayView {
  static double viewHeight = 138.5; //浮窗中画面的高
  static OverlayEntry? overlayEntry;

  /*
  * 显示悬浮窗
  * */
  static void showOverlayEntry(BuildContext context,
      {required FloatWindowParam param}) {
    floatWindow.close();

    overlayEntry = OverlayEntry(builder: (context) {
      return FloatViewPage(param);
    });

    OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
    overlayState?.insert(overlayEntry!);
  }

  /*
  * 关闭悬浮窗
  * */
  static void removeOverlayEntry([bool isDismiss = true]) {
    if (overlayEntry != null) {
      try {
        overlayEntry?.remove();
      } catch (e) {
        LogUtil.d('removeOverlayEntry failed');
      }
      overlayEntry = null;
    }
  }
}
