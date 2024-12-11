import 'package:flutter/material.dart';
import 'package:wechat_flutter/ui/w_pop/popup_menu_route.dart';

class WPopupMenu extends StatefulWidget {
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
  final EdgeInsets? padding;
  final Decoration? foregroundDecoration;
  final EdgeInsets? margin;
  final Matrix4? transform;
  final ValueChanged<String> onValueChanged;
  final List<Map<String, String>> actions;
  final Widget child;
  final PressType pressType; // 点击方式 长按 还是单击
  final int pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;

  WPopupMenu({
    Key? key,
    required this.onValueChanged,
    required this.actions,
    required this.child,
    this.pressType = PressType.singleClick,
    this.pageMaxChildCount = 5,
    this.backgroundColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 250,
    this.alignment,
    this.padding,
    Color? color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    this.constraints,
    this.margin,
    this.transform,
  })  : assert(actions.isNotEmpty),
        super(key: key);

  @override
  _WPopupMenuState createState() => _WPopupMenuState();
}

class _WPopupMenuState extends State<WPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        key: widget.key,
        padding: widget.padding,
        margin: widget.margin,
        decoration: widget.decoration,
        constraints: widget.constraints,
        transform: widget.transform,
        alignment: widget.alignment,
        child: widget.child,
      ),
      onTap: () {
        if (widget.pressType == PressType.singleClick) {
          onTap();
        }
      },
      onLongPress: () {
        if (widget.pressType == PressType.longPress) {
          onTap();
        }
      },
    );
  }

  void onTap() {
    Navigator.push(
      context,
      PopupMenuRoute(
        context,
        widget.actions,
        widget.pageMaxChildCount,
        widget.backgroundColor,
        widget.menuWidth,
        widget.menuHeight,
        widget.padding ?? EdgeInsets.zero,
        widget.margin ?? EdgeInsets.zero,
        widget.onValueChanged,
      ),
    ).then((index) {
      if (index != null && index is String) {
        widget.onValueChanged(index);
      }
    });
  }
}
