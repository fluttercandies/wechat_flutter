import 'package:flutter/material.dart';

class MainInputBody extends StatefulWidget {
  final Widget? child;
  final Color color;
  final Decoration? decoration;
  final GestureTapCallback? onTap;

  MainInputBody({
    this.child,
    this.color = const Color(0xfff4f4f4),
    this.decoration,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => MainInputBodyState();
}

class MainInputBodyState extends State<MainInputBody> {
  @override
  Widget build(BuildContext context) {
    return widget.decoration != null
        ? Container(
      decoration: widget.decoration,
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        child: widget.child,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
      ),
    )
        : Container(
      color: widget.color,
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        child: widget.child,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
      ),
    );
  }
}