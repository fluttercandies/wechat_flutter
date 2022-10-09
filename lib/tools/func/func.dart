import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

bool isTemporaryTapProcessing = false;

void restoreTemporaryProcess([int milliseconds = 500]) {
  Future.delayed(Duration(milliseconds: milliseconds)).then((value) {
    isTemporaryTapProcessing = false;
  });
}

/*
* 防止同时多个事件
*
* 关键字：防多次点击、防点击
* */

/// 通用防重复【防多点】点击组件
class ClickEvent extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final bool isNet;

  const ClickEvent({
    this.onTap,
    this.child,
    this.isNet = true,
  });

  @override
  State<ClickEvent> createState() => _ClickEventState();
}

class _ClickEventState extends State<ClickEvent> {
  /// 放到全局出现弹出对话框后，对话框内的内容不能点击
  bool isInkWellProcessing = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        /// 防止多个事件一起点
        if (isTemporaryTapProcessing) {
          return;
        }
        isTemporaryTapProcessing = true;
        restoreTemporaryProcess(300);

        Throttle.milliseconds(widget.isNet ? 1000 : 300, widget.onTap);
      },
      child: widget.child ?? Container(),
    );
  }

  @override
  void dispose() {
    Throttle.clear(widget.onTap);
    super.dispose();
  }
}

class MyInkWell extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;

  MyInkWell({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: child,
      onTap: onTap,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
