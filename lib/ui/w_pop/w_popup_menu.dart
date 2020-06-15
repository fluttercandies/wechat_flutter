import 'package:flutter/material.dart';
import 'package:wechat_flutter/ui/w_pop/popup_menu_route.dart';

class WPopupMenu extends StatefulWidget {
  WPopupMenu({
    Key key,
    @required this.onValueChanged,
    @required this.actions,
    @required this.child,
    this.pressType = PressType.singleClick,
    this.pageMaxChildCount = 5,
    this.backgroundColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 250,
    this.alignment,
    this.padding,
    Color color,
    Decoration decoration,
    this.foregroundDecoration,
    double width,
    double height,
    BoxConstraints constraints,
    this.margin,
    this.transform,
  })  : assert(onValueChanged != null),
        assert(actions != null && actions.length > 0),
        assert(child != null),
        assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'The color argument is just a shorthand for "decoration: new BoxDecoration(color: color)".'),
        decoration =
            decoration ?? (color != null ? BoxDecoration(color: color) : null),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  final BoxConstraints constraints;
  final Decoration decoration;
  final AlignmentGeometry alignment;
  final EdgeInsets padding;
  final Decoration foregroundDecoration;
  final EdgeInsets margin;
  final Matrix4 transform;
  final ValueChanged<String> onValueChanged;
  final List actions;
  final Widget child;
  final PressType pressType; // 点击方式 长按 还是单击
  final int pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;

  @override
  _WPopupMenuState createState() => _WPopupMenuState();
}

class _WPopupMenuState extends State<WPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
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
    );
  }

  void onTap() {
    Navigator.push(
        context,
        new PopupMenuRoute(
          context,
          widget.actions,
          widget.pageMaxChildCount,
          widget.backgroundColor,
          widget.menuWidth,
          widget.menuHeight,
          widget.padding,
          widget.margin,
          widget.onValueChanged,
        )).then((index) {
      widget.onValueChanged(index);
    });
  }
}
