import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wechat_flutter/tools/commom/check.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Color toastBgColor = const Color(0xff000000).withOpacity(0.8);

void q1ToastLong(String tips,
    {Duration duration = const Duration(milliseconds: 2000)}) {
  if (!strNoEmpty(tips)) {
    return;
  }

  /// 修复多重提示
  dismissAllToast();

  showToast(
    tips,
    textPadding:
        EdgeInsets.symmetric(horizontal: FrameSize.px(24), vertical: 15.px),
    textStyle: TextStyle(color: const Color(0xffFFFFFF), fontSize: 14.px),
    radius: 8.px,
    backgroundColor: toastBgColor,
    duration: duration,
  );
}

void q1Toast(String? tips,
    {Duration duration = const Duration(milliseconds: 2000)}) {
  if (!strNoEmpty(tips)) {
    return;
  }

  LogUtil.d("q1Toast::$tips");

  dismissAllToast();

  showToast(
    tips!,
    textPadding:

        EdgeInsets.symmetric(horizontal: FrameSize.px(20), vertical: 10.px),
    textStyle: TextStyle(color: const Color(0xffFFFFFF), fontSize: 14.px),
    radius: 8.px,
    backgroundColor: toastBgColor,
    duration: duration,
  );
}

void q1FailToast(String? tips,
    {Duration duration = const Duration(milliseconds: 2000)}) {
  if (!strNoEmpty(tips)) {
    return;
  }
  final Widget body = IconToastView(
    tips,
    Image.asset('assets/images/main/tip_close.png',
        width: 20.px, height: 20.px),
  );

  /// 修复多重提示
  dismissAllToast();

  showToastWidget(UnconstrainedBox(child: body), duration: duration);
}

Widget circularProgressIcon(
  double size, {
  Color primaryColor = Colors.white,
  Color? secondaryColor,
  int lapDuration = 1000,
  double strokeWidth = 1.67,
}) {
  return SizedBox(
    height: size,
    width: size,
    child: Image.asset('assets/images/main/loading.gif'),
  );
}

/*
* 加载中对话框
* */
void q1LoadingToast({
  String? tips,
  Duration duration = const Duration(milliseconds: 30000),
  VoidCallback? onComplete,
  double? marginTop,
}) {
  final Widget body = IconToastView(
    tips ?? "加载中",
    circularProgressIcon(20.px),
  );

  dismissAllToast();

  final ToastFuture toastFuture = showToastWidget(
      Container(
        margin: EdgeInsets.only(top: marginTop ?? 0),
        child: UnconstrainedBox(child: body),
      ),
      duration: duration);
  Future.delayed(duration - const Duration(milliseconds: 10)).then((value) {
    /// 为true则表示已销毁，否则表示还显示了
    final bool isDismiss =
        toastFuture.timer == null || !toastFuture.timer!.isActive;
    if (isDismiss) {
      return;
    }
    if (onComplete != null) {
      onComplete();
    }
  });
}

void q1SuccessToast(String tips,
    {Duration duration = const Duration(milliseconds: 2000)}) {
  if (!strNoEmpty(tips)) {
    return;
  }
  final Widget body = IconToastView(
    tips,
    Image.asset('assets/images/main/tip_ok.png', width: 20.px, height: 20.px),
  );

  dismissAllToast();

  showToastWidget(UnconstrainedBox(child: body), duration: duration);
}

class IconToastView extends StatelessWidget {
  final String? tips;
  final Widget icon;
  final EdgeInsetsGeometry? padding;

  const IconToastView(this.tips, this.icon, {this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: toastBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: padding ??
          EdgeInsets.symmetric(horizontal: FrameSize.px(20), vertical: 10.px),
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Space(width: 8.px),
            Text(
              tips!,
              style: TextStyle(color: const Color(0xffFFFFFF), fontSize: 14.px),
            )
          ],
        ),
      ),
    );
  }
}
