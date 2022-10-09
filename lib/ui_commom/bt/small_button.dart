import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_flutter/tools/data/my_theme.dart';
import 'package:wechat_flutter/tools/func/func.dart';

const Color _kDisabledBackground = Color(0xFFA9A9A9);
const Color _kDisabledForeground = Color(0xFFD1D1D1);
const double kMinInteractiveDimensionMagic = 44;

const EdgeInsets _kButtonPadding = EdgeInsets.all(16);
const EdgeInsets _kBackgroundButtonPadding =
    EdgeInsets.symmetric(vertical: 10, horizontal: 64);

class SmallButton extends StatefulWidget {
  const SmallButton({
    Key key,
    @required this.child,
    this.padding,
    this.margin = const EdgeInsets.symmetric(horizontal: 37),
    this.width,
    this.height,
    this.color,
    this.disabledColor = const Color(0xffEFEFEF),
    this.minWidth = kMinInteractiveDimensionMagic,
    this.minHeight = kMinInteractiveDimensionMagic,
    this.pressedOpacity = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.isShadow = false,
    this.shadowColor,
    this.border,
    this.gradient,
    this.filled = false,
    @required this.onPressed,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final Color disabledColor;
  final GestureTapCallback onPressed;
  final double minWidth;
  final double minHeight;
  final double width;
  final double height;
  final double pressedOpacity;
  final BorderRadius borderRadius;
  final bool filled;
  final bool isShadow;
  final Color shadowColor;
  final BoxBorder border;
  final Gradient gradient;

  bool get enabled => onPressed != null;

  @override
  _SmallButtonState createState() => _SmallButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _SmallButtonState extends State<SmallButton>
    with SingleTickerProviderStateMixin {
  final Tween<double> _opacityTween = Tween<double>(begin: 1);

  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  bool isInkWellProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(SmallButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color ?? MyTheme.themeColor();
    final bool enabled = widget.enabled;
    final Color primaryColor = CupertinoTheme.of(context).primaryColor;
    final Color backgroundColor =
        color ?? (widget.filled ? primaryColor : null);
    final Color foregroundColor = backgroundColor != null
        ? CupertinoTheme.of(context).primaryContrastingColor
        : enabled
            ? primaryColor
            : _kDisabledForeground;
    final TextStyle textStyle = CupertinoTheme.of(context)
        .textTheme
        .textStyle
        .copyWith(color: foregroundColor);
    final Color resultColor = backgroundColor != null && !enabled
        ? widget.disabledColor ?? _kDisabledBackground
        : backgroundColor;
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(borderRadius: widget.borderRadius),
      child: ClickEvent(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed();
          }
        },
        child: Semantics(
          button: true,
          child: ConstrainedBox(
            constraints: widget.minWidth == null || widget.minHeight == null
                ? const BoxConstraints()
                : BoxConstraints(
                    minWidth: widget.minWidth, minHeight: widget.minHeight),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: widget.gradient != null ? null : resultColor,
                  gradient: widget.gradient,
                  boxShadow: widget.isShadow
                      ? [
                          BoxShadow(
                              color: widget.shadowColor,
                              blurRadius: 10,
                              spreadRadius: 0.5),
                        ]
                      : [],
                  border: widget.border,
                ),
                child: Padding(
                  padding: widget.padding ??
                      (backgroundColor != null
                          ? _kBackgroundButtonPadding
                          : _kButtonPadding),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: DefaultTextStyle(
                      style: textStyle,
                      child: IconTheme(
                        data: IconThemeData(color: foregroundColor),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
