import 'dart:math';

import 'package:flutter/material.dart';

/// 封装之后的拍一拍
class ShakeView extends StatefulWidget {
  final Widget child;

  ShakeView({
    this.child,
  });

  _ShakeViewState createState() => _ShakeViewState();
}

class _ShakeViewState extends State<ShakeView>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = TweenSequence<double>([
      //使用TweenSequence进行多组补间动画
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 10, end: 0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(controller);
    controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimateWidget(animation: animation, child: widget.child);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimateWidget extends AnimatedWidget {
  final Widget child;

  AnimateWidget({Animation<double> animation, this.child})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    var result = Transform(
      transform: Matrix4.rotationZ(animation.value * pi / 180),
      alignment: Alignment.bottomCenter,
      child: new ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: this.child,
      ),
    );
    return result;
  }
}
