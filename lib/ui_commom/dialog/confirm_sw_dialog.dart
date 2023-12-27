import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui_commom/dialog/sw_scroll_dialog.dart';

bool _canShow = true;

typedef CallAppState = Function(AppLifecycleState state);

Future confirmSwDialog(
  BuildContext context, {
  String? text,
  TextStyle? headTextStyle,
  TextStyle? contentStyle,
  VoidCallback? onPressed,
  VoidCallback? onCancel,
  String? cancelText,
  TextStyle? cancelTextStyle,
  String? okText,
  TextStyle? okTextStyle,
  Widget? head,
  int type = 1,
  TextAlign textAlign = TextAlign.center,
  Widget? child,
  bool? barrierDismissible,
  double? headTopPadding,
  double? headBottomPadding,
  double? textBottomPadding,
  String? title,
  bool? isOkPop,
  bool? isDarkMode,
  bool isHaveCancel = true,
  final WillPopCallback? onWillPop,
  final CallAppState? callAppState,
}) {
  if (!_canShow) {
    return Future.value();
  }
  return showDialog(
      context: context,
      builder: (context) {
        return SwDialog(
          title,
          text,
          onPressed,
          cancelText,
          cancelTextStyle,
          okText,
          okTextStyle,
          head,

          type,
          textAlign,
          onCancel,
          barrierDismissible: barrierDismissible,
          headTopPadding: headTopPadding,
          headBottomPadding: headBottomPadding,
          textBottomPadding: textBottomPadding,
          isOkPop: isOkPop ?? true,
          isDarkMode: isDarkMode ?? false,
          //是否为黑色主题
          contentStyle: contentStyle,
          headTextStyle: headTextStyle,
          onWillPop: onWillPop,
          isHaveCancel: isHaveCancel,
          callAppState: callAppState,
          child: child,
        );
      }).then<void>((value) {
    _canShow = false;
    Future.delayed(const Duration(milliseconds: 20)).then((value) {
      _canShow = true;
    });
  });
}

class SwDialog extends StatefulWidget {
  final String? text;
  final TextStyle? contentStyle;
  final String? title;
  final String? cancelText;
  final TextStyle? cancelTextStyle;
  final String? okText;
  final TextStyle? okTextStyle;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;
  final Widget? head;
  final TextStyle? headTextStyle;
  final int type;
  final TextAlign textAlign;
  final Widget? child;
  final bool? barrierDismissible;
  final double? headTopPadding;
  final double? headBottomPadding;
  final double? textBottomPadding;
  final bool? isOkPop;
  final bool? isDarkMode;
  final bool? isHaveCancel;
  final WillPopCallback? onWillPop;
  final CallAppState? callAppState;

  const SwDialog(
    this.title,
    this.text,
    this.onPressed,
    this.cancelText,
    this.cancelTextStyle,
    this.okText,
    this.okTextStyle,
    this.head,
    this.type,
    this.textAlign,
    this.onCancel, {
    this.child,
    this.onWillPop,
    this.isHaveCancel,
    this.barrierDismissible,
    this.headTopPadding,
    this.headBottomPadding,
    this.textBottomPadding,
    this.isOkPop,
    this.isDarkMode,
    this.contentStyle,
    this.headTextStyle,
    this.callAppState,
  });

  @override
  _SwDialogState createState() => _SwDialogState();
}

class _SwDialogState extends State<SwDialog> with WidgetsBindingObserver {
  GlobalKey key = GlobalKey();

  final BorderSide borderSide = BorderSide(
      color: const Color(0xff8f959e).withOpacity(0.2),
      width: (0.5));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  ///切换到前后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.callAppState != null) {
      widget.callAppState!(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDialog(
      barrierDismissible: widget.barrierDismissible ?? false,
      onWillPop: widget.onWillPop,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            SizedBox(
              width: FrameSize.winWidth(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode!
                          ? Colors.black.withOpacity(0.85)
                          : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.only(top: widget.headTopPadding ?? 20),
                    width: FrameSize.winHeight() - (47.5 * 2),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Center(
                          child: widget.head ??
                              Text(
                                widget.title ?? '提    示',
                                style: widget.headTextStyle ??
                                    TextStyle(
                                      color: widget.isDarkMode!
                                          ? Colors.white
                                          : const Color(0xff121212),
                                      fontSize: 18,
                                    ),
                              ),
                        ),
                        SizedBox(height: widget.headBottomPadding ?? 30),
                        if (widget.child != null)
                          SizedBox(
                            width: FrameSize.winHeight(),
                            child: widget.child,
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: (24)),
                            child: Text(
                              widget.text ?? '请输入内容',
                              style: widget.contentStyle ??
                                  TextStyle(
                                    color: widget.isDarkMode!
                                        ? Colors.white
                                        : const Color(0xff121212),
                                    fontSize: 16,
                                  ),
                              textAlign: widget.textAlign,
                            ),
                          ),
                        Container(
                          key: key,
                          width: FrameSize.winHeight() - 50,
                          height: 0,
                          color: widget.isDarkMode!
                              ? const Color(0xff333333)
                              : Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: widget.textBottomPadding ?? 40),
                        if (widget.type == 1)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(8)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(top: borderSide),
                                color: widget.isDarkMode!
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  if (widget.isHaveCancel!)
                                    Expanded(
                                      child: ClickEvent(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          if (widget.onCancel != null) {
                                            widget.onCancel!();
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: (55.5),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(right: borderSide)),
                                          child: Text(
                                            widget.cancelText ?? '取消',
                                            style: widget.cancelTextStyle ??
                                                TextStyle(
                                                  fontSize: (17),
                                                  color: widget.isDarkMode!
                                                      ? Colors.white
                                                      : const Color(0xff363940),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.isOkPop!)
                                          Navigator.pop(context);
                                        if (widget.onPressed != null) {
                                          widget.onPressed!();
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: (55.5),
                                        child: Text(
                                          widget.okText ?? '确定',
                                          style: widget.okTextStyle ??
                                              TextStyle(
                                                fontSize: (17),
                                                color: widget.isDarkMode!
                                                    ? const Color(0xff1677FF)
                                                    : const Color(0xff6179f2),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              if (widget.isOkPop!) Navigator.pop(context);
                              if (widget.onPressed != null) {
                                widget.onPressed!();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: FrameSize.winHeight(),
                              height: (55.5),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: widget.isDarkMode!
                                        ? const Color(0xff333333)
                                        : const Color(0xff8f959e)
                                            .withOpacity(0.2),
                                    width: (0.5),
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.okText ?? '确定',
                                style: TextStyle(
                                  fontSize: (17),
                                  color: widget.isDarkMode!
                                      ? const Color(0xff1677FF)
                                      : const Color(0xff6179f2),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
