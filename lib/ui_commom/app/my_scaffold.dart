import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MyScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;

  /// 是否删除滑动焦点，为true则滑动到顶无焦点显示
  /// 默认为true
  final bool isRemoveBehavior;

  /// 是否在异步加载中，为true的话会有层加载蒙版
  final bool inAsync;

  /// 是否显示加载，为true时显示加载中圆形条
  /// 前提是inAsync为true才有效
  final bool isShowLoading;

  /// 是否删除[状态栏高度-安全区顶部]的边距
  final bool removeTop;

  final Color? backgroundColor;

  /// 控制状态栏字体颜色的，
  /// [SystemUiOverlayStyle.dark] = 黑色状态栏字体颜色
  /// [SystemUiOverlayStyle.light] = 百色状态栏字体颜色
  final SystemUiOverlayStyle? overlayStyle;
  final Widget? bottomSheet;

  /// 动画加载
  final bool animateLoading;

  /// 键盘不遮盖视图，遮盖的话传false
  final bool? resizeToAvoidBottomInset;

  const MyScaffold({
    this.body,
    this.appBar,
    this.isRemoveBehavior = true,
    this.removeTop = false,
    this.overlayStyle,
    this.inAsync = false,
    this.animateLoading = false,
    this.isShowLoading = true,
    this.backgroundColor,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) {
    Widget _content = AnimatedCrossFade(
      crossFadeState:
          animateLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
      firstChild: Container(
        width: FrameSize.winWidth(),
        height: FrameSize.winHeight(),
        color: animateLoading ? Colors.white : Colors.white,
        child: const CupertinoActivityIndicator(radius: 12),
      ),
      secondChild: SizedBox(
        width: FrameSize.winWidth(),
        height: FrameSize.winHeight(),
        child: ModalProgressHUD(
          inAsyncCall: inAsync,
          color: isShowLoading ? Colors.black : Colors.transparent,
          opacity: 0.5,
          progressIndicator: isShowLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : Container(),
          child: isRemoveBehavior
              ? ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: body ?? Container(),
                )
              : body,
        ),
      ),
    );
    _content = MainInputBody(child: _content);
    _content = MediaQuery.removePadding(
      removeTop: removeTop,
      context: context,
      child: Scaffold(
        body: _content,
        appBar: appBar,
        backgroundColor: backgroundColor ?? Colors.white,
        bottomSheet: bottomSheet,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
    if (overlayStyle != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle!,
        child: _content,
      );
    }
    return _content;
  }
}

class ModalProgressHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget? child;

  const ModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child ?? Container());
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null)
        layOutProgressIndicator = Center(child: progressIndicator);
      else {
        layOutProgressIndicator = Positioned(
          left: offset!.dx,
          top: offset!.dy,
          child: progressIndicator,
        );
      }
      final modal = [
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Stack(
      children: widgetList as List<Widget>,
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (kIsWeb) {
      return super.buildOverscrollIndicator(context, child, details);
    } else if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
}
